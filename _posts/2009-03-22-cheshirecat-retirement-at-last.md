---
layout: post
title : "cheshirecat: retirement at last?"
date  : "2009-03-22T02:01:34Z"
tags  : ["hardware"]
---
When I left home for college, I planned to take my heavily, hackily upgraded
386 (actualy a [Cyrix Cx486DLC](http://en.wikipedia.org/wiki/486DLC)) along
with me.  It had two full-height ESDI hard drives, and the weird, exposed
ribbon cable on the back of one broke about two weeks before I left home.  I
quickly sold a bunch of things I owned, begged some cash from my dad, and
purchased an AT&T mid-tower (a Globalyst, which later became an NCR line).
This Pentium 90MHz, `marvin`, lasted through most of college, and was finally
replaced by a Compaq that looked good in the store but turned out to be a real
pain.

I didn't replace that until I'd gotten out of college and had a decent job.  I
slowly saved up and bought each component one by one, in order of speed of
devaluation: case first, power supply, and so on, ending with the RAM.  The
machine I built was a dual Athlon MP 1600 box in a totally sweet Lian-Li 60
case.  It also took insanely expensive buffered EEC RAM, which remains insanely
expensive to this day.

I've upgraded it once or twice since then, but only by replacing its drives.  A
few years ago I put in two 250 GB drives and made a RAID1.  (I had to place two
orders for these: the first time I accidentally ordered SATA, forgetting that
nobody did PATA drives anymore.)

Maybe it's because all I ever did was compile and test code, but the box is
still blazing fast.  It also might help that my frames of reference for speed
are pretty much locked in to where they were in 1996 or so.

Unfortunately, I needed to upgrade it some more.  I was nearly out of space
on the drives.  I could get bigger drives, but I'd have to upgrade to SATA.
Maybe it was time to get a NAS box?

I agonized over all my options for well over a year.  I know that's ridiculous,
but I tend to do that over nearly any choice where I think I have a chance of
agonizing my way into a better decision.  I looked at LinkStation, ReadyNAS,
AirPort's disk sharing, Drobo, and all kinds of other stuff.

I won't recount all my boring concerns, but eventually I decided that I'd be
perfectly happy with one big drive attached to a computer and rsynced every few
days to another big drive elsewhere.  Cheap, low tech, and perfectly effective
given the kind of data I was storing.

I ordered two USB 1T drives (later it turns out I only needed one of them to be
in an enclosure) and an [MSI Wind
PC](http://www.newegg.com/Product/Product.aspx?Item=N82E16856167032).  I played
around for quite a while trying to make the Wind boot from an SD card with
Ubuntu or from an external USB drive running Ubuntu, but GRUB kept giving me
grief.  Finally,  I disassembled one of my enclosures and shoved the drive in
the case.  Problem solved.

This little box replaces both my gigantor server, `cheshirecat` and our disused
Linux workstation, `plumcake`, and is now the new `plumcake`.  So far, I'm very
happy with it.

Here is the big win:  noise.  That Lian-Li case had about seven fans in it,
at least half of them big 80mm beasts.  The MSI Wind PC has a single fan of
maybe 35mm.  It runs nearly silently.  I can actually hear what's going on in
my house, now when sitting in my office.  It is an amazing difference.

It will be sad to see cheshire go, as it has been an extremely good computer,
but it's just not pulling its weight.  Or, maybe more importantly, it doesn't
justify the amount of noise it produces.

I'm just a little bummed that I couldn't do what I really wanted, which was to
use a *really* small machine in place of the Wind.  I wanted something about
the size of a pack of cigarettes that would boot and run `sshd` and `samba` and
that would be about it.  It looked like that was just going to be a bit more
of a pain than I wanted to deal with.  Maybe in a few more years...

