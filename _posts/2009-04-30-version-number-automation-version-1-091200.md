---
layout: post
title : version number automation, version 1.091200
date  : 2009-04-30T05:12:18Z
tags  : ["distzilla", "perl", "programming"]
---
I've pushed some changes to the [Dist::Zilla
repository](http://github.com/rjbs/dist-zilla) to implement a simple first-pass
at autonumbering of versions.  After careful consideration -- one might say
pathological consideration -- I have set the default format to `x.yyDDD0` where
`x` is an arbitrary integer, `yyDDD` is the two digit year and the three digit
day of year and 0 is literal.

The `x` lets me use the major number to announce API changes, even if they're
not respected by the CPAN toolchain.  It also lets me abandon a version
numbering scheme by bumping `x` and trying something new after the dot.

`yyDDD` is not as obviously a date as 20090429, but it's much more compact.
People are used to version strings up to six places long after the decimal in
Perl.  Eight places gets sort of obnoxious, and nine to twelve (for `yyyymmdd0`
through `yyyymmddhhmm`) are just horrible.

The zero won't really be a constant.  If I need to do two releases in a day
(oops!) then I can use a number other than zero.  I have never needed to cut
more than two or thee releases in a day.  I am willing to bet I won't need to
cut eleven.  If I do, there's always `yyDD99`.  I don't know how I'll populate
that final constant, but I'll figure it out later.

The implementation is fun.  The configuration for the AutoVersion plugin takes
a "format" string, which is really a Text::Template string that has access to
the major number (`x`) and a `cldr` function for doing CLDR pattern formatting
on a DateTime object representing "now."  That means the default configuration
is equivalent to:

    [AutoVersion]
    major  = 1
    format = {{ $major }}.{{ cldr('yyDDD') }}0

I look forward to integrating this with the someday-future VCS integration
framework.

