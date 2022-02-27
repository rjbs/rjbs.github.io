---
layout: post
title : time machine and superduper
date  : 2007-11-04T01:30:21Z
tags  : ["apple", "macosx", "software"]
---
For quite a while now, I've used
[SuperDuper!](http://www.shirt-pocket.com/SuperDuper/) to do backups.  It's
basically a nice GUI over a rsync.  The common use it to tell it "make drive B
into an exact duplicate of drive A."  It does so as quickly as possible,
changing only the files that need to be changed.  This means that after your
initial backup, you can make a new backup very quickly by updating the initial
backup.

If you duplicate your system disk to an external disk, you can then boot your
system to the external disk and it's just like you were on your own system.
I've used this a number of times when sending my computer in for service.  I
backed up, wiped out the personal files from my computer, and sent it in for
service.  Then I duped the backup to a rental.  When my computer got back, I
duped the rental to it, and it was like I never was missing my own computer.

There are a lot of other features, but that's the most common use case.

Mac OS 10.5 introduced a new feature called [Time
Machine](http://www.apple.com/macosx/features/timemachine.html), intended to
make backups really, really, really easy.  I figured that either it would make
SuperDuper! obsolete or it would stink.  Neither is true: it seems totally
great, but I will still use SuperDuper!.  (Side note:  names that include
sentence-ending punctuation are a bit annoying.)

Time Machine makes a backup of your whole drive, but it doesn't do it by
cloning the drive to another drive.  It puts the whole backup on that other
drive, but inside folder named something like "2007-11-01 21:20" inside another
folder called something like "YourComputer."  Then, it keeps making new folders
every hour (or whatever interval you ask), storing the new state of things.
The downside of this is that you can't just reboot from the backup.  That's why
SuperDuper! will remain very useful.

The upside is that each backup only takes up as much space as is needed for the
files added since the previous backup.  That means that you might be able to
store a backup for every hour for a month or more on an external disk no larger
than the one in your computer already.  (It will depend on your usage habits.)

The upside of the upside is that you can say, "show me what this folder looked
like two days ago."  You don't need to dig up your backups from that date, you
just say, "show me old versions of this folder," and roll the time machine back
until you get to the date you want.  Awesome!

