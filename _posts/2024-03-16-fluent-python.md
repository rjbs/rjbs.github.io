---
layout: post
title : "I read Fluent Python"
date  : "2024-02-18T19:04:00Z"
image : /assets/2024/03/fluent-python.jpg
---

Almost a year ago, I started reading Fluent Python.  I finished it yesterday,
and I have to say, it was *great*.  With a few big breaks for various
uninteresting reasons, I read a chapter or two each weekend.  It's one of the
best technical books I've read in years, and I think it's going to
significantly improve my use of Python.

![the book cover](/assets/2024/03/fluent-python.jpg)

In some ways, I was an ideal audience for this book, so of course I liked it.
I don't think the things that made us a good match are too unusual, though.  I
think there are plenty of other people who use Python fairly casually, and who
could benefit from getting a much firmer grasp on the language.  That's what
this book is about.  It doesn't teach you how to write basic Python programs or
how to stand up a simple web service.  It assumes you know that stuff.

This is good.  If you want to write serious Python code, but don't know Python
at all, you can get up to speed very quckly.  If you're an experienced Perl,
Ruby, or JavaScript programmer, you can start write reasonably useful and
maintainable Python easily.  I don't know how many pages of tutorial you need,
but it's not the 1,600 pages of _Learning Python_.  (I should note that I read
Learning Python years ago, in a previous edition.  It was a pretty good book,
but as with many "Learn Blub" books, it spent a lot of pages on things an
experienced programmer in another language knows, or can pick up quickly.)

Learning how to write a function, use a dict, build a class… these are all easy
to pick up, and that's one of the nice things about Python.  Doing so, though,
we're often learning just the surface of how things work.  This is *good!*
Larry Wall talked about the important of being able to express yourself before
you learned the whole language.  You start talking in baby talk, and eventually
you do grown-up talk.

This book starts off saying, "Okay, look, you know what arrays and tuples and
dicts are.  Now I am going to explain, in depth, the abstract interfaces on
which they're built.  Then, how to leverage those interfaces for better
results.  Then, how to built your own container types."

It explains the common decorators you've seen a hundred times, but it explains
*exactly* how they work, down to the quirks of Python's class and instance
attribute semantics.  It explains typing, in great depth.  This means the
new(ish) type hint system, but also classes, subclasses, virtual subclasses,
ABCs, and named protocols.  Dozens of examples are given, maybe hundreds, and
they're all concrete, useful examples.

I think the book can probably be read out of order, but in order, the chapters
build on one another remarkably well.  Functions are discussed early, but we
come back to them for decorators, then for inheritance, then for generators,
then coroutines.

The book covers concurrency, not to show you how to make two functions share
time, but to show you how to use threads, how to use coroutines, the primitives
they're built on, and importantly, *how they can interoperate coherently*.
It's not giving you vocational training on how to get the job done.  It's
giving you a deep explanation of numerous concepts in Python.

Unsurprisingly, some of my favorite parts of this book were in Part Ⅴ:
Metaprogramming.  I've done a bit of metaprogramming, both in Python and
elsewhere.  It's a technique I find really rewarding, but it's very difficult
to get right, and it's rarely needed.  Still, the book gave three chapters to
the topic.  Two of them gave me a much firmer grasp of things sort of knew:
properties and metaclasses.  The third (though it came between those two) was
descriptors.  I knew descriptors were a thing that existed, but I never
understood them.  Now I think I understand them fairly deeply.  Also, after
twenty years very occasionally writing Python, I was deeply gratified, through
that chapter, to finally understand how bound methods are actually generated!

The class metaprogramming chapter — the last chapter in the book — provides a
thorough and (I thought) clear explanation of what a metaclass *is*.  In giving
tutorials on metaprogramming, this was always a bit tricky to get across.

I realize that this post is mostly gushing and not much substance.  I'm okay
with that.  All I'm saying is: this book give a deep explanations of many
Python features or concepts that you might otherwise be content to just sorta
*use*.  That's my kind of book.
