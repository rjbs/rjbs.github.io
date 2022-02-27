---
layout: post
title : "just how much data did I lose?"
date  : "2014-06-15T02:33:38Z"
tags  : ["hardware"]
---
For a few years, I've kept most of my "stuff" on a two terabyte hard drive in a
little tiny desktop computer running Ubuntu.  It's got another 2T drive
connected via USB, and once in a while I'd run an rsync job.  This was
basically my whole "storage solution" for my media files: ripped movies, ripped
music, and books.  Recently, I've been getting close to filling the drive, and
I thought I should improve the whole setup with something less ad hoc.

I settled on getting a [Synology
DS214play](http://www.amazon.com/Synology-DiskStation-Diskless-Attached-DS214play/dp/B00G9X5N2W)
NAS.  The price seemed pretty good, and it could serve as a DLNA server so I
could stop syncing files to an external drive plugged into my Roku.  I had two
1T drives sitting around from my last upgrade, and I figured I'd start with
those, migrate some files, and then move up to 3T drives if everything went
well.  This would probably have been a good plan, but it turns out that I just
couldn't leave well enough alone.

I started by moving my music collection, which was very roughly around 175 GB.
(I bought a lot of CDs in college.)  I started by rsyncing the music to an
external drive and then moving it from that drive onto the NAS.  I encountered
one pretty obnoxious problem which would continue to crop up over the rest of
the experience.  The NAS has a really neat web-based GUI that acts like a
standard WIMP interface.  To migrate the files in, I'd select the directory I
wanted to move over and take "Move to ... [target]".  Hours later, it would
report completion, but less than 100% of the files would be moved.  For
example, an album might have been moved with only 8 of its 10 tracks.  I'd run
several "move" operations in a row, until all files were moved.  Unfortunately,
sometimes empty directories were left behind, which made it a bit harder to
verify what was going on.

This *really* did not fill me with confidence.

To determine whether I'd gotten everything copied over, I'd run `find` on both
volumes, then compare the output.  This would sometimes be a bit less than
perfect because I'd get different encodings back for non-ASCII filenames.
Worse, I found that some badly-encoded filenames would simply be unavailable
via the NAS.  I think the problem is that some filenames were double-encoded,
but I'm not positive.  What I do know is that I'd see "Hasta Ma�ana" in the
GUI, but I'd be totally unable to access the directory in any way.

This problem had already been haunting me on my old drive.  I think it started
because of a Samba upgrade years ago, but it affected relatively few files.
Once in a while, iTunes would try to play one and I'd go sort out that
directory.  This migration gave me a reason to fix them all.  I scanned for
broken directories.  When I found one, I'd delete it on the NAS, fix the
filenames (with `mv`) on my Linux box, and then re-copy it individually.

This is where my first major problem probably crept in.

I had some problems with tracks by Cuban *son* artist "Compay Segundo," and
deleted his artist directory.  I believe that I accidentally cmd-clicked the
directory below his while working.  That directory was "Compilations," where
iTunes was storing albums made up of many artists working together.  This
included things like musicals, soundtracks, and tribute albums.  It was about
one tenth of my music.  I didn't notice that I'd deleted it, and I deleted it
while *fixing* discrepancies.  When I finished fixing problems, I didn't do a
second comparison, which would've detected this huge loss.

I took my old 2T drive, which had been the rsync backup of the master drive,
and slotted it into the NAS.  That way, I'd be able to grow the RAID faster,
later.  Now the master drive was the only copy of "all my stuff."

I fixed some similar encoding problems in my books, but far fewer.  At this
point, I had a 1T and a 2T drive in the two-bay NAS, acting as a RAID1.  I
copied my video collection onto an external drive, along with some other random
stuff.  At this point, I could destroy the master 2T drive by slotting it into
the NAS and letting the RAID repair itself, which would get me another terabyte
of storage.  Then I'd dump the video archive onto it and I'd be done.
"*Later*", I thought, "I can do the upgrade to 3TB drives."

This was stupid.  There was no reason to rush other than impatience and a
little bit of miserliness.  I could have ordered two 3T drives, had them on
Tuesday, and rebuilt the RAID in two steps then, *never destroying the master
data*.  Instead, I decided that I'd been careful enough and stuck the old
master drive into the NAS, utterly destroying the only remaining copy of 10% of
my music.  Oops.

I realized my error soon enough.  While the RAID rebuilt, I decided to play a
little music, but whatever it was I picked — I don't remember — it wouldn't
play.  I went to check what had happened, and I found that not only was the
album missing, *so was the entire Compilations directory*.  It didn't take long
to realize that I'd lost a whole lot of music.

Fortunately, thanks to iTunes' database, it was easy to print out a listing of
lost albums.  It filled seven pages, and I went through it, highlighting the
things I was interested in re-ripping.  This probably totals about half of the
lost music.  I imagine it will take me weeks to get it all done.  I'll also
lose all the work I did getting album art and ratings onto things.  (I've saved
the rating data, but getting it restored later will be a huge pain.)

One of the things I noticed missing didn't make any sense.  One track from Bad
Religion's "The Gray Race" was missing.  Why?  It, and no other track, had been
flagged as being part of a compilation.  Bizarre.  While investigating, I
noticed some tracks from their "New America" were also missing.  Now I began to
panic!  Had the "not all files copied" bug caused problems?  Was I going to
find that I was actually missing a huge random selection of all my data?

Kinda.

That is, plenty of stuff seems missing, but when I went back to the big `find`
that I had done on the source data, I find stuff like this:

    ./Radiohead/Pablo Honey/01 You.mp3
    ./Radiohead/Pablo Honey/02 Creep.mp3
    ./Radiohead/Pablo Honey/03 How Do You Do_.mp3
    ./Radiohead/Pablo Honey/04 Stop Whispering.mp3
    ./Radiohead/Pablo Honey/06 Anyone Can Play Guitar.mp3
    ./Radiohead/Pablo Honey/08 Vegetable.mp3
    ./Radiohead/Pablo Honey/09 Prove Yourself.mp3
    ./Radiohead/Pablo Honey/11 Lurgee.mp3
    ./Radiohead/Pablo Honey/12 Blow Out.mp3
    ./Radiohead/Pablo Honey/13 Creep (Acoustic Version).mp3
    ./Radiohead/The Bends/02 The Bends.mp3
    ./Radiohead/The Bends/03 High And Dry.mp3
    ./Radiohead/The Bends/04 Fake Plastic Trees.mp3
    ./Radiohead/The Bends/05 Bones.mp3
    ./Radiohead/The Bends/07 Just.mp3
    ./Radiohead/The Bends/08 My Iron Lung.mp3
    ./Radiohead/The Bends/09 Bullet Proof...I Wish I Was.mp3
    ./Radiohead/The Bends/10 Black Star.mp3
    ./Radiohead/The Bends/11 Sulk.mp3
    ./Radiohead/The Bends/12 Street Spirit (Fade Out).mp3
    ./Radiohead/OK Computer/01 Airbag.mp3
    ./Radiohead/OK Computer/02 Paranoid Android.mp3
    ./Radiohead/OK Computer/03 Subterranean Homesick Alien.mp3
    ./Radiohead/OK Computer/04 Exit Music (For A Film).mp3
    ./Radiohead/OK Computer/05 Let Down.mp3
    ./Radiohead/OK Computer/06 Karma Police.mp3
    ./Radiohead/OK Computer/08 Electioneering.mp3
    ./Radiohead/OK Computer/09 Climbing Up The Walls.mp3
    ./Radiohead/OK Computer/10 No Surprises.mp3
    ./Radiohead/OK Computer/11 Lucky.mp3
    ./Radiohead/OK Computer/12 The Tourist.mp3

Notice that: Pablo Honey is missing tracks 5, 7, and 10; The Bends is missing
tracks 1 and 6; OK Computer is missing track 7.  How long have these been
missing?  I have no idea!  It can't be *that* long, since Ripcord (track 7 of
Pablo Honey) is on my iPhone, which was synchronized from this share.

