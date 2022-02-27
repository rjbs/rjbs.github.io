---
layout: post
title : toward a free crossword puzzler
date  : 2007-04-30T22:26:26Z
tags  : ["crossword"]
---
Recently, Daniel Jalkut was doing that thing that has, sadly, become pretty
popular in modern blogging: announcing his hot new product before telling us
what it's for.  (Did this start with Segway?  I'm sure there are some prior
examples that I can't think of.)  Anyway, it turned out to be [Black
Ink](http://www.red-sweater.com/blackink/), a really nice looking Cocoa-based
crossword puzzle program.  It started out pretty buggy, but has gotten a little
better.  It costs $25, which probably isn't too unreasonable, but I can't see
myself spending that much on a game that I'll only play now and then.

It works by downloading files from newspaper sites.  They're named things like
"Wall Street Journal (3-23-07).puz" and their contents looked pretty
straight-forward.  I found some good notes on the format compiled by [Josh
Meyer](http://www.joshisanerd.com/puz/), and that led me to produce
[Games::Crossword::Puzzle](http://search.cpan.org/dist/Games-Crossword-Puzzle),
which I used to produce a simple HTML formatted crossword template.

I'd really like to write a PUZ-to-HTML compiler to produce playable
cross-platform puzzles.  It should actually be pretty easy, although getting
the interface down will take a while of experimentation and tweaking.  I'm not
sure how I want to handle saving state.  In an ideal world, I would have
some simple way to bless the file as having permission to update a section of
itself, saving form state.  That just isn't possible.  Other solutions seem to
include compiling to Firefox chrome (John C. suggests that mere XUL will not
have useful access to Firefox's offline storage) or using Dojo Offline.

If only Curses::UI worked properly on Mac OS X, I might consider using that,
instead.

Genius-brain-inspired suggestions welcome.

