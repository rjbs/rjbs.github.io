---
layout: post
title : fixing my accidentally strict mail rules… or not
date  : 2014-02-25T01:36:20Z
tags  : ["perl", "productivity", "programming", "ywar"]
---
I recently made some changes to Ywar, my personal goal tracker, and I couldn't
be happier!  Mostly.

Ywar is configured with a list of "checks."  Each check looks up some datum,
compares it to previous measurements, decides whether the goal state was met,
and saves the current measurement.  The checks used to run once a day, at
23:00.  This meant that, for the most part, the feedback I got was the next
morning in my daily agenda mail.  I could hit refresh at 23:05, if I wanted,
and if I was awake.  If I did something at 8:00, I'd just have to remember.
For the most part, this wasn't a big problem, but I wanted to be able to run
things more often.

Last week, when I was working on my [Goodreads/Ywar
integration](http://rjbs.manxome.org/rubric/entry/2035), I also made the
changes needed to run `ywar update` more often.  There were two main changes:
every measurement now carries a log of whether it resulted in goal completion,
and checks don't get the last measured value, but the "last state," which
contains both the last value measured and the value measured at the last
completion.

While I was at it, I added [Pushover](https://pushover.net/) notifications.
Now, when I get up in the morning, I step on my scale.  A few minutes later, my
phone bleeps, telling me, "Good job!  You stepped on the scale!"  Over
breakfast, I might read an article I've saved to Instapaper.  While I was the
dishes, or maybe while I read a second article, my iPad bleeps.  "Good job!
You read something from Instapaper!"

This is *surprisingly* motivating.  I'm completing goals much more often than I
used to, now.  (The Goodreads integration has also been really motivating.)

This change also inadvertantly introduced a pretty significant change in my
email rules.  Most of them follow the same pattern, which is something like
this:

* at least once every five days, have less unread mail than the previous day

Some of them say "flagged" instead of "unread," or limit their checks to
specific folders, but the pattern is pretty much always like the one above.
When I started passing each check both the "last measured" and "last
completion" values, I had to decide which they'd use for computing whether the
goal was completed.  In every case, I chose "last completion."  That means that
the difference checked is always between the now and the last time we met our
goal.  This has a massive impact here.

It used to be that all I had to do to keep my "keep reading email" goal alive
was to reduce my unread mail count from the previous date.  Imagine the
following set of end-of-day unread message counts:

* Sunday: 50
* Monday: 100
* Tuesday: 70
* Wednesday: 100
* Thursday: 75
* Friday: 80
* Saturday: 70

Under the old rules, I would get three completions in that period.  On each of
Tuesday, Thursday, and Saturday, the count of unread messages goes down from
the previous day.

Under the new rules, I would get only one completion: Tuesday.  After that,
the only way, ever, to get another completion is to get down to below 70 unread
messages.  Maybe in a few days, I get to 60, and now that's my target.  This
gets pretty unforgiving pretty fast!  My current low water mark for unread mail
is 28, and I get an averge of 126 new messages each day.  These goals actually
have a minimum threshold, so that anything under the threshold counts, even if
last time I was further below it.  Right now, it's set at 10 for my unread mail
goal.

It would be pretty easy to fix this to work like it used to work.  I'd get the
latest measurement made yesterday and compare to that.  I'm just not sure that
I *should* restore that behavior.  The old behavior made it very easy to read
the easy mail and ignore the stuff that really needed my time.  I could let
some mail pile up on Wednesday, read the light stuff on Thursday, and I'd still
get my point.  I kept thinking that I needed something "more forgiving," but I
don't think that's true.  I don't even think it makes sense.  What would "more
forgiving" mean?  I'm not sure.

One thing to consider is that if I can never keep a streak alive, I won't
bother trying.  It can't be too difficult.  It has to seem possible, and to be
possible, without being a huge chore.  It just shouldn't be so easy that no
progress is really being made.

Also, I need to make sure that once I've broken my streak, any progress starts
me up again.  If I lose my streak and end up with 2000 messages, having to get
back to 25 is going to be a nightmare.  My original design was written with
this in mind:  any progress was progress enough.  The new behavior ratchets the
absolute maximum down, so that once I've gotten rid of most of those 2000
messages, I can't let them pile back up by ignoring 5 one day, 5 the next, and
then reading six the third.  Maybe the real solution will be to keep exactly
the behavior I have, but to fiddle with the minimum threshold.

The other thing I want to think about, eventually, is message age.  I don't
want to ding myself for mail received "just now."  If a message hasn't been
read for a week, I should really read it immediately.  If it's just come in
this afternoon, though, it should basically be ignored in my counts.  For now,
though, I think I can ignore that.  After all, my goal here is to read email,
not to spend my email reading time on writing tools to remind me of that goal!

