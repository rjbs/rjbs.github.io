---
layout: post
title : "string truncate: now with word boundaries"
date  : "2007-07-23T22:16:30Z"
tags  : ["perl", "programming"]
---
Since roughly forever ago, I've meant to give String::Truncate the ability to try to truncate a string at word boundary.  Done!  That is, instead of turning "This is your brain on drugs." into "This is your br..." it can now return "This is your...".

This is one of those cases where my desire for the feature wasn't quite sufficient to get me to implement it.  Sure, I wanted it now and then, but I didn't feel like writing tests or code for it.  In these cases, what usually motivates me is pride:  I find some other code that does what I want, but is otherwise inferior or, equally likely, just bugs me in its interface.

It turns out that this feature took no time at all -- not surprisingly, I guess.  What I like about String::Truncate is that it focuses on making the not-quite-simple cases as easy as the simple ones, so that I can do what I really want, not just what's easy, without having to care.  I need to write more code like that. 
