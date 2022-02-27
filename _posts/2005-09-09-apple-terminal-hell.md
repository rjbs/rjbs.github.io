---
layout: post
title : "apple terminal hell"
date  : "2005-09-09T01:09:59Z"
tags  : ["apple", "macosx", "software"]
---
There is not a good terminal for use with Mac OS X, as far as I can tell.

Terminal.app doesn't let me redefine the RGB values of the colors, so I'm stuck with their horribly dark blue.  Worse, it uses bold fonts for bold colors, when they should really just be bright.  (I belive that 10.2's lousy Terminal.app actually had an option for this, and it was done away with.)  It's not an xterm, so it doesn't do xterm magic.  (I am sorely missing being able to have the Perl debugger pop open a new terminal to debug forked processes -- this despite having only learned about it today.)

iTerm is insane.  Sometimes it just starts using huge amounts of memory or CPU. I'm told it's slow, but it hasn't usually been so slow that I notice.  I actually don't like its tabbing feature, but it lets me redefine colors, and it doesn't bold terminal text.  It has some kind of "double-click to open URLs" thing, but it sucks, never works, and often tries to open http://%20/ when I'm just trying to re-focus my term.

xterm is xterm, but its copy and paste interacts poorly with the rest of the OS.  Dieter showed me how to make it work sometimes today: remap a key to "insert" and then use shift-insert.  This works when command-V and the Edit menu don't... but I have no convenient key to remap on my laptop, and hitting shift-insert is a pain in the butt to begin with.  The fonts are ugly, too.

Sometimes I wish I was still running Linux. 
