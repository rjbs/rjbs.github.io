---
layout: post
title : "the simplest thing that could possibly teach me more about postfix"
date  : "2011-06-14T23:01:31Z"
tags  : ["perl", "postfix", "programming"]
---
Earlier today, I tweeted:

> If I wrote a book, I might call it, "Everything I Learned About Programming,
> I Learned By Adding More Print Statements"

This is a little funny, but mostly serious.  Anybody who has had the
misfortunate to watch me try to fix anything has seen my great love affair with
printing more crap.  When I am deep in bug fixing, my code is brimming with
noise like this:

    say "about to do stuff"; # debug
    do_stuff;
    say "just did stuff"; # debug

Later, I'll tell Vim to `:g/# debug/d` and everything will go back to normal.

This isn't a weird practice.  Doctors on TV (who, I am assured, are just like
real life doctors) are always injecting radioactive dye.  The Mythbusters put
food color or colored smoke in some moving medium practically every other week.
The issue is simple:  most of what software is doing is invisible, and if you
make it visible, you can see why it is totally failing to do anything remotely
like it's supposed to.  There are a lot of great tools for this -- debuggers,
DTrace, and even (if you're very lucky) built-in logging facilities.  I like
them all.  It's just that adding print statements is easier for some very large
fraction of problems.

So, what does this have to do with Postfix?

At work, we move a lot of mail through Postfix.  By "a lot" I just mean that it
takes more than one server and I have to pay attention to the performance of
our custom code.  We have a lot of customizations to our mailflow to deal with
virtual users, spam filtering, rate limiting, and so on.  These are implemented
with different parts of Postfix's customization facilities, of which I'll be
talking about two: table lookups and policy services.

Often, all you want to do is say "mail for this domain goes to X, mail for this
other domain goes to Y," or "reject all mail from jerk@example.com."  These
kinds of rules are easy to do with a table.  Postfix has all kinds of places to
add table lookups.  For the two examples, we might have postfix configuration
like this:

    # in main.cf:
    transport_maps = hash:/etc/postfix/domain-transports
    smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender-access

    # in domain-transports:
    X                   smtp:x-transport.mydomain.com
    Y                   smtp:y-transport.mydomain.com

    # in sender-access
    jerk@example.com    551 you are a jerk

The "hash" in the configuration file says what *kind* of table it is.  To
simplify, it's saying that we're going to look up fixed strings and get fixed
results based on them.  During the SMTP conversation, Postfix looks up
"jerk@example.com" in the sender access table, finds the 551 result, and
rejects inbound mail.  There are other kinds of tables, like PCRE for regex
lookups and TCP tables to allow arbitrary logic behind the scenes.  They're
easy to use:

    smtpd_sender_restrictions = check_sender_access tcp:localhost:9000

Postfix will connect to localhost:9000 and this transaction can happen:

    Postfix:  GET jerk@example.com
    Server :  200 551 you are a jerk

This lets you, for example, store all these blacklists in some
centrally-managed database and not try to build text files on all your servers.

The other facility I mentioned was the policy server.  This is quite similar to
a TCP table, but the transaction is more complicated:

    # in your main.cf
    smtp_sender_restrictions = check_policy_server inet:localhost:9001

    # over port 9001...
    Postfix: request=smtpd_access_policy
             protocol_state=RCPT
             protocol_name=SMTP
             helo_name=some.domain.tld
             queue_id=8045F2AB23
             sender=jerk@example.com
             recipient=bar@foo.tld
             recipient_count=0
             client_address=1.2.3.4
             client_name=another.domain.tld
             reverse_client_name=another.domain.tld
             instance=123.456.7
             sasl_username=friend@example.com
             (blank line)
    Server:  action=551 you are a jerk
             (blank line)

This is obviously useful for doing all kinds of more complex policies, like IP
in conjunction with sender, or HELO name verification, or applying different
policies to different users based on their SASL authentication.

The event that set all my extra print statements, and thus this journal
entry, into motion was related to making some bugfixes to one of our policy
servers.  It had a race condition, and when clients' accounts were owned,
spambots were much more likely to exploit the race than humans.  The race had
to go -- but early attempts to fix it were miserably unsuccessful.  I added
some logging, and messages were being logged many times.  It was time to
finally admit my ignorance:  most of our Postfix-interfacing code was written
by a long-departed employee, and when he left, I never really stepped up to
learn everything I should have.

I read a lot of documentation, and I felt only somewhat more educated.  The
Postfix documentation is pretty good, but it's much more a reference than a
tutorial, and I needed a way to see what the heck the various settings would
*do*.  The solution was simple.  I would do what I always did:  add more print
statements.

I wanted to be able to see everything happening at each check, so I gave every
check both a TCP table lookup and a policy service lookup by adding the
following to the `main.cf` of a testing server:

    smtpd_client_restrictions = check_policy_service inet:localhost:9001

    smtpd_helo_restrictions = check_policy_service inet:localhost:9001,
                                     check_helo_access tcp:localhost:9002

    smtpd_sender_restrictions = check_policy_service inet:localhost:9001

    smtpd_recipient_restrictions = check_policy_service inet:localhost:9001,
                                     check_recipient_access tcp:localhost:9002,
                                     reject

    smtpd_data_restrictions = check_policy_service inet:localhost:9001
    smtpd_end_of_data_restrictions = check_policy_service inet:localhost:9001

Then all I had to do was set up servers on those ports.  This was easy!  I just
used Net::Server and a few lines of `<STDIN>`, and `print`.  Now every
restriction was being used (to get a more or less no-op answer) and was
consulting both a table and a policy server.  The servers turned the queries
they got into JSON and printed it.  I could send a message (with Net::SMTP) to
my test server and see all the radioactive dye swirl around.

The problem was immediately incredibly obvious:  all of the non-DATA
restrictions were being consulted only at RCPT time, and once per recipient!
Even though I could take action as soon as I saw the sender, it was checking
later, and many times.  By default, Postfix allows 1,000 SMTP recipients,
meaning we could consult 999 times more than needed!  Armed with this
knowledge, the documentation became very fruitful: the `smtpd_delay_reject`
setting defaulted to true, and turned all the pre-RCPT checks into RCPT checks.
With that off, I could reject things as early as connection time.

I also realized that relying on certain data in the DATA was no good.  You
can't get a list of all the recipients, for example, only their count.  This
makes sense, and is documented, but *seeing it happen* is a much more effective
way for me to realize this.  I learn in two ways:  learning by futzing around
and learning by staring at moving parts.  Here, I put the two together, with
stellar results.  Even when adding the print statements required building a
virtual machine and writing a few TCP servers, it was a pretty easy and
effective way to figure out what to do next.

I put my little TCP servers and test-mail-sending script and a few other odds
and ends in my [postfixplex GitHub
repository](https://github.com/rjbs/postfixplex).

