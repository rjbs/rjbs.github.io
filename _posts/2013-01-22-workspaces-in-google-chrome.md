---
layout: post
title : "workspaces in Google Chrome"
date  : "2013-01-22T03:35:15Z"
tags  : ["chrome"]
---
I really liked using [OmniWeb](https://www.omnigroup.com/products/omniweb/).
Back before Safari existed, OmniWeb was, for me, a much better option than
Firefox.  It was very fast, did a good job saving my session, had per-site
preferences, and had **workspaces**.  I am stymied, deeply and daily, by the
lack of good workspace support in every other browser.

I feel like I've spent hours, today, trying to figure out how to replicate the
basic features of OmniWeb workspaces in Chrome.  My spec is something like
this:

1. A workspace is a bunch of tabs.  Maybe windows, too.  I'm okay with tabs.
2. I can quickly switch from Workspace A to B.  All the tabs from A go away and
     the ones from B appear.
3. If I change the tabs I'm working on while in WS B, then go work in A, then
     come back to B, I come back to the the state of B before I left it.
4. I can easily move tabs from A to B.  (This is vital, because URLs opened from
     external programs will presumably go into whatever workspace is currently
     active, and might not be topical.)

I looked at a [Chrome
Workspaces](https://chrome.google.com/webstore/detail/chrome-workspaces/jiednhamhlmclhmmcfadedodgkkkjhma),
which was promising, but:

* had numerous reports of data loss
* didn't provide any clear way to move a tab from one WS to another; you can
    copy the URL and re-open it in the other WS, but that requires re-opening
    every tab in the workspace, and loses your tab's history, and if you have to
    switch back, you've got to reload all your tabs in your original workspace,
    too!

[Session Buddy](http://www.sessionbuddy.com/) seems great.  It saves all your
windows and tabs, and can keep multiple snapshots, both by time and named
snapshots.  Snapshots can be restored, deleted, and tweaked in place.

Unfortunately what you *can't* do is say "save my current session and swap out
all the current windows for the ones in some other session."  In other words,
it isn't a workspace system at all, even though it seems to have almost
everything it would need to be one.  Well, I guess it doesn't claim to be one,
so I shouldn't be grumpy.

While writing this, I was suddenly inspired to run Firefox, because I felt like
I'd found a solution there that I could no longer recall.  I was right!
[Panorama](https://www.youtube.com/watch?v=5r0TQJ-gGi0)!  Tab groups!  Panorama
is ***the best workspace thing ever***.  Forget about OmniWeb.  What was I
thinking?  Man!  Panorama is *awesome*.  Why did I stop using Firefox, again?

Oh, right.  It was because it was *achingly slow*.

Well, Panorama came out in mid-2010.  Surely it's been ripped off by now,
right?  **Yes!**

[Tab Sugar](http://tabsugar.com/) was a pure copy of Panorama to Google Chrome.

Unfortunately, [the developer gave up because Chrome couldn't offer the data he
needed](https://code.google.com/p/chromium/issues/detail?id=78344#c14).
**Augh!**

Having spent all this time suffering through trying to find a solution in
Chrome, I may just give up for now.  Either I'll continue to try to enjoy
Chrome without tab groups, or I'll move back to Firefox and see whether it's
gotten any faster in the last year.

Or maybe tomorrow morning I'll try [Tabs
Outliner](https://chrome.google.com/webstore/detail/tabs-outliner/eggkanocgddhmamlbiijnphhppkpkmkl)…
or [Sidewise Tree Style
Tabs](https://chrome.google.com/webstore/detail/sidewise-tree-style-tabs/biiammgklaefagjclmnlialkmaemifgo)…
