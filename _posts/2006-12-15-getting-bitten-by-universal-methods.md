---
layout: post
title : getting bitten by universal methods
date  : 2006-12-15T14:11:50Z
tags  : ["perl", "programming"]
---
When I work on code, I nearly always replace `UNIVERSAL::isa` and
`UNIVERSAL::can` with block-`eval` of a method call instead.  This lets objects
that overload `isa` or `can` work properly, and still avoids program death when
the invocant is an invalid invocant.

A few weeks ago, while working on memory issues, though, we found a horrible
problem with this.  Some of our code, which could accept either an
Email::Simple or a string, was doing something like this:

    if (eval { $message->isa('Email::Simple') }) { ... }

The code functioned as expected, and worked.  Sometimes, though, the process
would grow to ridiculous sizes.  The reason is that this code was running under
perl-5.6, which has some issues.

See, in perl-5.6, when you try to call a method on something that is not yet
defined, perl creates the package for you.  This creates a hash entry in the
stash for that package's variables to go, even though it has none.  Here's an
example:

    japh@perl-tester:~$ /opt/perl/perl-5.6.1/bin/perl -l test-mem "xy" 1000000
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3779  0.0  0.4   3956  1132 pts/0    S+   03:55   0:00

    Then we run: eval { (xy x 1000000)->can('bloat') }; 

    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3779  0.0  3.4  11780  8976 pts/0    R+   03:55   0:00

So, a two meg message called as a method can bloat you up quite a lot!  What email message is going to be "xy" repeated a million times, though?  Let's try something more realistic, just a bit:

    japh@perl-tester:~$ /opt/perl/perl-5.6.1/bin/perl -l test-mem "Subject: hi mom\n\nHow's the world's best mom?" 45454
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3782  0.0  0.4   3956  1128 pts/0    S+   03:58   0:00

    Killed

It ran out of memory, even though it's very nearly the same number of
characters.  What happened?  It's the apostrophes.  They're equivalent to ::,
and they cause much deeper structures to be created in the stash.  Here's some output that *didn't* kill the process:

    japh@perl-tester:~$ /opt/perl/perl-5.6.1/bin/perl -l test-mem "Subject: hi mom\n\nHow's the world's best mom?" 2500
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3801  0.0  0.4   3956  1128 pts/0    S+   04:01   0:00

    Then we run: eval { (Subject: hi mom\n\nHow's the world's best mom? x 2500)->can('bloat') }; 

    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3801  6.9 74.9 286708 192868 pts/0   S+   04:01   0:02

That's only a 110k message.  For a lot of fun, dump `\%::` after doing that.
This is just another reason to use perl-5.8:

    japh@perl-tester:~$ /opt/perl/perl-5.8.0/bin/perl -l test-mem "Subject: hi
    mom\n\nHow's the world's best mom?" 2500
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3807  0.0  0.4   4260  1148 pts/0    R+   04:03   0:00

    Then we run: eval { (Subject: hi mom\n\nHow's the world's best mom? x
    2500)->can('bloat') }; 

    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME 
    japh      3807  0.0  0.5   4428  1400 pts/0    R+   04:03   0:00

Of course, if you can't upgrade, there's always my old friend `_INVOCANT`, which
is now found in Params::Util.  If you say something like this:

    eval { _INVOCANT($x) && $x->can('do_awesome_stuff') }

Everything is much closer to normal:

    japh@perl-tester:~$ /opt/perl/perl-5.6.1/bin/perl -l test-mem-invocant "Subject: hi mom\n\nHow's the world's best mom?" 2500
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3905  0.0  0.4   3948  1184 pts/0    R+   04:11   0:00

    Then we run our code.

    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
    japh      3905  0.0  0.5   4112  1476 pts/0    R+   04:11   0:00

Despite this, you still won't see me using `UNIVERSAL::` methods as functions.
I think maybe Params::Util just needs a `_CAN`.

