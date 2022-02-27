---
layout: post
title : addex, mutt, and ascii
date  : 2008-04-12T23:30:58Z
tags  : ["addex", "perl", "programming"]
---
After my last set of poking at making Addex do 7-bitization of funny
characters, I did some more poking around and learned some things that helped
me get everything working just fine.  I've made a new release of Addex and the
Apple address book plugin, so now anyone can have his friend Jos&eacute; show
up with an alias of `jose` by updating his Addex config to include:

    [App::Addex::Output::Mutt]
    unidecode = 1

This replaced my lousy unicode-to-ascii conversion with Sean M. Burke's
presumably awesome Text::Unidecode.  It catches every case I caught, and
probably a lot more that I haven't had to worry about yet.  I saw the tests
spitting bizarre southeast Asian characters to the screen and was glad I never
had to think about it.

I also found out that the simple rule with Mac::Glue is that you either get
back Unicode or MacRoman.  From looking at the source, I think the Unicode will
always be in a string that `is_utf8`, so I just decode any non-`is_utf8` string
from MacRoman.

Having done that, without using Text::Unidecode, mutt was still confused.  Then
I realized that it was all my fault:  I was not setting the write filehandle to
utf8 mode, so the bytes were getting mangled.  Once I did that, the file made a
lot more sense.  Of course, it still meant that I would have to type in funny
characters if they were in the "before I hit tab to tab complete" part of a
name, so I still wanted to downgrade to the English alphabet.  Text::Unidecode
quietly replaced my code, and then I added a config option and it's done.
Anyone using Addex with contacts who have silly foreign names should update.
My mutt is a lot nicer to look at now.

