---
layout: post
title : "marrying dnd to perl"
date  : "2009-05-15T02:28:44Z"
tags  : ["dnd", "game", "perl", "programming", "rpg"]
---
I've been playing Dungeons and Dragons off and on since I was in elementary school.  I remember my brother's collection of carefully painted miniatures, although mostly I remember the ochre jelly.  I've been writing computer programs for almost as long.  Both hobbies have had large gaps in continuity, but they're still things I like and things that get a lot of my time.

Every time I try to do something to combine my programming with my RPG playing, though, it goes into the rough.  Lately, though, I've gotten a bit better at picking which RPG problems need some code.  For my previous game, I wrote a [DateTime](http://search.cpan.org/dist/DateTime) extension to deal with Standard Time, which was something like stardates, except less nebulous.

For my current game, which is a fantasy D&D campaign, I'm getting more ambitious and writing a set of calendars -- one for each of several fantasy races, of varying complexity.  I'm not yet sure that I'll even use DateTime, which is a scary prospect.  DateTime is ridiculously useful for dealing with time as kept by humans on planet Earth, but once you leave those confines, it's astounding how little it gets you!

I think I'm also finally going to finish my overhaul of Games::Dice, which I've poked at numerous times over the last few years.  I think I'm finally close to knowing how to make it really useful.

I'm also pondering whether I want to write an XML-to-Moose-Object converter for D&D 4E Character Builder files.  The rub there is that once I finished, I'd need to learn how to use a PDF generator so that I could finally start printing them.

The real weird experience, though, came when I realized that I needed to do something sufficiently complex to warrant releasing the heart of the code to the CPAN.  I can't really explain what the code is for, because it's related to things that my players haven't seen yet, but I found myself needing a very simple form of two-way area-under-function math, and wrote [Math::VarRate](http://search.cpan.org/dist/Math-VarRate/) to make it happen. It was fun, and next up I get to make it work with Math::BigFloat numbers.

In fact, that need is part of what led me to think to test for objects as hash keys in the new [tests for 5.10.1's overhauled ~~ operator](http://github.com/rjbs/perl-smartmatch-tests/blob/master/README.txt). So far, we've found a few bugs.  Anybody reading this should try to help find some more.

For now, though, I think it's time to stop thinking about D&D until my next game on Saturday.  Until then, I'll try to focus on Perl.  I've got so much to do before YAPC!  I'll have to write about all that tomorrow.
