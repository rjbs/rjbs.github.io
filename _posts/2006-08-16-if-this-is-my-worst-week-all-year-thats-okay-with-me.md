---
layout: post
title : "if this is my worst week all year, that's okay with me"
date  : "2006-08-16T21:48:15Z"
tags  : ["hardware"]
---
Where have I been?  The pits!

Last week was rough.  That's a really relative judgement, as my life remains pretty darn pleasant, but the past week or so has had me in a pretty grouchy mood.  Last Sunday night my arm started to itch.  By Monday morning, it seemed like it had been food for quite a lot of mosquitoes.  By Tuesday evening, it was pretty clear that I'd actually gotten poison ivy.  This time, I used calamine lotion instead of rhuli gel, and I think that was a good choice.  It still itched a lot, but the lotion cut it from a major distraction to a minor irritation.  The major distraction was the nasty blistering and scabbing, which revived an old question in my head:  is there a proper term for the fluid that oozes from urushiol blisters?

Also on Tuesday evening, my laptop stopped working.  I was lying on the floor in the living room, poking at some code, as is my manner.  Actually, I was getting ready to merge in a branch of William Yardley's work on the BounceParser for a release.  Suddenly, OS X stopped responding.  This had happened two or three times before, so I waited a little while and rebooted. When the machine restarted, I just got a grey screen.  I rebooted again, holding cmd-V for a verbose boot, but got nothing.  I reset the parameter RAM (or whatever they call it these days), took out the battery, burned incense, and sacrified to my dread lords.  Things improved: now I got a flashing question mark on a folder and a clicking noise.  When booted from the MacBook install disk, Disk Utility couldn't see any SATA devices at all.

I was going to take it to Double-Click, but they always seem put out when asked about providing warranty service on machines not purchased there.  (I'd like to buy my hardware with them, but placing an order on release date seemed easier on the web; I guess it wasn't, really.)  I called Apple and got a really helpful, competent Canadian who helped me set up my return.  "A courier will be by today or tomorrow -- probably today -- with a box.  You can pack it up and give it right back to the courier."  I should have known I was doomed when she confirmed that it would be DHL, the worst shipping company in the country. (Gloria suggests that they may be the worst in the world.)

The courier arrived the next day.  He handed me the box and I said, "It'll just take me a minute to pack this up for you."  He told me he didn't have time and, when I said I'd been told I could hand it back to him he just shrugged, turned away, and walked out.  It took just about a minute to pack the laptop up, leaving me with plenty of time to stew.  I called DHL to arrange pickup and prepared to spend my evening, from 14:00 to Whenever waiting for the guy's return.  When he did come by, he told Gloria (whom I let handle this transaction, lest I say something rude), "You know, I wasn't lying before; I didn't have time!"  I don't know who was at fault here, but excuses just made me grumpier.

I use my laptop as my main workstation for everything, including work at the office.  With it missing, I think my productivity must have dropped to less than 50% usual, which was really frustrating.  I got Gloria's PC's Ubuntu installation into a state where I could use it, but it still made work feel weird.

I got my machine back yesterday, and spent a lot of the day reinstalling things; it came with OS X installed, but on a case-insensitive filesystem.  I reformatted, installed the OS, installed its updates, installed all the stuff in my "essential Mac software" archive, and restored all of my backed up data.

My backup script, which I've used for a few years now, basically rsyncs essential data between three servers.  I like the script and will keep using it.  The problem is that there's a lot of stuff it doesn't back up.  Some of those things would be annoying to keep track of (giant files that I'm just holding on to until I read/view/hear their contents) and some I just haven't sufficiently cataloged (Firefox profile, iCal, modem dialing scripts).  When I moved from my PowerBook, I used my external drives for temporary storage, losing their backup contents.  Since then, I hadn't done any full backups, which I'd been doing in an obnoxious and slow way.  The net result is that I lost about 18 months worth of Address Book and iCal updates, several gigs of ebooks (some out of print and quite hard to find), and the modem script that had managed to get DUN working with my RAZR.  I guess I'll probably find a few more things that I lost.

I was able to sync phone numbers back from my phone, so my Address Book losses are more tolerable than they might have been.  It was funny to see iCal and Address Book go back to thinking I worked at IQE.  It would have been nice if iCalX, which I use, was more like a remote canonical storage area, and not a remote mirror.  That would've made restoring my old events easier.  Maybe iCal Server will start showing up on free installations sometime soon.

The biggest lost was those ebooks, and whatever else may have been in ~/tmp that I can't currently recall.  I had quite a lot of the original Paranoia rules, and I have no idea how I'll go about replacing them.  They're the thing I most wished I'd had backed up.  Why hadn't I?  Well, my ebooks directory was about 5 gigs, just large enough to not fit on one DVD.  Rather than make two, I just kept putting it off.  Oops!

I'd read a lot of good reviews of SuperDuper!, a OS X backup utility. Actually, I'd recommended it based on the reviews, but I wanted something more solid for my own decision to use it.  I spoke with some people I trust, including pudge, who said that it was pretty keen.  I shelled out the $28, and I've backed up with it a few times already.  It was a good $28 to spend.

So, apart from some data loss, life is back to normal.  I'm sure I'll notice more missing data or lost preferences over the next few weeks, but that's life. (Ugh, I haven't yet installed CPANPLUS or my usual tools.)

In other news, Gloria and I have started to actually look at houses.  We tried to see one on Tuesday, but there was miscommunication between realtors and we couldn't get in.  On Wednesday, we went to see a promising place on Second Street, but it was a big let down.  Almost every wall would need replacing, and there were drop ceilings in one of the bedrooms on the second floor.

We'll see some more tomorrow and Thursday.  I'm hoping we start seeing some things we like more, but I think I can be patient, for now.

I think there were some other things afflicting me last week, but I can't recall them, and I think it's better if I don't struggle to do so.  Instead, I will get back to enjoying my restored computer by doing some work. 
