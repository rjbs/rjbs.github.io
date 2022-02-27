---
layout: post
title : "all mail software sucks (thunderbird doesn't suck less)"
date  : "2005-09-20T13:27:12Z"
tags  : ["email", "software", "thunderbird"]
---
Last time on "rjbs hates email software," I was hating on Mail.app, which (as you may recall) sucks.  I still use mutt for most of my email needs, but sometimes I (sort of) need to use a client with HTML support, for work. Lately, Mail.app doesn't even start up anymore.  (I probably need to go into ~/Library and delete things.  Ugh.)  Without sucky Mail.app, I've been using sucky Thunderbird.

At first, I thought Thunderbird was going to be just great.  I thought that maybe I had found a GUI mail client that I could use.  It had an "always send plaintext mail" option, it had options to subscribe only to some of my IMAP folders, it had offline mail support.  Wow!

Too bad the interface is ridiculously horrible.  I have 539 mail folders, and I need to click on a tiny checkbox next to each one to which I want to sync for offline use.  That, by the way, is after subscribing to the folder via an equally horrible interface.  In that one, I can multiselect and click "Subscribe" to try to subscribe to many at once, but it doesn't recurse down subfolders, unless they're expanded to view... or so it seems.  It's pretty hard to pin down the behavior.

If I try to sync a folder to which I'm not subscribed, for whatever reason, it doesn't even show up as an option.  This is just great when the previous problem with subscribing to subfolders has caused me to subscribe to my Vim folder but not its children, meaning that the Vim folder doesn't get a disclosure triangle and now looks like it has no subfolders.

At least it can work offline without syncing my full two gig mailstore, right? Well, mostly.  If I have left my account in "online mode" and then, on the bus, try to switch to offline, it goes into an apparently infinite loop trying to connect to sync up.

Seriously, I need to get the offlineimap program working.  Maybe there's a new version... 
