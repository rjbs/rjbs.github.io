---
layout: post
title : "leaving perl v5.8 behind"
date  : "2023-01-08T16:17:11Z"
tags  : ["cpan", "perl", "programming"]
---

On New Year's Eve, I [posted that I'd uploaded 114 updated
distributions](https://rjbs.cloud/blog/2022/12/so-many-cpan-uploads-code-review-mark-iii/)
to the CPAN.  Many of those, in addition to updating distribution metadata,
made some changes to the version of perl they require, or say they may require
in the future.  I mentioned that in my last post.  I was adding text something
like this:

> This library should run on perls released even a long time ago. It should
> work on any version of perl released in the last five years.
>
> Although it may work on older versions of perl, no guarantee is made that the
> minimum required version will not be increased. The version may be increased
> for any reason, and there is no promise that patches will be accepted to
> lower the minimum required perl.

I've got more than one piece of boilerplate for various forms of policy, but
generally they are tied to one thing, conceptually: the ongoing march of time.
The policy above ("long-term") says you should expect the code to keep working
for perls up to five years old.  Another says ten.  Another tracks the
p5p-supported perl versions, which is also effectively time-based.  There are
three that don't:

* **toolchain**:  This says the code will abide by the consensus of The Toolchain
  Gang, which mean v5.8.1 until further notice.  (More on that below.)
* **none**:  This is abandoned software.
* **no-mercy**:  I will change anything at any time.  Do not rely on anything about
  this software.

I use those quite rarely.  I find that mostly I'm putting long-term support
onto modules, and feel good about that.

## what about older perls?

I put "perl v5.8" in the title of this post, but I don't want to cloud the
point:  I think some later versions are *also* too antique to be asked to cater
to.  I've been pretty happy to bump the minimum required version of a library
to v5.12 for the simple creature comforts provided there, and I don't feel bad
about it.  So, why not?

Let's consider Test::Fatal.  [I wrote Test::Fatal in
2010](https://rjbs.cloud/blog/2010/10/test-fatal-for-simpler-exception-testing/),
and I wrote it to make it easier to run the most cutting edge perl.  The
previous solution, Test::Exception, would break now and then on development
versions of perl.  In 2010, I wasn't project manager for perl5 yet, but I was
involved in p5p, and I ran the monthly snapshots as my primary development
perl.  I wrote Test::Fatal so more code would keep working on the newest
versions of perl.  We converted Moose to use Test::Fatal within a week of its
release.

Test::Fatal was pretty widely adopted.  Today, 16k other CPAN distributions
depend on Test::Fatal, either directly or indirectly.  In CPAN jargon, we
sometimes say that means that Test::Fatal is "[high up the
river](https://neilb.org/2015/04/20/river-of-cpan.html)", meaning that many
other libraries are affected by changes to Test::Fatal, and so it should not
change too precipitously.  I was in the room when the river metaphor was first
drawn on a whiteboard, and I think it's a good one.

I also think that a big question is what it means to change too precipitously.
I think, for example, that releasing a new version of a high-upriver library
that suddenly makes an uncommonly used method fatal is bad form.  Better to
give notice via deprecation warnings or, when that's not possible,
documentation.  People actively developing against the library maybe
continuously integrating, and they'll be better served by "fix this soon" than
"stop everything and fix it now."

On the other hand, I think there should be a basic assumption that eventually a
plaform will become obsolete and abandoned.  That is:  at some point, it is
reasonable to assume that anybody on an *n* year old platform is accepting the
implicit risk that they will be unable to run new versions of programs.  They
can, of course, keep running the old version!  Also, if they really need *part*
of the update — you know, the part that didn't start relying on a new perl —
maybe they can build their own forked version.

This is a pretty common conception throughout software.  New versions of
software eventually stop building on old compilers or on old operating systems.
Updated websites stop working on MSIE6.  Different ecosystems will have a
different take on what version of the platform is too old to support, but there
tends to be a norm.  On the CPAN, there isn't really such a norm.  Or, maybe,
the norm is v5.8, which just means the expected time window is one year longer
every year.

It wasn't always like this.  Many of the libraries I maintain once supported
perl v5.4 or v5.6, and when I moved them to v5.8, there was very little noise
-- in part, I think, because the general churn in all parts of Perl development
was higher.  We were doing more, so it was normal to keep moving forward.  Why
did it change?  Well, first, consider questioning *whether* it changed.  I
think so, but I'm relying on my memories of a general vibe.  This is hardly
science.  And as to why *I* think it changed?  It's hard to say.  I think that
perl v5.8 was the go-to for a very long time.  We had two years from perl v5.5
(which was not a dev release, despite the odd number) to v5.6, then another two
years to v5.8.  It took *five* years to get the next version, v5.10, and then
many people held off until v5.10.1, which was *another two years*.  During this
time, v5.8 got deeply entrenched.

But that was all ages ago.  Perl v5.10 came out in 2007, during the presidency
of George W. Bush, the same year as the first iPhone.  Anyway, around fifteen
years ago.  So, when a new version of a CPAN library *today* starts to require
a version newer than v5.8, the affected audience is people who:

1. have had fifteen years to upgrade their perl, but chose not to
2. continue to want to install the latest versions of libraries from the CPAN

I hold that catering to this behavior is a bad idea.  It penalizes the module
author or maintainer.  Despite (potentially) writing all their private code
targeting a recent perl, they must switch into another dialect of perl for
their CPAN work.  As time goes on, the gulf between these dialects grow.  When
a library is released in 2010 and targets v5.8, it forgoes the [benefits of
v5.10](https://perldoc.perl.org/perl5100delta) that the author might like.  By
2022, it's now also forgoing the benefits of
[v5.12](https://perldoc.perl.org/perl5120delta),
[v5.14](https://perldoc.perl.org/perl5140delta),
[v5.16](https://perldoc.perl.org/perl5160delta),
[v5.18](https://perldoc.perl.org/perl5180delta),
[v5.20](https://perldoc.perl.org/perl5200delta),
[v5.22](https://perldoc.perl.org/perl5220delta),
[v5.24](https://perldoc.perl.org/perl5240delta),
[v5.26](https://perldoc.perl.org/perl5260delta),
[v5.28](https://perldoc.perl.org/perl5280delta),
[v5.30](https://perldoc.perl.org/perl5300delta),
[v5.32](https://perldoc.perl.org/perl5320delta),
[v5.34](https://perldoc.perl.org/perl5340delta), and
[v5.36](https://perldoc.perl.org/perl5360delta).  Some of these benefits may be
small, like using `say` instead of `print` with a newline, or like using `//=`
instead of a ternary.  Still, the maintainer has to *remember* all this, and
has to suffer through a more tedious experience, and with the knowledge that
this gulf will only expand, because the far end is tied to a fixed point.

There should be a line drawn somewhere.  I have tentatively declared, for me,
that I think it should be around five versions, with wiggle room based on
circumstances.

## what if I'm affected?

I try to imagine what I'd do if I had to maintain important code that ran on
v5.8.  I can't imagine it, though, *because I'm living it*.  Most of the Perl 5
code at work runs on v5.34, but there are some significant bits of code that
still run on v5.8.8, for reasons that are not particularly interesting, but
also not particularly easy to work around.  (Ask me again in a year, I hope
it's all on v5.30-something by then.)

So, what do I do when somebody (like, say, *me*) releases a new version of
something that used to work on v5.8 but now requires v5.12?  Normally, nothing.
I look at the changelog and if it's terribly important (say, a CVE), we port
that fix to our own production environment.  We deploy from a private CPAN
mirror that has been pinned to the versions we use.  This prevents us from
shipping random versions to production without review.  It's something like
[Pinto](https://metacpan.org/dist/Pinto/view/lib/Pinto/Manual/Introduction.pod),
but a bit different.  (It's called XPAN, and we never really managed to make it
generally useful software.)

Of course, most people don't use XPAN or Pinto, and the idea of it's a bit
weird unless you're a bit of a CPAN-head.  On the other hand, there's
[Carton](https://metacpan.org/pod/Carton), which follows the model used by many
deployment systems, now.  You pin the versions you're using one time, and then
bump them deliberately later.  Carton isn't the only solution in this space for
Perl.  It's not even the only one by Miyagawa, who also wrote
[Carmel](https://metacpan.org/dist/Carmel).

If you need to pin your versions now, before more things start needing new
perls, I think those are good solutions.  Also, I think that's it's an
*appropriate level of onus*.  My position is that over time, the cost of not
upgrading should be paid more by the non-upgrader.  The measure of time over
which the burden shifts may not be clear cut, but I don't think we should worry
much about perls over ten years old.

## can't you just fork?

Let's say I wanted to make Test::Fatal use v5.20.  One option would be to fork
Test::Fatal into Test::Fatal2.  The API wouldn't change, just the required
version of perl.  Then I'd go find all my own downstream code that used
Test::Fatal and make it use Test::Fatal2.  But I'd have to *also* fork that
code, if it was on the CPAN, for similar reasons: if its version was thus going
up, it has to be forked, too, right?

Meanwhile, if Test::Fatal has a downstream dependent which has another upstream
dependency that depends on Test::Fatal, and *that* upstream doesn't switch to
Test::Fatal2, it's a bit of a mess all over, especially since *either*
Test::Fatal is now unmaintainer *or* there are two different maintainers.

Now multiply that across *n* things I might want to use a newer perl.

Now imagine that someday I want to make Test::Fatal2 use v5.30, and am
pressured to instead make Test::Fatal3.

If something has to fork, it should be the CPAN itself.  That is:  provide an
alternative CPAN mirror whose index is all 5.8-safe versions.  This was offered
years ago (by David Cantrell, if I recall correctly), but didn't last.  Really,
though, I maintain that the right solution is pinned versioning.

## perl, backcompat, and the toolchain

Perl has a great track record on backward compatibility.  Breaking changes have
been very rare, and generally pretty small.  This has been for many reasons,
but I can say that a large part of this policy was worked out and made explicit
by Jesse Vincent and me in the v5.12-v5.18 era, and the goal was to make it as
easy as possible for people to upgrade their perl often.  We also spent time
working with downstream vendors to make sure they could keep packaging new
perls in a timely way.  Again, I think the right priority here is to make it
easy to upgrade perl, and easy to upgrade important libraries on that recent
perl.  Making it easy to upgrade important libraries forever on very old perls
is not a plan I endorse.

Among other reasons that I've mentioned, I also think that spending time on
improving perl itself is significantly less valuable and rewarding when those
improvements are more or less not available.

So, what about the toolchain?  I mentioned, above, that there's a "toolchain"
policy in my set of boilerplates, which says it will stick with v5.8.1.  This
is the result of a set of conversations at the Perl QA Hackathon, an event
which was later given the more apt name "Perl Toolchain Summit".  It was an
annual event (last held before COVID) where folks who maintained PAUSE, CPAN
clients, Test::Builder, and similarly "Very Core to The CPAN Working" code got
together to solve problems and get things done.  I have always had a very high
opinion of the value of those summits.

At the summit held in Lancaster, one of the questions was about what version of
perl "the toolchain" could require.  "Toolchain" meant, here, the CPAN
installer (CPAN.pm), the distribution install tools (ExtUtils-MakeMaker,
Module-Build), and Test::Builder, which powered all the basic testing code used
by everything on CPAN at the time.  The big questions were:

1. Could we all agree to drop support for v5.6?
2. Could we all agree to require later v5.8 versions, which had significant
   Unicode fixes?

The answers at the time were "yes" and "no" respectively, but the "no" was very
tentative.  We agreed that if toolchain maintainers hit significant problems in
v5.8.1 that would be fixed by later v5.8 versions, we could bump to those
versions, up to and including v5.8.4, which shipped with Solaris 10.

This decision was part of "[The Lancaster
Consensus](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lancaster-consensus.md)",
which agreed a number of other things, too.  I remember the process very well,
as well as the little hotel we stayed at.  Also, I had "Life in a Northern
Town" in my head all week.

But I digress.

I think there are few things I'd point out regarding the Lancaster Consensus
and its agreement about perl v5.8.1:

* It was meant as much to free people from v5.6 as to keep them on v5.8.1.
* It was about a very limited set of libraries that form the absolutely final
  layer of version compatibility.  Without their functioning, nothing else can
  be installed.
* It was ten years ago.  (If it had said "perl from 10 years ago" instead of
  "v5.8.1", it would've meant v5.8.1 when signed and v5.18 now.)

## what's next?

I am not planning to go crazy and update all my libraries to v5.34.  (I
acknowledge that someone will say that I have already lost my mind in requiring
v5.12 in many things.)  On the other hand, I am not planning to put in any
effort on continued compatibility with v5.8.  As I release more software, I
will require newer versions of perl.  That's what's next.

I've done a [decent amount of
work](https://rjbs.cloud/blog/2015/04/my-stupid-cpan-meta-analyzer/), [over the
years](https://rjbs.cloud/blog/2018/04/i-went-to-the-perl-toolchain-summit-in-oslo/),
on a [little set of programs](https://github.com/rjbs/CPAN-Metanalyzer) that
gather and analyze dist metadata from the CPAN.  I'll probably write a bit more
about them, and how I have used them to see things about versions and
prerequisites.  I also might write a bit about Miyagawa's report on [what
version of perl is using cpanm](https://cpanmetadb.plackperl.org/versions/) and
some similar work I did recently.  But I might not, we'll see where I get to in
the next week or two.

I'll also keep trying to make progress on bug backlogs, build improvements, and
improvements to perl.  Wish me luck!
