---
layout: post
title : "updating tools, losing time"
date  : "2005-04-07T04:04:27Z"
tags  : ["productivity", "rubric", "win32"]
---
My daily accomplishments form lets me keep track of how I spend my time each day.  When I realize I've utterly wasted a block of time, or can't account for it just ten minutes later, I color it in black.  Today, I had an hour and three quarters of lost time, which is just awful.

I don't mind some amount of leisure time (about an hour and a half, today), but if I didn't do anything I can identify, like "watch Futurama," it's just stupid.

My workday wasn't very productive, either, I'm afraid.  I had a number of little things come up, the most annoying and time-consuming was my inability to change a file association on Windows XP.  It should be really easy for me to say "I open .TXT files with this executable," but it isn't.  I had to go clear custom settings and create menu options by hand, because WinXP refused to listen when I said, "Use this program for these files."  I would click OK and it would just ignore me.

I searched the registry, and found a number of relevant keys, so I edited or deleted them, but the data seemed to be stored somewhere else, or to be distributed in some sort of GUID-based self-healing fashion.  I spent an hour on that.

I also got distracted by some stupid things.  I tried to make a good favorites icon for Rubric.  I got one looking great, but it needed a white background. Dan tried to make me a nice alpha-channel version, but it won't work on my system.  (I'll investigate more another time.)  Why can't they just be pngs? That took an hour, too, and yielded no real result -- just some prototype icons.

I also updated my journal-posting script to write to Rubric instead of Bryar, which would have taken roughly zero seconds if I hadn't thought that the hash passed to LWP::UserAgent's get method was parameters.  For future reference, it's headers.  POSTing the data did the trick.  The Rubric API should be nice and simple, since if I've played my cards correctly it will just be the existing form API without HTML.  I really do need to fix session generation, though.  No need to create a session and cookie for casual visitors.  I just painted myself into a bit of a corner, there.

Gloria hasn't been feeling well, but seems to be getting better, which is good. Friday is our anniversary!  Eleven years since we met, and five since we married.  I am happy with the whole thing.  We have a pretty great life together.
