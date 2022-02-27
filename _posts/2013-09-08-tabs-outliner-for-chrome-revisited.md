---
layout: post
title : "Tabs Outliner for Chrome revisited"
date  : "2013-09-08T16:29:42Z"
---
Earlier this year, I [lamented the state of "workspaces" in
Chrome](http://rjbs.manxome.org/rubric/entry/1980).  I said that I'd settled on
using Tabs Outliner, but that I basically didn't like it.  The author of the
plugin asked me to elaborate, and I said I would.  It has been sitting in my
todo list for months and I have felt bad about that.  Today, Gregory Meyers
commented on that blog post, and it's gotten me motivated enough to want to
elaborate.

I agree with everything Gregory said, although not everything he says
is very important to me.  For example, the non-reuse of windows doesn't bother
me all that much.  On the other hand, this nails it:

> Panorama is intuitive. I didn't have to read a manual to understand how to
> use it. TO comes with an extensive list of instructions... because it is
> *not* intuitive. Now, supplying good instructions is better than leaving me
> totally lost. But it's better to not need instructions at all. I have to work
> much harder to use TO.

I wanted to use Tabs Outliner as a way to file tabs into folders or groups and
then bring up those groups wholesale.  For example, any time I was looking at
some blog post about D&D that I couldn't read now, I'd put it a D&D tab group.
It's not just about topical read-it-later, though.  If I was doing research on
implementations of some standard, I might build a tab group with many pages
about them, along with a link to edit my own notes, and so on.  The difference
is that for "read it later," traditional bookmarks are enough.  I'd likely only
bring them back up one at a time.  I could use Instapaper for this, too.  For a
group of research tabs (or other similar things), though, I want to bring them
all up at once and have changes to the group saved together.

This just doesn't seem like that Tabs Outliner is good at.

Let's look at how it works.  This is a capture of the Tabs Outliner window:

<center><a href="http://www.flickr.com/photos/rjbs/9699467755/" title="tab
outliner plugin by rjbs, on Flickr"><img
src="http://farm6.staticflickr.com/5524/9699467755_267ed11aae_o.png"
width="400" height="589" alt="tabs outliner plugin"></a></center>

It's an outliner, just like its name implies.  Each of the second-level
elements is a window, and the third level elements are tabs.

At the top, you can see the topical tab groups I had created to act like
workgroups that I could restore and save.  I can double-click on, say, Pobox
and have that window re-appear with its six tabs.  If I open or close tabs in
the window, then close the whole window, the outliner will be up to date.  If
this was all that Tab Outliner did, it might be okay.  Unfortunately, there are
problems.

First, and least of all, when I open a tab group that had been closed, the
window is created at a totally unworkable size.  I think it's based on the
amount of my screen *not* taken up by the Tab Outliner window, but whatever the
case, it's way, way too small.  The first thing I do upon restoring a group is
to fix the window size.  There's an option to remember the window's original
size, but it doesn't seem to work.  Or, at least, it only seems to work on
tab groups you've created after setting the preference which means that to fix
your old tab groups, you have to create a new one and move all the tabs over by
hand, or something like that.  It's a pain.

Also in the screenshot, you'll see a bunch of items like "Window (crashed Aug
17)".  What are those?  They're all the windows I had open the last time I
quit.  Any time you quit Chrome, all your open windows, as near as I can tell,
stay in Tab Outliner, as "crashes."  Meanwhile, Chrome re-opens your previous
session's windows, which will become "crashes" again next time you quit.  If
you have three open windows, then every time you quit and restart, you have
three more bogus entries in the Tab Outliner.  How do you clean these up?  Your
instinct may be to click the trash can icon on the tab group, but don't!  If
you do that, it will delete the container, but not the contents, and the tabs
will now all have to be deleted individually from the outliner.  Instead *first
collapse the group* and *then* delete it with the trash icon.

Every once in a while, I do a big cleanup of these items.

Here's what I really want from a minimal plugin:  I want to be able to give a
window a name.  All of its tabs get saved into a list.  Any time I update them
by adding a tab, closing a tab, or re-ordering tabs, the list is updated
immediately.  If I close the window, the name is still somewhere I can click to
restore the whole window.  If I have a named window open when I quit Chrome,
then when I restart Chrome, it's still open and still named.  Other open
unnamed windows are still open, and still unnamed.

This would get me almost everything I want from tab groups, even if they don't
get the really nice interface of Panorma / Tab Exposé.

