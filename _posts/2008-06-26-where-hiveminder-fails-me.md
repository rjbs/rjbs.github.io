---
layout: post
title : "where hiveminder fails me"
date  : "2008-06-26T02:10:30Z"
tags  : ["hiveminder", "liquidplanner", "productivity", "software"]
---
So, several months later, I'm still mostly using
[Hiveminder](http://hiveminder.com/), though not as
fastidiously as I once was.  I still like it, and I have no plans to abandon it
for some other next big thing, but there are places where it lets me down and
where I wish I could Just Send Patches or something.  I mean, who knows if I
would, but it's easy to convince myself that I would be *all over* fixing it up
if I could.

There are lots of places to send feedback to the BPS staff about Hiveminder.
Unfortunately, you can't see the feedback you've already sent in.  That's one
of the things I don't like, and it may make writing this post a bit harder than
it would otherwise be.

I think Hiveminder might make a tolerable simple bug tracking system, if there
were a way to mark a group's tasks as publicly visible.  There isn't.  I don't
have a bug tracker of choice.  I've never found one I really liked.

Hiveminder might make a tolerable project planner for simple projects, if its
dependencies were more elegant.  I'm not sure exactly why I don't like them,
but they just feel really bolted on, sort of like the "x is blocking y" plugin
for Trac (which has been an object of my ire lately).  See, there are no real
"projects" in Hiveminder, just tasks.  If you want a project, you can use tags
or a group, or you can set up dependencies.  "Do X, then do Y."  This is useful
information, but there's no way to see the schedule at a glance.

I've been playing with [LiquidPlanner](http://www.liquidplanner.com/) a little,
lately.  It's a browser-based project planning system, and so far it looks
pretty good.  It's a little slow and awkward, which is fine for dealing with
fairly hefty project plans (deploy large new subsystem at work) but would be
awful for simple things at home (paint third floor).  Its real killer feature
is that it's multi-user, so one person can run the project and others can
update their workload as they go.

So, if I want to deal with one-off work orders (bugs), I have to use RT or Trac
or Bugzilla or something.  For my personal to-do list, I'll use Hiveminder.
For large-scale projects, LiquidPlanner, maybe.  Ugh!  I know, I know: do one
thing and do it well, but...

Oh, another tool I'm "forced" to use is post-it notes.  Well, actually, I also
wrote my own AIM bot.  See, I want to keep track of daily items I want to get
done.  "At 13:00, go meet Adam for lunch" or "clean the guinea pig cage before
bed."  I can't do this with Hiveminder because its tasks are all per-day and
you can't set sub-day resolution due dates.  If I could, the IM bot could have
an "agenda" command showing me what I have to do in the next 24 hours, in the
right order.  It could send me an IM telling me, "It's time to pick up your
take-out order."

I'd use iCal.app, but creating new items in iCal is a pain.  I'd talk a bit
about how awfully the tab key is interpreted by iCal, but... well, try it
yourself sometime.

So, I do use iCal for my calendar.  I put my triweekly RPG on there, the
monthly ABE.pm meetings, travel plans, and so on.  I use iCal because it's got
a fantastic view for this information, and can pull in lots of other calendars
(like Gloria's!), but it's kind of obnoxious to add events to it.  Of course,
Hiveminder offers an iCal (webcal) view of my tasks.  Unfortunately, it's
wonky.

Tasks show up as both events (on the calendar) and "todo" items (in the to do
list).  The todo items don't have due dates or priorities, they're just a big
list of things.  The events show up on their due date, so if it was due a few
weeks ago, I won't see it.  Also, that sub-day resolution thing can be a
problem.  "Go to airport" would be more useful if I knew what time I needed to
leave or get there.

Since the feed is read-only (webcal, instead of caldav), I can't actually click
the "I am done!" box on my todo items.  I have to double-click the item, click
the URL, possibly log back into the rarely-used-by-me web interface, and then
click "done" and "save" (I think).  This is pretty forgiveable.  Nobody seems
to offer a caldav server, including Google Calendar.  I really hope that Mobile
Me does caldav with shared calendars.

I don't know how repeating tasks interact with dependencies.  It could be
pretty great, though.  I could tell the system that every three weeks I have a
gaming session, and that by three days before I need to have prepared notes.
One of those would be an event (it gets done by virtue of the date passing) and
one would be a todo (it gets done by virtue of me writing down stuff in my
notepad).

There are reports, but none of them strike me as very useful.  I can't see how
many items I have over time (am I clearing out my list, holding steady, or
building a backlog?).  I also can't see that report for certain groups or tags,
either, obviously.  There's a report that claims to be about that question, but
it's just number created or closed each day, which isn't anywhere near as
useful.  Actually, the reports that are provided strike me as really weird.
Why would I want to know at what time of day I usually mark tasks complete, or
on what day of the week?  It's sort of interesting, I guess, but not actually
useful to see how I'm doing.

The more I deal with ticket trackers, project planners, personal calendars, and
to do list managers, the more I think that these things really need to
converge.  I'm pretty open to different ways this might happen.  Maybe they'll
just all be able to share data nicely.  Hiveminder is inching that way with its
iCal feed.  Maybe there will be one or two pieces of software that will solve
all the problems well enough.  I hope Microsoft does something in that space.
I'd like to see something like a combined Exchange, Project, and SharePoint
monster.

So, anyway, I still like Hiveminder.  I'm going to stick around and keep
telling it to remind me to do stuff.  (Doing that over [Jott](http://jott.com)
is great.)  I just hope that sometime soon it will be something I can use to
replace other software, so I can stop adding more items to my "where do I look
to see what I'm doing today" list.

