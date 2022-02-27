---
layout: post
title : installing dropbox on cancer (debian)
date  : 2009-05-04T02:00:22Z
tags  : ["dropbox", "perl"]
---
I've been using [Dropbox](https://www.getdropbox.com/referrals/NTg4NzQ2OQ)
(that's a referral link, but they're free) for a good while now.  It's a online
storage service that syncs folders online with other computers.  Your file is
local *and* in the cloud *and* on all your other synchronized computers.  It is
also very, very fast, and runs on Win32, OS X, and x86 Linux.  I use it for a
bunch of stuff, including synchronizing my notes on my D&D game.

I wanted those notes available on my Linode, cancer, so today I took the plunge
and decided to figure out how to get Dropbox running without Nautilus.  See, if
you use Ubuntu, you just point at some `deb` file and everything installs,
including desktop integration.  I didn't want that, I just wanted the directory
content to show up.  It turned out that I wouldn't need to figure out very much
at all.  There's a [wiki page about headless
Dropbox](http://wiki.getdropbox.com/TipsAndTricks/TextBasedLinuxInstall)
already up on the Dropbox wiki, and it worked seamlessly.  I didn't throttle
the sync, so my disk IO and bandwidth usage spiked to hundreds of times their
usual value, but once it was done, everything was back to normal.

I only have two small issues:  first, Dropbox doesn't seem to log anything at
all.  I can't tell what it's doing, I can't tell that it's working, I can't
tell anything at all other than what I can find in `/proc`; secondly, I can't
get the same per-file information that I can in Nautilus or Finder.  Apparently
all this stuff is available by speaking a line-based protocol to the Dropbox
daemon, but it's not yet documented.  On the other hand, the source for the
Nautilus plugin is open source.

I see a Dropbox client Perl library in my future...

