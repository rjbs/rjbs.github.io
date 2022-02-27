---
layout: post
title : "importing version-control-free code from the cpan"
date  : "2009-01-15T15:39:58Z"
tags  : ["cpan", "git", "perl", "programming"]
---
I've been meaning to convert some old code, not originally mine, from VCS-free
CPAN releases to git.  That is: I want to take each release and commit it to
a git repository, preserving authorship, dates, and so on.  Someone told me
that Jon Rockway's metacpan would help with this, but it wasn't going to work
right out of the box, and I was more interested in results than learning.  I'm
sure that he could produce something much better than the garbage I produced,
and I hope he does.

In the meantime, I got Net-Server-Mail and IPC-Run3 onto GitHub using [my awful
Perl (and shell)
script](http://github.com/rjbs/misc/blob/master/bp2git).

