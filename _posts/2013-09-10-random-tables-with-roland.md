---
layout: post
title : "random tables with Roland"
date  : "2013-09-10T12:42:54Z"
tags  : ["dnd", "perl", "programming", "rpg"]
---
This post is tagged `programming` *and* `dnd`.  I don't get to do that often,
and I am pleased.

For quite a while, I've been using random tables to avoid responsibility for
the things that happen in my D&D games.  Instead of deciding on the events that
occur at every turn, I create tables that describe the general feeling of a
region and then let the dice decide what aspects are visible at any given
moment.  It has been extremely freeing.  There's definitely a different kind of
skill needed to get things right and to deal with what the random number gods
decide, but I really enjoy it.  Among other things, it means that I can do more
planning well in advance and have more options at any moment.  I don't need to
plan a specific adventure or module each week, but instead prepare general
ideas of regions on different scales, depending on the amount of time likely
to be spent in each place.

Initially, I put these charts in
[Numbers](https://en.wikipedia.org/wiki/Numbers_(spreadsheet)), which worked
pretty well.

<center><a href="http://www.flickr.com/photos/rjbs/9715303822/" title="Random
Encounters spreadsheet by rjbs, on Flickr"><img
src="http://farm3.staticflickr.com/2833/9715303822_1c2a6f4967_z.jpg"
width="640" height="429" alt="Random Encounters spreadsheet"></a></center>

I was happy with some stupid little gimmicks.  I color-coded tables to remind
me which dice they'd need.  The color codes matched up to colored boxes that
showed me the distribution of probability on those dice, so I could build the
tables with a bit more confidence.  It was easy, but I found myself wanting to
be able to drill further and further down.  What would happen is this:  I'd
start with an encounter table with 19 entries, using 1d20+1d8 as the number
generator.  This would do pretty well for a while, but after you've gotten
"goblin" a few times, you need more variety.  So, next up "goblin" would stop
being a result and would start being a redirection.  "Go roll on the goblin
encounter table."

As these tables multiplied, they became impossible to deal with in Numbers.
Beyond that, I wanted more detail to be readily available.  The encounter entry
might have originally been "2d4 goblins," but now I wanted it to pick between
twelve possible kinds of goblin encounters, each with their own number
appearing, hit dice, treasure types, reaction modifiers, and so on.  I'd be
flipping through pages like a lunatic.  It would have been possible to inch a
bit closer to planning the adventure by pre-rolling all the tables to set up
the encounter beforehand and fleshing it out with time to spare, but I wasn't
interested in that.  Even if I had been, it would have been a lot of boring
rolling of dice.  That's not what I want out of a D&D game.  I want *exciting*
rolling of dice!

I started a program for random encounters in the simplest way I could.  A table
might look something like this:

    type: list
    pick: 1
    items:
      - Cat
      - Dog
      - Wolf

When that table is consulted, one of its entries is picked at random, all with
equal probability.  If I wanted to stack the odds, I could put an entry in
there multiple times.  If I wanted to add new options, I'd just add them to the
list.  If I wanted to make the table more dice-like, I'd write this:

    dice: 2d4
    results:
      2: Robot
      3: Hovering Squid
      4: Goblin
      5: Weredog
      6: Quarter-giant
      7: Rival adventurers
      8: Census-taking drone

As you'd expect, it rolls 2d4 to pick from the list.

This was fine for replacing the first, very simple set of tables, but I wanted
more, and it was easy to add by making this all nest.  For example, this is a
table from my test/example files:

    dice: 1d4
    times: 2
    results:
      1: Robot
      2: Hovering Squid
      3:
        dice: 1d4
        times: 1d4
        results:
          1: Childhood friend
          2-3: Kitten
          4: Goblin
      4: Ghost

This rolls a d4 to get a result, then rolls it again for another result, and
gives both.  If either of the results is a 3, then it rolls 1-4 more times for
additional options.  The output looks like this:

    ~/code/Roland$ roland eg/dungeon/encounters-L3
    Robot
    Ghost
    ~/code/Roland$ roland eg/dungeon/encounters-L3
      Goblin
      Kitten
      Kitten
      Kitten
    ~/code/Roland$ roland eg/dungeon/encounters-L3
    Hovering Squid
      Childhood friend
      Kitten
      Goblin
      Kitten

Why are some of those things indented?  Because the whole presentation of
results stinks, because it's just good enough to get the point across.  Oh
well.

In the end, in the above examples, the final result is always a string.  This
isn't really all that useful.  There are a bunch of other kinds of results that
would be useful.  For example, when rolling for an encounter on the first level
of a dungeon, it's nice to have a result that says "actually, go roll on the
second level, because something decided to come upstairs and look around."
It's also great to be able to say, "the encounter is goblins; go use the goblin
encounter generator."

Here's a much more full-featured table:

    dice: 1d4 + 1d4
    results:
      2:  Instant death
      3:  { file: eg/dungeon/encounters-L2 }
      4:  { file: eg/monster/zombie }
      5:
        - { file: [ eg/monster/man, { num: 1 } ] }
        - { file: eg/plan }
        -
          type: list
          pick: 1
          items:
            - canal
            - creek
            - river
            - stream
        - Panama
      6:
        dice: 1d6
        results:
          1-2: Tinker
          3-4: Tailor
          5: Soldier
          6:
            type: dict
            entries:
              - Actually: Spy
              - Cover: { file: eg/job }
      7: { times: 2 }
      8: ~

(No, this is not from an actual campaign.  "Instant death" is a bit much, even
for me.)

Here, we see a few of Roland's other features.  The mapping with `file` in it
tells us to go roll the table found in another file, sometimes (as in the case
of the first result under result 5) with extra parameters.  We can mix table
types.  The top-level table is a die-rolling table, but result 5 is not.  It's
a list table, meaning we get each thing it includes.  One of those things is a
list table with a `pick` option, meaning we get that many things picked
randomly from the list.  Result 7 says "roll again on this table two more times
and keep both results."  Result 8 says, "nothing happens after all."

Result 6 under result 6 is one I've used pretty rarely.  It returns a
hash of data.  In this case, the encounter is with a spy, but he has a cover
job, found by consulting the job table.

Sometimes, in table like this, I know that I need to force a given result.  If
I haven't factored all the tables into their own results, I can pass `-m` to
Roland to tell it to let me manually pick the die results, but to let each
result have a default-random value.  If I want to force result six on the above
table, but want its details to be random, I can enter 6 manually and then hit
enter until it's done:

    ~/code/Roland$ roland -m eg/dungeon/encounters-L1
    rolling 1d4 + 1d4 for eg/dungeon/encounters-L1 [4]: 6
    rolling 1d6 for eg/dungeon/encounters-L1, result 6 [3]: 
    Tailor

Finally, there are the monster-type results.  We had this line:

    - { file: [ eg/monster/man, { num: 1 } ] }

What's in that file?

    type: monster
    name: Man
    ac: 9
    hd: 1
    mv: 120'
    attacks: 1
    damage: 1d4
    num: 2d4
    save: N
    morale: 7
    loot: ~
    alignment: Lawful
    xp-bonuses:
    description: Just this guy, you know?
    per-unit:
    - label: Is Zombie?
      dice: 1d100
      results:
        1: { replace: { file: [ eg/monster/zombie, { num: 1 } ] } }
        2: Infected
        3-100: No

In other words, it's basically a [YAML](http://yaml.org/)-ified version of a
Basic D&D monster block.  There are a few additional fields that can be put on
here, and we see some of them.  For example, `per-unit` can decorate each unit.
(We're expecting 2d4 men, because of the `num` field, but if you look up at the
previous encounter table, you'll see that we can override this to do things
like force an encounter with a single creature.)  In this case, we'll get a
bunch of men, some of whom may be infected or zombified.

Not every value is treated the same way.  The number encountered is rolled and
used to generate units, and the `hd` value is used to produce hit points for
each one.  Even though it looks like a dice specification, `damage` is left
verbatim, since it will get rolled during combat.  It's all a bit too
special-casey for my tastes, but it works, and that's what matters.

    ~/code/Roland$ roland eg/monster/man

    Man (wandering)
      No. Appearing: 5
      Hit Dice: 1
      Stats: [ AC 9, Mv 120', Dmg 1d4 ]
      Total XP: 50 (5 x 10 xp)
    - Hit points: 6
      Is Zombie?: No
    - Hit points: 1
      Is Zombie?: No
    - Hit points: 2
      Is Zombie?: No
    - Hit points: 5
      Is Zombie?: No
    - Hit points: 5
      Is Zombie?: Infected

(Notice the "wandering" up top?  You can specify different bits of stats for
encountered-in-lair, as described in the old monster blocks.)

In the encounter we just rolled, there were no zombies.  If there had been,
this line would've come into play:

    1: { replace: { file: [ eg/monster/zombie, { num: 1 } ] } }

This replaces the unit with the results of that roll.  Let's force the issue:

    ~/code/Roland$ roland -m eg/monster/man
    rolling 2d4 for number of Man [5]: 4
    rolling 1d8 for Man #1 hp [7]: 
    rolling 1d100 for unit-extra::Is Zombie? [38]: 1
    rolling 2d8 for Zombie #1 hp [4]: 
    rolling 1d8 for Man #2 hp [8]: 
    rolling 1d100 for unit-extra::Is Zombie? [10]: 
    rolling 1d8 for Man #3 hp [7]: 
    rolling 1d100 for unit-extra::Is Zombie? [90]: 
    rolling 1d8 for Man #4 hp [2]: 
    rolling 1d100 for unit-extra::Is Zombie? [13]: 

    Man (wandering)
      No. Appearing: 3
      Hit Dice: 1
      Stats: [ AC 9, Mv 120', Dmg 1d4 ]
      Total XP: 30 (3 x 10 xp)
    - Hit points: 8
      Is Zombie?: No
    - Hit points: 7
      Is Zombie?: No
    - Hit points: 2
      Is Zombie?: No


    Zombie (wandering)
      No. Appearing: 1
      Hit Dice: 2
      Stats: [ AC 7, Mv 90', Dmg 1d6 ]
      Total XP: 20 (1 x 20 xp)
    - Hit points: 4

Note that I only supplied overrides for two of the rolls.

You can specify encounter extras, which act like per-unit extras, but for the
whole group:

    extras:
      Hug Price:
        dice: 1d10
        results:
          1-9: Free
          10:  10 cp

Finally, sometimes one kind of encounter implies another:

    extras:
      Monolith?:
        dice: 1d10
        results:
          1-9: ~
          10:  { append: Monolith }

Here, one time out of ten, roboelfs are encountered with a Monolith.  That
could've been a redirect to describe a monolith, but for now I've just used a
string.  Later, I can write up a monolith table using whatever form I want.
(Most likely, this kind of thing would become a `dict` with different
properties all having embedded subtables.)

Right now, I'm really happy with Roland.  Even though it's sort of a mess on
many levels, it's good enough to let me get the job done.  I think the problem
I'm trying to solve is inherently wobbly, and trying to have an extremely
robust model for it is going to be a big pain.  Even though it goes against my
impulses, I'm trying to leave things sort of a mess so that I can keep up with
my real goal: making cool random tables.

[Roland is on GitHub.](https://github.com/rjbs/Roland)

