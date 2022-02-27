---
layout: post
title : "all mail software sucks (mail.app doesn't suck less)"
date  : "2005-05-26T01:29:46Z"
tags  : ["apple", "email", "software"]
---
I decided that my next book would be Orthodoxy.  I started in on it ages ago, while we waited for Krispy Kreme to turn on their "hot" sign.  (They never did.)  The book didn't really keep my interest, but it's fairly short, and I want to read it so I can tell my dad why I disagree with it.  I mean, I may not be but a few dozen pages into it, but it seems pretty clear from the first few pages that I will disagree with it.

Well, anyway, I didn't read it at all today.  I slept just about all the way in, and on the way back I thought, "Hey!  I'll write emails to the people at IQE to whom I said I'd write emails."  This seemed like a good thing to do, even if I knew it was just a way to avoid Chesterton.

I fired up Mail.app, thinking, "Hey, it has an offline mode.  It will happily save my drafts until I get home and go online."  Oh, folly of my youth!

I wrote about ten emails, none of them particularly brief, and saved them in my Drafts folder.  I was actually pleasantly surprised that the battery lasted the whole trip, and still claimed to have two hours of life left upon arrival.  I'm not sure if it's Tiger, the fact that I turned off the wireless card, or if the time remaining indicator was just a lie.  Anyway, I spent nearly two hours composing email, and when I got home I sat down to send it.

The first message seemed to go just fine while Mail.app started to sync folders.  Then, strangely, it complained that there was "no such folder."  It didn't tell me what folder it wanted, or what was going on, it just complained. Then it went to the spinning pizza of death.

After killed Mail.app and re-opening it, I found the bodies of all my drafts missing.  "You must take this folder online," it told me.  I synchronized my folders, which happily cleared up that error: it deleted all my drafts.

Fortunately, I had feared just such an occurance, and before restarting Mail.app I had found the .elmx files in ~/Library and saved copies.  I was able to open these in Mail.app and copy the bodies to send them.  What a waste.

I think the core problem was that I have my mail accounts set to store drafts on the server.  Why can't Mail.app sanely handle the condition where I'm saving drafts while online, though?  If I hadn't saved that mail, it would've all been lost!  Only my suspicion of Apple's ability to make something "Just Work" and my rudimentary knowledge of where Mac apps store things let me avoid utter fury.  In other words, if I was my dad, I would've had to curse and throw things.  (Actually, I don't think he throws things in anger very often.)

I have long claimed that GUI mail clients just don't do anything that I need them to do.  Every now and then I feel that I have been too harsh, and I try to use one, and I am left irritated.  Tomorrow-ish, I will persue the proper solution: set up mutt and postfix on my laptop properly to queue mail for later delivery. 
