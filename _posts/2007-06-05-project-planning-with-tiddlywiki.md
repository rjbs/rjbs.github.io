---
layout: post
title : "project planning with tiddlywiki"
date  : "2007-06-05T04:13:32Z"
tags  : ["javascript", "perl", "programming", "tiddlywiki", "wiki"]
---
There are apparently a lot of TiddlyWiki plugins or rewrites centered around
"Getting Things Done" or other project management systems.  That's not what
I did today.

I made my first pass at spiking the "store structured data in TiddlyWiki" for
my D&D game by testing on data for work.  We're working on planning out a set
of large tasks at work, and I wanted to produce a plan. I put each task on a
TiddlyWiki tiddler, with all of its prereqs listed in a bulleted list.  The
pages contain descriptions of the tasks, links to related tasks, whatever.
It's only the bulleted lists that are special, in that they signify
dependencies -- and even that only on pages tagged with Graphable.  Some other
pages are tagged with "Goal," indicating a task that represents an end goal, as
opposed to a step toward a goal.  Others are tagged with "Unclear," because
they represend some sort of hand-wavey idea rather than something one can do in
a day or two.

Tiddlers are stored in the HTML file as `div` elements with a `tiddler`
attribue containing the name and a `tags` attribute containing the tag string.
The content of the tiddler is stored in the content of the div, with newlines
converted to the literal string "\n"

Pulling out the tiddlers I wanted was easy:  I just parsed the file with
HTML::TreeBuilder, then did a `look_down` for divs with a tiddler attribute and
a tags attribute matching something like `qr{\bGraphable\b}`.  I used those to
output lines like this:

    PageName -> NameOfPageInList

For pages with some of the other tags, I tacked on a little more information.
Fed to GraphViz, this provided me with a full-color diagram of all of the tasks
and their dependencies, including where I needed more information -- either
subtasks or better task definitions.

Total extra code for this goal?  About twenty lines of Perl.

I can't wait to apply this advanced technology to my D&D wiki.

