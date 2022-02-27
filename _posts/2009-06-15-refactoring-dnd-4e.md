---
layout: post
title : refactoring dnd 4e
date  : 2009-06-15T14:46:57Z
tags  : ["dnd", "game", "rpg"]
---
I'm trying to keep up to date with what's going on in the Dungeons & Dragons
world.  I think the fourth edition rules are nice and easy to use.  On those
occasions where I encounter a rule I don't know well, I can guess and when I
look into the rules later, it usually ends up being easy to remember for next
time.  I'm looking forward to seeing the new rules for psionics.  I like the
stuff they're doing with hybrid classes to introduce something more like old
style multiclassing.

That said, I still think that 4E is very different from what I want out of a
ruleset.  It all comes down to the order of organization at which genericity is
applied.  D&D 4E has a number of core concepts that are used all throughout the
game to do just about everything.  There's the "core mechanic" that's used to
determine most events' outcomes.  There's the combat round, the defense system,
and effect keywords.  These are simple, universal concepts that show up all
over the rules to make the game easy to learn.

The next level of specifics are almost entirely limited to special abilities:
some class features, powers, and monster abilities.  This is what I'd like to
refactor.

Imagine that I wanted to introduce a new kind of character to my campaign.
Right now, I might do that by creating a new class.  Creating a new class,
though, means creating new powers.  Classes in the PHB have about fifteen pages
of powers each, so that's a huge amount of work.  The powers have to be
playtested, considered for balance, and so on.  It's a massive amount of work,
almost certainly beyond what any Dungeon Master will do.  Other than that, what
can be done?  Well, there's always rebranding.  That is: we'll call your
character a hybrid rogue-warlock but replace "Arcane" with "Divine" and
"Martial" with "Primal" and change the name and flavor text of your powers.
This is a great solution, and very easy -- as long as you can accurately
describe the new class as a hybrid of two others.  This is probably
increasingly likely as more core classes are added.  It also means more and
more powers are being added to the game, which really reduces what remains of
the "hold the whole game in your head" simplicity we had in some very early
editions.

For example, I recently read some comments about how original Dungeons &
Dragons, as typified by the [Rules
Cyclopedia](http://en.wikipedia.org/wiki/Rules_Cyclopedia), was an incredibly
simple game, easy to learn, easy to run, and lots of fun.  I looked over a
copy, and while it's clearly simple, it's not very flexible.  It has nine
classes (each of which is both a class and a race), and each class has its own
kind of rules.  In other words, there is no generic powers system.  You can't
hybridize classes.  So, "OD&D" is great if you want to run a game set in
Mystara or Greyhawk.

There was another game that I liked, which had very, very simple rules.  It's
been years since I played it, so I may have forgotten some of them, but I think
I could remember nearly all of them enough to write them down.  I could
certainly sit down and start playing now without being confused or needing
review.  The game had lots of splat books, but none of them really added new
rules beyond minor tweaks or flavor.  The basic rules perfectly covered the
whole system.

The game was [Mage: the
Ascension](http://en.wikipedia.org/wiki/Mage:_the_Ascension).  It was one of
the original "World of Darkness" games, so it used the Storyteller System (aka
"the d10 system").  In some ways, it was like 4E: there was a fixed set of
attributes and skills, and they were used together to accomplish nearly
everything -- apart from the application of powers.

Powers were entirely defined by the Spheres.  There were nine spheres, each
dealing with some broad domain like "life" or "position in space" or
"consciousness."  Each sphere was ranked from zero to ten (although in practice
this was really from zero to five) and each achieved rank granted broad powers.
For example, "Matter 3" allowed the user to create matter.  The amount of
matter that could be created was related to the core d10 mechanic.

Absolutely every magical effect could be reduced to a set of sphere values.
Anything else could be resolved with the skill system.  Because the Sphere
system covered combat as well as non-combat applications of magic, it was much
more generically useful.  (I will restate, but not elaborate, at this point on
my complaint that 4E rogues are more like ninjas than burglars.)

I know that rules systems are built to reinforce the flavor of the game that
one wants to run, and that highly generic game systems can be bland and boring.
Mage's system was fantastic for Mage, but would be bizarre and horrible for
D&D.  I wonder, though, whether D&D could be adapted to use a system *like*
Mage's.  There might be more than nine core power stats.  Maybe more would be
added later.  (This would have been absurd in Mage.)  Classes could become
optional -- collections of flavor text and ideas for using powers, or possibly
granting bonuses for certain types of power.  It would be possible to have an
entirely free collection of powers and keywords, up to the discretion of the
DM.  Some Dungeon Masters will allow you to have both "Melee Combat" and
"Abjuration" and some will not.

So far, I have been able to do what I want by hybridizing and rebranding
classes.  I've been just slightly wary of this as I've produced a
Divine-sourced Invoker/Warlock, because "normal" combinations are presumably
playtested -- along with their huge list of powers -- but my tweaks are not.  A
metapowers system would provide more built-in balance.

Maybe someday I'll take some time to sketch out a generic metaclass system for
D&D.  For now, I'll just try to keep myself one adventure ahead of the party.

