---
layout: post
title : "notes on drawing programming for children"
date  : "2015-03-22T03:10:54Z"
tags  : ["programming"]
---
Once in a while, my daughter asks me to teach her programming.  We've done a
number of little things together, including some Python, some Scratch, and
other things.  When I was trying to think of what I enjoyed doing with
computers around that age, one of the things I remembered was drawing.  We did
turtle graphics with
[Logo](http://en.wikipedia.org/wiki/Logo_%28programming_language%29) in my
school, and it was nice to get instant and visual feedback of what the program
did.  I thought this seemed like a fun idea.

I had looked at using [Scratch](http://scratch.mit.edu/) for this, but it
didn't seem likely to work out.  Scratch is neat, in some ways, but terribly
limited in others.  I decided we'd stick to Logo.  I downloaded
[ACSLogo](http://www.alancsmith.co.uk/logo/), the only gratis OS X
implementation of Logo I could find.  At first, it went well.  We drew some
stuff.  She drew a vampire girl.

<center>
![vampire girl](/img/journal/turtle-vampire.png)
</center>

I wanted, next, to show her how to do some of the more commonly-seen tricks,
like rotated squares making a flower.  This is simple: you define a function
and call it in a loop.  Then I realized that ACSLogo had neither of these
things.  Or, worse, it had functions, but they weren't defined in the program
text.  You have to bring up an inspector pane, edit them across several
different GUI widgets... it's a mess.

Fine, I said, forget it.  There are other languages specialized for drawing
stuff!  I decided to teach her PostScript.  We'd already played with RPN
calculators, so we were halfway there, right?  She was a natural.  I showed her
this little box-drawer:

      newpath
        250 225 moveto 275 225 lineto
        275 200 lineto 250 200 lineto
        250 225 lineto
        stroke

...and she said "moveto, and lineto, but don't use goto!"  I don't even know
where she picked this up.  Kids these days!

Anyway, she drew a skull, and it was awesome:

<center>
![vampire girl](/img/journal/ps-skull.png)
</center>

Those three squares were going to be a lesson.  After we did one square, we
could turn it into a square subroutine!  Only as I began to say this out loud
did I remember that like only the [most backward of
languages](http://www.perl.org/), PostScript routines did not have parameter
lists.  This is pretty obvious, of course, but I hadn't thought of it until I
got there.

A routine to compute `a²+b²` would look something like:

    /sum2sq { dup mul swap dup mul add }

If you wanted to actually get "a" and "b" to use, you'd write something like
(and please forgive the fact that I will get this wrong, probably):

    /sum2sq {
      2 dict
      /b exch def
      /a exch def
      a a mul
      b b mul
      add
    }

So, you declare that the next two definitions are local, then you define named
routines that return the values you've popped off the stack, in reverse order,
of course... this is not something you want to bother teaching a second-grader
who just wants to draw a cool skull.

(It gets a lot worse, if you care about the program, actually.  The above
program re-alloctes a new local dictionary every time you call the routine.  In
reality, you'd want to move that definition outside the routine, then swap the
routine's definition in and out of the dictionary stack.  But then it isn't
re-entrant!  This gets easier if you're using Level-2 PostScript, but my
reference is only for the original version with no garbage collection.)

Anyway!

I seriously considered writing a PostScript preprocessor to allow for something
like:

    /sum2sq(a b) { ... }

...but this was bordering on madness.  PostScript has so many other drawbacks
to begin with that I took this as a sign.

I looked for another version of Logo, found one, bought it, and found that it,
too, had no procedure definition.  I got a refund.  Thanks, Apple Store!

Finally, I learned that Python's Tk system comes with turtle graphics.  We'd
already done some Python, so this was familiar!  It was a lot easier to work
with, we could write named functions, and the kid was pleased that TextMate had
good syntax highlighting for it.  She made the long-overdue flower:

<center>
![vampire girl](/img/journal/turtle-flower.png)
</center>

Next up, I'd like to make it easier for her to run the program without a bunch
of terminal nonsense and "hit a key to continue" stuff.  Still, so far so good.
She tells me that when she gets older, she'll be a better programmer than I am,
because her programs "won't have bugs."

Ah, innocence!

