---
layout: post
title : more blog mods
date  : 2004-05-21T02:28:00Z
tags  : ["code"]
---
I was really annoyed to find that my Bryar patch, for passing config objects instead of Bryar objects around, was nowhere to be found.  I recoded the changes, then immediately found the patch.  That's life.

I also managed to remove a few of my custom subclasses, namely Bryar::Cloning and Bryar::Collector::RJBS, both of which were going to be used by my crapped muxer, but which won't be needed now.  I think I'll be set to get muxing working this weekend.

I went through my $gamesite entries and converted them to my new file format so they can use my new, super-simple DataSource.  Really, it's a lot like the old one, but uses the ancient and simple "header and body" format, so I'm not worrying about filename and modification time if I can help it.  They'll be the first thing to get multiplexed, and getting that done will give me a good incentive to get post-posting processing working to post $gamesite entries to $gamesite and keyword:code articles to use.perl.

I might do some more mucking about with how Vim handles journal entries, but I don't want to get obsessive over that stuff.  However, having typed that, I wonder if there's a WikiFormat syntax rule set.  It should be easyish...

