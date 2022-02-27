---
layout: post
title : at long last, email sender is released
date  : 2008-12-10T18:04:09Z
tags  : ["email", "perl", "programming"]
---
When I started at Pobox, we had a few different ways we sent or delivered mail.
Chief among them were IO::Persistent::SMTP, `smtpsend`, ICG::TestTools::Mail,
and Email::LocalDelivery.  These all had their own purposes, which was fine,
but they also had their own APIs, which was not.

This irritated the heck out of me, and I started to get us moved to
Email::Send.  Very soon, though, it became clear that Email::Send wasn't going
to work out.  It didn't let you specify the envelope (the addresses used in the
SMTP conversation), which is vital to managing bounces properly.  It didn't
have a clear way to add that kind of API, either, because it assumed all
arguments other than the email to send were for the "message modifier," which
let you alter the message each time you were about to send it.  It also didn't
let you use objects as mailers, only classes, which meant that configuring them
was often done with package variables.  Again, the way things worked made it a
pain to fix this, and only a partial solution was possible without breaking
backwards compatibility.  Finally, the API for signalling success or failure
was non-existent.  Most mailers used something based on the horrible
Return::Value.  (I don't mind calling it horrible because I was one of its
chief authors.  It was a cute idea that should've been identified as Too Clever
much earlier on.)  Others just returned true or false.

I hacked up our Email::Send internally, defined a new API for success or
failure, and rewrote our mailers in terms of that API.  I released as much of
the improvements as I could to Email::Send on the CPAN, but some of them broke
backwards compatibility.  I resolved to produce an even cleaner version for the
CPAN with a new name... but that kept getting pushed back.

Finally, we had time and need to do that on the clock, so it got done.  I'm not
sure how much work remains before the new code, Email::Sender, is really ready
for production use, but I'm willing to bet "not much."  It's heavily based on
our internal code, which has been used to deliver billions of messages.

Here are some highlights:

When it succeeds, it returns a true value (an object of a known class).  When
it fails, it raises an exception (of a known class, generally).  By default,
success means "all recipients successful," but some transports or transport
options may allow partial success.  (SMTP may be configured to do this, LMTP
(not yet implemented) must be allowed to.)

Transports exist not only for the `sendmail(1)` program and SMTP but also for
Maildir, mbox, and other just-for-testing purposes like "deliver to an SQLite
database" and "deliver to an array in memory."  Because these all share one
API, it's easy to run your code with a different mailer to see whether it
behaves properly in the case of failure.  (I make extensive use, in testing our
forking, queueing mailing list exploder, of a SQLite mailer wrapped in a
fail-every-n-transmissions hook.)

I have omitted a few Email::Send transports that I didn't think were likely to
be getting a lot of use.  I don't provide transports for NNTP, `qmail-inject`,
or IO::All.  Re-implementing these should be trivial.  (I am assuming that
qmail users will be using its `sendmail` wrapper.)  I am looking forward to
implementing some other transports.

I'm also really looking forward to writing Email::Sender::Simple, which will
hide some of the complexity by allowing only pure success/failure transports,
returning false on failure (in non-void context), filling in the envelope from
the message, adding an archive-sent-mail feature, and some more things.
Basically, it will be an improved version of our own ICG::Sendmail, which we
use to send *all* our mail.

The distribution is sitting in [the PAUSE incoming
queue](http://pause.perl.org/incoming/Email-Sender-0.000.tar.gz) right now and
should show up as [Email-Sender on
CPAN](http://search.cpan.org/dist/Email-Sender/) shortly.  I'm really excited
to have this out in the wild and, uh, to start receiving bug reports.  If you'd
like to *fix* bugs or add documentation, you can fork the [Email-Sender git
repository](http://github.com/rjbs/email-sender).

I'll try to add a `TODO.txt` file, or maybe a
[ticgit](http://github.com/schacon/ticgit/wikis) branch soon.

