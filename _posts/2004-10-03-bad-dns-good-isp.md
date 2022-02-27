---
layout: post
title : "bad dns, good isp"
date  : "2004-10-03T21:03:00Z"
---
Well, UltraDNS still hasn't updated their data, so clients are still being sent to my old IP.  You can imagine that I am less and less thrilled with this as the days go by.  The DNS needs an enema. 

Yesterday, I realized that if people were still getting sent to my old IP, I could probably get Speakeasy to move that IP from my old (defunct) loop to my new one.  After all, it's on the same subnet.  I called them, and got bounced around a lot of automated phone menus.  They were dreadful, dumping me frequently into messages that immediately hung up afterward.  Finally, I got into a queue for a CSR.  After about ten minutes on hold, it decided to tell me that they were gone for the weekend.  Why did I need to hold just to find that out?

I gave up and filed a ticket with them, and within half an hour I got an email back that they'd moved the IP.  I made a new tinydns installation, added an IP to the server, and immediately the mail started coming in!  Awesome.

I'm really annoyed with UltraDNS, but at least Speakeasy is just as awesome as ever.  Dealing with this mess has reminded me that I enjoy system administration.  I remember that, when I got my current job, I was really look for sysadmin work, and that programming was just something to do in the meantime.  I guess things turned out alright, but it would be nice to have goofy systems problems to deal with now and then.  Of course, we use Win32 at work, and I don't want any problems with those systems.  They wouldn't be goofy, they'd be hellish.

Anyway, the point is that manxome.org resolves again, so we're getting mail, and all the other little internal services work.  Things seem mucher nicer from the outside, too.  I guess I may now feel driven to do more work on jGal and start getting my backlog of photos up.

