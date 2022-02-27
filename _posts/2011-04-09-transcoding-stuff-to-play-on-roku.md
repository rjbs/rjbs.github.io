---
layout: post
title : transcoding stuff to play on Roku
date  : 2011-04-09T19:32:28Z
tags  : ["programming", "tool", "video"]
---
A few weeks ago, I was near my wits end with our XBMC box.  XBMC itself seemed pretty good, but the hardware I had it running on wasn't so great, and one complication after another just made it a pain.  What I'd wanted when I set the box up was something less annoying than trying to play video over pseudo-UPnP stuff supported by XBox or PS3.  My XBMC setup wasn't quite living up to that.

John C. said he'd gotten XBMC running on a jailbroken Apple TV, which sounded pretty good, and I gave that a go.  It was a big pain to get it working, and even then it only barely worked.  This isn't Apple TV's fault: I was trying to use it for something for which it really wasn't meant.  I sent it back, disappointed, but ordered a [Roku XDS](http://astore.amazon.com/rjbs-20/detail/B00426C57O) box, which is a pretty similar device, but has explicit support for playing movies from a USB hard drive.  When I got the Apple TV, it took hours to get it kinda-sorta playing my personal movie files.  With the Roku, I had it playing a movie in under half an hour -- and that includes time to answer the door for UPS and unpackage the device.

The one down side is that the Roku "USB Media Channel" supports an [*extremely* limited selection of formats](http://support.roku.com/entries/423946-what-media-file-types-does-the-roku-usb-media-player-channel-support). It won't play AVI containers and it won't play any video encoding other than h.264 and some Windows Media formats.  Thankfully, I've ripped most of my DVDs with [HandBrake](http://handbrake.fr/)'s "Apple Universal" settings, which are great for Roku.  That was only *most*, though.  I had a lot of files ripped from before HandBrake had that setting, and those had to be transcoded.

I spent several CPU-days transcoding everything before finding out that Roku's *audio* requirements are very specific, too.  I had ensured that everything was AAC, but it turned out that it had to be 48 KHz, too.  (Their site seems to imply that 44.1 KHz is okay, but files at 44.1 KHz were sort of noisy, for me.)

So, if you want a Roku and you want to make sure your movie files work on it, I suggest a variation on the following stupid little program:

    #!/usr/bin/perl
    use strict;

    for my $ARG (@ARGV) {
      (my $NEW = $ARG) =~ s/avi$/mkv/;

      my $return = system ffmpeg => (
        '-i',
        $ARG,
        qw(-acodec libfaac -ab 96k -ar 48000 -vcodec libx264 -vpre medium -crf 22 -threads 0),
        $NEW,
      );

      unlink $ARG unless $return;
    }

Enjoy!
