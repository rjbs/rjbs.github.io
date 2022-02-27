---
layout: post
title : "my new raid"
date  : "2006-02-01T05:07:09Z"
tags  : ["hardware", "linux"]
---
Yesterday afternoon, I saw that my Newegg order would be "shipping soon."  I hoped I'd see my drives before Friday.  This morning, I saw that it had shipped.  Not only that, but it had shipped from Edison, New Jersey, and was already out for delivery to my apartment.

I had two new 250 GB drives waiting for me at home, so I got to work getting my storage situation hashed out.

The first problem was recompiling with RAID1 and LVM support.  I kept getting a weird C-language level error from make.  Finally I realized that at some point I had bizarrely decided to upgrade my Slackware 7 box to GCC 4.  Using 2.95.3, the kernel compiled just fine.

The next problem was finding mdadm and the lvm tools.  Once I found them, one of them only compiled with 2.95.3, the other with GCC 4.  Huh?

I got the RAID set up easily with mdadm, spent a little time figuring out how to create a volume group, and got my CPAN mirror (and some other things) moved onto the first logical volume.  I rebooted, and found that I hadn't given any thought to the fact that I'd need to reassemble the RAID on boot.  I got it put back together, but I haven't rebooted again.  I'm hoping that the mdadm.conf that I put together, along with "mdadm -A /dev/md0" in my rc.S will be enough.

I'm also wondering whether I'll really need to run vgchange to activate the volume group on each boot.

Once I'd gotten my mirrors onto the RAID (which was running with just one drive) I was able to pull the old mirrors drive and put in the other 250.  I started md rebuilding the RAID mirror, and boy howdy!  It's going to take a while.  Under normal load, it was saying it was getting between 2.5 and 3 megs per second, which seems very low to me.  Now I decided to be impatient and start copying my music archive onto the raid.  The load is sitting around 4 and /proc/mdstat is showing recovery occuring between 400 and 1000 K/s, despite /proc/sys/dev/raid/speed_limit_min being set at 10000.

I have ATA-100 controllers on this motherboard, so I'm not sure what's up.

I think I'll give it more thought when I can talk to more knowledgeable people about it.  For now, I think I'll go to bed. 
