---
layout: post
title : "oscon: day zero"
date  : "2004-07-25T12:11:00Z"
tags  : ["code", "oscon", "perl"]
---
I'm in that annoying state where I'm ready to leave, but it just isn't time to go yet.  We'll be heading out in about 45 minutes to go pick up a few last things from my office and then head to the PHL airport.  "We" are John C and me.  John came to town to hang out, drink some beers, and give me a lift to the airport.  Awesome.

He also brought me a birthday present!  Zelda: Four Swords for GameCube.  We played a bunch of it, and it's pretty rockin'.  I hope the one player version is good, or, better, than Gloria enjoys playing it with me.  As far as the beer situation goes, we drank the Two Hearted Ale that Matt from work had given me, and it was really good.  We also picked up some Newcastle Brown Ale, which I'd never had before, and which was also good.

Gloria is in Connecticut for her AFAA fitness certification exam, which will be going on today.  By the time I get to the hotel, I should be able to call her and find out how everything went.  We haven't been able to get iChat video chatting working, which is a bummer.  I think there's probably some kind of firewall in place at the bed and breakfast at which she's staying.  Hopefully everything <em>will</em> work between home and Portland!  Even if things don't work at first, there, I bet it could be reported and fixed.  Nobody wants a firewall to get in the way of me smiling at my wife, right?

I released very tentative versions of the modules I use as my Module::Starter plugins.  They're plugins to store templates on the filesystem and to render them with TT2.  Given the fact that Module::Starter has no config file (yet!) I have something like a four line command to create a module.  Of course, three and three quarters of that is static, so it's alias to the rescue!
<pre><code>	alias n2pm='MODULE_TEMPLATE_DIR=~/.ms-tt2 module-starter \
	 --plugin=Module::Starter::Simple \
	 --plugin=Module::Starter::Plugin::Template \
	 --plugin=Module::Starter::Plugin::DirStore \
	 --plugin=Module::Starter::Plugin::TT2 \
	 --author="Ricardo SIGNES" \
	 --email=rjbs@cpan.org'
</code></pre>

Now creating a new module is just: n2pm --module=Games::Nintendo::Samus

I got some feedback on the current (developer) release of Module::Starter that I shouldn't require UNIVERSAL::require as a prerequisite.  I'll probably remove it, but it's a shame.  The require method on a string should be vanilla functionality.  Still, I can live with removing it here, it's only saving me a line or so.

Plugins I'd like to write soon:  KwikiStore, to retrieve templates stored on a Kwiki; License, to provide license text for common licenses; ModuleInstall, to provide Module::Install support.  I'd also like to produce a pre-built template file (using InlineStore) for a few Kwiki plugin types.  There are enough questions on #kwiki about how to make a plugin that this might be quite useful.

I'm going to shut down, now, and do my last few bits of getting ready.  John is up and in the shower, so I can pack up his bed.  Then, it'll be waffle time!

Oh, and in case anyone sees this before heading to OSCON, I'm on United, flying from Philly at 13:55 and Chicago at 17:10.  If you see me, say hello!

