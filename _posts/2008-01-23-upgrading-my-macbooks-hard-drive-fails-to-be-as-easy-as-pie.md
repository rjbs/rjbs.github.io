---
layout: post
title : "upgrading my macbook's hard drive fails to be as easy as pie"
date  : "2008-01-23T14:40:56Z"
tags  : ["apple", "backup", "hardware", "macosx", "stupid"]
---
Before the semiannual Big Mac Announcements, I was thinking that I might buy a
new laptop.  I was half suspecting that we'd see a subnotebook -- something
like a Duo or even more like the 12" PowerBook.  I wanted something narrower
than the MacBook, as that would make it a bit easier to use on the bus, if
someone sits beside me.  Unfortunately, the new MacBook Air isn't any narrower,
but is a good bit more expensive, so I skipped replacing my MacBook.  Instead,
I spent about .5% its original purchase price on nearly tripling its storage,
which is the only limitation that I bump into much.

[Apple's instructions
(PDF)](http://manuals.info.apple.com/en/MacBook_13inch_HardDrive_DIY.pdf) made
it seem like swapping out the hard drive would be as easy as eating pie.  Some
friends confirmed this belief.  I'd replaced the hard drive in my 12"
PowerBook, and before that in my [Compaq Contura
Aero](http://automagically.de/images/c_slippy_01.jpg), so I figured this
couldn't be so bad.

Well, it wouldn't have been, if the people at Apple weren't liars and jerks.

Yeah, I'm still in a cooling-off period since last night.

First of all, they say that you'll need a #1 Phillips head screwdriver.  This is
not true.  The L-shaped bracket inside requires a #0 driver.  That's fine,
because I have a few.  It's just a filthy lie... but it does matter.  You see,
the last person to work on this computer -- the Apple tech who *finally* caused
its video to stop flipping out -- either had the power of ten men or a tiny
power screwdriver.  The third screw on the bracket was so tightened so fast
that I was nearly unable to break it.  I thought I'd try to unscrew it with my
drill, but of course I had no Phillips head bits smaller than #1.  If their
DIY instructions had been true, I would've been all set.  In the end, Gloria
braced the computer in place with both hands.  I used my strong hand to press
the tiny #0 driver into the screw as hard as I could, while I used a wrench to
turn it.

Once that was out, the drive sled came out easily.  If the screw had been easy
to remove, I probably would've been grinning like an idiot at this point --
rarely are laptop drive replacements so easy.  What I saw next would've only
caused me to roll my eyes.  Instead, I believe I may have lost a few years from
my life, suppressing the urge to scream and throw things.

The drive was secured to the sled with four of the tiniest TORX screws I've
ever seen.  Actually, maybe they were triple squares.  It doesn't matter
because I couldn't turn it with a triple square head, an Allen head, or a TORX
head.  Finally, I unscrewed them all with a pair of pliers.  I had two Phillips
on hand, and used them to re-secure it -- but it still wasn't secure enough, so
I ended up screwing two of those devil screws back into it with my pliers.

If the screws had all been sanely tightened and of normal types, this would've
been an incredibly painless process.  As it was, I think replacing my 12"
PowerBook's drive was easier.

I took it upstairs and booted from my SuperDuper backup.  Ugh.  Leopard and
SuperDuper aren't a great match, yet.  That's fine, and not a big deal.  I
booted from my 10.5 media and restored my latest Time Machine backup.

Things booted, I started a new backup, checked in on my
[Travian](http://travian.us/) village, and went to bed.

Well, the joke was on me.  It turns out that [Time Machine is a partial
backup](http://discussions.apple.com/thread.jspa?messageID=6367763).  It
doesn't back up things in `/var/spool` or `/var/log`.  I don't really mind
losing my old logs, although it's pretty obnoxious that I do.  I actually
wouldn't even mind if I ended up with mail in my Postfix queue getting
delivered twice, after a restore.  The problem is that it creates `/var/spool`,
but not `/var/spool/postfix`, meaning that Postfix then fails to start or run
properly.  At least `sudo mkdir /var/spool/postfix` is easy to type, and seemed
to fix the problem.

I think everything is now back to normal, although I suspect something will
explode a little later today.  At least, now, I have a whole lot of free space.

