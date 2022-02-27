---
layout: post
title : "dear lazyweb: looking for a little nas/router combo"
date  : "2009-04-05T17:38:37Z"
tags  : ["hardware", "lazyweb", "programming"]
---
I'm getting ready to write up events of the Birmingham QA Hackathon.  One of
the outcomes was that I ended up really wanting the device I am about to
describe.  Bear with me.

On the first day of the event, we discovered that the wireless at the venue was
totally worthless.  There was a wired computer, but we had bizarre problems
trying to use its wired connection to share.  Several man-hours were lost in
these endeavors.  Instead, for the first day and a half, we did a lot of USB
keystick trading.  Once again, Git saved the day.

I'd talked about setting up a Linux virtual PC with Samba set up so everyone
could have a shared space to push to and pull from -- and everyone could have
read-only access to everything, to make remotes easy.  David Golden went ahead
and did this, using his own already-Ubuntu machine.  In the end, we didn't use
it.  We found out that *my* laptop worked with the wired connection, and I
became the router.  (The theory was that I was the only person with GigE to
give it a try.) This worked just fine... well, until GitHub was unavailable for
nearly a whole day.  Oops!

At any rate, it occurred to me that it's very, very rare that a conference or
hackathon has a great network connection.  Last year at Oslo was probably the
best I've ever seen, as we were hosted by a tech company and worked in their
office.  Apart from that, it's usually hit or miss.  At a "normal" conference,
this isn't the end of the world.  For one thing, I'm usually in the US and I
can use my EVDO modem.  For another, network access is just for goofing off.

At a hackathon it's a bigger issue.  Everyone wants to share their work as
quickly as possible, and the repository is usually remote.  Git makes it easy
to share across an intranet, but generally we don't have our laptops set up to
act as publishing git servers.  Since the two QA Hackathons have been in
Europe, I've also had to deal with the fact that neither my iPhone nor my EVDO
modem were of any use.

I realized that the perfect hackathon appliance would be a little hunk of junk
that you can stick in your carry on.  It would be a wireless router with the
ability to share an attached USB drive.  One quick solution would be to use an
Apple Airport Extreme, but there's a big problem -- and I don't mean the price.
Every time you add or alter a user on the Airport, you have to reboot the darn
thing.  Ugh!

I figure these are the requirements:

* provide each user with rw access to his own space and ro access to others
* adding or changing settings (users) should not restart the device
* it should be able to plug into a wired network and share it wirelessly
* it should be able to join a wired or wireless network as a normal node
* it would be pretty cool to support gitjour
* supporting some kind of local dyndns wouldn't be so bad, either

I thought about running a FreeNAS virt on my laptop, but if the machine is
operating in "share a wired connection" mode, you're stuck sitting near the
outlet.  That's why you really want something you can plug in and leave more or
less unattended.

I only would use this thing a few times a year, so it needs to be cheap.

Right now, contenders seem to be the [Marvell Linux
wall-wart](http://www.linuxdevices.com/news/NS9634061300.html) (which would
need external storage and wireless) or a [fit-PC](http://www.fit-pc.com/), or a
Asus Eee PC laptop.  These are all a bit more than I would want to spend,
though.  For me, the best price would be about $50 - $75.

David found an [ASUS wireless
router](http://www.newegg.com/Product/Product.aspx?Item=N82E16833320023) with a
USB port, and it can run DD-WRT -- but I don't know much about DD-WRT or what
it can do.  How does it compare to FreeNAS, for example?  It looks, for
example, look it has no NAS component.  That's a big bummer.  Flashing a cheap
device with some stock OS to get a web-configurable NAS router would be
"turnkey enough" for me.

So, all I wonder is: who already has something like this working, with an
easy-to-reproduce setup?  Suggestions?

