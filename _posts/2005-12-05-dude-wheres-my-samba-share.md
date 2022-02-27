---
layout: post
title : dude, where's my samba share?
date  : 2005-12-05T13:57:35Z
tags  : ["network", "stupid"]
---
Last night I was up late doing some preparation for a game today.  I wanted to listen to some music while I worked, but I couldn't get my damn Samba share to mount.  It would wait and wait and wait.  After ten minutes or so, I'd get a message that was pointless, as most Samba errors tend to be, at least on Mac OS.  It was something like, "You can't mount this share because stuff isn't working."

My logs -- by the way, who thought it was a good idea to call the log file log.smbd instead of smbd.log? -- didn't show any interesting hits from my WAP's IP.  I ended up listening to streaming radio, which was OK, except that every once in a whiel something really obnoxious would come on and I'd have to find a new station.  Mostly I listened to BassDrive, to which I used to listen a lot at IQE.  I also found "cliqhop," which was pretty good, until it started to not be.  Finally I ended up on MostlyClassical.com, which played the Moonlight sonata, one of my favorite piano pieces.

Also, at the advice of a friend, I set up TivoToGo on my usually-powered-down PC.  This was a royal pain, only because for a long time my TiVo claimed that its media access key was not available.  Even though I got it from the web, I couldn't connect to my TiVo while it said that.  I rebooted my TiVo, I rebooted my PC, nothing helped.  I called TiVo tech support, but after ten minutes on hold, I was disconnected.  Eventually, it just started working.

I followed my friend's further advice and got a tool to remove the DRM from the video so that I could watch it on my Mac.  Dann at the LUG has often complained that DRM makes it a real pain to enjoy things legally on Linux.  Even if he pays for the music, movie, or whatever, he can't listen to it on Linux unless he breaks the law and circumvents the protection.  This left me feeling the same way: I pay for cable and I pay for TiVo, but I had to crack the protection the files just so I could watch an episode on the bus.

Once I had prepared an MPEG to take with me, I started to transfer it from my PC to my laptop, but I couldn't connect, despite the fact that I could clearly see, from ipconfig, that both machines were on the same /16.  Finally I transferred to my server and then started to copy to my laptop, but I was only getting about 35Kbps, which seemed a sure sign that somehow the traffic was going out and back my DSL circuit.  (My server isn't on my Airport.)

This didn't make much sense, but I finally gave up on that, too, grumbling.

This morning, I tried one more time and found the same thing.  I still couldn't mount my Samba share, either.  When I ran my offline syncing script, which is a typical morning activity, it was taking ages to transfer one 25MB file.  "It's as if I'm not on my own network!" I thought.

Which, of course, I wasn't.

This thought made me realize that I might not be on my own network, so I checked the little Airport menu and saw that my computer had connected to the nearby open access point, "linksys."  It stayed there despite the fact that I'd rebooted a few times.  I'm not sure where it is, but it's close enough that I get full signal strength, so I hadn't noticed.  I wish I could say something like, "If you see the manxome network, you use it, not anything else, unless I tell you to."

I felt pretty silly, but no harm done.  I transferred my file in time for the bus, I updated my iPod, and I figured out what it was that had been driving me nuts. 
