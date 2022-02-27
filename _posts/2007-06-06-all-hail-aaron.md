---
layout: post
title : "all hail aaron"
date  : "2007-06-06T12:26:01Z"
tags  : ["perl", "programming"]
---
Once again, Aaron Straup Cope has written code so I don't have to.  Last time, I wanted to back up my bookmarks from del.icio.us, so I didn't feel paranoid that they might go away and take my bookmarks with them.  (This was before I switched to Rubric.)  Because Net::Delicious existed, I was able to write Net::Delicious::Simple on top of it, taking only a few minutes instead of hours of toiling with XML.

I found a couple little problems at the time, and Aaron fixed them lickety split.  When I said, "gosh, where are the tests?" he said, "Oh, well, I can't publish them because they use a specific account, but here they are if it will help!"  It went a long way to making me see that this was a nice, stable, tested piece of code.

A few months ago, I used Flickr::Upload to convert all my old jGal galleries to Flickr photo sets, which involved uploading about two gigs of photos to Flickr. Now, I still had these photos as backed up jGals on DVD, and all the new photos I uploaded were in iPhoto, but now new photos were only getting descriptions and titles on Flickr.  Not only that, but now they got tags, annotations, comments, sets, and other data that only got created after uploading to Flickr. If Flickr went under, I'd be out of luck.  I needed a backup of all the useful information I was now entrusting only there.

I tried using Net::Flickr::Backup a few months ago, but failed, saw something shiny, and went to bed.  There was a new upload recently, though, and seeing it in the CPAN RSS feed made me want to try again.  Within twenty minutes, I got things going on my laptop.  Getting it to work on my backup server was a little more painful, but I got it running overnight and went to bed -- but first I filed some bugs about the snags I'd hit while doing so.  By the time I got back to my terminal in the morning, Aaron had addressed all the tickets and made a new release.

Thanks, Aaron!  You have dealt with XML so that I don't have to.  What more could a guy ask for? 
