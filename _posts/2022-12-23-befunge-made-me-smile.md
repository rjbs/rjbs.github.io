---
layout: post
title : "befunge made me smile"
date  : "2022-12-23T21:59:25Z"
tags  : ["programming"]
---

I like Advent of Code, in theory, but in practice I never get very far.  Around
ten days on average, it looks like.  (In 2015, I made it to 23!  I didn't
remember that.)  Anyway, it's just, well, *a lot*.  I don't make enough time
for it, and mostly I think that's the right decision.  On the other hand, I
love a little coding challenge, and I love it twenty times more when other
people are doing it and we can compare notes.

This month, at Fastmail, our engineering manager took it upon herself to issue
weekly katas to the company.  This suited me much better, because I could put
in a little time each day… or so I thought.  In reality, once I started, I
finished pretty quickly each time, but I think the whole thing was just lower
stress and higher fun.

The programs were all quite simple, which meant that there was a lot more time
for shenanigans.  I shenaniganed a lot, and I wanted to post one of my
submissions here, just because I had so much fun doing it!

### the challenge

[This kata](https://www.codewars.com/kata/583203e6eb35d7980400002a) came from
codewars, and is very, very simple.  Kate said something that I heard as, "I
wanted to pick to simplest thing possible, to see if it would lead to the
greatest possible nonsense."  Maybe this isn't what she said at all, but it's
what I decided to act on!  The challenge is to count the ASCII smileys in a
string, where a smiley is very strictly defined, basically as follows:

```perl
m/ [:;] [-~]? [)D] /x
```

You can, of course, just write this regex, but where's the fun in that?
Overcome by the need to submit immediately, I *did* submit it, but it wasn't
gratifying.  Instead, I thought about how I wanted to solve this problem, and
the answer came to me quickly.

### befunge

I wanted to use [Befunge](https://en.wikipedia.org/wiki/Befunge)!

Befunge is an esolang.  Esolangs are *esoteric languages*, which mostly means
"weirdo garbage used only to prove you are a weirdo".  This is right up my
alley.  There is a whole [Esolang wiki](https://esolangs.org/wiki/Main_Page),
which I recommend.

Befunge is one of the more famous esolangs.  Its weirdness is very obvious, but
you can still look at a program and (sort of) reason about what it will do.
There are lots of esolangs where that's just not the case.

Here's how it works:  A "normal" computer program is a list of instructions in
sequence.  One of those instructions is the current instruction, pointed at by
the "program counter".  When it's executed, we move on to execute the next one,
in sequence.  If you want to do something not strictly sequential, you can say
"set the program counter to something else", but then you continue executing in
sequence.  This is fine!  It's how computers work, basically ever since the
Turing machine's moving bit of tape.

In Befunge, the above is *sort of* still true.  Instead of linear, memory,
though, it's a grid.  The program fills out an 80x25 grid.  Execution starts at
the top left and moves to the right.  When it reaches the end, it does *not*
start over on the next line.  That would basically be linear memory!  Instead,
the grid is a torus.  When you fall off the right edge, you pick back up on the
left edge, on the same row.  There's no jump instruction, so you can't get to
the next row by jumping there.  Instead, you can change the direction that the
program counter moves.

Every cell on the grid is a byte.  Every byte is both data and instruction.  If
the program counter enters a cell, it better contain an instruction.  You can't
jump to an arbitrary cell, but you can *write* to one, so you can modify
instructions before (or after) you reach them, or use cells to store data.
Also, there's a single stack, and you know I love a stack based language.

Here's a simple program:

```
>9 3 + .    v
^ .-  6  8  <
```

The arrow-like characters do what you think, and make the program run in that
direction.  The digits push those values onto the stack, and plus is plus.  So,
we push 9 and 3 onto the stack, pop and add them, and then hit dot.  The dot
instruction pops, formats, and prints the number atop the stack.  At the end of
the line, we start executing downward, then go left, push 8, then 6, and
eventually printing their difference.  This program prints 12 and 2 forever.

Since you can't jump, how do you branch?  The operators `_` and `|` are
branches.  When entered, the redirect the program either left-or-right or
up-or-down, respectively, based on whether the top value on the stack is zero.

So:

```
v       <
> 22+:. |
^       @
```

When this program, moving right on line two, hits the `+`, it ends up with 4 on
the stack.  The `:` dups the value, `.` pops and prints, and then we reach `|`.
There, the top of the stack isn't zero, so we begin to execute upward, are
directed left, and continue on.  The program prints 4 forever.

If we replace the `+` with a `-`, when we reach the branch, we will branch down
and terminate.  The at sign is end-of-program.  (Mnemonic: your program swirls
down the drain.)

There are, of course, more operators.  Some of them you'd expect, like "drop
the top value on the stack".  Others, you might not, like "after this
instruction, move the counter two, instead of one."

With a list of all the operators in front of me, it was time to get crackin'.

## counting smileys: step 1

The first program I wrote (or committed, anyway) was this:

```
>  094+91+ 040p                                                              v
v  ":-) :] :D 8/)"                                                           <

# (* 0. If top character is zero, print numeric value of ACC, exit.
§    1. If top character is eyes, pop and continue.
v       Else, pop and restart.
     2. If top character is a nose, pop and continue.
        Else, continue.
     3. If top character is a mouth, pop, increment (0,1), restart.
        Else, pop and restart.
 v <
> :|
 , >40g.@
^<
```

We push a nul and CRLF onto the stack (well, LFCR, but I was still figuring
things out), and then store a nul.  We store it where that `§` is, which I put
there to remind myself which cell I was using for data.  This turned out to be
a bit of a pain, because the debugger really wants you to use ASCII for
everything.  If I implement my own befunge — and I might — it will mostly be to
get UTF-8 support.

Anyway, with those terminators in place, we move on to the next line, where we
execute leftwards, pushing a string onto the stack.  `"` toggled string entry
mode, where each the ASCII value of each cell is pushed onto the stack.  I took
care to execute from right to left here because that way the string could be
written left-to-right and still end up on the stack in the order I'd want to
deal with it later.

At the end of the second line, we hang a left turn (meaning we're headed down,
keep up!) and then hit `#`.  That doesn't quite introduce a comment.  It's the
"skip the next cell" instruction from above.  We skip over the just-for-data
cell, cruise along the left edge, and go into a branch like the one I showed
above.  If the top of the stack (which we dup before testing) is zero, we head
toward the drain — but not before getting (`g`) the value at (0,4) and printing
it.  That was our accumulator, even though it hasn't accumulated anything yet.

Otherwise, we loop up, left, down, and around, printing out the string on each
loop until we hit that nul that we pushed onto the stack at the very, very
beginning.  It's the "Hello, world!" program, basically.  Cool, but how did
those comments work?  Turns out it isn't interesting.  They're just cells that
we take care not to enter!

Now, having laid out my plan in the comments, how do we build the real thing?

## step 2

In moving on to step 2, I'm afraid I did a bit of "draw the rest of the owl",
and actually managed to do it.  I think this version (pulled from git) has bugs
that I later fixed, but it's what I committed:

```
>  094+91+ 004p                                                              v
v  ";-) :] :D 8/)"                                                           <

# /* 0. If top character is zero, print numeric value of ACC, exit. */
-  >       : ";" - #v !# _ : ":" - #v !# _  v  This line sees eyes.
> :|                                        $
 , >04g.@v    $     <               <  v                                <
^<            $                        <    <
         > : "-" - #v !# _ : "~" - #v !# _  v  This line smells noses.
                    >$      v      $<
         v                  <               <
         > : ")" - #v !# _ : "D" - #v !# _  v  This line tastes mouths.
                    >$      v      $<a      >                           ^
^             p40+1g40      <
```

First off, you can see that the `§` is gone, replaced with `-`, because I got
tired of the debugger.  Other than that, the whole program is basically there.

After the `#` (which, by the way, is called a "bridge"), we cruise right on the
eye detector.  We dup top the top item, push a semicolon on the stack, and
compute their difference.  If it's zero, we branch down to reach the leftward
highway that will take us to loop around for another rightward approach on the
nose detector.  If it's not zero, we try again with a colon.  Failing that,
we'll go *further* down to a *different* leftward course to start over with eye
detection.

Those "compare the given character to the semicolon or colon" bits are sort of
fun:  `: ";" - #v !# _` says "dup the top element, push a semicolon, compute
the different, (skip the down instruction), NOT the top of the stack, (skip a
nop), and branch.  This branch is left/right, which might send us right back
where we came from!  But this time, moving left, the first `#` we hit will jump
over the NOT.  Then we'll hit the `v` that we previously skipped.  The line
contains two sets of instructions, each only reachable when traversing in
opposite directions.

Really, the rest of the program is much of the same.  Eventually, if all three
detectors fire (well, the scond one is optional, which is why you only find one
left-bound lane of traffic between the nose and mouth detectors), we increment
the data cell at (0,4).  When we reach the end of the string, at the `:|` (not
a smiley), we branch down into ` >04g.@`, which prints the accumulator and ends
the program.

## beautification

With the program basically working, I wanted to make it look nicer.  I'll be
honest: I didn't get very far on that front.  Mostly, I compacted it down and
tweaked one two little things, and added a much nicer comment.

```
>  094+91+ 010p                                                           v
v  "My face is saying :-) but my heart is saying ;-D"                     <
   >       :";"-#v!# _:":"-#v!# _v   +------------------------------------+
> :|:                          <$<   |                                    |
   >10g.vv   $   <          < v      | To detect smiley faces in a string |
^<           $                <      | that may contain them, enter the   |
        9> :"-"-#v!# _:"~"-#v!# _v   | string on line two, in a pair of   |
  G@ME  4        >$    v   $<        | double quotes, without disturbing  |
  OvER  +v             <         <   | the ">" or "v" that begin and end  |
   #    ,> :")"-#v!# _:"D"-#v!# _v   | the line.  What could be simpler?  |
   ^,+19<        >$    v   $<  ^ <   |                                    |
^p01+1g01              <             +------------------------------------+
```

It's the same program with very few tweaks, but I felt this had better use of
space.  Even so, it seems wildly inefficient in terms of space.  I feel pretty
confident I could squish out lots of the whitespace.  In the end, though, I
*liked* this shape.  It was what felt natural to build, and I built it.

Of course, we never talked about the `␠` (space) instruction.  Every cell is an
instruction after all!  The space character is a no-op.  It doesn't do
anything, but it also takes a cycle to execute.  The more space in your
program, the more cycles it wastes — a real demonstration of the battle between
readability and efficiency, right?

What I didn't do was try to generalize the organ detectors.  It doesn't seem
crazy to think it should be easy to write a construct with the stack signature
`(given allow-1 allow-2 -- )` that branches one way if `given` is either of the
allowed values, and another if it isn't.  I thought about this for a while and
decided that it was probably much less efficient, and I didn't feel like I was
going to have fun, so I didn't write it.

I really wanted to enclose my commentary in nice box-drawing characters, but I
didn't, because when run in the `bef` debugger, you just don't see anything.
Each UTF-8 byte is considered its own cell, and then they're displayed on their
own grid position on screen.  So it goes!  (Imagine, though, a more
Unicode-integrated Befunge!  If you wrote your combining grapheme clusters in
decomposed form, how many cells is that? 🤔)

But I will briefly talk about debugging.

## the dev tools

I started by just installing the `befunge93` package from Homebrew.  This was …
*fine*.  It has a debug mode, enabled with `-d`, which prints the program's
state and PC position to the screen as it runs.  This is great, and just what
you want!  It had a bunch of problems, though.

It doesn't have a default output channel for print instructions, so they're
skipped.  That would be okay (I guess), except it's not what you expect: it
doesn't skip *printing*, it skips *the whole instruction*, and those
instructions pop elements from the stack!  Debugging the program can alter its
behavior drastically!  You get past this by providing a file to print output
to, but you won't see that live unless you take more pains.

There's the trouble I mentioned above with UTF-8, but it's a bit worse than
that.  Putting a nul into a cell can show up strangely, along with other
control character values.  What would I have done?  I don't know, probably I'd
show a colored `x` or something, but I didn't write it, so I sucked it up.

…at least for a while.  Then I looked for alternative interpreters, and found a
bunch, only one of which seemed close to what I wanted.  That was [jsFunge
IDE](https://befunge.flogisoft.com/), a Befunge-93 IDE in JavaScript.  It has
multidirectional editing, a stepping debugger, an output window, and a stack
visualizer.  It's just what I wanted… except it was really sort of a pain to
use.  It's got multiple windows, and its window behavior is weird.  When a cell
contains a non-graphic character, the grid display can fall out of alignment.
Still, it was a good set of features for a serious programmer's Befunge.

## other esolangs

For the next kata, I looked at whether I wanted to use some other esolang, but
nothing called out to me.  Certainly not
[Funge-98](https://esolangs.org/wiki/Funge-98), which expands out to three
dimensions of arbitrary size and concurrency.  I may just rest on these very
small laurels, or maybe I'll try writing a little befunge in some other
language.

By the way, the reason Befunge even exists is that the author wanted to come up
with a language that would be hard to compile.  It's a good stab at that, but
some compilers have been written.  Check the wiki!
