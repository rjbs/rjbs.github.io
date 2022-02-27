---
layout: post
title : how 2SWAP works
date  : 2011-07-22T15:01:11Z
tags  : ["forth", "programming"]
---
I'm learning Forth.  So far, so good.  Even if I don't end up using it for
much, maybe it will make me a better
[dc](http://en.wikipedia.org/wiki/Dc_%28computer_program%29) user.

Anyway, I'm using the much-praised book "[Starting
Forth](http://www.forth.com/starting-forth)" by Leo Brodie, which I picked up
used a few months ago.  For the most part, I like it, but I its explanation of
the "double" stack manipulators is terrible.

Earlier in the book, you've learned about these operators:

    DUP   - duplicate the top number on the stack
    SWAP  - swap the top 2 number on the stack
    OVER  - copy the 2nd number down the stack to the top
            (i.e., given (a b c) you end up with (a b c b))
    DROP  - discard the top number on the stack

Later, variants are described:

    2DUP   - duplicate the top 2 pairs of numbers on the stack
    2SWAP  - swap the top pair of numbers on the stack
    2OVER  - copy the 2nd pair of numbers down the stack to the top
    2DROP  - discard the top pair of numbers on the stack

This would be all be pretty clear with examples, but instead we get the "stack
notation," which is something like a function signature.  For example:

    SWAP    ( n1 n2 -- n2 n1 )
    2SWAP   ( d1 d2 -- d2 d1 )

This is not at *all* what I would expect.  Does `d` mean "pair of numbers" or
something?  Well:

    The prefix "2" indicates that these stack manipulation operators handle
    numbers in pairs. The letter "d" in the stack effects column stands for
    "double." "Double" has a special significance that we will discuss when we
    talk about "n" and "u."

Depending on how much C you know, you are either more or less confused by this
explanation.  If you're only learning to program from this book (which is
supposed to be possible), you are probably totally lost.  `n`, we have been
told, means single-length numbers, and `d` is for double-length numbers.  The
`2SWAP` word swaps two pairs of numbers -- by which they implicitly mean
single-length numbers -- but it can also swap two (non-pairs of) double-length
numbers. The printed book explains in a footnote that single-length numbers
range from -32K to 32K and the website has replaced that range with -2e9 to
2e9.

To understand what's really going on, if you don't know how numeric
representation works, you need some examples, and probably a quick explanation
of how an integer and double differ and are stored on the stack.  Instead, you
get this line:

    The "2"-manipulators listed above are so straightforward, we won't even
    bore you with examples.

Wow.  That lack of examples cost me plenty of time.  (The [Gforth Manual's
tutorial](http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Stack-Manipulation-Tutorial.html#Stack-Manipulation-Tutorial)
isn't much better.)  The closest to an example we get is this exercise:

> **Exercise 2-1**
>
> Q: *What's the difference between DUP DUP and 2DUP?*
>
> A:<br />
>     DUP DUP: (1 2 -- 1 2 2 2)<br />
>     2DUP:    (1 2 -- 1 2 1 2)
>

So, how does `2SWAP` work?  Well, your stack is a sequence of memory, divided
up into units.  One unit is big enough to store a single-width number.  `SWAP`
swaps the top two units, which will reverse the position of two single-width
numbers, or mangle anything else.  `2SWAP` does the same thing, but acts on
regions twice as big.  One of the book's many cartoons could have illustrated
this nicely:  two pairs of single-width numbers would be reversed, or two
double-width numbers.  Again, anything else would be likely to be mangled.

I think the real problem is avoiding discussing memory or representation in
memory.  Without understanding these concepts, Forth does not seem like a
language one can learn easily.  It's the same problem you see with people
learning Git who haven't learned how commits form graphs.  If that isn't
explained early, everything else is a mystery.

Now, back to learning Forth.

