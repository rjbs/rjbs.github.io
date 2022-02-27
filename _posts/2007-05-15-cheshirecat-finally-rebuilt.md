---
layout: post
title : cheshirecat finally rebuilt
date  : 2007-05-15T03:12:53Z
tags  : ["linux"]
---
I've long been meaning to install a new operating system and services on my home server, cheshirecat.  Mostly it only exists to host my big old RAID that stores ~rjbs, my MP3's, and a few other personal things.  It used to host my website, the primary MX for manxome.org, and some other important things, so replacing it was going to be a pain.  Still, it was running Slackware 7, dating from 1999, and it had only been patchily upgraded here and there.

Yesterday, I finally decided that I'd give rebuilding it a go.

It was fantastically painless.  I downloaded a Debian 4 net install ISO, added a little partition, and did a little floundering around until I got everything working.  "Everything" here means, roughly: Samba, Apache 2 with SSL and SVN DAV, software RAID, LVM, and mounting my existing volumes.

I'm sure I'll hit a couple little snags over the next few weeks, but all the important stuff is already taken care of.  (Well, I haven't set up djbdns yet.) It's nice to know I can more easily remain up to date now, and worry about more interesting things.

As a side note:  I've been using BitTorrent, the original Python console client, version 4.  Debian only has version 3, so I decided to take someone's advice and try rTorrent.  Wow!  It's fantastic.  It's just about everything I always wished "launchmany_curses" would be. 
