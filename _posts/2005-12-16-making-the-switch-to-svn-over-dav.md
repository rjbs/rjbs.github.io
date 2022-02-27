---
layout: post
title : "making the switch to svn over dav"
date  : "2005-12-16T03:14:23Z"
tags  : ["subversion"]
---
Well, actually, I don't plan to switch.  I don't think I have any real need to, although I guess I'll find out if someday my client starts complaining that I'm able to see or create or modify some file that came in through WebDAV.

I've been saying for a long time that I'd set up svn_dav so that I can have more people work on some of the code I've got in my repository.  I really didn't want to have to give them all system accounts, but I wanted to make it possible to give out access.  Shawn S. said he'd help me set things up, which I knew would be stupidly simple, but it's useful to have someone there to say, "No, if you do that you will waste several hours."

Well, I kept putting it off, and finally, despite the fact that Shawn was busy with some lame excuse like "spending time with his family," I sat down to get things fixed.  He was on IRC for the first half hour or so -- long enough to react in horror ("Upgrade! Upgrade!") when I said I was running Apache 2.0.47. (I installed it in July '03.)

I went through a few phases of recompiling things as I realized that I needed to tell Apache specifically that I wanted DAV, then I had to recompile svn for the new Apache, then I had to recompile Apache for SSL, then I had to recompile svn to build SSL into Neon.  Bryan gave me a simple but super-useful little script to build a cert.  The Apache documentation on getting a self-signed certificate built and in use by an HTTPS server is either hidden or horrible.

Eventually, I got everything working as I wanted.  It took a little longer than it might have, but mostly because I wasn't being very focused.

I also upgraded my SVN::Web installation, which wasn't very exciting.

I'll probably add a few more of my repositories to my svn_dav service, at least partially, at some point.  I'd like to make some of my config files available, but not others.  My mutt configuration might be a useful starting point for some, but my address book file is private, etc.

I also need to decide the simplest way to make the repository-less root of my svn HTTP server serve up a nice little page.

Anyway, now I can give commit rights to a few people who can then maybe write some patches for me.  Would that be keen? 
