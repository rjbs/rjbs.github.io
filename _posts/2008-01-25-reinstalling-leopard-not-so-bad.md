---
layout: post
title : "reinstalling leopard: not so bad"
date  : "2008-01-25T03:04:44Z"
tags  : ["macosx"]
---
So, I don't use Apple's Mail.app very much.  Actually, I detest it.  Still, you
know, I'm an email geek.  Every once in a while, I get a bug that says
something like, "Apple Mail is doing something totally insane, and only you can
help us, Rik!"  Well, that's how I like to read the bug reports, anyway.  It
makes me feel like more of a superhero, even while doing my secret identity
thing behind a terminal.

I had my main email accounts set up in Mail, but no matter what, Mail wouldn't
save my password in the keychain.  I tried nearly everything I could think of,
and finally resorted to asking our [local Apple retail/repair
place](http://dclick.com/) if they had any ideas.  (They had ideas.  It didn't
help.)

Lots of other things were using the keychain without incident, but Mail kept
failing.  Actually, iTunes failed at remembering (at least) my Audible account.
Here's my guess:  a few months ago, I was running low on space, and I was
getting really tired of constantly shuffling things onto and off of my laptop.
I took a drastic step: I used
[Monolingual](http://monolingual.sourceforge.net/) to effectively
[lipo](http://developer.apple.com/documentation/Darwin/Reference/ManPages/man1/lipo.1.html)
my whole system.  It removed most of the non-English localizations and all of
the PowerPC binaries.  This didn't really cause my any problems, except that
Safari complained that its signature was no longer valid.  I replaced Safari
with a fresh copy, and life was good.

My guess was that somehow Mail was not getting access to the keychain.  Since I
just replaced my hard drive, I figured that I could make a fresh install and
not lipo anything.  That went pretty well.  Here's what I did (mostly for my
own future reference):

1. backed up everything with Time Machine
1. shrank my installed Leopard partition
1. made a second partition
1. installed Tiger (via the MacBook restore disks) to the second part
1. upgraded to Leopard
1. re-installed the apps that I use the most, using the old /Applications as a guide
1. used the Migration Assistant to move my user data from the old to the new system
1. ran a lot of system updates
1. reapplied my [postfix configuration](http://rjbs.manxome.org/rubric/entry/1297), using [Lingon](http://lingon.sourceforge.net/) for the launchd stuff
1. installed [MacPorts](http://www.macports.org/)
1. found out that MacPorts' `mutt` sucked and rolled my own
1. reinstalled `perl` 5.10 and a bunch of my most-needed modules (note to self: make a Bundle)
1. backed up with Time Machine
1. booted to Leopard install DVD
1. used Disk Utility to remove old crufy system
1. used Disk Utility to duplicate second partition to first partition
1. rebooted to first partition and verified that it was okay
1. booted to Leopard install DVD
1. used Disk Utility to delete second partition and grow the first (took forever!)
1. got back to work

This all took a long time.  I was at it from about 19:00 to 01:00 last night,
and then another hour or so, today.  Knowing what I know now, I'm sure I will
be able to do it faster, if I need to do it again.  Still, given the fact that
I really did *reinstall* everything I needed, it really wasn't so bad.

It turns out that, yes, now I can save passwords for Mail.app in the keychain.
My Audible passwords are still getting ignored, though.  Ugh.

