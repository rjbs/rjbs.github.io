---
layout: post
title : Will your perl remain supported -- and what does that mean?
date  : 2011-01-28T16:11:13Z
tags  : ["perl", "programming"]
---
Yesterday, I tweeted this:

> Remember, Perl shops: if you're still on 5.8 come April, you're on an
> unsupported legacy version. Current versions are 5.10.1 and 5.12.3

A few people asked for more details, and in giving them, I said this:

> It's more an amalgam of truths than an actual truth.

Right now, the average company using Perl (or Python, or Ruby, etc.) has no
support contract for the language.  It's free, open source software that comes
with no warranty, guarantee, or promises.  Of course, everybody knows that this
doesn't mean that it's every man for himself.  There are a number of volunteers
who put in incredible amounts of work to fix bugs, ensure portability, and
improve the language itself.  The key word above is *volunteer*, which means,
fundamentally, that nobody is under any obligation to fix *anything*.  If you
absolutely need work done, you just might have to pay for it.  (In my
experience, this is exceedingly rare; the lengths to which I have seen the core
Perl team to go to fix bugs that don't even affect them directly are both
staggering and humbling.)

Still, the Perl team wants people to have the right kind of expectations, and
that comes in two parts:  the team *will* investigate and try to fix bugs in
recent perls, but it *won't* promise to spend its valuable time on old
versions.  After all, the internals of perl change over time, and it takes a
significant mental effort to keep various major versions of perl's VM and its
implementation fresh in one's mind.

It was recently my great pleasure to perform the routine work required to
[release
perl-5.12.3](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2011-01/msg00748.html),
which contained the most up-to-date copy of
[perlpolicy](http://search.cpan.org/dist/perl/pod/perlpolicy.pod), which
contains the promises that the core team will try to keep, regarding perl
support.  Here are two of the key points:

* we will attempt to fix critical issues in the two most recent stable release series
* we will attempt to provide "critical" security patches or releases for release series begun within the last three years

In April, the release process for 5.14.0 begins, meaning we'll probably have it
in April or May, barring strange circumstances.  Once 5.14.0 is out, the
official support period for 5.10.x will end, and the chances of bugfixes being
applied to the `maint-5.10` branch will become very slim.  The chances of a new
5.10.x release will become tiny.  There simply won't be enough interested
volunteers to do the work for such an old version.  Maybe if there is a big
influx of workers who want to support 5.10, the policy will change -- but that
seems a pretty unlikely scenario.

Not only will 5.10.x be out of its normal "official support period," but it
will be out of its security update period, too.
[perlhist](http://search.cpan.org/dist/perl/pod/perlhist.pod) tells us that
5.10.0 was released in December, 2007 -- already more than three years ago.

So, with spring's 5.14.0 release obsoleting 5.10, why was I talking about 5.8?
Well, perl 5.10.1 was released in August, 2009, and I suspect that almost
anybody running 5.10 is running 5.10.1 -- it has too many critical bugfixes for
me to stomach the idea that there's a lot of 5.10.0 out there.  (Let's not
burst my bubble, okay?  Optimism is all I have.)  People who upgraded their
perl in 2009 can probably manage to do it again in the next year or two without
serious pain.  They remember how.

On the other hand, experience on IRC, mailing lists, and the rest of the world
has told me that the most common subversions of 5.8 in use are 8, 5, and 4,
probably in that order.  My gut tells me that 5.8.1 comes next, but I'm a lot
less confident.  Those releases were in 2006, 2004, 2004, and 2003,
respectively.  Assuming that these upgrades were done within a year or so of
the language release (which isn't a great assumption, but a tolerable one) then
there are a lot of places who haven't upgraded their primary programming tool
in over five years.  Think of all the other technical tasks you last performed
five years ago, and you might realize how little you remember how you did it,
and what all the little details were that cost you your 80% time overrun.

That's why I try to track current versions whenever possible.  It's not that
older versions are always a serious liability, it's that it can cost much more
to upgrade only very rarely, compared with frequently.  It also drives you to
have better integration tools, since you integrate frequently and want it to
have a low cost.  It means that when the next maintenance release comes out,
you can easily perform an automated test of your systems, build a new
deployment build, and upgrade, all as routine tasks.

So, my advice is this:  if you're building your company's software on a
doubly-obsolete version of a tool that's still under development, it's time to
begin tooling up to stay up to date.

