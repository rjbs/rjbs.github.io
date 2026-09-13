---
layout: post
title : "perl-ci: new container images for CI of CPAN modules"
date  : "2026-09-13T02:00:00"
tags  : ["perl","programming","testing"]
---

I have changed, slightly, how I run CI on my Perl modules, and this is the
update.

A couple years ago, I posted about writing [dzil
workflower]({% post_url 2024-06-02-dzil-workflower %}) and the
[dzil-actions]({% post_url 2024-06-08-github-actions-for-dzil %}) set of
automations for using them to automatically test changes to the Perl modules
that I maintain.  In brief, it works like this:

* `dzil workflower` installs a GitHub workflow definition into your repo
* the workflow runs `dzil-matrix` from rjbs/dzil-actions
* `dzil-matrix` will...
    * on a boring Ubuntu runner, build a tarball using Dist::Zilla
    * figure out all the perl versions to test on
    * start one container for each, using
      [docker-perl-tester](https://hub.docker.com/r/perldocker/perl-tester)
    * in each container, install prereqs and run the tests
    * report the total result

This has been pretty great for the years since.  It's caught real problems, and
I absolutely stood on the shoulders of a bunch of people here.  I didn't build
the container images and I cribbed a lot of my "how to test like this" from
other folks who came before me.

*Mostly*, this has been pretty great.  Every once in a while, something stops
working quite right, and I go look, and some new library needs to be pinned, or
there's some other weird problem with some old version of perl.  This makes
supporting older versions annoying.

I release a lot of stuff that requires v5.20 or newer.  I'm pretty aggressive,
compared to a lot of CPAN authors, about moving versions forward.  On the other
hand, when I'm willing to support an old perl, I want it to be easy.  Anything
that makes v5.18 a pain to test is a reason for me to drop "use v5.20" in
there: problem solved.  ("That's a 12 year old version of perl!" I will cry.)

Anyway, I've been hitting this a bit more lately, and I thought that after
years of pushing on "just upgrade", I would *not* do that for a week or so, and
went to fix the problem at hand.  This would mean making a PR against the
[docker-perl-tester repo](https://github.com/Perl/docker-perl), fiddling with
its build scripts or cpanfile.

Unfortunately, this time, I hit a few problems in succession, and the more I
dug, the more I slumped down in my seat.  The problem was like this:
docker-perl-tester is built on docker-perl.  It's basically a docker-perl
image, but with a bunch of test libraries pre-installed.  This is a good idea!
It means we can re-use base images.

The problem is that docker-perl's mission is at odds with docker-perl-tester's.
Here's a snippet from the docker-perl README:

> This project is the source for the Docker Library official perl images, which
> builds the officially-supported perl versions on the officially supported
> Debian base images for several architectures. These are reviewed and built by
> Docker Library.

The "officially-supported perl versions" are basically "the last three".  If I
want to test on 5.8, I'm talking about "the last nineteen".  This is not a
small gap.  Meanwhile, docker-perl doesn't just build a container image.  For
v5.44.0, it builds the matrix of:

* bookworm, bullseye, or trixie
* threaded or not threaded
* slim or not slim

docker-perl-tester picks one and builds on that.  Of course there's no trixie
build of v5.14 from docker-perl, because v5.14 was long out of support by the
time trixie came around.  If you wanted v5.14, you'd get buster (ca. 2019).

So, **here's what I wanted**:

* one container image per perl version (think "v5.40" not "v5.40.3")
* a consistent Debian version
* with that version of perl
* with known-good versions of common or critical libraries

That's basically squashing the two projects together, eliminating the
complications introduced by their mismatches.  It could not have been much
easier, either.  I wrote a detailed description and handed it to Claude Code,
which spat out eight commits that solved the problem.  I've added ten more
since then, but they've largely been administrative work, like a workflow to
delete old images.

The one interesting fix was Test2::Harness.  My workflow always runs tests with
`yath`, but the earliest pin for Test2::Harness in docker-perl-tester was for
perl v5.10.  Any earlier and it was omitted.  I tried picking one that would
work and just fixing the cpanfile, but I stuffed it up.  So I said, "Hey,
figure out what version will get the job done" and I was presented with an
option:

* switch to v5.8.9 for v5.8 testing (which I had told it must use v5.8.8) and
  use Test2::Harness v0.001074
* stay on v5.8.8 and use v0.001030, which has some weird bugs

I picked the second option, as the bugs aren't weird.  But what I didn't need
to do was sit there bisecting myself.  With that done, I was able to *lower*
the minimum perl for Test-Fatal to v5.8, knowing I'd have a reliable CI run.

Right now, I'm building all of these images on trixie.  In the future, I may
switch it to forky.  The code already takes Debian version as an option, I just
figured that 20 images on the GitHub Container Repository was enough.  Well…
actually, it's more like 40, because every labeled version is a
dual-architecture manifest.  They're built for arm64 and amd64, so I can use
them for local testing on my macOS before sending things up to run on GitHub
Actions.  Given the availability problems up there lately, doing my part
locally feels like a kindness.

You can find the code and packages on GitHub at
[rjbs/perl-ci](https://github.com/rjbs/perl-ci).
