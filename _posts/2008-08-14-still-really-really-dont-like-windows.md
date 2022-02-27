---
layout: post
title : still really, really don't like windows
date  : 2008-08-14T01:09:57Z
tags  : ["software", "stupid", "win32"]
---
Ugh!  Remember that dream I had about going to work at a Windows shop?  I don't know, man.  I don't know.

I'm working on a project that has me writing some code in a few different languages.  Earlier this week I was suffering the slings and arrows of outrageous PHP.  It seemed only fair to write a library in C# while I was at it.  Tom told me that I could get a free version of Visual Studio to do this, so I gave it a go.

First I booted up my trusty old Parallels virt for Windows XP.  It wanted SP3 to be installed, so I told it to go ahead.  Unfortunately, it kept failing with no reason.  This was familiar:  there was an old security update that kept failing.  Here's the advice from Microsoft Update in case of upgrade failure:

> Problem: A problem on your computer is preventing updates from being > downloaded or installed Solution: To fix the problem, try installing the > updates again. If that doesn't work, use the Troubleshooter to try solve the > problem.

What's that saying?  The definition of insanity is trying the same thing and expecting different results?

Well, I tried it over and over, and I did, indeed, go insane.  I got better.

So I went through the Troublehsooter, which was totally worthless, except that by following all the links that I was discouraged from following, I finally found an SP3 standalone installer download "only for IT professionals planning to deploy SP3 via automated blah blah blah."

I ran that, it churned and showed some progress bars and finally said, "You don't have enough space to back up files needed for uninstall."

Oh!  Well that's fine!  I can make more room.

I added more storage to my virt and installed the update.  I had very little space left, though, and even after some cleaning wasn't happy with the space left.  Worse, though, was the performance.  I basically must not have Firefox and Parallels running at the same time (at least not running Windows).  I've heard many times that VMWare Fusion is better-performing than Parallels, though, so I gave it a go.  It installed XP handily and I installed SP3 with no problem.  I installed Visual Studio 2008 Express C# Edition, Strawberry Perl, Firefox, and AWG for virus scanning.  I went back to MS Update and there were 17 more updates to install.  No problem... just kidding.

> Problem: A problem on your computer is preventing updates from being > downloaded or installed Solution: To fix the problem, try installing the > updates again. If that doesn't work, use the Troubleshooter to try solve the > problem.

Argh!  Is it the virus scanner?  I "paused" it, but no help there.  I shut it down.  No help.  I uninstalled it, and still no help.

I had gigs free.  I'd check the logs, but there really aren't any useful logs to look at.  I can't really strace or dtruss the installer.  I resort to the tool of the clueless:  Google.

[Eureka!](http://www.technipages.com/error-a-problem-on-your-computer-is-preventing-updates-from-being-downloaded.html)

There was nothing to it.  I just needed to re-register a few core Windows Update dynamic libraries with the system via the command line.  I guess any non-technical user would've just intuited this on his own, and my own technical background blinded me to its obviousness.

Fusion sure is performing better than Parallels, though.  Maybe I'll buy it. 
