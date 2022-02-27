---
layout: post
title : my boot stomping on character builder's face, forever
date  : 2009-05-03T18:55:54Z
tags  : ["dnd", "games", "rpg", "software", "stupid"]
---
I write software for a living, and because some of it powers publicly available
services, I have real people bitching about it, so I try my best not to just
rant furiously about software.  I know there are people behind it.

I have been struggling not to just emit long strings of expletives all weekend,
dealing with the D&D 4th Edition Character Builder program.  I was predisposed
to dislike it, then fairly pleasantly surprised, then plunged into a deep and
furious funk.  All of my anger comes from problems that should be pretty easy
to solve (or so I guess), so I'm not going to entirely give up yet.  Still,
man!  There was a point (ten minutes ago) where I found myself crumpling up a
pile of paper and throwing it across the room.

D&D 4E simplifies a lot of rules, but there are still lots of them, especially
because all classes now have spells in the form of Powers.  Each power is a
unique snowflake with its own, often complex, effects.  Also, a lot of the
complexity of improving many stats individually has been replaced by using
"half your level" as a modifier all over the place.  That means that when you
level up, you have to update potentially dozens of little boxes.

The Character Builder takes care of all this.  It walks you through character
creation and through every part of leveling up.  It can tell you if your
character is legal according to the published rules.  It prints out a fairly
standard character sheet with all your stats filled in, including all the
modifiers.  It also prints out a summary of all your powers.  It's really,
really useful.  When creating NPCs or one-shot characters, it saved me a lot of
time.

The first big problem, for me, is that it doesn't run on anything but Windows.
This is an annoyance, although not a huge one.  I own a copy of XP and I have a
VMWare instance for it.  On my current machine, with 4 GB of RAM, running XP is
not a burden.  It's just annoying.

The bigger problem is that to some extent, there may never be a free version of
this software.  The 4E rules are not free, even to the limited extent that the
3E rules were.  There exists a really cool thing called the D&D Compendium.
It's a website that you can visit to look at basically any item in the rules.
Unfortunately, it's not a web service, so you can't pay money to have access to
that to write your own character builder.  Basically, I think we'll only have
the DDI (D&D Insider) Character Builder for the life of 4E, unless WOTC decides
to rewrite it.

So, I decided I'd get a one-month subscription to DDI to see how I liked it.
I'd have access to old Dungeon articles, I'd have the Compendium, and I could
try playing more with the DDI CB.  The next game is a one-shot with only two
players, and I'd recently made characters for that game.  I loaded them into
the CB and it was swell.  I loaded the main party in next, and it went almost
as well.

The problems I encountered at this point were not that frustrating.  One of the
PCs is a gith, and I'm not using the stock rules gith (either flavor) provided
in the Monster Manual.  I was able to define a custom race, but I couldn't give
it any ability bonuses, meaning that now the character appears to have illegal
attribute scores.  I had a similar problem with the dwarf: I replaced the stock
dwarven weapon proficiency, but I couldn't fix that, so the dwarf had no
proficiency in his main weapon.  Worse, I couldn't just force a weapon
proficiency feat onto him -- you can't add feats or powers for no reason.

Oh, and I couldn't set languages by hand.

Anyway, these were all pretty minor.  I don't mind the consequences.

What drove me totally into the red was printing.

The CB kept trying to print onto eight and a half by eleven inches worth of my
paper.  I mean: it didn't leave any margins.  Of course, that means that it cut
off a bunch of stuff, like languages, seom skills, and so on.  I spent hours
and maybe fifty pieces of paper trying to fix this.  It kept trying to fix
things to pages by cropping instead of shrinking.  When I *did* manage to print
it to a PDF with no margins and asked Preview.app to shrink it to fit, Preview
shrunk it, but left it flush with the lower left corner of the paper, so it was
still unprintable.  If there was a "shrink *and center* to fit page" option, I
couldn't find it.

Finally, it looks like the *only* way I can print legible character sheets is
to:

1. open the character sheet
2. print to a 8.5 x 11" PDF (using CutePDF)
3. open the PDF in Adobe
4. print to a 7.5 x 10" PDF, shrinking to fit page
5. copy that PDF to my Mac desktop
6. open the PDF in Preview.app
7. print the PDF

No other formula that I tested worked.  Even trying to print the PDF from
Adobe, shrinking to fit, failed.  Obviously, this is ridiculous.  I just want
to be able to click "print" and have it come out of my printer.  Two steps:
open, print.  Really, it'd be nice to be able to print from the context menu in
the explorer, but I can live without that.  Instead, I have seven somewhat
complex steps.  Keep in mind, for example, that changing the targeted paper
size is about seven or eight clicks.

I'm about ready to print the entire party, now, and God willing every one of
those sheets will come out just fine.  With that done, I hope only to re-print
when the party levels up.  If that's the case, I can live with it.  Still, wow.
I hope this problem is addressed quickly.  I'd build more NPCs!

**Update!** You *can* add arbitrary feats.  I'm a bonehead... and it isn't very obvious.  If you click the little "house" icon on your skill listing, it adds a "House Rule Slot" for one.  Great!
