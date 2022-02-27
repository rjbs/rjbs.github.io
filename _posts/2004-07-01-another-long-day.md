---
layout: post
title : "another long day"
date  : "2004-07-01T03:23:00Z"
tags  : ["perl"]
---
The layoffs continue.  A problem with shift work is that it takes time to get through a round of layoffs.  They should be done by now, though.  Maybe I'll look into things before I go to bed.

I didn't get a lot of work done.  It's always hard to focus while things like this go on.  Still, I was pretty busy, considering!  I did a smidgen more work on Epitaxy::Substrate, but nothing really useful.  Instead, I got started on Number::Tolerant, which I'll be putting on the CPAN soonish.  It creates an object that is overloaded to act like a number, but the number represents a number with a tolerance.  So, the number (5 ± 1) is less than 7, equal to 4.3, and not greater than 4.9.

I'm happy with it.  There are a number of ways to specify ranges, and tomorrow I'm going to try to make them and-able, so a bitwise and creates their intersecting range as a tolerant number.  I was thinking about supporting some basic math, but it will be too hard and not very useful.  So, KISS.

One hundred tests passing is good for an evening's work, I think.  Yeah, I should admit: a lot of this code was written this evening, not at work.

So, what was I busy with at work?  Well, I helped Calvin refactor some code, explaining references (barely) as I went.  We had a meeting in which I got to hear about more finance reporting stuff that made me grumble.  I know there was more, but I'm too tired to recall the tawdry details.

I did some cycling after work, which was good except for going through some nettles.  Gloria and I had awesome fake chicken nuggets for dinner, with lima beans (also tasty) and buffalo sauce.  We watched some Farscape.

That's about it for my day.

Oh, and one other thing.  For some reason my journal on use.perl.org keeps looking like it's not allowing comments.  I don't know what's up.  When I edit my entries, they say comments are OK.  I need to harass pudge.  Thanks to Geoff Y. for pointing this out!
