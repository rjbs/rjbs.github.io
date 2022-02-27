---
layout: post
title : perlish testing in python
date  : 2005-08-10T01:47:00Z
tags  : ["programming", "python"]
---
I am not a Python programmer.  I don't do much work at all in Python.  (It is almost entirely accurate to say that I do not use Python at all.)  I haven't tried their test systems, which seem sort of OK.  One is jUnit.  The other sounds neater: you provide a transcript of an interactive Python session, which the test framework tries to reproduce.

I just thought it would be fun to produce <a href='http://rjbs.manxome.org/hacks/python/TAP.py'>TAP in Python</a>.  It's got some issues, but not many, and basically works.  It's super-simple because it isn't thread safe -- and I have no interest in making it so.

I had some fun writing it, and even found a nice little bug in Test::Builder while doing it.  In talking to Schwern about the bug, I learned about the refactoring Schwern and chromatic were working on, and stole those ideas.  (I think I also contributed one back, so I don't feel too thiefly.)

So, my library provides TAP.Builder, which is very similar to Test::Builder. It doesn't deal with exporting at all, because that's all different in Python. I also implemented Test::More, but it sucked.  To write a useful Test::More equivalent, I need to use Python more so that I understand the useful things to provide, and how to do so properly.

Writing this reminded me of two things: (1) Python isn't as annoyance-ridden as I sometimes thing and (2) Python's actual annoyances are incredibly annoying. I long for anonymous functions, useful destructors, and interpolation (not template strings).  Still, I had fun. 
