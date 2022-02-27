---
layout: post
title : "I'm learning Rust!"
date  : "2016-10-16T02:45:11Z"
tags  : ["programming", "rust"]
---
I've been meaning to learn Rust for a long time.  I read [the
book](https://doc.rust-lang.org/book/) a while ago, and did some trivial
exercises, but I didn't write any real programs.  This is a pretty common
problem for me:  I learn the basics of a language, but don't put it to any real
use.  Writing [my stupid 24 game solver in
Forth](https://rjbs.manxome.org/rubric/entry/2102) definitely helped me think
about writing real Forth programs, even if it was just a goof.

Now I'm working on implementing the [Software Tools](http://amzn.to/2edFnB4)
programs in Rust.  These are simple programs that solve real world problems, or
at least approximations of real world problems.  I've written programs to copy
files, expand and collapse tabs, count words, and compress files.  So far, all
[my programs](https://github.com/rjbs/Sweater) are pretty obviously mediocre,
even to me, but I'm having fun and definitely learning a lot.  At first, I
thought I'd be working my way through the book program by program, but now I
realize that I'm going to continually going back to earlier work to improve it
with the things I'm learning as I go.

For example, I sarted off by buffering all my I/O manually, which worked, but
made everything I did a bit gross to look at.  Later, I found that you can wrap
a thing that reads from a file (or other data source) in something that buffers
it but then provides the same interface.  I went back and added that to my old
programs, deleting a bunch of code.

Soon, I know i'm going to be going back to add better command line argument
handlng.  I'm pretty sure my error handling is all garbage, too.

Still, the general concept has been a great success:  I'm writing programs that
actually do stuff, and they have fun edge cases, and it's just a lot less
tedious than exercises in a text book.

So far, so good!

