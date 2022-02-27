---
layout: post
title : "audible.com itunes stupidity"
date  : "2008-02-04T14:05:09Z"
tags  : ["security", "software", "stupid"]
---
Ages ago, I got an [Audible](http://audible.com) membership.  Three days each
week, I walk about half an hour to the bus and about half an hour home.  For
most of the year, I can spend that time reading a book.  In the winter, though,
it's just too cold.  My fingers freeze, even if I read with one hand in my
pocket and switch back and forth.  Audible sells audiobooks, and I can listen
to them on my iPod while I walk.  They have a subscription model where get one
or two credits each month, and each credit can be exchanged for one book.
Sometimes, this is an okay deal: you pay $15 per month and get a $25 copy of
the abridged version of a popular novel.  Sometimes, it is a great deal: you
get a $40 copy of a twenty-five hour classic.

I cancelled my old membership when winter ended, but my sister got me a gift
certificate for Christmas (because I'd asked for one) and I signed up again.  I
got in on a promotional rate of about $7 per month.  This week, I downloaded
the 41 hour unabridged audiobook of Gibbon's Decline and Fall of the Roman
Empire, volume one... for $7.

Audible lets you download files in their `.aa` format, which is basically an
MP3 wrapped up in some DRM.  I'm not a fan of restricted media files, but
Audible has such good deals that I don't mind.  iTunes has a plugin that lets
you authorize your computer to play your Audible tracks.  Ever since I
rejoined, it's been giving me grief: I try to play a track and I have to
re-enter my password.  After that, all my Audible files will play until I quit,
when I have to re-enter my password again.

It's not some easy six character password, either, it's a big monster generated
by 1Password.

I was concerned that I'd broken something in my account, the way I broke things
(I think) by stripping PPC and certain languages from Mail.app.  I hadn't
touched anything since I reinstalled, though!  Why was this happening?

I had a heck of a time finding information on this until I stumbled across
[this blog post](http://ursecta.com/wp/2007/12/barely-audible/) that pointed
out the undisclosed fact that when you authorize iTunes to play your Audible
content, *you must be logged in as an administrator*.  I have no idea why.
Maybe it stores your token somewhere in `/Library`.  I am pretty damned sure
that no matter what the reason, the reason is stupid.

Anyway, I'm pretty annoyed at Audible about this, but not annoyed enough to
write them off forever.  I mean, even at their normal rate, $15 for a forty
hour audiobook is a pretty great deal.  Maybe I'll even stay subscribed through
the summer, this year.

