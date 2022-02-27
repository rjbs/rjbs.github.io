---
layout: post
title : Dist::Zilla testing continues
date  : 2010-03-18T03:37:01Z
tags  : ["distzilla", "perl", "programming"]
---
"Hey, look, I wrote some more unit tests!" is about as fun to report as it is
to do, but so far, so good.  The Dist::Zilla::Tester system I put together has
been working pretty well, and I've made a few tweaks as I go.  I'd originally
meant to write one test per plugin, but for some of them it's just much, much
simpler to combine them to have two or three plugins per test file.  If this
leads to problems, I can split it up again later.  For now, it's looking good.

I've found a few bugs by testing, which is excellent.  Most of them would never
actually show up, but it's still nice to find.  I also found a bug in PPI, but
it turned out that it had been fixed in the latest trial release already.  It
was related to testing an actual code change.  Prior to tonight, the PkgVersion
plugin would generate this:

    package MyPackage;
    our $VERSION = '1.234';

...but now it generates...

    package MyPackage;
    $MyPackage::VERSION = '1.234';

This means that there is no lexical `$VERSION` variable in build that isn't in
source.  That helps prevent mysterious changes in compile time failure.  It
also lets you target 5.005, if you really need to.

This is one of the many small changes that I've wanted to make while adding
tests.  I made some others to AllFiles, but most other changes I've thought
about, I skipped.  I'm trying to test existing behavior.  I can add new stuff
later!

