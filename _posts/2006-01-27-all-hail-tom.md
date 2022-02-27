---
layout: post
title : "all hail tom"
date  : "2006-01-27T04:42:50Z"
tags  : ["perl", "programming"]
---
Today, I got an email from Tom, my replacement at IQE.  He'd found himself needing a new kind of tolerance for Number::Tolerant.  I originally wrote Number::Tolerant for IQE's characterization system, and I really enjoyed working on it.  Once I left, though, I didn't have much reason to work on it.

So, today Tom sent me that email, and included the code for the new kind of tolerance.  It's basically a plus-or-minus offset, but the target value is not the midpoint of the extremes.

I integrated his code (tweaking just a bit), and wrote tests.  After writing tests for offset, I ran coverage and found that it was nowhere near the 100% coverage I remebered.  I reorganized a bunch of my tests, wrote about 150 more tests, found a few little bugs, and fell back in love with this obscure, weird little distribution.

I can clearly see how it needs to be refactored, now, and I may just do that soon.

Potentially best of all, I believe I've found a bug in Devel::Cover.  Maybe I'm wrong, or maybe Paul will decide that the condition required to make the bug appear is not worth addressing.  If not, though, we will have identified a new bug in one of the most useful Perl programming tools, all because some engineers at IQE demand weird product specifications!

Tom at IQE, I salute you! 
