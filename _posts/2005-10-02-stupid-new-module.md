---
layout: post
title : "stupid new module"
date  : "2005-10-02T04:46:38Z"
tags  : ["perl", "programming"]
---
On #perl today, Jesse was asking about a module to convert binary data into a string using only explicitly permitted characters.  This was a problem I encountered a year or two ago when trying to use MD5 sums as worksheet names in Excel.  Excel has some weird subset of Latin-1 as valid characters in worksheet names.  Unfortunately, when I went to pull up the code, I found that the only revision I took with me from IQE was missing most of that code (which I had replaced with something simpler).

Anyway, I said something like, "It's really trivial, it's just a simple matter of programming," to which Jesse replied, "I'd love to see it on the CPAN." (Actually, I think he is part of the majority that doesn't use the "the" in "the CPAN.")  It seemed like a fun little distraction, so I sat down after dinner and busted out Number::Nary.  To be fair, it doesn't work on arbitrary bitstrings.  It wants a numeric value.  It's easy enough to get from a bistring to a number, though.

Wait, it is, right?  I know this is one of those pack/unpack things, but I think that pack is the part of Perl that I have managed to avoid the most. I've done socket IO, I've done forking, and I've skirted around the edges of threading.  I've just never touched pack, and I feel like learning how to use it would break my head.  That's fine, though.  I wrote Number::Nary just for fun, not to get anything specific done.  I'm sure not going to be generating Excel worksheet names again any time soon. 
