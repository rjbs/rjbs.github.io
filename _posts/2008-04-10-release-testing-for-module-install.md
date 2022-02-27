---
layout: post
title : release testing for module::install
date  : 2008-04-10T21:03:39Z
tags  : ["perl", "programming"]
---
As threatened, I have written and uploaded an improved replacement for
Module::Install::AuthorTests.  It's Module::Install::ExtraTests.  It's scary
and probably somewhat ill-advised, but it seems to work just fine.  It takes
away some of the configurability of AuthorTests, but it's way more useful, I
think.

Basically, you add one line to your Makefile.PL:

    extra_tests;

That tells it that you might have something like this:

    ./xt/author/live-tests.t
    ./xt/release/perl-critic.t
    ./xt/release/pod.t
    ./xt/release/pod-coverage.t
    ./xt/smoke/diag-rig-info.t
    ./xt/smoke/test-rig.t

The author tests would only be run when run in the author's working copy (a
concept dealt with by Module::Install).  The release tests are only run during
`make disttest`, when RELEASE_TESTING has been set.  The smoke tests are only
run during smoke testing, when AUTOMATED_TESTING has been set.

Making this work required doing ugly things.  I'm not sure how reliable it will
be, but I'll make a release or two of things using it, in the next few days,
and we'll see what happens.

