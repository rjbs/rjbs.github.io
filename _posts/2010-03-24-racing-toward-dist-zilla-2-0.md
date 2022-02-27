---
layout: post
title : "racing toward Dist::Zilla 2.0"
date  : "2010-03-24T03:27:20Z"
tags  : ["distzilla", "perl", "programming"]
---
I thought I'd have to wait another week or two to feel good about the next
major (slightly backwards incompatible) release of Dist::Zilla.  It looks like
I should be able to release it this week.

The big hold up has been that when I build Dist-Zilla, now, parts of it had
been altered to be ... broken.  For example, the test Pod files got munged by
the release process, so the test suite could no longer munge them.  Almost all
of these problems have now been fixed, and only one significant one remains:
AutoPrereq.

AutoPrereq is smart enough to exclude the modules you ship, but it isn't
excluding modules in `./t/lib`, and it's scanning directories that don't
matter, like `./corpus`.  I need to adjust it to scan only installed modules
and executables for runtime-required libraries and test files for test-required
libraries.  This should be easy, but I'm going to put it off for a day or so.

Once that's done, I think I can build version 2.x and make a trial release!

