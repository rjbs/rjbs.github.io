---
layout: post
title : "reviews are not bug reports"
date  : "2006-12-02T03:05:37Z"
tags  : ["perl", "stupid"]
---
Sometimes, I see a bad review of a module on the CPAN, and I wonder why it
wasn't filed as a bug report instead.  For example, I recently saw [this
review](http://cpanratings.perl.org/#2608) of the popular and indispensable
Time::Local.  The reviewer makes three points:

1. The module thinks that there are 30 days in October.
2. The module stops executing (dies?) when an invalid date is given.
3. The module doesn't parse the date for you.

Well, the module doesn't think there are 30 days in October:

    DB<1> p "@{[localtime(timelocal(0,0,0,31,9,106))]}"
    0 0 0 31 9 106 2 303 0

Probably the reviewer didn't pay attention to the fact that months run from
zero to eleven, not from one to twelve, and he tried this instead:

    DB<2> p "@{[localtime(timelocal(0,0,0,31,10,106))]}"
    Day '31' out of range 1..30 at (eval 22)[/usr/local/lib/perl5/5.8.8/perl5db.pl:628] line 2

The behavior makes sense, since the module provides, as documented, "the
inverse of build-in perl functions `localtime()` and `gmtime()`."  If this had
been filed as a bug report, the reviewer could have been set straight.

The modules *does*, as we see above, throw an exception if the input is
invalid.  That's a documented feature, though, and easy to deal with by using
eval.  If a bug report had been filed, the reviewer could have been set
straight.

As for the third complaint, it's true.  The module does not parse dates,
because it is not *for* parsing dates.  The reviewer suggests other modules
which *do* parse dates, but don't perform the functions that Time::Local
performs.  I wonder if we will shortly see a negative review of Time::ParseDate
for its inability to convert from a time struct to epoch seconds.

I see a lot of these reviews, which are clearly written by people who don't
know what they're talking about.  They amuse (or irritate) people who have a
clue, and they just confuse or misdirect people who might otherwise have used
the right tool for the right job.

I will write no more negative reviews of a module until I have filed bug
reports that are either ignored or rejected, unless the problems are clearly
major design issues.  I urge all other reviewers to do the same.

