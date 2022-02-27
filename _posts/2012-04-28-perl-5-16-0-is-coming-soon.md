---
layout: post
title : Perl 5.16.0 is coming soon!
date  : 2012-04-28T19:23:21Z
tags  : ["perl", "programming"]
---
In October 2011, Jesse Vincent [handed me the patch
pumpkin](http://www.nntp.perl.org/group/perl.perl5.porters/2011/10/msg178691.html),
meaning that it's now my responsibility to keep Perl development on track and
moving apace.  One of the biggest parts of this responsibility is making sure
that we release new versions of perl, and that they're fit for human
consumption!

We're getting quite close to the next production release, which will be perl
5.16.0.  Right now, there are no open tickets marked as blocking its release,
although there *are* a few that need to be looked at to decide whether they
block.  Even if so, we've got very few bugs on the radar, and we're getting
ready to get this thing out the door.

For those of you who haven't been paying close attention to how perl 5
development has changed, it's like this:  almost all of the development effort
goes toward the development branch of perl, "blead."  Every month we release a
new development snapshot.  Every year we release a new stable production
release.  As we approach each year's new stable release, the amount of changed
expected (and allowed) in blead is reduced.  Right now, we're in the frozenest
part of the "code freeze" that precedes a stable release.  Changes only go in
if they're simple and obvious bugfixes, or complicated but critical bugfixes,
or documentation improvements.  There are some other categories, but this is a
good summary.  The code freeze, like all things in Perl development, is a
priority, but not a hard and fast rule.

The [`perl5160delta`](https://github.com/mirrors/perl/blob/blead/Porting/perl5160delta.pod) document, which describes what's new in perl 5.16.0, needs
some finalization, but not much more.  After that, we're just on the lookout
for serious bugs, smoke failures, and stupid typos.  Smoke failures get
categorized as either serious bugs, flukes, or edge cases.  Failures
categorized as serious bugs need fixing before 5.16.0.  The other kinds don't.

So, this means that we could be looking at perl-5.16.0 RC1 within a week!

If you use perl 5, the most important thing you can do right now is *test*!
Build perl from blead and test your code and your favorite modules.  You can
build perl with [perlbrew](http://perlbrew.pl/) very easily.  Once you've got
perlbrew set up, just run `perlbrew install blead`, switch to it with `perlbrew
use blead` (or `s/use/switch/` if you're on an environment where `use` won't
work), and get to work testing.

Otherwise, you can clone `git://perl5.git.perl.org/perl.git` and follow the
instructions in `INSTALL`.  Build with the same options you use in production.
Let us know what fails that didn't fail before, either by running `perlbug` or
mailing [p5p](http://lists.perl.org/list/perl5-porters.html) if `perlbug` gives
you trouble.

I'm hoping we'll see perl 5.16.0 hitting mirrors in early May, and 5.16.1 a
month or two later.

