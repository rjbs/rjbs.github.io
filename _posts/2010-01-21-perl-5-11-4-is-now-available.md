---
layout: post
title : "perl 5.11.4 is now available!"
date  : "2010-01-21T14:15:20Z"
tags  : ["perl", "programming"]
---
> And you don't suppose that I went into it headlong like a fool? I went
> into it like a wise man, and that was just my destruction. And you
> mustn't suppose that I didn't know, for instance, that if I began to
> question myself whether I had the right to gain power -- I certainly
> hadn't the right -- or that if I asked myself whether a human being is
> a louse it proved that it wasn't so for me, though it might be for a
> man who would go straight to his goal without asking questions.... If
> I worried myself all those days, wondering whether Napoleon would have
> done it or not, I felt clearly of course that I wasn't Napoleon.
>
> -- Fyodor Dostoevsky, *Crime and Punishment*

It gives me great pleasure to announce the release of Perl 5.11.4.

This is the fifth DEVELOPMENT release in the 5.11.x series leading to a
stable release of Perl 5.12.0. You can find a list of high-profile changes
in this release in the file "perl5114delta.pod" inside the distribution.

Perl 5.11.4 is the first release of Perl 5.11.x since the code freeze for Perl
5.12.0.  It and subsequent releases in the 5.11 series include very limited
code changes, almost entirely related to regressions from previous released
versions of Perl or which resolve issues we believe would make a stable
release of Perl 5.12.0 inadvisable.

You can  download the 5.11.4 release from
[search.cpan.org](http://search.cpan.org/~rjbs/perl-5.11.4/)

The release's SHA1 signatures are:

    MD5:  40f2199cc48de9cb27fd55d91b0d3b3a          perl-5.11.4.tar.gz
    SHA1: 16d26872078c880ffec222a63935d30fb0cbd25a  perl-5.11.4.tar.gz

    MD5:  bafebb25fd9647bb9ca829477935b3f0          perl-5.11.4.tar.bz2
    SHA1: 8eaaff0c2f8305787baba070ae84369158accbf7  perl-5.11.4.tar.bz2

This release corresponds to commit 2908b263df in Perl's git repository.
It is tagged as 'v5.11.4'.

We welcome your feedback on this release. If you discover issues
with Perl 5.11.4, please use the 'perlbug' tool included in this
distribution to report them. If Perl 5.11.4 works well for you, please
use the 'perlthanks' tool included with this distribution to tell the
all-volunteer development team how much you appreciate their work.

If you write software in Perl, it is particularly important that you test
your software against development releases. While we strive to maintain
source compatibility with prior stable versions of Perl wherever possible,
it is always possible that a well-intentioned change can have unexpected
consequences. If you spot a change in a development version which breaks
your code, it's much more likely that we will be able to fix it before the
next stable release. If you only test your code against stable releases
of Perl, it may not be possible to undo a backwards-incompatible change
which breaks your code.

Perl 5.11.4 represents approximately one month of development since
Perl 5.11.3 and contains 17682 lines of changes across 318 files
from 40 authors and committers:

Abigail, Andy Dougherty, brian d foy, Chris Williams, Craig A. Berry,
David Golden, David Mitchell, Father Chrysostomos, Gerard Goossen,
H.Merijn Brand, Jesse Vincent, Jim Cromie, Josh ben Jore, Karl
Williamson, kmx, Matt S Trout, Nicholas Clark, Niko Tyni, Paul Marquess,
Philip Hazel, Rafael Garcia-Suarez, Rainer Tammer, Reini Urban, Ricardo
Signes, Shlomi Fish, Tim Bunce, Todd Rinaldo, Tom Christiansen, Tony
Cook, Vincent Pit, and Zefram

Many of the changes included in this version originated in the CPAN
modules included in Perl's core. We're grateful to the entire CPAN
community for helping Perl to flourish.

Notable changes in this release:

* Version semantics have been more clearly defined
* Wide-ranging improvements to documentation, both to clarify and to correct
* Numerous CPAN "toolchain" modules have been updated to what we hope are the final release versions for Perl 5.12.0.
* Some crashing bugs or regressions from earlier releases of Perl were fixed for this release.

Development versions of Perl are released monthly on or about the 20th
of the month by a monthly "release manager". You can expect following
upcoming releases:

    February 20    -    Steve Hay
    March 20       -    Ask Bjørn Hansen

