---
layout: post
title : "The Great Infocom Replay: Sorcerer"
date  : "2024-01-24T08:50:24Z"
tags  : ["games", "infocom-replay", "int-fiction"]
---
After over eight years on hiatus, [The Great Infocom
Replay](https://rjbs.cloud/blog/2013/02/the-great-infocom-replay-foreword/) is
back!

I've been feeling sort of generally at loose ends of late, and a while ago I
went through my list of unfinished projects to see what might be inspiring.
There was definitely stuff that I would like doing *in theory*, but the jury is
out on whether I'll follow through and love it.  On the other hand, the Great
Infocom Replay seemed like something that would be fun, not too taxing, and
that I'd feel good about doing.

I looked at, and lamented, the state of Z-Machine interpreters for macOS,
shrugged, and got to work.  (I started on Frotz, my old stand-by, but due to
terminal problems, I eventually moved on to Yazmin.  More on this another time,
maybe.)

Sorcerer is the second game in the Enchanter trilogy, which is roughly "Zork
except you play a low-level wizard instead of a murderhobo."  When I think of
the Enchanter games, I think of the collection of spells with very Infocom
names like *frotz* and *yomin*.  Upon my recent replay, I felt reassured.  The
game was exactly that.

I say replay, but I don't think I ever played Sorcerer before, apart from the
first twenty moves or so.  I would've been most likely to have done so in 1991
with the release (and my purchase) of [The Lost Treasures of
Infocom](https://en.wikipedia.org/wiki/The_Lost_Treasures_of_Infocom), but I
was more interested in replaying Zork, replaying Suspended, playing the
Planetfall games, and maybe Lurking Horror.

On the whole, I'm going to say that Sorcerer was good.  It built on Zork's
success and didn't feel too much like more of the same.  It's still very much
of its era, though.  It came out in 1984, and it does stuff that by 2024 (and,
frankly, by 1988) was really tedious.  Here's what I wrote in my post about
Enchanter, the game to which Sorcerer is a sequel:

> It has a lot of the same problems as other games of the period, though. The
> two that gutted me: hunger and mazes. “You are getting hungry” is one of my
> least favorite things to see in a game. It is a guarantee that I will end up
> dead and have to figure out how to replay the game in fewer moves, next time.
> Similarly awful is the feeling of leaving “The Transparent Room” only to find
> myself in “The Transparent Room” with a slightly different description. It
> means I’m going to waste half an hour figuring out a maze using the “gather a
> bunch of items and drop them in different rooms” technique. It’s not fun.

I started playing Sorcerer and groaned when, fairly early, the game said
"You're beginning to feel hungry."  I thought, "Didn't some game eventually put
a lampshade on this problem by giving you a Eliminate All Hunger Forever
spell?"

Well, yes, and that game is Enchanter.  So great, hunger and thirst go away…
but not the need to sleep.  Why not?  It really serves no purpose.  It's safe
to sleep almost anywhere.  The only places you can't sleep, you'd clearly be
foolish to try.  But also I find that the "you are feeling sleepy" messages are
easy to miss, meaning you might eventually fall asleep while swimming.  It's
just an annoyance, and not at all a puzzle.

On the other hand, the coal mine provide a much better form of this problem.
Once you enter the coal mine, you can't go back.  It's full of deadly gas, so
you will die almost immediately… unless you drink the *vilstu* potion, which
"eliminates the need to breathe".  It only lasts for some number of turns,
though, so you've got to figure out exactly how to accomplish your mission
within that number of turns.  Oh, and it's a maze.

So, mazes are still around.  The coal mine is just one of them, and it exposes
another characteristic of the game.  (I'd like to say problem, but I think that
it's a matter of taste, and not objective.)  It's this:  you've only got around
a dozen moves to solve the area or die, but also the area is a maze.  Mazes are
generally solved by dropping items in rooms to make them unique, then
traversing the exits to figure out the actual room graph.  This will take much
more than your twelve turns, *so you will die often*.

"You will die often" is definitely a characteristic of this game.  There are a
bunch of puzzles you more or less *can't* solve without having died trying.
There's a spell to let you view the future, which supposedly can be used to
help with this problem… but I never figured out how to use it successfully.
Instead, I saved and restored *very* often.  Once in a while, I'd realize that
my save game was made after some very early mistake.  The most notable one is
when I drank the "eliminate need to breathe" potion as soon as I found it.
This seemed to make sense:  the "eliminate need to eat or drink" potion is
permanent, so I figured this one would be, too.  Great!  I didn't notice the
message indicating that it wore off, and when I got to the coal mine, I
realized I had to start over.

I wouldn't say I can now play Sorcerer straight through without thinking about
it, but I can definitely speed through quite a bit of it on auto-pilot, because
I had to.  This made me feel like a modern Z-Machine interpreter should really
provide better command log, replay, and undo/save management than they seem to.

(On that note, I also would love a 'terp with a memory browser and poke
command.  I hit some stupid bug at some point, and wished I could just reset
the state of something.)

There is also something satisfying about the game's extreme lethality.  I don't
know that I can explain it, but so many random actions result in death that it
becomes funny, especially since you're restoring saves all the time anyway.
It's got some of the gonzo nature of Zork, maybe turned up just a little.
There's a big amusement park, and I think it's underground.  (I think it's
pretty common to confuse aboveground and underground in these games.  Was the
Zork Ⅱ volcano underground?  I think so, but it's nonsensical.)  Anyway, why is
there an amusement park?  Well, *why not*?  It's really only there for one very
simple puzzle, or maybe two, so it could've been anything.  Instead, it's an
eight room area with two fully implemented thrill rides that give you a look at
the rest of the game areas for no particularly valuable reason as far as I can
tell.  I love it.

I've gotten distracted from my previous train of thought, though: mazes.
There's the coal mine maze, but also another maze, the Glass Maze.  This is a
three-by-three cube of rooms made of glass.  There are no twisty little
passages.  If you can go east from room A to room B, then you can go west from
room B to room A.  The difficulty is that you can't tell where there's an exit
or where there's a wall.  You can solve this maze without dropping items.  It's
still somewhat tedious, but it's a novel kind of tedious, and I felt okay about
it.  Even better, though, you can use a spell to transform yourself into a bat.
With a bat's echolocation, you can sense where the walls are.  The puzzle is
even a little better than just that, but this maze was really okay with me.

As with most of these old Infocom games, I'm struck by the great brevity and
economy of the text.  There wasn't a lot of room for words, so there aren't
many words.  The authors do a good job making it count.  Still, I wish there
was room for much more.  When they do spend more words on something, it seems
pretty successful.  I had hoped that I'd find that the third game in the
trilogy, _Spellbreaker_, would be a later version of game file, and so be
likely to contain more words.  Sadly, it's another v3 game, so will probably be
about the same.  I'll find out in about eight more games, though!

Finally, I really enjoyed mapping this game.  I don't know why, it was just
satisfying.  I've always enjoyed making a diagram, though.  I did use the
Invisiclues for this game in a few places, but I also felt I went through it
quite quickly.  I wondered whether part of that is that via OmniGraffle, I have
much better map-making tools than the average player of 1984.  Here's my map:

![a map of Sorcerer](/assets/2024/01/sorcerer-map.png)

Next up is [Seastalker](https://en.wikipedia.org/wiki/Seastalker).  I hope to
report on that sooner than eight years from now.
