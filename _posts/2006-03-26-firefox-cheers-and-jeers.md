---
layout: post
title : firefox cheers and jeers
date  : 2006-03-26T20:06:10Z
tags  : ["firefox"]
---
Really, I think Firefox deserves mostly cheers.  I reserve most of my jeers for
lousy extensions or extension incompatibilities.  (That, despite the fact that
I know how hard it is to write code that will Just Work when plugged into an
existing larger system with other plugins.)

After reading more about [Tab Mix
Plus](https://addons.mozilla.org/extensions/moreinfo.php?id=1122&application=firefox),
which Shawn also suggested, I decided to give it a try.  It said it wasn't
compatible with Session Saver .2, and would disable its own session management
if it saw it installed.  I installed TMP, uninstalled Session Saver, and quit.
Firefox crashed.  When I restarted Firefox, it still showed some extensions as
"will uninstall when restarted," but they seemed to be non-functional.  Worse,
it wouldn't properly quit, and seemed odd when starting, too.  I finally
decided that it was just really broken and deleted my profile.

Maybe I could have taken less drastic measures, but I didn't feel like
researching it.  Fortunately, I had the foresight to back up my session before
this whole mess, so once I was back up and had my extensions set up, a little
bit of Vim magic got my tabs and windows back in place.

I didn't just use the same set of extensions on this new profile.  I skipped
Tab X (for a "close" button on each tab) and Session Saver, and went right to
Tab Mix Plus.  I think this was a good choice.  TMP seems a little slow, but it
works well.  One thing it doesn't do, much to my chagrin, is allow me to drag a
tab from one window to another to move it.  Instead, dragging a tab will copy
it, so that I must then go and close it in the original window.  I can live
without OmniWeb's "select, cut, paste" operations on tabs, but I really wish
basic drag and drop was more reasonable.

