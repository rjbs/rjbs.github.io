---
layout: post
title : "if you only read one blog post about the upcoming perl 5.18.0..."
date  : "2012-12-05T15:39:30Z"
tags  : ["perl", "programming"]
---
...it probably shouldn't be this one.  Instead, go read [Breno G. de Oliveira's
piece on hash
randomization](http://onionstand.blogspot.com.br/2012/12/are-you-relying-on-hash-keys-being.html).

There are lots of important changes in 5.17 right now, and there may be some
more between now and 5.18.0, which is due in Spring 2013.  The one that you
need to care about right now, though, is the change hash randomization.  The
changes to hash randomization are still themselves changing, but the bottom
line is this:  **The order of things coming out of hashes is going to seem more
random.**

It's a pretty common mistake to believe that hash ordering is in some way
deterministic.  The best guarantee you get from `perl` is that if you call
`keys` and `values` on a hash, the results correlate with one another.  Relying
on any more ordering than that is a bug.

The changes in 5.18.0 will expose these bugs where they had been hidden before.

So, rather than restate the things that Breno said so well, I will once again
tell you:  Go read [Breno's
post](http://onionstand.blogspot.com.br/2012/12/are-you-relying-on-hash-keys-being.html).

If you want to be *really* helpful, you could look at the [list of CPAN
distributions affected by this
change](https://rt.perl.org/rt3/Public/Bug/Display.html?id=115908) and help
make sure they are patched before 5.18.0 arrives.  Heck, maybe your own code is
in there.

