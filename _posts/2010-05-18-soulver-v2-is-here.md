---
layout: post
title : soulver v2 is here
date  : 2010-05-18T22:14:10Z
tags  : ["math", "software", "stupid"]
---
[I wrote about Soulver](http://rjbs.manxome.org/rubric/entry/1465) about three years ago when I accidentally acquired a free license.  This morning, I saw Marcus promoting a new version and I thought I'd give it a look.

On one hand, it looks to have gotten lots of neat new features, some of which could be very useful.  It also no longer bills itself as understanding mathematical expressions in English quite so literally.  It focuses more on simple, loosely structured shorthand for simple math.  On the other hand, it still accepts lots of stuff that it just doesn't know what to do with.  It doesn't say, "I have no idea what I'm doing, so I can't answer."  Instead, it just does crazy things.

Here's the same set of questions I posed it three years ago, with the old and new answers.

    Q: 2 to the power of 2
    O: 4
    N: 4
    ?: right!

    Q: 2 squared
    O: 2
    N: 2
    ?: wrong!

    Q: square root of 2
    O: 1.414...
    N: 2
    ?: was right, now wrong

    Q: cube root of 2
    O: 1.414...
    N: 2
    ?: wrong!

    Q: average of 1, 2, and 3
    O: 6
    N: 5
    ?: wrong!

    Q: sum of 1, 2, and 3
    O: 6
    N: 5
    ?: was right, now wrong

    Q: 1, 2, and 3
    O: 6
    N: 15
    ?: was right, now wrong

    Q: quotient of 9 and 3
    O: 12
    N: 12
    ?: wrong!

    Q: minimum of 1 or 3
    O: 13
    N: 3
    ?: was mind-bogglingly wrong, now just wrong

    Q: 1 or 2 or 3
    O: 123
    N: 6
    ?: was wtf, now just wrong

There are *some* minor improvements to mitigate these problems.  Syntax highlighting seems like it helps you spot what things Soulver understood and what things it's just guessing at, but it's still a real mess.  See how "2 to the power of 2" was right?  "of" is just being interpreted as multiplication, so "2 to the power of 9" is 18.  Despite this, the "of" doesn't highlight the way it does if you say "2 of 9"

In most of their demo documents, everything can be parsed.  The only weird stuff is units, where you can say something like "2 breakfasts at $20" and get $40.  If units were made a special case, then I bet almost all unknown crap could be rejected and this would work much more like what you expected.

Perhaps even more usefully, a column could be added to show a canonical representation of what you tried to say.  So you'd enter "1, 2, and 3" and this column would display "1 + 2 + 3".  I'd especially like this because it would let me understand why "1 or 2 or 3" is 6.  (I think it's because any unknown token between two numbers is interpreted as addition, but I'm not sure.)
