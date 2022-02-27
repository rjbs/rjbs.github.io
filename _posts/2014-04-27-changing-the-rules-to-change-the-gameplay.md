---
layout: post
title : "changing the rules to change the gameplay"
date  : "2014-04-27T03:09:08Z"
tags  : ["perl", "productivity", "programming"]
---
I still use [The Daily Practice](https://tdp.me/) to track the things I'm
trying to do reliably.  I like it.  It helps.

It's got a very simple implied philosophy, which is something like "you should
always have every streak active."  This is good, because it's simple, and it's
not some weird method that you have to accept and internalize.  It's a bunch of
lines, and you should probably keep them solid.

It's worked well for me for nine months or so, but I'm starting to feel like
I'm hitting problems I knew I'd hit from the beginning.

The way the scoring works is that every time you "do" a goal, you get a point.
Points add up as long as the streak is alive.  If you have to do something once
a week, and you do it once a week for a year, you end up with 52 points.  If
you did it twice a week (even though you didn't have to) you end up with 104.
Then, if after you score that 104th point, you miss a week, your'e back to zero
points.  All gone!

Once you're at zero points, *it doesn't get any worse*.  This means that once
you've got a streak going, you're really motivated to keep it going, but once
it's broken, it's not worth that much to start it again, unless you can keep it
going.  Another instance of a long-lived unimportant goal is worth a lot more
than a streak-starting instance of something you care about.

You don't have to buy into the idea that points are really important to get
value of of TDP, but I've tried to, because I thought it would make me feel
more motivated.  Unfortunately, I think it's motivated me in some of the wrong
ways.  To fix it, I wanted to make it more important to restart dead goals, and
I've made a first pass at a system to do that.

For a long time, I've been bugging the author of TDP, the excellent and
inimitable [Jay Shirley](http://www.jayshirley.com/), to add a way to see a
simpler view of a given task's current status.  He added it recently, and I got
to work.  The idea is this:

* a live goal is worth its length in days, plus the number of times it got done
* for every day a goal is dead, it's worth one more *negative* point than the
    day before

In other words, on the first day it's dead, you lose 1 point.  On the second,
you lose 2.  On the third, 3.  The first ten days of missing a goal look like
this:

    day  1 -  -1
    day  2 -  -3
    day  3 -  -6
    day  4 - -10
    day  5 - -15
    day  6 - -21
    day  7 - -28
    day  8 - -36
    day  9 - -45
    day 10 - -55

This gets pretty brutal pretty fast.  For example, here's my scoreboard as of
earlier today:

                     review p5p commits:  562
                      catch up with p5p:  547
       get to RSS reader to 10 or lower:  451
                          drink no soda:  348
                      step on the scale:  332
               close some github issues:  191
                         spin my wheels:  160
               review p5p smoke reports:  111
             review and update perlball:   89
                   post a journal entry:   48
      have no overdue todo items in RTM:   24
                  no unhealthy snacking:   22
                      read things later:   22
                        read literature:   20
                       read unread mail:   17
                respond to flagged mail:   15
                work on my upload queue:   14
            do a session of code-review:    4
                  do a writing exercise: - 28
                        play a new game: - 45
               close an old task in RTM: - 45
                        read humanities: - 66
              work on Code Wars program: - 78
              plan the next RPG session: -120
               email the Code Wars list: -253
                read science/technology: -465
    make progress on the Infocom Replay: -820
                                  TOTAL: 1057

What does this tell me?  My score would go up 78% instantly if I'd just make
some progress on my "[Great Infocom
Replay](http://rjbs.manxome.org/rubric/entries/tags/infocom-replay)", which
I've ignored horribly since declaring I'd do it.  (It's been over a year and
I've only played six of the thirty-ish games.)  In other words:  if I make
something a goal, I should do it, even if I'm not doing it as frequently as I
wanted.  If I fall off the wagon, I need to get back on, even if I can't stay
on for long.

I'd also wanted to change the result of missing a day.  As I said, missing day
1000 of a 999-day streak drops you back to zero.  Right now, I get *sorely*
tempted to use "vacation days" as mulligans if I can remotely justify it.  That
is: the scoring model is driving me to game the system rather than live within
its rules.  This is *my* problem and not TDP's, but I'd like to address it.  My
idea was that each day a goal was dead, I'd lose a fraction of its point.
Maybe half, maybe a quarter.  This would add up quickly.  For example, given
that 1000 point streak, it would look like this:

    day  1 - 500
    day  2 - 250
    day  3 - 125
    day  4 -  62
    day  5 -  31
    day  6 -  15
    day  7 -   7
    day  8 -   3
    day  9 -   1
    day 10 -   0

Unfortunately, this isn't quite possible using only TDP's available-to-me data.
I could implement it if I stored more of my own data locally, but I think I'll
put that off for now.

The problem is that I can only see the length of the current streak.  To
implement the "I'm bleading points" system, I'd need to look before the current
streak to see how many points were left over from that.  I think I'll be fine
without it for now.

I've published the [code to compute a list like the one
above](https://github.com/rjbs/misc/blob/master/tdp-harsh), in case you use TDP
and want to be graded harshly, too.

