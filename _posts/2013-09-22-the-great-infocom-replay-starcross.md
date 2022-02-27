---
layout: post
title : The Great Infocom Replay: Starcross
date  : 2013-09-22T23:51:31Z
tags  : ["games", "infocom-replay", "int-fiction"]
---
Having finished the Zork trilogy, it was time for me to continue on into the
great post-Zork canon.  I was excited for this, because it means lots of games
that I haven't played yet.  First up:  Starcross.  I was especially excited for
Starcross!  It's the first of Infocom's sci-fi games, and I only remembered
hearing good things.  I'd meant to get started on the flight to YAPC::Asia, but
didn't manage until I'd begun coming home.  On the train to Narita, things got
off to a weird start.

First, I realized I needed to consult the game's manual to get started.  I'm
not sure if this was done for fun or as copy protection, but fortunately I had
a scan of the file I needed.  After getting into the meat of the game, it was
time to get mapping.  Mapping Starcross took a while to get right, but it was
fun.  The game takes place on a huge space station, a rotating cylinder, in
which some of the hallways are endless rings.  I liked the idea, but I think
that up/down, port/starboard, and fore/aft were used in a pretty confusing way.
I'm not sure the map really made sense, but was a nice change of pace without
being totally incomprehensible.

The game's puzzles had a lot going for them.  It was clear when there was a
puzzle to solve, and it was often clear what had to be done, but not quite how.
Some objects had multiple uses, and some puzzles had multiple solutions.
Unfortunately, it has a *ton* of the classic text adventure problems, and they
drained the fun from the game at nearly every turn.

The game can silently enter unwinnable state, which you don't work out until
you can't solve the next puzzle.  (It occurs to me that an interpreter with its
own `UNDO` would be a big help here, since I don't save enough.)

There are tasks that need to be repeated, despite appearances.  Something like
this happens:

    > SEARCH CONTAINER
    You root around but don't find anything.

    > SEARCH CONTAINER
    You still don't find anything.

    > SEARCH CONTAINER
    Hey, look, a vital object for solving the game!
    [ Your score has gone up 25 points. ]

…and my head explodes.

There are guess-the-verb puzzles, which far too often have as the "right" verb
a really strange option.  For example, there's a long-dead spaceman, now just a
skeleton in a space suit.

    > LOOK IN SUIT
    It's a space suit with a dead alien in it.

    > SEARCH SKELETON
    You don't see anything special.

    > EXAMINE SKELETON
    It sure is dead.

    > TOUCH SKELETON
    Something falls out of the sleeve of the suit!

Argh!

There's a "thief" character that picks up objects and moves them around.  It's
used to good effect (as was the thief in Zork Ⅰ) but it wastes time.  Wasting
time wouldn't be a problem, if there wasn't a part of a time limit built into
the game.  The time limit can be worked around, but it means you need to play
the game in the right order, which might mean going back to an early save once
you work that out.  (Why is it that I love figuring out the best play order in
Suspended, but not anything else?)  Even *that* wouldn't be so bad, in part
because I happily I had started by solving a number of puzzles that can be
solved in any order, but there was a problem.  Most of the game's puzzles
center around collecting keys, so by the end of the game you're carrying a
bunch of keys, not to mention a few objects key to getting the remaining keys…
and there's an inventory limit.  It's not even a *good* inventory limit, where
the game just says "you can't carry anything more."  Instead, it's the kind
where, when you're carrying too much, you start dropping random things.

Argh!

It did lead to one amusing thing, at least, when I tried to pick up a key and
accidentally dropped the space suit I was wearing.

Still, the game is good.  I particularly like the representational puzzles,
like the solar system and repair room.  Its prose is good, but neither as
economical as earlier games nor as rich as later ones, making it inferior to
both.  As in earlier games, I'm frustrated by the number of things mentioned
but not examinable.  Getting "I don't know that word [which I just used]" is
worse than "you won't need to refer to that."  I'm hoping that the larger
dictionaries of v5 games will allow for better messages like that.  I've got a
good dozen games until I get to those, though.

Next up will be Suspended.  I'm not sure how that will go, since I've played
that game many times every year for the past decade or so.  After that, The
Witness, about which I know nearly nothing!

