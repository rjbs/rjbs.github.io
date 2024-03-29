---
layout: post
title : "closing up my server"
date  : "2006-02-02T04:37:18Z"
tags  : ["hardware", "linux"]
---
cheshirecat is all closed up, and basically changed over to its new configuration.  My whiteboard plan was to have a five gig drive become the system disk, replacing the Caviar 22500, which was only half the size, and not large enough for my system... or so I thought.  Now that I look at it, I see that my new root partition, including var, usr, and tmp, is only 2.2 gigs -- which would have left me enough room for swap, too.

Of course, I never really had things set up such that I could easily repartition the Caviar.  Maybe I'll try to transfer the system back to that drive, though, if I get it working in the external USB enclosure. That might make it easy to swap things around again, without doing too much disassembly.

I won't bother with it, if I didn't have my 2.2 gigabyte system partition, now, on a 120 gig drive!  I don't know what I want to do with that, but I want to do something better than have my local mail spool on it.

It was a real pain to get the system firmly moved over, though, largely because of the boot loader.  Back when I built Linux boxes for fun, every now and then, I knew the trick to getting LILO or GRUB set up on the third or fourth hard drive so that I could then yank them, make them the first, and have them just work.  This time, though, I ended up with a lot of "L 07 07 07" and that sort of nonsense.

Finally I just gave up, booted from an Ubuntu Live CD, chrooted to the new drive, and installed LILO while the new system disk was hda.  I guess I'll probably try re-transferring to a newly fdisk'd Caviar tomorrow, and then try setting up a new system installation at some point in the near future. cheshirecat's system could do with an overhaul.  I'll be interested to see how a new Slackware 11 install does mounting the RAID/LVM that I've built with my antiquated tools... I think it will probably do just fine.

If I do put the Caviar back in there, I'll have three drives sitting around: a 40, an 80, and a 120.  The 40 and 120 were in cheshire before, and the 80 is currently in my USB enclosure.  I have no idea what I'll do with them.  I'm tempted to try to put another IDE controller in cheshire, but I rarely hear of any good coming from a fifth and sixth parallel ATA drive. 
