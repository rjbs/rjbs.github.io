---
layout: post
title : "blast from my programming past"
date  : "2008-07-30T02:27:09Z"
tags  : ["perl", "programming"]
---
Despite all my attempts to convince myself that it was a bad idea and not
needed (I mean, I even tried to solve the problem with XML), I have found
myself working on a schema and data validation system.

I'll write more about it when it's more done.

In the meantime, I needed, in several places, both in the schemata and in my
internal code, to quickly say "given these minimum and maximum values, which
may or may not be exclusive, construct a validator."

I was slowly slogging through this, dreading the growing cross-product of
possible combinations, when I realized that I made this simple five years ago,
and now I could reap the benefits -- becoming, once again, probably the only
person to use Number::Tolerant.

    push @tolerances, Number::Tolerant->new($arg->{min} => 'or_more')
      if defined $arg->{min};
    push @tolerances, ... if ...;

    my $tol = reduce { $a & $b } @tolerances;

    return sub { $_[0] == $tol };

Thanks, younger me!  For once you didn't set me up for more obnoxious work.

