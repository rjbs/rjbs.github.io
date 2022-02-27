---
layout: post
title : nexting out of loops via sub calls
date  : 2005-08-18T16:36:32Z
tags  : ["perl", "programming"]
---
12:19  * rjbs wants macros in Perl.
12:19 <DrForr> rjbs: Lisp-style? :)
12:19 <rjbs> of course
12:20  * rjbs wants a simple expression that can evaluate to "warn and next"
12:20 <rjbs> (loop-assert cond message)
12:21 <rjbs> which would become (unless (cond) (warn message) (next))
12:22 <DrForr> sub `loop_assert { my ($cond,$warn) = @_; unless($cond) { warn $warn; next } }
12:22 <rjbs> heh
12:24 <rjbs> er... wait...
12:24 <rjbs> that works!?  next will propagate up the call stack?
12:24 <rjbs> how did I not ever know this?
12:24 <DrForr> That's what the ` is for :)
12:24 <rjbs> no, but it seems to do so already
12:25  * rjbs tests more thoroughly.
12:25 <broquaint> Yeah can use loop control in a subroutine but you will get a warning too.
12:26 <rjbs> hell, I'll use "no warnings" for that.

So, yes.  If you call a sub inside a loop, and the sub calls next (without the next call being inside an interior loop) the next will propagate up the call stack.  There's a warning, but "no warnings 'exiting'" will quash it.

Wow!
