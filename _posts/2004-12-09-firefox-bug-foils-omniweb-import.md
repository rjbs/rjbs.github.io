---
layout: post
title : firefox bug foils omniweb import
date  : 2004-12-09T14:53:00Z

---
I don't understand my own modus operandi, but here it is:
<ol>
<li value="1">identify a problem</li>
<li value="2">produce simplest easy solution</li>
<li value="3">totally ignore solution for X duration</li>
<li value="4">get around to trying it</li>
</ol>

I do this a lot, and other manifestations of this problem show up in my behavior.  I think it's part of shiny-object syndrome.

Anyway, I finally imported my OW5 shortcuts into FF today.  I'd done so before, but it was a small subset, and I only tested them by glancing at the properties of the created bookmarks.

Unfortunately, now that I'm actually trying to use the bookmarks (by which I mean, lessen the horrible suffering that is life-on-Win32), I've found a bug in Firefox that prevents me from doing so.

Netscape::Bookmarks stringifies bookmarks as valid HTML, entity-encoding things like ampersands.  If I load the bookmarks.html produced by my ow5sh script, I I can click the links and they go where they should.  Unfortunately, Firefox (and Mozilla, etc) don't treat bookmarks.html like plain html.  Entities in the HREF are not decoded, so ampersands show up as entities, which break the link.

Ugh!  Bug 273886 filed.  I'll have to apply some s/// logic to the output of the script, for now.

