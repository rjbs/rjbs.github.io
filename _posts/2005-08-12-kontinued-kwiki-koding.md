---
layout: post
title : kontinued kwiki koding
date  : 2005-08-12T03:58:37Z
tags  : ["kwiki", "perl", "programming", "wiki"]
---
Putting plugins into Kwiki installations is fun, and usually as easy as eating pie.  I installed a bunch at work last night, and I think I'll install some of them at home, tomorrow.  Today, though, I did a little more work on tweaking the ones I like best (or need more): Kwiki::Keywords and Kwiki::Edit::RequireUserName.

As I told cdent: keywords rule and categories drool.  While cleaning up the work wiki, I found a quote from C2's page on wiki categories, and it's just so primitive compared to auto-backlinks and keywords!  I had given Chris patches to make keywords respect pages' writability and to optionally ditch the (to me repellant) auto-tagging with editors' names.  Those patches got integrated and released today, after a bit of fighting with TT2 and my is_writable munging. I'm excited to see it out, now (0.13), because I will use it everywhere.

The is_writable wrangling was in Kwiki::Edit::RequireUserName.  I'd forgotten how that whole thing had played out, and forgetting is bad.  See, I originally wrote Kwiki::RequireLogin, which basically said "if the current user isn't logged in, pages aren't writable."  This caused the Edit button to go away, and made editing impossible, which is just what I wanted.  Unfortunately, if an anonymous user clicked on a link to a missing page, it would begin an infinite loop: go to the missing page; it isn't there, so edit it; you can't, so view it; it isn't there...

Well, that sucked.
