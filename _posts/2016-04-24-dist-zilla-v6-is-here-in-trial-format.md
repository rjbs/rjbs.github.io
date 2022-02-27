---
layout: post
title : "Dist::Zilla v6 is here (in trial format)"
date  : "2016-04-24T08:38:22Z"
tags  : ["perl", "programming"]
---
I've been meaning to release Dist::Zilla v6 for quite a while now, but I've
finally done it as a trial release.  I'll make a stable release in a week or
two.  So far, I see no breakage, which is about what I expected.  Here's the
scoop:

## Path::Class has been dropped for Path::Tiny.

Actually, you get a subclass of Path::Tiny.  This isn't really supported
behavior.  In fact, Path::Tiny tells you not to do this.  It won't be here
long, though, and it only needs to work one level deep, which it does.  It's
just enough to give people downstream a warning instead of an exception.  A lot
of the grotty work of updating the internals to use Path::Tiny methods instead
of Path::Class methods was done by Kent Frederic.  Thanks, Kent!

## -v no longer takes an argument

It used to be that `dzil test -v` put things in verbose mode, `dzil test -v
Plugin` put just that plugin in verbose mode, and `dzil -v test` screwed up
because it decided you meant `test` as a plugin name, and then couldn't figure
out what command to run.

Now `-v` is all-things-verbose and `-V` is one plugin.  It turns out that
single-plugin verbosity has been broken for some time, and still is.  I'll fix
it very soon.

## Deprecated plugins deleted

I've removed `[Prereq]` and `[AutoPrereq]` and `[BumpVersion]`.  These were
long marked as deprecated.  The first two are just old spellings of the
now-canonically-plural versions.  BumpVersion is awful and nobody should use it
ever.

## PkgVersion can generate "package NAME VERSION" lines

So, now you can avoid deciding how to assign to `$VERSION` and add the version
number directly to the package declaration.  This also avoids the need to have
any room for blank lines in which to add `$VERSION`.

## Dist::Zilla now requires v5.14.0

Party like it's 2011.

