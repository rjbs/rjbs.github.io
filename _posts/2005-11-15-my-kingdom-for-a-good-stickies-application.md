---
layout: post
title : "my kingdom for a good stickies application"
date  : "2005-11-15T00:12:43Z"
tags  : ["apple", "macosx", "software", "stupid"]
---
I want a way to take really quick notes.  I want to scribble down a to-do, write down a MySQL log position, write down the length of time it took to build the CPANTS database, or whatever.

Using Vim is annoying: I have to have an open screen, I have to run Vim, I have to give it a filename, and save it.  The up side is that it's a very good editor, I end up with a plaintext file, and if I do it on a screen session on cheshirecat, I can pick that note up anywhere.

Apple has two distinct Stickies programs, which blows my mind.  What blows it more is that they have different good and bad points.

Stickies.app has resizeable windows.  It supports real Cocoa text editing, lets me use any font (even monospace), lets me create a new note with Cmd-N, lets me print my notes, and can save notes as plaintext if I ask.

Stickets.wdgt can't resize windows, but will automatically resize the font to fit the window size.  It's on Dashboard, so I can hide and display all my stickies anywhere with a single keypress.

The font resizing in Stickies is neat, but mostly I want the easy hide/display. I thought I'd have a look at Konfabulator, but its note-taking widgets were either roughly identical to Stickies.wdgt (except requiring 80% of my CPU) or wildly overengineered.  One of them, THnotes, does multipage notes that are actually editors for plain text files anywhere on your filesystem.  That's great except that you can only have one note window and you can't create an anonymous note.  When I need to scribble a note, I want to hit Cmd-N, not click the little "new note" button followed by navigation around my filesystem.

The Dashbaord widget is hardly better, as far as new note creation goes.  I have to click the "plus" button to bring up a bar from which I can click the "Stickies" icon -- assuming that it's on the current page of widgets.  I may have to scroll around, nine widgets at a time.

"Well," I thought, "this isn't going to be that hard to fix.  I'll tell Desktop Manager to display Stickies on every Desktop, I'll write a little AppleScript to hide or display the Stickies application, and then I'll bind F12 to that script.  I can eliminate my use of Dashboard entirely!"

Now I find out that there is no (or is no documented) way to hide an application from AppleScript.  (By hide, I mean what happens when you hit Cmd-H.)  Fine!  I can always "repeat with w in (get every window) set w's visible to false" -- except that Stickies.app isn't scriptable.  Neither is Desktop Manager, so I can't quietly change display settings for that app, either. 

Maybe I can just tell it to quit if it's not running!  Well, actually, I don't see a simple way to ask whether a named application is running.  Maybe once I'm online again I'll find something on Google, but my on-disk copy of the entire ADC Reference Library isn't helping, despite Spotlight's best efforts.  Maybe it's because the AppleScript reference documentation hasn't been updated since 1999.  Even if the language is stable, shouldn't the documentation be getting better?

Finally, I end up with this.  I cannot express my exasperation sufficiently, so I will leave it to your imagination:

<code>
set StickiesRunning to
    (do shell script "ps ax | grep Stickies.app | grep -v grep | wc -l") + 0

if StickiesRunning > 0 then
    tell application "Stickies" to quit
else
    tell application "Stickies" to activate
end if
</code>

-- Bonus Hate!

If you use Spotlight to search and select "Show All" you get a window from which you can launch anything you've found.  If you then open any of those documents and thereby create a window that hides Spotlight, you can't cmd-tab back to it.  You have to use Expose or close/move/hide the windows that got in the way.

-- Bonus Bonus Hate!

When viewing the ADC Reference Library in Safari, there are two frames: an index on the left and content on the right.  The frame size can be changed by dragging the divider, but the cursor does not indicate this when hovering over the divider.  (In every other "reasonable" Mac OS X application, it would turn into the little <-|-> curosr.)
