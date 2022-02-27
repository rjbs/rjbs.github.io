---
layout: post
title : more more cpan metrics
date  : 2008-11-04T19:06:29Z
tags  : ["cpan", "perl"]
---
As suggested, I have run the code such that a dist's mere appearance on the
CPAN is not counted.  In other words: code exists if it is used.  If not, it is
ignored entirely.  It ends up not having much effect.

    author   | volume | req (old) | req (new)
    ZOFFIX   | 1      | 145       | (n/a)
    ADAMK    | 2      | 32        | 34
    RJBS     | 3      | 43        | 43
    MIYAGAWA | 4      | 82        | 84
    NUFFIN   | 5      | 85        | 91
    GBARR    | 114    |  1        | 1
    PMQS     | 221    |  2        | 2
    PETDANCE | 31     |  3        | 3
    MSCHWERN | 40     |  4        | 4
    SAPER    | 32     |  5        | 5

JROCKWAY suggested running this in reverse: see who uses the most.  I think
that doing both would be interesting: who gets used a lot, "despite" also using
a lot of prereqs.

