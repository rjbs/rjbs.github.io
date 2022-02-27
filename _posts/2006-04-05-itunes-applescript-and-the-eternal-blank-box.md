---
layout: post
title : "itunes, applescript, and the eternal blank box"
date  : "2006-04-05T21:43:41Z"
tags  : ["applescript", "itunes", "programming"]
---
Why is AppleScript so slow?  Whenever I try to do a bunch of things repeated
tasks with it, it feels like it takes forever.  I assume it isn't really
AppleScript per se, but the underlying Apple Events layer.  When I've used
Mac::Glue, it's been about as slow.

I wanted to re-name a bunch of mp3 files, last night.  Actually, I didn't want
to rename the files, I just wanted to get their ID3 tags set properly.  First,
I worked with their track numbers.  I had the files in a play list in order, so
I wanted to iterate over them, giving them sequential track numbers.  First, I
tried iterating over `selection`, but it seems like the `repeat with` loop gets
confused if the list changes as it works.  I got things working quickly,
though.

    tell application "iTunes"
      set num to 1
      set song_list to selection
        
      repeat with song in song_list
        set track number of song to num
        set num to num + 1
      end repeat
    end tell

In my first pass, I used `songs` instead of `song_list`.  It turns out that
it's an iTunes object.  I don't know what.  It's not in the dictionary.  I
don't know enough to inspect the object further.  You can just tell iTunes to
`get songs`, though, and you'll get back "songs."  Huh.

Some of the files I was working with were named like this:

    02 - Your Favorite Song

To get rid of the now-fixed track number, I did something else very simple.

    tell application "iTunes"
      repeat with song in selection
        set song_title to name of song
        set title_length to length of song_title
        set fixed_name to text 6 thru title_length of song_title
        set name of song to fixed_name
      end repeat
    end tell

Other tracks were more like this:

    Your Favorite Band - Their Best Album - 01 - Stupid Spoken Intro

So fixing the titles was simple:

    set the text item delimiters to " - "
    tell application "iTunes"
      set song_list to selection
      
      repeat with song in song_list
        set title to name of song
        get text items of title
        set name of song to text item 4 of title
      end repeat
    end tell

Yeah, I could've done something like that to get all the data, but by the time
I got to this stage, I'd fixed everything else.  This script seemed to update
files at a rate of about one file ever three or four seconds.  Often, when I have to sit through this kind of delay, a modal dialog box pops up with no caption and no status bar.  It tends to appear and disappear just frequently enough to keep me from doing anything useful.

AppleScript continues to be extremely useful and extremely annoying.  I like
Mac::Glue a lot, but I feel like it's often faster to struggle through
AppleScript.  That's probably because it has the dictionary browser, a
compiler that catches a lot of simple problems, and a lot of ways to get
instant feedback.

I just wish it ran faster.

