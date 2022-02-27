---
layout: post
title : "today's timezone rant"
date  : "2014-03-08T00:02:27Z"
tags  : ["perl", "programming", "time"]
---
Everybody knows, I hope, that you have to be really careful when dealing with
time in programs.  This isn't a problem only in Perl.  [Things are bad all
over.](https://mail.python.org/pipermail/python-ideas/2014-March/026446.html)
If you know what you're doing when you start, you can avoid many, many
problems.  Unfortunately, not all our code is being bulit anew by our present
selves.  Quite a lot of it exists already, written by other, less experienced
programmers, and often (to our great shame) our younger selves.

Every morning, I look at any unusual exceptions that have been reported
overnight.  Last night, I saw a few complaining about "invalid datetime
values," and I saw that they were about times around two something in the
morning.  A chill went up my spine.  I knew what was going to be the case.  I
checked with MySQL:

    mysql> update my_table set expires = '20140309015959' where id = 134866408;
    Query OK, 1 row affected (0.00 sec)

    mysql> update my_table set expires = '20140309030000' where id = 134866408;
    Query OK, 1 rows affected (0.00 sec)

    mysql> update my_table set expires = '20140309020000' where id = 134866408;
    ERROR: Invalid TIMESTAMP value in column 'expires' at row 1

So, 01:59:59 is okay.  03:00:00 is okay.  02:00:00 through 02:59:59 is not
okay.  Why?  **Time zones!**  Daylight saving time causes that hour to not
exist in America/New_York, and the field in question is storing local times.
You can't store March 9th, 2014 2:00 in the field because *no such moment in
time exists*.  The lesson here is that you shouldn't be storing your time in a
local format.  Obviously!  I tend to store timestamps as integers, but storing
them as universal time would have avoided this problem.

Of course, since there's a lot of data already stored in local times, and it
can't always be "just fixed," we also have a bunch of tools that work with
times, being careful to avoid time zone problems.  Unfortunately, that's not
always easy.  This problem, though, came from a dumb little routine that looks
something like this:

    sub plusdays {
      Date::Calc::Add_Delta_YMDHMS( Now, 0, 0, 0, 0, 0, 86_400 * $_[0]);
    }

So, you want a time a week in the future?  `plusdays(7)`!  You want a time 12
hours from now?  `plusdays(0.5)`.  Crude, but effective and useful.
Unfortunately, when it's currently 2014-03-08 02:30 and you ask for one day
later, you get 2014-03-08 02:30 — a non-time.

The solution to this should was trivial.  We already use
[DateTime](https://metacpan.org/pod/DateTime) extensively.  It just hadn't
gotten done to this one little piece of code.  I wrote this:

    sub plusdays {
      DateTime->local_now->add(seconds => $_[0] * 86_400)
    }

It's a good thing that we did this in terms of seconds.  See, this does what we
want:

    my $dt = DateTime->new(
      time_zone => 'America/New_York',
      year => 2014, month  => 3, day => 8, hour => 2, minute => 30,
    );

    say $dt->clone->add(seconds => 86_400);

It prints `2014-03-09T03:30:00`.

On the other hand, if we replace the last line with

    say $dt->clone->add(days => 1);

then we get this fatal error:

    Invalid local time for date in time zone: America/New_York

This is *totally understandable*.  It's the kind of thing that lets us
distinguish between adding "a month" and adding "30 days," which are obviously
distinct operations.  Not all calendar days are 86,400 seconds long, for
example.

Actually, this problem wouldn't have affected us, because we don't use
DateTime.  We use a subclass of DateTime that avoids these problems by doing
its math in UTC.  Unfortunately, this has other bizarre effects.

While I doing the above edit, I saw some other code that was also using
Date::Calc when it could've been using DateTime.  (Or, as above, our internal
subclass of DateTime.)  This code generated months in a span, so if you say:

    my @months = month_range('200106', '200208');

You get:

    ('200106', '200107', '200108', '200109', ..., '200208')

Great!  Somewhere in there, I ended up writing this code:

    my $next_month = $curr_month->clone->add(months => 1);

...and something bizarre happened!  The test suite entered an infinite loop as
it tried to get from the starting month to the ending month.  I [added more
print statements](http://rjbs.manxome.org/rubric/entry/1897) and got this:

    CURRENTLY (2001-10-01 00:00) PLUS ONE MONTH: (2001-10-31 23:00)

What??

Well, as I said above, our internal subclass does its date math in UTC to avoid
one kind of problem, but it creates another kind.  Because the offset to UTC
changes over the course of October, the endpoint seems one hour off when it's
converted back to local time.  The month in local time, effectively, is an hour
shorter than the month in UTC.  So, in this instance, I opted *not* to use our
internal subclass.

Now, the real problem here isn't DateTime being hard to use or date problems
being intractably hard.  The problem is that when not handled properly *from
the start*, date representations can become a colossal pain.  We're only stuck
with most of the stupid problems above because the code in question started
with a few innocent-seeming-but-actually-terrible decisions which then
metastasized throughout the code base.  If all of the time representations had
been in universal time, with localization only done as needed, these problems
could have been avoided.

Of course, you probably knew that, so in the end, I guess I'm just venting.  I
feel better now.

