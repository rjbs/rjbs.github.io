---
layout: post
title : "python programmers unbellyfeel oldcode"
date  : "2006-03-29T03:32:09Z"
tags  : ["programming", "python"]
---
I just love [this blog
entry](http://www.artima.com/weblogs/viewpost.jsp?thread=98196) from Guido.
It's just about a year old now -- it was resent verbatim (replacing Python with
Scheme) to some Scheme lists as an April Fool's joke.  Guido is talking about
how he'd like to drop filter, reduce, and map.  He says:

> I think having the two choices side-by-side just requires programmers to
> think about making a choice that's irrelevant for their program; not having
> the choice streamlines the thought process.

He's talking about how nested functions can substitute for lambdas.  In other
words, he wants to make it even less possible to have something like anonymous
code blocks in Python.  See, removing those function applicators will help make
that decision seem reasonable:

> Also, once map(), filter() and reduce() are gone, there aren't a whole lot of
> places where you really need to write very short local functions; Tkinter
> callbacks come to mind, but I find that more often than not the callbacks
> should be methods of some state-carrying object anyway (the exception being
> toy programs).

Right.  If you ever want a closure, you probably want an object.  Right?

Anyway, it makes the language clearer.  He writes:

> `filter(P, S)` is almost always written clearer as `[x for x in S if P(x)]`

I just don't understand the audience.

