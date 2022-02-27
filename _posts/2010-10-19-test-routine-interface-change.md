---
layout: post
title : Test::Routine interface change
date  : 2010-10-19T13:51:26Z
tags  : ["perl", "programming", "testing"]
---
I've been trying to learn more about different patterns people use while
writing test code, and to make sure that
[Test::Routine](http://rjbs.manxome.org/rubric/entry/1858) accomodates them all
fairly easily.  So far, I'm happy with it, but I've had a few changes I've
made.  So far, only one is intended to be user visible.  From now on, instead
of writing:

    use Test::Routine::Runner;
    run_tests(...);

You should write:

    use Test::Routine::Util;
    run_tests(...);

That's it!  The Runner is now an object that can be given slightly different
kinds of behavior to help implement fresh fixtures.  The next
fixture-freshening feature I want to add will be more visible and complex, but
I'm not in a rush.  First, I want to convert more of the tests that I run
frequently to Test::Routine to see how it goes.

