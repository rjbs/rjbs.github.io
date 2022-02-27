---
layout: post
title : fixing my playlists with applescript
date  : 2005-06-01T01:10:05Z
tags  : ["applescript", "itunes", "programming"]
---
So, some time ago I ranted about how happy I was with my Radio RJBS playlists. Basically, I have a playlist that's always eight hours of three-star music and sixteen hours of four- or five-star music.  It's all "regular music," which by my definition is something like "not a musical, not noise, not spoken word, not classical."  (My "Classical" genre, I admit, is really more like "music composed before 1900.")  All the songs are selected by recency of last playing: less recently played songs are chosen over more recently played songs.

At some point, I realized that because I had sometimes gone on binge days of rating single artists, I ended up with that artist's last play dates clumped together.  For some reason, I decided that the best way to fix this was by clearing the last played dates.  This wasn't a horrible idea, since iTunes seems to have gotten over its old problems with sorting.  It used to be that given ten songs that couldn't be sorted by your given criterion, it would sort by name.  I believe it now picks a distributed sample, but I haven't bothered really researching this.  It just seems better than it used to.

Anyway, given that I have a huge amount of certain artists, they started showing up in big clumps again.  I was hearing nearly all Elvis Costello, DEVO, and Tom Waits.  This wasn't so bad, but it meant that I'd always have these songs clumped together.  (To some extent, this problem is fated to exist, as I've defined the playlists, but it needn't be so bad.)

On the bus on the way home, I brushed off my AppleScript and put a script together to distribute a selection of songs randomly across a given period of time.  My first pass at this was hilarious, because I couldn't remember the silly AppleScript way to get a random number, and settled for building a list and using "some."  It was great.

Anyway, here's what I settled on:

	set earliestDate to date "Tuesday, March 1, 2005 00:00:0 "
	set latestDate to date "Monday, May 30, 2005 00:00:0 "
	set totalRange to latestDate - earliestDate

	tell application "iTunes 4.8"
		set selectedSongs to selection
		repeat with song in selectedSongs
			set played date of song to earliestDate + (random number from 1 to totalRange)
		end repeat
	end tell


