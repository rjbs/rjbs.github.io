---
layout: post
title : "email::send to be written off; email::sender supplants it"
date  : "2009-06-07T05:20:18Z"
tags  : ["email", "perl", "programming"]
---
I was long at least tangentially involved in the development of the Email:: namespace's early code.  I talked with Casey West often when he was working on Email::MIME and Email::Send.  Once I started working at Pobox, though, my email needs became much more serious.

At Pobox, I found a lot of really cool code for doing email stuff, but it
wasn't very uniformly distributed.  There were too many ways to do this or
that, and that made troubleshooting a real pain.  I really wanted to reduce the
number of tools being used, and one of the big problem areas was in injecting
email into our mailflow.

I figured we could use Email::Send, since it was fairly recent and was meant to
be pluggable and extensible.  What I found, though, was that both of these
qualities were fairly limited, and a few design problems with the code made it
very, very hard to correct those problems.  On February 2, 2006, I contacted
Casey to tell him my specific concerns and offer some of the patches I'd been
toying around with internally.  That was probably when I really got on track to
become the poor sap keeping track of Email:: and friends.

Over time, it became clear that to really fix the problems we had with
Email::Send, we'd need to break backwards compatibility in a few ways.
Internally, we wrote a new Email::Send subclass called Email::Send::Mailer,
which was just an abstract base class that enforced a stricter API for mailers.
We patched Email::Send to work with mailers that were objects and to remove the
"message modifier" feature, which got in the way of passing arguments to the
mailers.

The big win here was that we entirely eliminated the use of Return::Value --
probably one of the worst ideas I unleashed on the CPAN -- and made sure that
all our Mailer subclasses could set the envelope information distinctly from
the message header.  This is a really, really imporant point, so I'll
elaborate a bit.

Here's a simple email message:

    From: Ricardo Signes <rjbs@example.com>
    To:   Perl Email Project <pep@example.biz>
    Subject: all your modules are belong to us

    Sure, I'd be happy to fix bugs in Email::MIME.

    -- 
    rjbs

If you send this message with the existing Email::Send code, it will
more or less have to be sent to the address at example.biz.  This is fine for
many cases, but often it's not.  For example, if I was implementing the mailing
list manager that sends this mail, I'd want each recipient to get the message
from a unique SMTP-time sender.  This is called the envelope sender, and is
distinct from the From header.  If you can't specify the envelope distinctly
from the header, you have a major handicap.

So, with the envelope problem solved and Return::Value replaced with the use of
exceptions, we had a really useful way write mail transports.  Next, I built a
layer of indirection atop those transports so that no program ever had to think
about the transport it would use.  Normally they'd inject into the local SMTP
service, but if we wanted to we could run the program with an environment
variable set to capture all the mail into a Maildir, or an SQLite database, or
we could just throw it away.

It is difficult for me to express how important that indirection layer became.
It made any email-sending code almost trivial to test.  We wrote a mailer that
could cause predictable failures and we could then test how our code would
behave in the face of adversity.  We could run any command that sent out email,
but have that email discarded instead, if we didn't want to send out noisy
updates.  Within a few months, nearly all of the code at Pobox used this
system.

The big problem was that we couldn't just release it.  It didn't have enough
test coverage -- sure, it sends millions of messages a day, but we didn't have
enough tests we could ship -- and a few too many things were tied to our
internal code.  What's worse, it relied on our backcompat-breaking changes to
Email::Send, which was too popular to risk breaking in horrible ways.

Writing a replacement for Email::Send, based on what we'd learned writing
Email::Send::Mailer and Pobox::Sendmail seemed like a really great route
forward.  Of course, since we already had our problems solved internally, this
wasn't much of a priority.

Eventually, though, it got written, and this week I've made the first dev
releases of Email::Sender::Simple, a greatly improved version of our own
Pobox::Sendmail.  I've also tried to improve the documentation available for
new users, leading to the [Email::Sender quick start
guide](http://search.cpan.org/~rjbs/Email-Sender-0.091560_002/lib/Email/Sender/Manual/QuickStart.pm).

It could still use more coverage, but 88.7% isn't bad.  It's at least as easy
to use as Email::Send, far more flexible, far easier to maintain, test, and
extend.  I hope to keep improving the code and its documentation, and I hope
that I can convince people to move away from Email::Send and toward
Email::Sender.  I'll be happier to support better code and users will be
happier to have a simpler interface.

Share and enjoy!

