---
layout: post
title : "nerflearning: learning SwiftUI by not writing any"
date  : "2026-03-25T12:00:00"
tags  : ["programming","agents"]
---

I had Claude produce a complete daily to-do checklist for me -- something like
a bullet journal.  The results were great, and I've been using the program for
weeks and it's definitely helping me stay on track and keep an eye on what I'm
doing.  The problem was that unlikely everything else I'd had Claude write, I
was not competent to review this work.  I felt confident it wasn't going to
cause me big problems, but what if I wanted to debug it myself?  I realized
there was a plausible solution waiting for me…

I gave Claude a prompt that went roughly like this:

> We have built a really useful program here, and I am using it and enjoy it.
> Next, I would like to be able to work on it directly and to think more deeply
> about its architecture.  The problem is that I don't really know Swift.
>
> I am an experienced programmer with decades of experience.  I have worked
> primarily in Perl, but am well-versed in general programming concepts from
> many other different languages.  It seems relevant so:  I understand
> event-driven programming, observers, and MVC, in general.
>
> I would like you to prepare a syllabus for me, which will help me learn
> SwiftUI, using NerfJournal as a working example.  What might be useful here
> is a set of topics, starting with fundamentals and building to more complex
> ones, related to how the project actually works.

This began a back and forth that didn't go on all that long.  (You can read
[the transcript](https://static.rjbs.cloud/claudelog/nerflearning-part-1.html).
Claude produced a syllabus.  I proposed that we turn the project into a
website.  We fought with Jekyll for a while.  Claude told me that I wouldn't
need some skills I thought I might want.  (Later, I did want them.)

Still, in short order, I had: **Unit 1: Swift as a Language**.  It started like
this:

> Before touching SwiftUI, you need the language it’s built on. Swift is
> statically typed, compiled, and designed around a distinction — value types
> vs. reference types — that will shape every decision in the units that
> follow.
>
> This unit covers the language features you’ll see constantly in NerfJournal’s
> source: structs, enums, optionals, protocols, extensions, modules, closures,
> and computed properties. None of this is SwiftUI-specific; it’s just Swift.
>
> The single most important idea in this unit is that structs are value types.
> Everything else makes more sense once that has settled in.

I felt that the text was *good*.  It wasn't confusing.  It wasn't unclear.  It
also didn't captivate me or lead me to imagine I was reading a lost work of
Edward Gibbon.  But I didn't need that, I just needed something to
systematically help me learn SwiftUI, with an eye to working on the project I'd
summoned into existence.  On that front, the text was *good*.

Eventually, I *did* end up creating some skills and standing instructions.
First, the standing instruction:

> When the user asks a question about Swift or SwiftUI during a learning
> discussion, log it to learning/questions.md under the appropriate unit
> heading, then commit it. Do this automatically without being prompted.

As I read the content, I'd do all the things I'd normally do when reading a
programming book:  I'd close my eyes and think hard.  I'd fiddle with the
source code to see how things changed.  I'd go consult the authoritative
documentation.  But sometimes, I'd also (or instead), ask Claude to elaborate
on something.

At some point, the text said that extensions were "module-scoped".  I had no
idea what a module was.  The text didn't say.  Rather than consult the docs, I
just asked Claude:  "You refer to module scope.  What is a module?  Is this
going to be explained later?  If so, no problem."

Claude said that no, its plan hadn't included modules, and really they belonged
in unit one.  It provided me a clear and useful explanation and then, without
prompting, [wrote a
commit](https://github.com/rjbs/NerfJournal/commit/fa6a06b2fd30ab7d19beaac46e9362fa2d8b477b)
to add the explanation to the Q&A appendix of the book.  More questions like
this came up, and Claude would populate the Q&A section.

Later, I added a skill, 'next-chapter':

> Write the next unit of NerfLearning.
>
> First, rebase this branch on `main`.
>
> Review the changes between the state of this branch before rebasing and
> after.  If changes to the project suggest that `learning/SYLLABUS.md` should
> be updated for future chapters, make those changes and commit it.
>
> Then review the file `learning/questions.md`, which reflects questions from
> the reader during the last unit.  Merge the material from the questions into
> the unit they came from.  Remove the now-merged questions from the questions
> file.  Commit that.
>
> Then write the next unit from the syllabus.  When doing so, reflect on the
> question-and-answers content you just merged into the previous unit.  That
> reflects the kind of thing that the reader felt was missing from the text.
>
> Commit the new unit.

I asked Claude to write Unit 2, and it did so.  "It seems like the user wants
more implementation details," it mused, "I should make sure to cover how
`@ViewBuilder` actually works."  Then it spit out another unit.  Was the unit
actually better because of those instructions?  How the heck should I know!?
But it remained *good*.

I'm up to unit six now, where I'm stalled mostly due to other things taking my
time.  I actually feel like I can read the whole program and pretty much follow
along what it's doing, how the syntax works, how the SwiftUI "magic" is
suffused through the system, and how I'd change things in significant ways.
I'm no expert.  At best, I'm a beginner, but I have been given a huge boost in
my learning process.

Of course this sort of process could go haywire.  I would not want to learn a
foreign language or culture this way and then go on a diplomatic mission.
Software learning is much more forgiving, because so much of it can be
trivially verified by checking authoritative sources or performing experiments.
Also, I've got a lot of experience to draw on.  But even so, it's clear that
this has been valuable and I'll do something like this again.

There is sometimes an argument that "why will anybody learn anything anymore if
the computer can do the work?"  I don't get this argument.  Sure, some people
will try to get by on the minimum, but that's already the case.  Now there are
some longer levers for just skating by.  But the same levers can be used to
learn more, to achieve more, and to experiment more.  I don't think any of this
is an unvarnished good, but it's also clearly not just spicy autocorrect.

I'm hoping to get back to SwiftUI in a week or two.  I'm piling up a number of
little features I'd like to implement, and might try a few by hand.

You can read [NerfLearning](https://nerfjournal.rjbs.cloud/), up to wherever
I've gotten to, if you like… but it's targeting a pretty darn small audience.
