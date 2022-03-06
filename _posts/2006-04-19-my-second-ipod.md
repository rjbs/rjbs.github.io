---
layout: post
title : "my second ipod"
date  : "2006-04-19T03:22:04Z"
tags  : ["ipod"]
---
So, apparently there was some kind of controvery with the earlier iPods'
battery life.  Apple advertised eight hours and they only lasted six, or
something like that.  Maybe the battery replacement plan fitted in.  All I
really know is that I got a class action form, filled it out, and then got a
gift coupon.  It was for $50 on Apple branded hardware from an Apple outlet.

I really didn't need anything specific from Apple, and I didn't feel like
waiting to put it toward a MacBook.  I decided I'd either get a refurbished
Shuffle or an AirPort Express.  The Expresses are really neat:  we have one at
work, and my father has one.  I just didn't have much of a use for one.  I
didn't have much use for a Shuffle, either, but it would cost less and I had
some things I could do with it.

When the Shuffle first came out, I made an iTunes playlist to simulate life
with a Shuffle.  It was 512 megs of randomly selected good music, something
like this:

    Shuffle
      playlist is "Good Music"
      playlist is "Not Recently Played"
      time is less than 10:00
      limit to 512 MB select by least often played

    Good Music
      playlist is "Regular Music"
      rating is greater than 3 stars

    Not Recently Played
      last played is not in the last 3 weeks

    Regular Music
      genre is not X (for a long list of X)

These kind of nested playlists are a fantastic tool, and one of the reasons I
can't move to a non-iPod player.  (More on that problem another day.)

Most of the time I listen to my 3G iPod, I listen to "Radio RJBS," which is a
bit more complicated, and which I've [talked about
before]({% post_url 2004-12-01-itunes-light-and-dark %}).  Sometimes, though, I listen
to Shuffle instead, because it gets a different distribution of songs.  It's a
good playlist.

I ordered a gigabyte Shuffle, and it arrived today.  I loaded it up and I'm
listening to it now.  It sounds just fine, even though I haven't yet picked up
any new Shure or Etymotic headphones as I've been told I should.

Since I'm using a half-gig playlist on a full-gig Shuffle, I had plenty of room
to muck about.  I'm using it as a keydrive, and it's finally one with enough
space to actually use for something.  All my previous keydrives either crashed
my PowerBook (because they were crap) or were just too small for any real use
beyond holding a document or two.  The rjbShuffle holds all my essential
installers for Win32 and Mac software (in case I have to use someone else's
computer) and a checkout of my personal Subversion repository for my important
documents and configuration.

I wanted to add the updater to my regularly-run backup/synchronization script,
and it turned out to be boring and easy:

    #!/bin/sh
    # ~/bin/shufsync

    VOLUME=/Volumes/RJBSHUFFLE

    if [ ! -d $VOLUME ]; then
      echo the rjbShuffle isn\'t mounted; skipping
      exit
    fi

    rsync --delete -rcv /Users/rjbs/Documents/essentials $VOLUME

    for repo in $VOLUME/svn/*; do
      svn update $repo
    done

The only weird thing was that I needed to pass -c to rsync.  That tells it to
check the checksum on each file.  Without that, it always synced everything.
I'm sure this is caused by the FAT filesystem on the Shuffle, but I'm not sure
what the exact cause is; maybe it's some sort of stupid timestamp thing.  It's
slower because of the -c, but I don't think I'll ever be in a big rush when
doing this.

I'm not sure what I'm going to put in the remaining 300-some megs.  I might
save it for future use, or I might start calling more software "essential."  It
would be really great if the million jillion "keep track of latest versions"
sites made it simpler to write a five-line script that said, "check if these
packages have been updated.  If so, replace my archived copy with the new one."
(Probably better: "If so, download the new one and send me an email."
Otherwise, you end up losing the last version to support your favorite feature
and you have to send some angry email.)

