---
layout: post
title : "hand cramps, et al"
date  : "2004-09-30T13:27:00Z"
---
Workrave has done a good job at helping me avoid hand pains, and the fact that one instance of it can communicate with others is just keen.  Unfortunately, I don't split my time between two Win32 machines so much, but rather between my Win32 box and my Mac.  AntiRSI is great, but it doesn't talk to Workrave.  I almost feel motivated enough to try my hand at C again to fix this problem... but not quite enough, yet.  Maybe after a few more shooting pains.

UPS should attempt, today, to deliver my new DSL modem.  Covad should activate my service.  Tonight, I may have a new connection, with six times my current upstream.  Woo!  I'll have a day or two of annoying DNS changeover, and I expect that I'll have an unsightly cord running through the apartment for a while, if I find that the old dedicated line isn't going to the beige box, as I suspect it isn't.

I finally wrote ModuleStore for Module::Starter, so that templates can be packed in a module, which makes it quite easy to distribute template packages on the CPAN.  It's in the SimpleStore distribution, which should really be cleaned up and tested.  Working on this stuff makes me want to do a lot of things, especially rewrite Module::Starter::Simple and the module-starer program.  I don't like Getopt::Long, and I don't know of any other Getopt system that's any better.  I need to stop glowering at getopt, though, and fix the stupid parts of the code, especially the parts that make me write other, equally stupid code.

ModuleStore is a good thing, though.  John will probably make a Kwiki plugin template available soon, and I may write a few of my own template packages for my own use.  (An idea strikes me: use @ISA (or something) to say "first go get templates from this other module.  Nice for overriding one file.)

Back to work, though.  I have a workstation to build and an internal audit to perform.

