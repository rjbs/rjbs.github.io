---
layout: post
title : "busy doing nothing"
date  : "2003-07-19T04:00:00Z"
---
Er, so, I thought I could be really good about keeping up with this while I enjoyed my time off.  Right!

## wednesday

Wednesday I stayed home from work and relaxed.  Gloria gave me Super Mario Advance, the first SMB game for GBA.  It's just a repackaged and regraphicked SMB2 from NES, so it's just fine.  You can play as Toad (he screams a lot) and throw vegetables at ... things.  I had forgotten about the weird door potions. More on all that later at $gs.

I had a roast beef sandwich and got some ice cream with Brian.  While I was out I picked up some JBz for Gloria.  They're these weird jelly bean covered chocolate candies from Jelly Belly.  We both agreed that they're OK, but that Jelly Bellies are better.  In fact, yesterday we bought a good number of Jelly Bellies and ate them at the movies.  More on that below.

Mostly I ripped CDs, futzed around with cleaning up jGal's code, and did a few work-related things.

## thursday

I stayed home from work and relaxed.  Gloria gave me Golden Sun 2.  I haven't played it yet, as I <em>really</em> want to finish GSUN first!  I'm so close to done with it, I just need to figure out how to get to the last battle.  Arrgh! Fortunately, I've got other games to keep me busy until then!

I did more of the same things as Wednesday: some coding, some work, some game-playing, and so on.  The batteries on my GBA died (or maybe that was the day before) and I spent some time deciding whether it was more economical to just buy a GBA SP instead of batteries.  Of course it isn't;  the SP costs about as much as a year's worth of batteries.  So, while I'm sure to be using the GBA for more than a year, the ability to spread out the charge is worth it, for now, especially while I'm working on paying for other things.

Speaking of that, I got my first bill for my Apple Loan.  Well, actually it's just a statement, since nothing is due yet.  I payed off the first 5% anyway. Ninteen same-sized payments left!  I actually think that this and next month will be good ones for hefty overpayments;  August is a three-paycheck month, and while I know that should make a difference, it always does.

## friday

I stayed home from work and relaxed.  So did Gloria!  She doesn't work Fridays. I was shocked to be given a package that wasn't GBA-box-sized.  It was, in fact, CD sized, and it contained Super Puzzle Fighter II Turbo!  Man, I played craploads of that game in the GSU basement at BU.  It was the third-to-last game on the left in the first row of games facing away from the pool tables.  I was a pretty average player, and I think I still am.  I played it for a good while, trying to remember the rules.  It was Good.

I'm trying to get Gloria to try it, but I think it will take some doing!

We did some grocery shopping, had some breakfast, chilled out, had some lunch, and saw Hulk.  It's weird, I think, that the movie is called "Hulk" and not "The Hulk."  Of course, I'm not sure anyone at all leaves the "the" off when talking about it.

It was good.  It exceeded both our expectations.  It wasn't a fantastic movie, but it had a lot of good points.  I didn't think the Hulk looked bad.  I'd heard a lot of smack talked about his appearance, but the CGI was good.  It wasn't the best ever, but he looked right.  The editing was fantastic;  Ang Lee did all kinds of weird stuff with multiple windows and strange cuts, presumably all designed to make it look more like a comic book.  I think it was successful.  Occasionally something made me go, "Wuh?" but for the most part it was very impressive.

### cheshirecat's hdd

Meanwhile, cheshirecat (our server) had been acting very strangely.  It was being sluggish and ... well, just odd.  In the past few months, I'd had a few strange broken links in the filesystem, but I'd figured they were the result of me doing something stupid.  Well, it turns out that the main drive was flaking out.  I had piles of kernel errors about it in dmesg.  Why hadn't I noticed them in syslog?  Well, for some reason my syslog.conf wasn't set to catch them, I guess; it wasn't catching anything worse than warns, and they were probably crits.  I have no idea why syslog was set up like that.  Arrgh!

I tried to buy a replacement at Staples before the movie.  They had a decent deal going on.  Unfortunately, everything that could go wrong with the transaction did.  Apparently the offer was stupidly complicated.  After several minutes of their bumbling, I got them to void the transaction and we saw our movie.  Afterwards, we stopped back at Staples, I got the drive and rebate stuff without incident, and I started moving things over from the bad drive to the good one.

Strangely, I found that drives have different apparent geometry when put on ide0 and ide1.  The old, bad drive was showing partitions not ending on the cylinder boundary.  I figured that was a symptom.  When I moved the new drive, though, I found the same thing.  Google confirmed that others had seen this: the drive would look different on different busses.  I'm left wondering whether this was the real problem with the old drive to begin with!  I'll need to test it.  In the meanwhile, I left the new drive on the secondary bus.  Everything seems fine, and I'm moving our music onto it for faster access.

### dinner and foodtv

We decided to skip the gym and just have a light dinner.  I had a roast beef sandwich, finish the sammich fixin's.  It was good.  After dinner we watched some FoodTV, which was also good.  Tyler Florence made some chicken (meh), Bobby Flay cooked for firemen (meh), and Tony Bourdain and his brother went to France.  That was good.  They didn't do as much eating and weird-food-finding as he usually does; it definitely seemed to be just something he wanted to do, and it was good to watch, so I didn't mind.  His brother looks <em>really</em> French.  Gloria said he looked like Gerard Depardieu with a smaller nose.  It's true.

### jacob

I have a new nephew!  Going by my entry in the pool, he was born too early and too light, but I'll let it go.  Carmita was in labor (or at least discomfort; all the details aren't in) for a very long time, and they finally performed a C-section.  Jacob Arthur looks like a normal human baby, which is good.  I'm hoping for more information soon.

## saturday morning

Woop!  Gloria woke me up between her morning exercise at home and her morning trip to the gym.  (Wuh!)  She gave me a box quite a bit larger than previous boxes, containing ... a Virtual Boy!  Fear it!

It works perfectly.  It came with Wario Land and Tennis, both of which are A-OK.  It's such a silly fun little toy.  I kind of hope that there's a Virtual Boy II sometime in the future!

We went out and got breakfast at Moravian.  It was disappointing for both of us.  We got quiche, and it was bland and kind of mushy.  I also got some wings; they were lame.  Afterwards, we got some ice cream, and that was good.  I got some books while at Moravian, taking advantage of my 15% birthday month discount.  I picked up Of Human Bondage, Democracy in America, Fast Food Nation, and (mostly for Gloria) Everything's Eventual.  I want to read all of them, but I'm not sure when I'll get to it!

