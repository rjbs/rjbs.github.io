---
layout: post
title : my new rt.cpan.org workflow
date  : 2011-06-03T02:56:22Z
tags  : ["cpan", "perl", "programming"]
---
Years and years ago, I got a fortune cookie that told me:

> Simplify your life with recurring patterns.

I like this advice, and try to listen to it.  Lately, I've greatly reduced the
number of balls I have in the air, and I've designated days of the week to work
on specific projects.  Wednesday and Thursday, I work on open source projects.

For the most part, this has gone well, although I missed a few days due to
other things intruding recently.  Now that I'm back to it -- and up to these
two days instead of my original one -- I wanted to spend more time coding and
less looking at lists of bugs and patch requests.  To help with that, I've
tweaked how I'm using [rt.cpan.org](https://rt.cpan.org/), with help from
[Kevin Falcone](http://search.cpan.org/~falcone/), famous RT expert.

First, I went to my "home" page once logged into RT and edited the contents
(with the "Edit" link at the very top right) to add "Bookmarked Tickets" at the
top right.  Now when viewing tickets, I can click the star icon to bookmark
them and they'll show up at the top of my RT dashboard.  This is my hit list.
It's the tickets I want to work on next.  When I empty it, I will go through
all my tickets and repopulate it -- but now I can ignore my backlog and focus
on a smaller workload of already-evaluated tickets.

How do I evaluate them?  Well, also on my dashboard is "Queues I'm an AdminCc
for".  I go to that list, scan down the list of new and open ticket counts, and
command-click any non-zero number so that I end up with one tab for each RT
queue with bugs in it.  I flip through those tabs, opening in a new tab any
ticket that I think needs attention.  This might mean tickets that I haven't
seen, or tickets that seem easy to deal with, or just tickets that I don't
think will ruin my day.  Now my browser is just a bunch of tabs, each with a
ticket in it.  I read each ticket and either close it, mark it stalled and send
it back to the rqeuester, or star it for future work.  On some rare tickets, I
see that I can solve it in under five minutes and just go do so.

When I'm done with this, my browser is empty and I can reload my dashboard: now
I have a list of tickets to work on.

<img src='/img/journal/bookmarked-tickets.jpg' />

I want to see how I do each day, so I put another box under that: tickets I've
closed today.

<img src='/img/journal/closed-today.jpg' />

This was easy to set up, too.  In the [Query
Builder](https://rt.cpan.org/Search/Build.html), I made a query with the
following lines:

    Resolved > '12 hours ago'
    AND QueueAdminCc.id = '__CurrentUser__'

I saved the query, and added the saved query to my dashboard.

Now, on Wednesdays and Thursdays, I can go to my list of marked tickets and
power through as many as I can, without thinking about what to work on.
That decision will have already been made.

Next, I'm going to have to deal with adding GitHub pull requests to my
workflow, but I think I'll figure something out!

