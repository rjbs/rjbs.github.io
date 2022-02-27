---
layout: post
title : making my daemon share more memory
date  : 2014-01-11T00:45:16Z
tags  : ["perl", "programming"]
---
Quick refresher:  when you've got a unix process and it forks, the new fork can share memory with its parent, unless it starts making changes.  Lots of stuff is in memory, including your program's code.  This means that if you're going to `require` a lot of Perl modules, you should strongly consider loading them early, rather than later.  Although a runtime `require` statement can make program start faster, it's often a big loss for a forking daemon: the module gets re-compiled for every forked child, multiplying both the time and memory cost.

Today I noticed that one of the daemons I care for was loading some code
post-fork, and I thought to myself, "You know, I've never audited that program
to see whether it does a good job at loading everything pre-fork."  I realized
that it might be a place to quickly get a lot of benefit, assuming I could
figure out what was getting loaded post-fork.  So I wrote this:

    use strict;
    use warnings;
    package PostForkINC;

    sub import {
      my ($self, $code) = @_;

      my $pid = $$;

      my $callback = sub {
        return if $pid == $$;
        my (undef, $filename) = @_;
        $code->($filename);
        return;
      };

      unshift @INC, $callback;
    };

When loaded, PostForkINC puts a callback at the head of `@INC` so that any
subsequent attempt to load a module hits the callback.  As long as the process
hasn't forked (that is, `$$` is still what it was when PostForkINC was loaded),
nothing happens.  If it *has* forked, though, something happens.  That
"something" is left up to the user.

Sometimes I find a branch of code that I don't think is being traversed
anymore.  I *love* deleting code, so my first instinct is to just delete it…
but of course that might be a mistake.  It may be that the code is being run
but that I don't see how.  I could try to figure it out through testing or
inspection, but it's easier to just put a little wiretap in the code to tell me
when it runs.  I built a little system called Alive.  When called, it sends a
UDP datagram about what code was called, where, and by whom (and what).  A
server receives the datagram (usually) and makes a note of it.  By using UDP,
we keep the impact on the code being inspected very low.  This system has
helped find a bunch of code being run that was thought long dead.

I combined PostForkINC with Alive and restarted the daemon.  Within seconds, I
had dozens of reports of libraries — often quite heavy ones — being loaded
after the fork.

This is great!  I now have lots of little improvements to make to my daemon.

There is one place where it's not as straightforward as it might have been.
Sometimes, a program tries to load an "optional" module.  If it fails, no
problem.  PostForkINC can seem to produce a false positive, here, because it
says that Optional::Module is being loaded post-fork.  In reality, though, no
new code is being added to the process.

When I told David Golden what I was up to, he predicted this edge case and
said, "but you might not care."  I didn't, and said so.  Once I saw that this
*was* happening in my program, though, I started to care.  Even if I wasn't
using more memory, I was looking all over `@INC` to try to find files that I
knew couldn't exist.  Loading them pre-fork wasn't going to work, but there are
ways around it.  I could put something in `%INC` to mark them as already
loaded, but instead I opted to fix the code that was looking for them, avoiding
the whole idea of optional modules, which was a pretty poor fit for the program
in question, anyway.

I've still got a bunch of tweaking to do before I've fixed all the post-fork
loading, but I got quite a lot of it already, and I'm definitely going to apply
this library to more daemons in the very near future.

