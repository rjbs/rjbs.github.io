---
layout: post
title : Dist::Zilla is for lovers
date  : 2014-01-25T16:21:34Z
tags  : ["perl"]
---
I don't like getting into the occasional arguments about whether Dist::Zilla is a
bad thing or not.  Tempers often seem to run strangly high around this point,
and my position should, at least along some axes, be implicitly clear.  I wrote
it and I still use it and I still find it to have been worth the relatively
limited time I spent doing it.  Nonetheless, as David Golden said, "Dist::Zilla
seems to rub some people wrong way."  These people complain, either politely
or not, and that rubs people who are using Dist::Zilla the wrong way, and as
people get irritated with one another, their arguments become oversimplified.
"What you're doing shows that you don't care about users!" or "Users aren't
inconvenienced at all because there are instructions in the repo!" or some
other bad over-distillation.

The most important thing I've ever said on this front, or probably ever will,
is that Dist::Zilla is a tool for adjusting the trade-offs in maintaining
software projects.  In many ways, it was born as a replacement for
Module::Install, which was the same sort of thing, adjusting trade-offs from
the baseline of ExtUtils::MakeMaker.  I didn't like either of those, so I built
something that could make things easier for me without making install-time
weird or problematic.  This meant that contributing to my repository would get
weird or problematic for some people.  That was obvious, and it was something I
weighed and thought about and decided I was okay with.  It also meant, for me,
that if somebody wanted to contribute and was confused, it would be up to me to
help them, because I wanted, personally, to make them feel like I was
interested in working with them¹.  At any rate, *of course* it's one more thing
to know, to know what the heck to do when you look at a git repository and see
no Makefile.PL or Build.PL, and having to know one more thing is a drag.
Dist::Zilla imposes that drag on outsiders (at least in its most common
configurations), and it has to be used with that in mind.

Another thing I've often said is that Dist::Zilla is something to be used
thoughtfully.  If it was a physical tool, it would be yellow with black
stripes, with a big high voltage glyph on it.  It's a force multiplier, and it
lets you multiply all kinds of force, even force applied in the wrong
direction.  You have to aim really carefully before pulling the trigger, or
you might shoot quite a lot of feet, a surprising number of which will belong
to you.

If everybody who was using Dist::Zilla thought carefully about the ways that
it's shifting around who gets inconvenienced by what, I like to imagine that
there would be inconsiderate fewer straw man arguments about how nobody's
really being inconvenienced.  Similarly, if everybody who felt inconvenienced
by an author's choice in built tools started from the idea that the author has
written and given away their software to try and help other users, there might
be fewer ungracious complaints that the author's behavior is antisocial and
hostile.

Hopefully my next post will be about some fun code or maybe D&D.

1: My big failure on this front, I think, is replying promptly, rather than not
being a big jerk.  I must improve, I must improve, I must improve...

