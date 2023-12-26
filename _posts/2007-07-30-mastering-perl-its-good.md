---
layout: post
title : "mastering perl: it's good"
date  : "2007-07-30T03:51:54Z"
tags  : ["books", "perl", "review"]
---
Mastering Perl is a toolbox full of very sharp tools.  I can imagine myself
presenting it to a junior co-worker, very somberly informing him, "It is time."

More likely, actually, I'd present him a few chapters ripped out of the book
and rebound.  It's not that there are chapters I object to, or that don't
matter.  It's that some of the chapters are about safety and responsibility,
while others are about wielding deadly weapons.  I want up-and-coming Perl
programmers to know about taint mode, debugging, profiling, and good code
formatting long before typeglobs, ties, or AutoSplit.  I'd divide the chapters
into "things you must learn to become a master of the language" and "things you
had better know if you want to be considered a good professional."

The chapters are not particularly cumulative, and can be read out of order.  If
you're ready for the book in general -- which basically only means
understanding the basics of packages, references, regex, objects, and closures
-- you're ready for any chapter at any time.  I read the chapters in order, and
I was glad to switch between technical and procedural topics.  It let my brain
rest a little between bouts of dense code.

My main concern is the lack of warning given on a number of tools discussed.
brian begins, in the first chapter, by saying that coverage does not mean
endorsement, but I don't think that's quite strong enough in some cases.  The
first chapter discusses some regular expression techniques, and casually
mentions using `$&`, with no mention of the long-standing performance bug this
introduces.  Maybe I'm being silly, but it seems like such an easy and
worthwhile thing to mention -- especially since the section in which `$&` is
discussed is actually about `@-`, which can be used to efficiently replace
`$&`.  (As a side note, while reading this chapter, on what was effectively the
fourth page of the book's real material, I saw `$#-` casually used in some
code.  That is when I realized that this book was not going to screw around.)

Another chapter is devoted to tied variables, which are fantastically fun, but
can also be a major source of headaches.  Maybe brian's thinking is that any
real master will be able to make his own judgement on the subject.  Still,
without an included warning about the danger of a few topics, I'll definitely
have to red ink a few margin notes on the office copy.

My worries about sharp tools, though, are far outweight by the excellent
explanations of the features covered by the book.  brian's explanation of a few
features of Perl really, really cleared a few things up for me.  I feel fairly
at home in Perl, but there are a number of features that I've always felt were
never going to stick with me, and that I'd always need to refer to the docs on.
Among these were the regex position bits (`/g`, `/c`, and `\G`), which I've
used, but always with perldoc open; also, pack, which I've only ever used in
its simplest form.  After reading the explanations of both in Mastering Perl, I
almost didn't notice that I had quietly internalized the concepts.  One of my
notes actually reads, "p219: pack: I get it now!"

I think this is because of the extremely straight-forward presentation of the
material.  It doesn't go to great lengths to create elaborate scenarios.  It
says, "Here is a feature.  This is how it works.  Here are a few examples.  Now
you understand."  brian's paragraph on pack was far, far more useful as a
learning tool than the four hundred lines of pack documentation in perldoc.
What's even better, though, is that now I can look at that perldoc and
understand everything it says quite easily.

This kind of excellent, straightfoward explanation of fairly complex topics is
present throughout the book, and is the best reason to pick it up.

Finally, I had a few typographical quibbles with the book.  There are a number
of footnotes throughout the book, and that's fine, but rather than using
numbers or sticking to a commonly-seen set of characters, the footnote markers
are unusual.  I think it progresses in each chapter: asterisk, dagger,
double-dagger, funky `||` symbol, and possibly others.  The asterisk looks
lousy and the `||` is just weird, and not immediately obvious as a footnote
marker.  I don't understand the thinking.  Much worse, though, the monospace at
sign (@) used in printing the book is from another planet.  It hardly looks
like an at sign at all.  Given the quantity of @'s seen in Perl code, this is
extremely distracting, and should really be fixed before O'Reilly prints more
Perl books.

So, I had a few concerns about journeymen programmers picking up dangerous
tools, and I didn't like the at sign.  These are pretty small concerns, in the
end, when compared with the quality of the material.  It's very clear, and
covers most of the topics I'd expect in a book like this, and covers most of
them quite thoroughly.  I'd want this on the shelf at any office that might
hire non-masters, and I'd want those employees to have their hearts set on one
day understanding everything in Mastering Perl.
