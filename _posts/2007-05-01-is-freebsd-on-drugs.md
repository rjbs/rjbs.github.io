---
layout: post
title : "is freebsd on drugs?"
date  : "2007-05-01T14:00:25Z"
tags  : ["perl", "programming", "stupid"]
---
Gabor recenly posted some reports about what version of what CPAN dists were in
what OS distributions.

I thought I'd have a look at one of the clusters of modules I maintain in the
Email:: namespace.  I headed to [the E
section](http://www.szabgab.com/distributions/E.html) and I saw something
bizarre.  Why does FreeBSD change so many version numbers?  Email-FolderType is
distributed as 0.8.12 instead of 0.812.  Does that mean they only use X.Y.ZZZ?
No, because Email-Folder 0.852 is distributed as 0.85.2.  Does that mean they
just require some form of three-part version?  I don't think so, since
Email-MIME 1.855 is distributed as 1.855.

Can someone tell me what the hell they're doing?

