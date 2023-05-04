---
layout: post
title : "PTS 2023: The Lyon Amendment (minimum perl) (2/5)"
date  : "2023-05-04T12:09:01Z"
tags  : ["perl", "programming"]
---

## Minimum Toolchain Perl

Ten years ago, the "toolchain gang" who manage the libraries most central to
deploying and testing CPAN libraries came to [an
agreement](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lancaster-consensus.md)
on the minimum supported version of perl.  Nobody needed to keep maintaining
v5.6, and everyone who hadn't already, moved to v5.8.  That was ten years ago,
but the toolchain was still pinned to v5.8.  I am not enthusiastic about
targeting v5.8, and have [written about this before]({% post_url
2023-01-08-leaving-perl-v5.8-behind %}).  I bumped some modules to v5.12,
earlier this year.  I got some feedback, both positive and negative, but I felt
good about it.

This year, a number of people wanted to talk about bumping that number.  To me,
the interesting question wasn't about the toolchain per se, but about what
version of perl people feel they can rely upon in CPAN without being a pain to
others.  I didn't have strong feelings, coming into this conversation, but I
thought it would be nice if the version number moved.

There were a few positions voiced in these conversations:

1. Supporting v5.8 should continue, in part because any change in required
   version may inconvenience people, and in part because it makes bisecting
   changes in how code behaves more difficult (you can't, for example, test a
   library on v5.8 if it `configure_requires` v5.22).
2. We should provide an alternative CPAN index or repository that will only
   index code known to work with older versions of Perl.  If you use that
   version of CPAN, you won't ever get the newer Test-Deep, but you can get the
   last one that worked on v5.8.
3. We should agree to a newer minimum, both for the convenience of the
   toolchain authors in coding, but also in debugging: it takes real time to
   work around issues in perl that were fixed 12 years ago.
4. The new version shouldn't be a one-time bump, but a policy about what
   version we support over time.

The short version here is that the last two positions won out, and many people
were interested in the "alternative index" idea.  For my part, I saw many
complications in making something reliable and long-lived, so my goal was to
*not* couple the idea of a new version to the existence of this system.  As for
the first position, basically it was outvoted.  I do like that Perl has a long
tradition of backward compatibility, but for me, it can only go so far.  All
the way back to 2003 is too far.

In the end, we wrote an [amendment to the Lancaster
consensus](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lyon-amendment.md),
stating that the toolchain would track the perl of 10 years ago.  That would
mean that this year we'd target v5.18 — but we also said we'd let Red Hat v7
reach end of maintenance support before moving past its version of perl, v5.16.

That means v5.16 this year, v5.20 next, then v5.22.  To my mind, this is huge
progress.  I'm not in a rush to go change everything, but I will definitely
freely update my code when I touch it.  CPAN::Meta::Requirements is likely to
get an update soon, requiring at least v5.10, maybe v5.12.  Test::Deep may
follow on toward newer versions over time.

If you want to see older versions of perl continue to have `cpan Some::Library`
work (by finding an older version of that library), keep an eye out for news
about projects to make that possible.  I don't really plan to follow that work.
