---
layout: post
title : back to Dist::Zilla features: finders, installed resources
date  : 2010-03-22T03:03:32Z
tags  : ["distzilla", "perl", "programming"]
---
I don't think I'm quite done with my basic tests, but I've gotten to the point
where I need to fix some other features first.  The yak stack is actually sort
of interesting, so I'll explain it:

I can't release Dist-Zilla right now, because the build process alters the test
corpus.  See, the PkgVersion plugin adds a package to every Perl-like file it
finds, and that includes test input in `./corpus/DZT/lib`.  So, while the tests
all pass before I build the dist, if I build the dist, the tests stop working.
Oops!

So, there's actually a piece of the grant work that fixes this:

    =head3 core set of well-known FileFinder plugins

    The FileFinder plugin role allows other plugins to operate on dynamically
    located sets of files like "all Perl modules that will be installed" or
    "all files marked executable."  At present, there are no predefined
    FileFinder plugins with Dist::Zilla.  By providing a few core finders with
    well-known names, it is easier for new third-party plugins to behave more
    like core plugins.

    This requires writing the finders, testing them, and updating existing
    plugins to use them.  It also must be possible for a user to override the
    behavior at the well-defined name.

    Estimated time; one day

(I'm finding, unsurprisingly, that all my estimates were underestimated.)

Anyway, PkgVersion and PodWeaver, and others, should really be run against
some clearer subset of files like "Perl and Pod files under ./lib" or "those
files plus all the executables we're going to instal."  The FileFinder system
gives us this.  Today, I improved how the FileFinder system works, and I'm
pretty happy with it.  I've got a plugin for finding the stuff that will get
installed under `@INC`, but I need one for the "stuff installed to `$PATH`."
The current InstallDirs plugin sucks, and that needs to get fixed, so that's
next.

There have been a few other features I've improved, already.  The Prereq
plugin can now work for `configure_requires`, `build_requires`, and so on.
The AutoPrereq plugin has been moved into the core distribution.  A few other
plugins have had minor improvements made.

Hopefully I can get the first pass of an InstallDirs replacement done
tomorrow.  InstallDirs and a few other plugins really need to be replaced,
overhauled, or renamed.  I don't think there will be another official release
of Dist-Zilla until that's happened, and it will be numbered as version 2.

