---
layout: post
title : email::sender::simple is brewing
date  : 2009-05-15T14:48:30Z
tags  : ["email", "perl", "programming"]
---
If I were going to was introspective, I'd say that one of my best and worst
qualities is my love of designing something for ages before building it.  I
think it tends to make my end product better, but it also means that the
product languishes.  Right now, that's the state of Email::Sender::Simple.

[Email::Sender](http://search.cpan.org/dist/Email-Sender/) is my replacement
for Email::Send.  It was planned for about two years before it was released,
and when it was released, it contained the notice that Email::Sender::Simple
would be included in a future version to reduce the number of decisions for the
end-user to make.  After all, the end user does not usually want to think about
how his email is tramsmitted.

Right now, [the Email-Sender repo](http://github.com/rjbs/email-sender/) has a
young version of Email::Sender::Simple in it.  It's meant to steal the best
things about Email::Send, Email::Sender::Transport, MIME::Lite, and (Pobox's
own) ICG::Sendmail.  It simplifies things in a number of ways, some of which
end up being *incredibly* powerful, based on our usage of ICG::Sendmail.

For one, you never need to worry about what transport you want to use.  There
are sane defaults (like MIME::Lite *tries* to provide), and they can be
overridden by a subclass or the environment.  The environment override is a
fantastically powerful tool, and probably the best part of ICG::Sendmail.  When
`EMAIL_SENDER_TRANSPORT` is set, no other transport but the one identified
there will be used.  This means that *any* program in our world can be run like
this:

    walrus!rjbs% EMAIL_SENDER_TRANSPORT=Maildir generate-activity-report xyzzy

Everything will happen as usual, but the mail will be sent to `./Maildir`
instead of SMTP.  It's also trivial to set that environment variable at `BEGIN`
time inside your test scripts and have messages delivered in memory.  Do your
tests run subprocesses or fork?  No problem, you can use the SQLite transport
and inspect all deliveries across all subprocesses.

I think that, released now, Email::Sender::Simple would be great.  That said,
there are still a bunch of design questions up in the air -- and I'm going to
keep obsessing about them for a while.  I'm hoping to have it all decided in
time for my email talk at [YAPC](http://yapc10.com/) this year.  Here are some
of my current quandaries.

Right now Email::Sender::Transport is the most important class in Email-Sender.
It has two vital methods: `send` and `send_email`.  The first is what users
call.  It does a bunch of stuff like convert all kinds of input into an
Email::Abstract, sanitychecks the envelope, and so on.  Then it calls
`send_email`, which is what most transports are *expected* to provide.  I think
that this behavior belongs in a role, but refactoring Email::Sender::Simple
and Email::Sender::Transport with minimal chaos.

Should Simple return a bool or should it throw an exception?  I'm nearly
entirely sure that I want it to throw.  Email::Send soured me on return values
for non-predicates.

How will other senders signal to Simple that they're not suitable for use by
it?  I *never* want to allow Simple to signal partial success (ugh!) so right
now I just check for something like `can_signal_partial_success`.  I think
instead I want to just check `suitable_for_simple`.

What are some common ways people will extend Simple?  ICG::Sendmail has some
built-in magic to do things like make it easy to save copies of sent mail.
Hopefully the refactoring can make it easy to plug this in with subclasses,
roles, and method modifiers.

Anyway, there's a lot of obsessing still to be done, but hopefully it will all
pay off before the end of the summer, and I will finally be able tell people to
stop using Email::Send for good.

