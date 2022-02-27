---
layout: post
title : our new media box
date  : 2010-07-29T03:21:13Z
tags  : ["hardware"]
---
Last week, I was at [OSCON](http://oscon.com/).  I have to write a lot more
about that whole experience.  For now, it's only relevant because it mean that
when my [Popbox](http://popbox.com) arrived, I wasn't home.  I checked some of
the reviews and they were *bad*.  Like, shockingly bad.

When I arrived home, Popbox had issued a few firmware updates, so I remained
hopeful.  Unfortunately, they utterly bricked the box.  I sent it back and
ordered an [Acer Aspire
Revo](http://www.newegg.com/Product/Product.aspx?Item=N82E16883103266) to use
as an Ubuntu machine with [XBMC](http://xbmc.org/).  It showed up today.

It was pretty frustrating as attempt after attempt failed to get the darned
thing working.  I just finished watching an episode of Batman: The Animated
Series, though, so I'm hoping that everything is now right with the world.

First, I couldn't get the XBMCLive system installed.  I could get it onto a USB
stick, but that would boot to a login prompt, not the XBMC system with an
installer.  I tried this a few times, and gave up in disgust.  Then I tried to
install it to a hard drive, but grub died.  The drive changed its device name
between setup and attempted install, but grub was dying too early for me to fix
the setup.

Finally I installed Ubuntu 10.04 to a micro SD card and installed Ubuntu from
there.  After that, I let it do all of its upgrades, installed
`xbmc-standalone`, and set it up to run that automatically on boot.  This was
progress!

Next up, it couldn't find my RaLink RT3090 wireless chip.  The guys in
`#xbmc-linux` were alternately helpful and not, but they kept my brain active
while I kept looking.  Finally, I found [this bizarre
solution](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/541620/comments/21)
in a forum:

    As root:

    mkdir -p /etc/Wireless/RT2860STA/
    touch /etc/Wireless/RT2860STA/RT2860STA.dat
    service network-manager restart

...and that's it.  Wuh?  Well, it worked.

So, I took the thing downstairs and hooked it up.  Everything seemed okay,
until I tried to play my first video.  It took ages to buffer anything and
playback was unacceptable.  I'd gotten some grief from IRC about using wireless
for streaming video, but I do this all the time already to my Xbox 360 and PS3.
Further, I wasn't getting any audio over HDMI.  I struggled with that for a
while before finding [another useful forum
post](http://www.uluga.ubuntuforums.org/showpost.php?p=8560765&postcount=9)
suggesting that the HDMI output was muted, and that the only way to find it was
to run the terminal `alsamixer` program and hit the undocumented "`m` for mute"
command.  That did the trick!

After that, I tried to play an episode of Batman, and it worked.  Why was the
wireless weird before?  No idea.  It would be nice to get a cable run, somehow,
but I am in no hurry.

I also installed XBMC Remote on my iPhone, but I think it's sort of
underwhelming.  I'm not sure what I'll do in its stead, but I don't think it's
a long term solution.  I might just get an IR receiver and set up the XBMC in
our Harmony remote.

My hope is that we can use this device to let Martha see whatever of her DVDs
she wants without having to fumble with discs.  Any other application is pure
gravy.

