---
layout: post
title : plodding along
date  : 2006-01-31T05:05:55Z

---
I've got nothing much to report: life continues on, and is pretty much unexciting and acceptable.

I just left the book club; tonight we were discussing the first book I've suggested, "Augustine of Hippo" by Peter Brown.  I read it twice in college, and I really enjoyed it both times.  I reread a little more than half of it before the meeting, and it was still a very enjoyable book.  It was a little longer than most of our books (about 450 dense pages), and no one had finished it.  A fair number of people, in fact, hadn't even started it.

I was a little disheartened, but not surprised; this meeting had been pushed back to allow more people to finish (and start) the book, and some people complained that it was too long, or that it was a "Jesus book."  In reality, though, I think it went pretty well.  Everyone who had read some of the book seemed to have found it interesting.  Jennifer thought that Brown was a bad writer, but I only agreed with one part of that: he used, way too, many commas.

I suppose that the better drop-in replacement for Augustine of Hippo might have been Augustine's own Confesions, but I think that I assumed, at the time, that everyone would have read it already.  I don't know why I would have thought that.

I think the discussion went well, at any rate.

Paul made a lot of tasty food, and I ate too much today.  Fortunately I was forward-thinking and had a salad for lunch.  It was a salade Nicoise, one of my favorite kinds of salads.  To its credit, it contained anchovies, which I've seen left out of American salad Nicoise before; to its detriment, the tuna in it was far too cooked, as if it had come from a can.

Louis gave his suggestions this evening, and for the meeting after next we will be reading The Spy Who Came in From the Cold.  I am expecting great things. For the next meeting we're reading Steven's suggestion, The Amulet of Samarkand.  I am keeping my expectations low, for that, for now.  I may well be pleasantly surprised, though!

Work was not very productive today, although I think I closed a number of little bugs that needed closing.  This weekend I continued my war on Bugzilla, and made a few little changes that may help it become yet more useful.  The one change I wasn't able to complete was the creation of a little Subversion/Bugzilla bridge.  Because of the complexities of our Perl environment, I couldn't just do it.  Bugzilla's own uglieness didn't help.  Is it too much to ask to think that one could, roughly, write: Bug->get(123)->add_comment($string) ?

I also encountered some annoyances, unrelated to Bugzilla, with superclass methods.  Simon suggested SUPER.pm would solve my problems, but at first pass it didn't.  That's not a big deal, because I can accomplish what I wanted to accomplish, slightly less correctly, using a simpler method.  I feel like I'm making good, steady progress on making Listbox better, which is a continual source of satisfaction.

I complained, the other day, about the death of the filesystem on my external firewire drive.  I downloaded a program called Data Rescue II, which someone suggested would help.  Lo and behold, it listed the contents of the filesystem and tempted me to restore files -- but then said I'd need to pay $99 if I wanted more than a single five megabyte file.  It just wasn't worth that much to me, so I was about to quit, when I noticed that the drive had now become mounted.  I think this was probably a coincidence, but frankly I didn't care. I copied nearly everything from the drive (one or two files gave i/o errors) and build a new filesystem.  Time will tell whether this was a hardware or software failure.

I'm having another weird failure, this one on cheshire.  Once I offloaded a the bulk of my recovered data to that machine, I realized that I had very little free space left: just about three gigs, out of one hundred.  The annoying truth is that I had about fifteen gigs free, in other partitions, but I didn't have enough space to actually reorganize my data to make that space useful.  I thought that my external USB enclosure contained a 120 gig drive, which would have made it simple to reorganize by cannibalizing it.  Unfortunately, once I opened it up I found that it was just an eighty gigger.  Rather than spend a long time solving the Towers of Hanoi with cpio and fdisk, I gave in and finally ordered new drives.

For a long time I've been thinking about getting new storage; my initial plan with cheshire was to build a RAID5, but I settled on a plain old SLED setup, and it never really caused my any grief.  I thought that I'd wait until I could do that, this time, but prices still aren't where I want them to be, and I've got better things to use money toward than self-indulgent hardware purchases. I didn't even bother with SATA, because I knew it would be an annoyance to set up a new kernel, and that I'd probably end up feeling rushed to upgrade to a 2.6 kernel.  Instead, I ordered two 250 GB drives from Seagate, for just over $200.  Once they arrive, I'll set them up with LVM and a RAID1, and that should last me for a good long time.  I'm excited about doing something new with cheshire; it's been unchanged for ages, now.  That's mostly a nice thing, but doing different things is good for me.

When I got to work, today, I tried to compile a kernel with RAID1 and LVM support, but the kernel compile kept dying.  Rather than try to solve it while at work, I put it aside for now.  I'll look at it Tuesday or Wednesday, or maybe on Thursday night while Gloria's teaching.

I'm even thinking about totally rebuilding cheshire with the newest Slackware, to clear out any accumulated cruft.  I might even switch to Postfix (from qmail) and some sort of lightweight httpd (from Apache); the only issue with leaving Apache is that I've grown to really like mod_svn for Subversion access.

Mostly I'm just looking forward to reorganizing my drives to make more sense. 
