---
layout: post
title : "backups now stored on time capsule"
date  : "2008-03-22T02:46:43Z"
tags  : ["apple", "hardware"]
---
The Time Capsule from Apple has been a source of grumbling from me ever since
it was announced.  I was annoyed that I couldn't use my existing Airport (even
though I have an ancient model that doesn't do drive sharing).  I was annoyed
that if I got a Time Capsule, Gloria couldn't benefit from it because her iBook
can't run Leopard.  I was annoyed because I can't even really benefit from the
802.11n networking on my first-rev MacBook.  My TiVo prevents me from using
WPA.  Grumble, grumble, grumble.

This week, it finally became possible to use a newer Airport (with drive
sharing) for backups.  I realized, though, that it wasn't going to be very cost
effective.  I looked at ordering a capsule from Amazon, but they're sold out.
My [friendly local Apple place](http://www.dclick.com/) was also out.  The
local Apple retail store, though, had them.  Gloria, Martha, and I packed up
and headed out there around twelve thirty.  The Apple store is at the Lehigh
Valley Mall, which sucks.  It has long been overcrowded, is on an overcrowded
highway, and has nowhere near enough traffic capacity around it.  This got much
worse in the past year, though, because they added a small, awful "lifestyle
center," or whatever they want to call it.  It's a bunch of snooty stores with
a sidewalk forming a cul-de-sac.  Getting into it sucked.

In the store, there were at least a half dozen employees.  There was a pair
near the door, whom I ignored, and then someone else who said hello and asked
if he could help.  "I'm just here to get a Time Capsule," I said.  He said,
"Ok, just wait here and I'll get a Specialist."

Huh?

I waited while he went to the "Genius Bar" to talk to someone, who shook her
head and walked away.  He came back and said, "Someone will be right with you."

While I waited (and while Gloria drove in circles in the Lifestyle Cul-de-Sac)
I noticed a huge shelf full of Time Capsules, so I went and took one off the
shelf.  The employee who'd greeted me (and was now just standing around) saw
this and said, "Oh, is that one?  Great."

I got in line at the register, where a single employee was working.  He was
helping someone apply for a line of credit.  While I waited, another employee
approached me and asked if I was done.  I said yes, and he rang me up on a
little hand-held gadget.  I had my choice of printed or emailed receipt.  I
didn't want to give them an email address, and I wanted to be able to return
the item, so I asked for a printed receipt and waited while he went back behind
the counter to get a hardcopy.

Finally I had the damned thing in my possession and we got the hell out of
Whitehall, hopefully never to return.

Once home, I started to get things set up.  It took a while, and things got
weird when I tried to go from "it is just plugged into my laptop with a
patch cable for backing up" to "it is my wireless access point."

I think that when I set up a Time Capsule for my dad, I will have to stick to
this order of operations:

* make sure that the computer being used to configure the Capsule has Airport set to a higher priority than ethernet for network traffic -- otherwise, when I connect the capsule via ethernet, the computer will fall off the internet
* apply all firmware updates first
* export the settings of the existing Airport (if applicable)
* import them to the capsule
* update things that should change or don't copy across: device name, port mapping names, etc.
* replace the Airport with the Time Capsule and make sure wireless networking works
* restore the order of routing to make ethernet perferable to wireless
* reconnect via ethernet and begin backup
* take a nap
* done

One problem I had was that after my initial backup, I changed the name and
password on the Time Capsule, which seemed to make Time Machine want to start a
new backup -- obviously, this was not something I wanted to have to do again.
I still think it might be a little weird, since I can mount the Time Capsule
drive but not eject it quite normally.  Time Machine shows a "network share"
rather than "time machine" icon for the disk I have chosen.

Still, it's working, and that's good enough for me.

