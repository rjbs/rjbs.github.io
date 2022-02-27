---
layout: post
title : "once again trying to keep up with the tickets"
date  : "2013-07-04T02:42:43Z"
tags  : ["perl", "productivity", "programming"]
---
I maintain a bunch of published code.  I probably wrote more than half of it,
and I've been the sole maintainer for years on most of the rest.  I inherited a
lot of bug reports, I get new bug reports, and I get feature requests.  I used
to try to respond to everything immediately, or at least within a few days.

This doesn't happen anymore.

Now, I've got piles and piles of suggestions and patches, some of which are
obviously good, some of which I'd like to see happen but don't want to write,
some of which are okay but need work, and some of which just aren't a good
idea.  Any time I want to try to clear out some of these tickets, I have to
pick which ones.  This takes too much time, especially because I'm often
feeling sort of run down and like I want to cruise through some easy work, so I
spent a lot of time looking at lists of tickets, burning up the time I could be
spending just *doing something*.

A while back — maybe six months or a year ago — I thought that what I'd do was
work alphabetically through my module list.  I'd keep working on the next
target until every ticket was stalled or closed.  Eventually I got burned out
or distracted.

I also didn't announce this plan publicly enough, so failing to keep on it
brought me insufficient shame.

Now I'm back to the plan, roughly as follows:

I made a big list of all my code.  (I'm sure I missed some stuff, but probably
not much.  Hopefully those omissions will become clear over time.)  I started
with everything in alphabetical order.  Every time that I want to get some work
done on my backlog, I go to the list, start at the top, and clear as many
tickets as I can.  If I clear the queue, or when I'm done doing work for the
evening (or afternoon, or whatever) I file the dist away.

If there are still tickets left, I put it at the bottom of the "main sequence,"
where I keep working on stuff over and over.  Otherwise it goes into either
"maintenance," meaning that it'll pop to the top of the queue once it actually
gets bugs, or "deep freeze," meaning that I seriously doubt any future
development will happen.  The deep freeze is also where I put code that lives
primarily in the perl core but gets CPAN releases.

While I'm going through my very first pass through the main sequence, things
that have never been reviewed are special.  If a bug shows up in a
"maintenance" item, it will go to the top of the already-reviewed stuff in the
main sequence, but below everything still requiring review.  I'm also checking
each module to make sure that it points to GitHub Issues as its bug tracker and
that it doesn't use Module::Install.

What I should do next is write a few tools:

* something to check the bugtracker and build tool of all my dists at once
* something to check whether there are tickets left in the rt.cpan.org queue
* something to check whether there are non-stalled tickets for dists in
    maintenance or deep freeze

I don't know whether or when I'll get to those.

In the meantime, I'm making some progress for now.  I'm hoping that once I
finish my first pass, I'll be able to do a better job of clearing the backlog
and keeping up, and then I'll feel pretty awesome!

I may try to publish more interesting data, but for now [my maintenance
schedule](https://github.com/rjbs/misc/blob/master/code-review.mkdn) is
published, and I'm keeping it up to date as I go.

