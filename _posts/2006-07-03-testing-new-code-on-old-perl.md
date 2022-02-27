---
layout: post
title : testing new code on old perl
date  : 2006-07-03T00:39:10Z
tags  : ["perl", "programming"]
---
When putting together a slide for YAPC, I felt a little guilty about showing Exporter.pm in a slightly uglier light than required, mostly by avoiding the use of "our."  I wrote a little to do for myself, at the time, to see whether Sub::Exporter would even work on an our-less perl.  This has been a pain.

I thought it would be pretty simple to install an older distribution of perl on one of my Parallels virtual machines, but 5.4.5 isn't compiling.  I get some stupid Makefile error which I haven't yet investigated.  ("No rule to make target <built-in>" or something like that.)  I installed 5.5.4, but Params::Util wouldn't work: it was built with a broken version of Module::Install that wouldn't work on pre-5.6.  With that and another problem or two fixed, I got all a bunch of things installed, only to be reminded that "use warnings" is a 5.6-ism.  I always forget that!

I'm not really excited about removing all my uses of warnings.  It's just so convenient!  I think that I may just say that 5.6.0 is as old as I'll go. After all, that's six years old.  While I understand that some people are stuck on older perls, hopefully they're just maintaining, and not writing new code.

Even with this problem solved (by fiat), I'm still interested in getting a better testing environment set up.  I'll probably talk to sachmet, who I'm told has a good set of scripts for building a menagerie of perls. 