I have no idea how much data has been lost, nor when, but I am just gutted.  At
least if I'd kept the original drive, I'd be able to go look at something more
concrete than a dump of `find` output to see what was up.  I am definitely
paying for my stupid, pointless impatience.

I don't think the NAS is actually to blame.  If it was, I'm not sure what that
would get me, anyway.  I burned my own bridge, here.  What I need to do next is
finish gettin my data onto the NAS, *and then build a complete backup just in
case*.

Finally:  in the unlikely event that you recently broke into my home,
duplicated my media drive, and now have a backup I don't know about, please let
me know.  I won't press charges.

**UPDATE**: Immediately upon lying down in bed, I realized what happened with the randomly missing files.

While migrating, I saw that the rsync from the master drive was syncing not just (for example) `./music/Bad Religion` but also `./music/Music/Bad Religion`.  Surely, I thought, I had at some point partially duplicated the entire music store within itself.  A quick look showed that the artists and albums under `music` were also under `music/Music`.  I deleted the "duplicate" without a thought and promptly forgot about it until just now.

Today, I noticed a song vanish when I played it.  Later, it turned out that it had not vanished.  iTunes decided to move it.  It moved it from my music library in `/Volumes/music` to the new-style location of `/Volumes/music/Music`.  It has presumably been doing that silently since the most recent upgrade to iTunes.  So, when I deleted the nested Music directory, I deleted, from the master, all files that I'd played since upgrading iTunes most recently.
