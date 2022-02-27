---
layout: post
title : my own templating engine
date  : 2005-12-11T03:46:05Z
tags  : ["perl", "programming"]
---
It had to happen eventually, didn't it?

I guess I've written templating things before, but not many and not complicated.  jGal, my lousy image gallery generator does some find-and-replace, although it inherited that from iGal.  I've probably written template-like things elsewhere without thinking about it, too.

Now, though, I did it on purpose and even released it.  I was tempted to call it Template::Sorry -- it's a sorry excuse for a templating system, and I'm sorry to inflict another one on the CPAN.

I'm not really sorry, though.  It's different than the rest, despite being similar to a few.

I needed to write it for work, to replace an existing, similar system that wasn't quite flexible enough for what I wanted to make it do.  I figured it would be pretty simple to fix in situ, but it wasn't.  I thought about what I wanted, wrote some tests, wrote some code, and felt really good about it.  Then I wrote some more tess, built an adapter, put it in place, watched the tests pass, and felt even better.

I deployed it to production, feeling really good about it, and within a few minutes one of my orkers asked, "Why is $SERVER swapping like crazy?"

Well, it turns out that perl 5.6.1 just really didn't like what I was doing.  I was returning a closure with an enclosed closure.  This seems perfectly reasonable to me, and did exactly what I wanted.  Unfortunately, that seemed to leak memory very, very quickly.  Just building and throwing away 100,000 empty macro expanders took up 125 megabytes of RAM in a few seconds.  For long-running processes with non-empty expanders, this was not promising.

I sulked about it for a while, because I really didn't want to change my implementation, which I liked.  Today I relaxed, played Disgaia, and baked and distributed some (delicious) cookies with Gloria.  Then, after dinner, dessert, and some DVDs, I put together a subclass that was less elegant, but didn't leak memory on 5.6.  Tests passed, memory didn't leak, and I was ecstatic.

Fixing something broken is just a really, really good feeling.  I'm glad that now and again I have the chance to experience it.

Macro::Micro is on a CPAN mirror near you!  (You'll want 0.03 if you're running 5.6 (and if you actually have use for the little beastie).) 
