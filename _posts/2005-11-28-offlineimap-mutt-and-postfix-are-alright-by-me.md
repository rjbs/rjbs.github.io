---
layout: post
title : "offlineimap, mutt, and postfix are alright by me"
date  : "2005-11-28T01:09:14Z"
tags  : ["email", "software"]
---
Many times I have complained that Thunderbird and Mail.app are no darn good. They both filled me with hope of reading my mail offline and writing responses that will go out when I'm back online.  Both, too, disappointed.  They were just too hard to use, too hard to configure, prone to data loss, and provided me with generally crappy tools for dealing with my mail.

I just wanted mutt!

Well, I think I may have everything worked out, now.  I had tried, a month or two ago, to get offlineimap working.  offlineimap is a badly-named program, written in Python, that can synchronize multiple IMAP stores, or an IMAP store to a Maildir, and so on.  (The name isn't inaccurate, it's just too generic. It's like calling a mail program "mail" or "Mail.")  I never could get it working, in the past, but I'm not sure why.  I think I may have been having trouble with the Tk interface, but switching to the tty or curses interfaces has made everything run just fine.  I wrote a little lambda expression to filter out my spam-storage folders and now I have a nice little replica of my mailstore on my laptop.  Syncing it takes about a minute, assuming there isn't too much change.  It's about half a gig.  I think that means I've got a gig and a half of spam sitting around.  I should probably find something fun to do with it or just ditch it.

Another problem I'd been having was with postfix.  When I sent mail via sendmail(1) on my laptop, it would bounce, because it couldn't find the hosts for which it was destined, because it was being sent while I was offline.  I knew this would be easy to solve, but my mastry of postfix isn't that great, and I didn't have much need to get it working.  The only things that were bouncing were CPAN tester reports.  Now that I was going to have mutt working offline, this mattered.

John gave me a little advice, and the fact that he was looking at the problem made me want to find the solution first.  We kept finding the same answers at the same time, which was good enough for me: I got my problem solved.  I set up a relay host and set up SASL so that all mail through my laptop's postfix will go through an authenticated relay.  Awesome!  I haven't tested sending mail without a connection yet, but I'm feeling pretty confident about it.  Maybe I'll need to turn on soft bounces.  We'll find out.

I installed GnuPG on my laptop and upgraded it on my workstation -- I was running 1.0.7, which is pretty well out of date.

The only thing left to trouble me, as far as I can see, now, is that mutt on my laptop needs its configuration tweaked just a little bit to be as easy to use as it is on my workstation.  Although it has all its mailboxes set up with the mailboxes muttrc command, I can't cycle through mailboxes with space bar. That's weird.  I'm not sure, either, how to get things set up so that I can type the same thing on either machine to refer to the same mailbox.  I want =lists/perl/p5p to mean INBOX/lists/perl/p5p and just work on both machines, so I can not worry about using the right name.

Oh, and it would be nice to be able to sync just this month spam folder, so I can save to it and then have it go away for the new month... but that's not urgent.

Anyway, I'm pretty happy with the progress I made. 
