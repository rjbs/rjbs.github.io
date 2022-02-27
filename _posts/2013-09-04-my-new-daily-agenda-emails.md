---
layout: post
title : "my new daily agenda emails"
date  : "2013-09-04T01:27:46Z"
tags  : ["productivity", "ywar"]
---
I've finally finished (for now, anyway) another hunk of code in my ever-growing
suite of half-baked productivity tools.  I'm tentatively calling the whole mess
"Ywar", and would paste the dictionary entry here, but all it says is "obsolete
form of 'aware'".  So, there you go.  I may change that later.  Anyway, a rose
by any other name, or something, right?

Every morning, I get two sets of notices.  [The Daily
Practice](http://tdp.me/person/rjbs/) sends me an overview of my calendar,
which makes it easy to see my streaks and when they end.  [Remember the
Milk](https://www.rememberthemilk.com/home/rjbs/) sends me a list of all the
tasks due that day.  These messages can both be tweaked in a few ways, but
only within certain parameters.  Even if I could really tweak the heck out of
them, I'd still be getting two messages.  Bah!

Fortunately, both TDP and RTM let me connect and query my data, and that's just
what I do in my new cronjob.  I get a listing of all my goals in TDP and figure
out which ones are expiring on what day, then group them by date.  Anything
that isn't currently safe shows up as something to do today.  I also get all my
RTM tasks for the next month and put them in the same listing.  That means that
each email is a summary of the days of the upcoming month, along with the
things that I need to get done *on or before* that date.  That means I can (and
should) start with the tasks listed first and, when I finish them, keep working
my way down the list.

In theory, I could tweak the order in which I worked based on time estimates
and priorities on my tasks.  In practice, that's not going to happen.  This
whole system is held together by bubblegum, paperclips, and laziness.

Finally, the emails implement a nagging feature.  If I've tagged a RTM task
with "nag," it will show up on today's agenda if I haven't made any notes on it
in the last two weeks.  I *think* I'm better off doing this than using RTM's
own recurring task system, but I'm not sure yet.  This way, all my notes are on
one task, anyway.  I wanted this "automatic nagging" feature for tasks that I
can't complete myself, but have to remind others about, and this was actually
the *first* thing I implemented.  In fact, it was only after I got my `autonag`
program done that I saw how easily I could throw the rest of the behavior onto
the program.

Here's what one of the messages looks like:

<center><a href="http://www.flickr.com/photos/rjbs/9665618769/" title="Ywar Notice by
rjbs, on Flickr"><img
src="http://farm4.staticflickr.com/3780/9665618769_50b1de5dc1_o.png"
width="650" height="629" alt="Ywar Notice"></a></center>

Right now it's plaintext only.  Eventually, I might make a nice HTML version,
but I'm in no rush.  I do most of my mail reading in `mutt`, and the email
looks okay in Apple Mail (although I think I found a bug in their
implementation of quoted-printable!).  The only annoyance, so far, is the goofy
line wrapping of my per-day boundary lines.  In HTML, those'd look a lot
better.

I'll post the source code for this and some of my other TDP/RTM code at some
point in the future.  I'm not ashamed of the sloppy code, but right now my API
keys are just sitting right there in the source!

