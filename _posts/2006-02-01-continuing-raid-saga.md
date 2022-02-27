---
layout: post
title : "continuing raid saga"
date  : "2006-02-01T15:25:06Z"
tags  : ["hardware", "linux"]
---
Last night, I was complaining that it was going to take six forevers to build my RAID.  This morning, it was still going, and expecting over a day to complete.  I whined about this to Dieter, who was similarly perplexed.  He asked a few questions, including, "Well, of course you're using DMA, right?"

I've had this damn box for almost exactly four years now, and I never set up DMA for its IDE devices.  Wow.  What the heck is wrong with me?  I guess I never noticed, since it was never doing a lot of heavy disk work that would make me take notice.  Probably when I first set the box up, I wasn't as well versed with hdparm, and then I never bothered to have another look.

Sheesh.

Well, with a new kernel in place and DMA turned on, I started getting about twenty times the throughput.  I'm hoping it will finish building the mirror in about twenty minutes from now.  Then, I'll restart and see if my current init scripts get everything mounted correctly.  If so, I'll be almost ready to close up the case... I'm going to need to figure out how to physically arrange the drives in there, though.  I'm not sure I have the right cables for the job. 
