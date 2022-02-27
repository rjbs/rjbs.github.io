---
layout: post
title : omnifocus versus hiveminder: round one
date  : 2008-02-19T04:16:09Z
tags  : ["hiveminder", "omnifocus", "productivity", "review"]
---
The first thing I really had to do in order to start giving Hiveminder a try
was to load in all my tasks from OmniFocus.  This was a little tedious.
Unluckily for me, I missed my bus home on Friday and had to kill four hours at
the office, waiting for the next one.  I used some of this time getting things
loaded into Hiveminder and then cleaning up the data I'd loaded.

I had already created one or two tasks, and it was pretty easy.  It became
ridiculously easy, though, when I switched to using the AIM interface.
Basically, I started to send messages to a contact in Adium saying things like
"release new CPAN::Mini [perl CPAN::Mini]" and "write Oma a letter [due:
tomorrow] [writing]."  Every once in a while I'd commit my list of events and
the bot would tell me what I'd just done so I could spot mistakes.

I said that I needed my entry method to be quick, require only one field, and
allow some more.  Hiveminder's AIM bot (it speaks Jabber, too) was all of these
things.  It let me set more fields more easily than OmniFocus quick entry, and
lacks only a global hotkey.  I'm sure I can fix that with
[Quicksilver](http://docs.blacktree.com/quicksilver/what_is_quicksilver) or
something else.

I had a good dozen projects set up in OmniFocus.  Hiveminder doesn't really
have a concept of projects, and I didn't miss it at all.  Tags were enough.  I
don't need a project for App::Addex tasks, because I can just tag those things
with "App::Addex."  There is a system for task dependencies, but I've barely
used it so far.  Right now, all my projects are just tagged tasks.  Maybe later
I'll create ordering, but for now there was no need.

Once I was done with task entry, it was time to review my tasks and figure out
which ones were actually on my agenda for the short term.  I looked at doing
this on the web, and it was immediately clear that the interface was about what
I expected, but that it was going to be a real pain in the ass.

Of course, the bot does reviews, too.  See, the AIM interface isn't just for
creating tasks, it's a complete interface to quite a lot of the features of
Hiveminder.  I said "review" and we got to work.  The bot showed me each task
in my list and I hid it, scheduled it, or did whatever else I had to do.  Forty
minutes later, I was down to ten things to do on my list.  Last night I did
another review, which took much less time.

It's hard to explain how good the AIM interface is.  When a task came up in
review I could say "hide until Thursday" or "due by tomorrow" or even "++" to
set the task to a high priority.  The bot is *really* fast.

[Paul Fenwick](http://pjf.id.au/) made an excellent [slidecast about
Hiveminder](http://www.slideshare.net/pjf/effective-procrastination-with-hiveminder)
that introduced me to a number of neat tricks.

So far, the todo view I get is just fine.  I say "todo" and the bot lists task
ids and descriptions.  The web view is a bit more informative, but not much.  I
think I'd like some more information-rich reports, but for now I'm writing off
those desires until I feel like I'm actually missing something by not having
them.  I am ever in favor of avoiding features that I only *think* I want.

I haven't given much time to testing the existing offline methods, yet.  That
includes printing, saving to a text file (which can be edited and re-uploaded),
syncing to iCal, or anything else.  I'll try those later in the week.  The
ability to get at tasks on the web or by AIM really means that I can get at my
todo from anywhere that has a computer I can use.  What really remains to be
seen is how well I can prepare myself for working on my Hiveminder tasks while
in the jungle.

I haven't done much with any of the collaboration features, although I've got
some ideas for doing so in a fun way.  I'll write a bit more about that once
I've done it.

As things stand, I'm not sure whether OmniFocus has anything on Hiveminder.
Its GUI is much, much faster than the Hiveminder web interface, but I don't
plan on using the web interface very often at all.  Also, a very very fast
interface to a significantly reduced set of features isn't clearly all that
valuable.  The best place to compare them may end up being in my ability to
build more software on top of them.

It might be a good test, except I think Hiveminder is likely to win by default.
It has a real API with pre-published client libraries.  OmniFocus has (ugh)
AppleScript hooks.

