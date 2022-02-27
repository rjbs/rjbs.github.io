---
layout: post
title : Dist::Zilla much more tested, but much less releaseable
date  : 2010-03-20T02:54:23Z
tags  : ["distzilla", "perl", "programming"]
---
I've added a bunch more tests to Dist::Zilla as I try to work through my
checklist of plugins to cover.  Some have been easier than I expected, but I've
found myself in a bit of a predicament.

Right now, things like the PodWeaver are very aggressive in figuring out what
to rewrite.  They even rewrite things like tests.  That means that the tests
work in my working copy, but fail in the built version of the dist.  I could
work around this by storing all the not-to-be-rewritten files in a tarball
inside the dist, but the right answer is really to get to work on the "named
file finder plugins" that was part of the grant work.  This will let me target
only files to be installed, which should solve this problem nice.

Strangely enough, the Dist::Zilla IRC channel has been *hopping* lately, and
I'm getting quite a few requests for changes -- many of which I already want to
make.  It's been frustrating to keep saying, "It has to wait until I finsih
tests!" but I know I'll be happy to have a test suite I can use to ensure I
haven't broken everything, as I add more features in the future.

