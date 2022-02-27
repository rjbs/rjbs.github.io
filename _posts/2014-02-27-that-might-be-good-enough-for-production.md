---
layout: post
title : "that might be good enough for production..."
date  : "2014-02-27T15:30:48Z"
tags  : ["forth", "programming"]
---
Sometimes, the example code in documentation or teaching material is really
bad.  When the code's dead wrong, that might not be the worst.  The worst may
be code that's misleading without being wrong.  The code does just what it says
it does, but it doesn't keep its concepts clear, and students get annoyed and
write frustrated blog posts.  This code might be good enough for production,
but not for pedagogy.

I'm back to learning Forth, which I'm really enjoying.  The final example in
the chapter on variables is to write a tic-tac-toe board.  (By the way, more
evidence that Forth is strange: variables aren't introduced until chapter nine,
more than halfway through the book.)

The exercise calls for the board state to be stored in a byte array,
initialized to zeroes, with `1` used for X and `-1` used for O.  I thought
nothing of this and got to work, but no matter what, when I played an "O" I
would get a "?" in my output board — an indication that my code was finding
none of -1, 0, or 1 in the byte in memory.  Why?

Well, bytes are 0 to 255, so -1 isn't a natural value, but "everybody knows"
the convention is that -1 is a way of writing 255.  I wrote this code which,
given a number on the stack, returns the character that should display it:

    : BOARD.CHAR
      DUP 0 =  IF '- ELSE
      DUP 1  = IF 'X ELSE
      DUP -1 = IF 'O ELSE '? THEN THEN THEN SWAP DROP ;

The `-1` there is a *cell* value, not a *byte* value, so on my Forth it's not
255 but 18,446,744,073,709,551,615.  Oops.

The answer should be easy:  I want a way to say `CHAR -1` or something.  We
didn't see that yet in the book.  How does the author do it?  At this point,
I'm already a little annoyed that I'm going to have to look at the author's
answer, but that's life.  My guess is that either he's using something he
didn't show us, or he's using a literal 255.

It's neither.  His factoring of the problem's a bit different, but:

    : .BOX  ( square# -- )
      SQUARE C@  DUP 0= IF  2 SPACES
          ELSE  DUP 1 = IF ." X "
                ELSE ." O "
                THEN
                THEN
      DROP ;

He totally punts!  If there's anything in a cell other than 0 or 1, he displays
an O.  Bah!

I found absolutely no value in this use of -1, so I stored all of O's moves as
2.  All tests successful.

