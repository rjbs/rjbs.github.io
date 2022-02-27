---
layout: post
title : "firefox instead of msie"
date  : "2004-11-18T15:52:00Z"
---
I'm endeavoring to use Firefox instead of MSIE at work.  There are a number of things that require MSIE on our intranet, but not many, and I've been slowly making sure that all the JavaScript in our internal apps is cross-platform friendly.  (The last WebKit upgrade made that much easier, as it finally decided that yes, THEAD elements are part of the node tree.)

The thing that bugged me most was the lack of my OmniWeb shortcuts.  Sure, I didn't have them in MSIE, but now that I'm using a real browser, I wanted all the stuff I have on my Mac.  A shortcut is a parameterized bookmark, so I can type "w 18018" into the URL bar and get my local weather.  I knew Firefox could do this, but I figured it needed an extension.  After some yelling in #perl, I was told that Mozilla bookmarks do this by default.  All those years before MSIE, loving bookmark keywords, and I never knew this!

So, I wrote a nice little <a href='http://rjbs.manxome.org/hacks/perl#ow5sh'> hack</a> to convert my OW5 shortcuts into a Mozilla bookmarks file.  A few caveats:  I think the current version of Netscape::Bookmarks has a bug which, when fixed, will require alterations to that script.  (I'll comment it accordingly.)  Also, it requires a patch to NS::B (that I've sent to bdfoy) to allow SHORTCUTURL to be added to Netscape::Bookmark::Link objects.

Still, yay!

In other news, Metroid Prime 2 continues to rule.

