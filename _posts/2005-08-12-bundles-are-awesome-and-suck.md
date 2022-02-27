---
layout: post
title : bundles are awesome and suck
date  : 2005-08-12T03:37:50Z
tags  : ["perl", "programming"]
---
John and I, both unhappy with the lack of awesome plugins on the Kwiki at work, made a list of what we wanted and got things installed.  "Hey," I said, "I'll just make a Bundle!"

Bundles are a good idea.  You make a list of stuff, call it a bundle, and it all gets installed at once.

The popular Bundle::Whatever implementation stinks, though.  All the work is done by CPAN.pm or CPANPLUS, which is keyed to the Bundle namespace.  If it sees that, it parses the POD, basically ignores the build file, and installs the modules.  This is swell if you use CPAN.pm, but otherwise sort of sucks. Other people have noted this, before, at the monastery and elsewhere, but I hadn't paid it much mind until last night.

I mentioned something about this to Alias, who'd said something about disliking Bundles, and we griped together for a bit about how the prereq system should already make this work properly and how it was time to release Sack::O'Kwiki (or whatever) on an unsuspecting world.

As is usually the case, though, I mellowed with time and decided to look at existing knowledge on the subject.  I've found that this is yet another place where I should just be using Module::Install.  After specifying what your module needs, you can just say, "Oh, and bundle it all for installation" or "If it's not there, use CPAN to get it when needed" or other things.

I think I may skip Module::Build and go right to Module::Install.  This means Module::Starter will get Module::Install support, and that hopefully I will get around to making it handle arbitrary new files.

I will probably not carry out my threat to implement the non-simple Module::Starter engine as Module::Starter::Spoon. 
