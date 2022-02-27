---
layout: post
title : acrossdown crossword rebus format
date  : 2007-08-26T15:43:15Z
tags  : ["crossword", "perl", "programming"]
---
A few months ago, I wrote [a crossword puzzle
library](http://search.cpan.org/dist/Games-Crossword-Puzzle) for reading
"Across&Down" format .puz files.  It's fine, and the features I wanted to add
to the library really don't matter too much to using it.

There's a feature I'd really like to add, though, and that's support for
"rebus" puzzles.  That's when you have something weird in a box, like a bunch
of letters.  You might have the following:

    S?E
     T
     E
    ?RY

Where each `?` is actually filled in with "QUAR."  The Thursday puzzles in the
New York Times tend to do this.  I have a sample file, but I don't think I'm
free to redistribute it openly.  Some parts of the format are pretty clear.
There's a chunk that says "the following are the weird values: QUAR," and
there's a chunk that says "weird value 1 appears at these locations," but I'm
mostly not sure how to reliably find the beginning of these sections.  I think
I need to build up a small corpus of sample files, then work from there.  If I
can't find any, I can always buy the builder and use it to build sample files.

This is largely for the fun of it.  Gloria bought me a copy of Black Ink, so
I'm in less of a hurry to write my once-considered puz-to-dhtml compiler.

