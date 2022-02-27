---
layout: post
title : "enough time manipulation for now"
date  : "2006-10-24T03:11:33Z"
tags  : ["calendar", "perl", "rpg"]
---
I might go ahead and write a few tests, just to ensure that everything that I
think works, works, now and forever.  Apart from that, I think I've spent
enough of the last few days writing obsessively silly code to support my RPG.

On my way home on the bus, I finally got the last few kinks worked out of
negative offsets, so that both of these commands work.  (Note that output has
been cropped to hide secrets from any players reading my journal!)

    ~/Documents/rjbs/docs/deliverance$ ./code/when -- 1.213
    offset: 1.213
    offset s: 35213875.2
    standard: 1:03:16:13:37:55

    ~/Documents/rjbs/docs/deliverance$ ./code/when -- -1.213
    offset: -1.213
    offset s: -35213875.2
    standard: -2:10:13:10:22:04

I wonder what the calendar *will* look like in the future.  I don't see it
changing much in my lifetime, but it certainly is annoying to deal with, and
once we're not worried about the sun and moon as much, maybe we really will use
something simpler.  I doubt it, though.  I bet we'll end up with a bunch of
different, complicated calendars, one for each settled colony.  I was extremely
grumpy the last time I "had to" write my own time zone conversion code; I can
only imagine how annoying it will be to convert between Alpha Centari I
Meridian Summer Time and Western European Standard Time -- and don't forget to
resync your hardware clock after exiting FTL space!

Here's hoping I live to fix a bug in that code.

