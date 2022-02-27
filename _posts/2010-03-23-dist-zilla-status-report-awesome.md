---
layout: post
title : "Dist::Zilla status report: awesome"
date  : "2010-03-23T03:09:51Z"
tags  : ["distzilla", "perl", "programming"]
---
I'm feeling pretty good about progress so far, especially after today taking an
axe to the InstallDirs plugin, which was a bug ugly mess.  Here's the big
board:

### proper logging facility

Done!

### reusable testing tools

Done!  I'd like to improve the App tester, but it's still working.

### extensive testing of the core

Done!  I mean, they're not providing 100% coverage, but that wasn't the goal.
The goal was to have enough tests that you could see that things were testing,
and to prove that the testing tools worked.  I think it's been extremely
successful.

### improved prerequisite handling

Almost done!  I need to tweak the way the FixedPrereq role works, or possibly
eliminate it in favor of something else, but all the hard stuff is now done.

### core set of well-known FileFinder plugins

Done enough!  I've created the most important well-known FileFinder and have
converted a few core plugins to use them.  This makes the tests pass again, and
that's huge.  I should probably add one for `:TestFiles`, though...

### improvements for authoring distributions containing XS

Well, we have `dzil run` now, but I'm not sure that's enough.  This is the
"most optional" task for me.  I've implemented the suggestions I had when I
propsed the grant, and now I'd like to see if there are any other benefits.
I think this may have been largely addressed, too, by the recent plugins for
custom Makefile.PL and Build.PL templates.  I might support core-ing that
feature, too, soon.

### simplification of the command line tool's code

This hasn't quite happened yet, but I think this one is going to be close to
its estimate.  For the most part, I think this one will just be moving code.  I
could be wrong, though.  I might be overcome with the urge to refactor the
Dist::Zilla `test` method or something... but I think it's unlikely.

### event structure for distribution creation

I haven't really thought much about this yet, but I'm excited.  David Golden
wrote one of the only distribution-skeleton-creators that I've liked, and now
he's gotten onto the Dist::Zilla bandwagon.  I'm hoping to work with him to
find ways to rework his never-released-to-CPAN tool into Dist::Zilla plugins
targeting this new subsystem.

Even if this falls through, I think I will not have a terrible time getting
started with a few simple roles for plugins to perform here.

### documentation: improved new user's guide

Well, this is the big one!  Once the coding work is done, this is going to be a
huge sink of time, and I'm sort of terrified of it.  Dist::Zilla is not easy to
document in typical "just document each class" fashion, and I really want to
get it right.  Perl Pub recently [published a bit on
Dist::Zilla](http://www.perl.org/pub/2010/03/more-code-less-cruft-managing-distributions-with-distzilla.html),
and I'll be giving a talk on Dist::Zilla at OSCON, so I have some more
experience writing about it, and will be working on writing about it more for
the conference.  Still, this is going to be a lot of work, and I'm both worried
an excited for it.

So, in short: about three weeks in, I think I'm between one third and halfway
complete.  The remaining code work is, I think, mostly minor work or all about
polish.  After that, I'm into the documentation phase, and that will be really
time-consuming, but hopefully it will pay dividends.  I look forward to being
able to say, "Jeez, didn't you read the awesome manual?"

