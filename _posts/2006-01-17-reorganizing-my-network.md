---
layout: post
title : "reorganizing my network"
date  : "2006-01-17T16:55:17Z"
---
John C. and I were talking, for a few months, about getting a new rackmount and colocating it somewhere.  That didn't happen, but he did find a really great deal on a nice virtual server package, from <a href='http://www.aktiom.com'>Aktiom</a>  

For some reason, I was initially really tentative about moving things there. First, I moved my non-personal Subversion repositories, then some other little tidbits of data.  This weekend, I moved over my main web pages, including rjbs.manxome.org, which took quite a good while.  At home, since May, I've only had about 128 Kbps upstream, or maybe 384.  I don't recall.  Anyway, it's not very fast, considering that I host a lot of images.  Uploading about two gigs of data to the virt took hours, but now my pages should be significantly faster.

The next step is probably to move my mail service, but we'll need to figure out our strategy for virtual users a bit better, for that.  I'm hoping it will all go well.

One thing that this (and other recent work) has driven home is that I need to do more work with PostgreSQL again.  I used to use it quite a bit, for personal projects, but eventually I slacked off and shoved everything in SQLite.  This weekend I found myself struggling with access control, mostly because I didn't remember stupid things like how DBD::Pg would decide how to connect to a server (that is, unix sockets or TCP sockets).

I'm looking forward to more fun with the new box, including more time playing with RT. 
