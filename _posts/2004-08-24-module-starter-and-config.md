---
layout: post
title : "module-starter and config"
date  : "2004-08-24T00:00:00Z"
tags  : ["code", "perl"]
---
So, I really like Module::Starter.  There are a number of little things in it that bug me, but mostly they only bug me because of the way they're coded or because of the way I want to extend them.  In other words, they're things that wouldn't bother users (I think).

The big thing that's annoying as a user is the lack of a configuration file. As you've seen if you've used it -- especially with plugins -- the command line can get stupidly large.  I fixed this for me, first with an alias and then with a script.  Of course, if the point of sharing software is to help make everyone's life easier, it doesn't make a lot of sense to release software that needs a wrapper just to be a non-pain to use.  I'm trying to make the module-starter program easy for anyone to use without a wrapper or a half dozen command-line options.

The obvious thing to do is make a configuration file, which has been vexing me for a long time.  I was growing thought-sick, and I have decided to take drastic measures and write the simplest thing that will possibly work: a simple configuration file with the basic options in it.  Everything else can happen later.  If I have a totally awesome idea, in a few months, about how to make the config file better, so be it.  It probably won't make this file format obsolete, so who cares?  I want people to be able to just run "module-starter --module Honk::Honk::Simple" and have things work.  This does that.

It should be on the CPAN this week, after some more testing and poking around.

Another item of interest in Module::Starter is a link to Module::Release.  I really like Module::Release.  It's good.  I was introduced to it by Andy, who was already using it for Module::Starter before I got on board.  Yesterday and today I took some time to update some of my old code and release the updates with Module::Release.  It catches a lot of my stupid screw-ups, and I know that with a little more messing around I can make it catch more.

So, Bisbee has suggested that module-starter should create a .releaserc in the standard distribution skeleton.  It would be easy -- really, really easy.  I'm just not sure I want to start adding new features to module-starter.  Andy and I have talked about how there are two classes of potential M::S user.  There are newbie authors who need a system that's as simple as possible, so they can just write their code and go; then there are "power users" who write a lot of modules and want to be able to customize the tool to work just they way they like.

The key to making everyone happy is to keep those two use cases distinct.  I don't want the simple users to have to install plugins and muck about with TT2, which means I need to avoid the idea that the basic distribution should contain a big smorgasboard of useful and simple features.  So, what features are the key features?  A few months ago I would have even argued that Module::Build is a luxury.  Now, that idea sounds silly to me.  I'm not sure where I'll end up thinking Module::Release belongs -- but I sure want to think about it before I add it.  Otherwise, it'll never come out.

