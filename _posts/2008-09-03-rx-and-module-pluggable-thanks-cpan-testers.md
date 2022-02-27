---
layout: post
title : rx and module::pluggable; thanks, cpan testers!
date  : 2008-09-03T13:08:21Z
tags  : ["perl", "programming", "rx", "testing"]
---
There's been a fresh outburst of acrimony about how CPAN testers just send
unpleasant and useless email to people who don't care and can't benefit.
Coincidentally, I got one of the most useful bug reports I've gotten in a long
time from an automated tester.

I got a [test
report](http://www.nntp.perl.org/group/perl.cpan.testers/2008/08/msg2120675.html) that seemed completely bizarre.  I got another one from the same tester with the same message, too.  It was complaining: `Can't locate Data/Rx/CoreType/int/SUPER.pm`

What?  I never tried to load that module.  The closet I came was, in
Data::Rx::Coretype::int, having this code:

    $self->SUPER::check($value);

Clearly this tester was on drugs, right, and had done something insane in his
rig that no "real user" would ever do?

I contacted SREZIC, the smoker and he said he didn't know just what happened,
but that the versions of Module::Pluggable differed between those two machines
(which had 3.1) and another machine that passed (3.9).

Aha!  It turns out that prior to Module::Pluggable 3.7, its inner-package
finder (intended to find multiple packages inside of files) would find that
`SUPER` call and try to load `SUPER.pm`.  Oops!

Now I can update the prerequisite version for my dist to avoid this bug, *and*
I've learned about a generally important to know about bug in a common module.

Thanks, CPAN Testers!

