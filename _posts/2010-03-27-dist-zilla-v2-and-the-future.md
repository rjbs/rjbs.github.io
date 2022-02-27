---
layout: post
title : Dist::Zilla v2 and the future
date  : 2010-03-27T18:44:25Z
tags  : ["distzilla", "perl", "programming"]
---
## Trial Releases

This morning, I uploaded `Dist-Zilla-2.100860-TRIAL.tar.gz`.  It's the first
candidate for what will be Dist::Zilla v2.  Notice that `TRIAL` in the file
name?  Of course you do.  That tells PAUSE, the CPAN upload system, that this
release is just a test release, and shouldn't be indexed as the latest release.
It prevents users from automatically upgrading to this version, even though
it's newer than the last one.  Usually, when you see someone trying to send
this message to PAUSE they do it by setting a version like `1.234_001`.  The
underscore tells PAUSE that it's a trial release.

This is, I think, a pretty lousy way for it to work.  Because you want your
version to be a number, but because (for uninteresting reasons) you want the
first assignment to `$VERSION` to keep the underscore, this magic incantation
shows up in your code:

    our $VERSION = '1.234_001';
    $VERSION = eval $VERSION;

Why?  Well, a lot of people use it without knowing, but it's to get $VERSION
holding a number with the value 1.234001, because although `1.234_001` would be
that as a literal in Perl, the string form has the numeric value 1.234.  People
also get confused about the numbering.  The version after 1.234_001 is not
1.234, and generally it shouldn't be 1.235, either.  It should be either
1.234002 or 1.234_002 or 1.235000.

Finally, because of that `eval`, you can't even look at `$VERSION` to
determine whether it was a trial release.  The underscore will be gone.

If you think this is really stupid, then you and I agree.  Now, PAUSE only
looks at the tarball name.  You don't actually need to change your package
versions -- it's just an easy way to get that underscore in there.  If your
tarball's version appears to differ from your package versions, it can be
confusing.  You will get exactly the same behavior from PAUSE if your
distribution's tarball's filename has `TRIAL` in it, and all the version number
related nonsense goes away.

Dist::Zilla now makes it very easy to use this system:

    $ dzil release --trial

This builds your distribution just like normal, then packs it up in a tarball
with the right kind of name.  I'm toying with the idea of adding a `$IS_TRIAL`
package variable if you use the (hypothetical) `[PkgTrial]` plugin, but I can't
really see much use for it yet.

## What's new in this release?

Dist::Zilla v2, starting with this trial release, has quite a few significant
changes, quite a few of which are not backward compatible.  I've tried to make
sure that most users won't notice the change, but if you're doing much other
than using `@Classic`, you probably will.

### AllFiles is gone, replaced by GatherDir

This makes the name match up more clearly with what it does, because although
it defaults to gathering from the dist root, it can gather an arbitrary
directory.  Also, with FileFinder plugins showing up all over the place, the
temptation to try to find "AllFiles" just seemed too great.

### InstallDirs is gone, replaced by ExecDir and ShareDir

This plugin was a stupid idea.  It was one place to set up directories to
install as sharedirs (q.v. File::ShareDir) and executable programs that go into
your path.  These are really different, but I had a clever (read: terrible)
mechanism to make them seem similar.  I ripped out the terrible mechanism a
while ago, and that just made things more complicated.  Now they're different
things, and they make a lot more sense.

### PodTests has been split into PodSyntaxTests and PodCoverageTests

Pod::Coverage, even with CountParents and Moose and TrustPod, doesn't quite cut
it for me.  There's no reason that everybody who wants one will want the other.
I'd like to use the coverage tests again someday, but right now I can't -- and
anyway, I know plenty of people who say they'll never want them.

### the FixedPrereqs role is gone, replaced by PrereqSource

Plugins performing FixedPrereqs would return a hashref of prereqs to register.
This was fine when there was only one kind of prereq.  Now that we handle
different kinds (like prereqs for build-time only) I needed more flexibility.
Also, Pedro Melo wanted to write a plugin that would up all prereqs to the
latest version from CPAN.  Someone else wanted to require the version installed
on his computer, since that what he tested with.  FixedPrereqs couldn't do
this, either, and I didn't want to add the proposed PrereqMunger phase and role.

Instead, plugins that perform the PrereqSource role will be given a chance to
register their prereqs just before prerequisite finalization.  They can
register different kinds of prereqs, and they'll be able to inspect, clear, and
tweak existing ones.

### lots of other stuff

You can look at [the Changes
file](http://github.com/rjbs/dist-zilla/blob/2.100860/Changes) for version 2 to
see what else is new.

## What's in the future?

Well, there are the unfinished code todos for the TPF grant:

* improvements for authoring distributions containing XS
* simplification of the command line tool's code
* event structure for distribution creation

(Those are *all* the remaining items to do for the code half of the grant.
Isn't that *exciting*?)

There are quite a few more todo items in the repo's `./todo` directory and in
the RT queue for the distribution.  Most of these will have to wait until I've
completed the grant work.  (In fact, most of the best improvements for XS
authoring will as well, I think.  The useful ones are going to require much
more extensive changes than were originally imagined.)

With the bulleted items above done, I'll be able to move on toward the new
documentation and learning material.  Once *that* is done, I've got my big pile
of ideas to work through.  My goal is to work through them steadily, keeping
backwards compatibility when possible.  Although I'm generally extremely
conservative about breaking backcompat, I'm not going to worry about it too
much with Dist::Zilla, yet.  It's too young, too complex, and too fast-moving
for me to get everything right the first (or second, or third...) time just
yet.  Instead, I'll try to work on big new features in branches and when
releasing things that break backcompat, I'll bump the major number.

I might produce some sort of documentation, too, that indicates how likely to
change any given part of the system is.  I've got to think about that more.

Finally, because there was a bit of confusion about this on IRC earlier:
Dist::Zilla's master branch in git is *not* stable.  It is where the main
development occurs, and new, slightly-unstable features may land at any time.
For a stable Dist::Zilla, start with a tagged release.  Eventually, there may
be a maint branch, but I don't see that happening any time really soon.

