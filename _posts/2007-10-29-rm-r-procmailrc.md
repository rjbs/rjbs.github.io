---
layout: post
title : rm -r ~/.procmailrc
date  : 2007-10-29T02:54:41Z
tags  : ["email", "perl", "programming"]
---
I first started using procmail around 1993, I guess, when I got my first access to the Internet through my dad's alumni account at Lehigh University.  The only programming language I knew was C (and things that don't count, like Logo and BASIC), so procmail was like magic.

Of course, I also didn't know very much about email, and my needs were few.

So, now I get a few hundred pieces of legitimate email every day, and a few thousand pieces of spam.  I need to keep my mail organized, sequester spam, and never lose mail that I wanted.  If I do lose mail that I wanted, it needs to be easy to figure out where it went.

I've slowly grown my procmailrc file over the years, tweaked my SpamAssassin config, and handed out a lot of different addresses at various domains.

I really don't like procmail, because while it's fine for doing really, really simple filtering, it's just insanely painful to use for complicated filtering. It has really esoteric features (see the man page for procmailsc, sometime) but its boolean logic and flow-control structures are a joke.  Every time I had to change something in my procmailrc, I grumbled and thought about replacing it with a proper program.

Every time I tweak my SpamAssassin rules, I think about how I work for a company that offers really good spam protection (and lots of other benefits) that I don't take advantage of, largely because it would be a hassle to keep using my other weird settings.

Friday, I bit the bullet and started making the big change, moving most of my email to Pobox and all of my local delivery filtering to an Email::Filter script.  It's pretty awesome to see procmail gone, and to start to benefit personally from Pobox features that I've written or improved.

It's also great that now I can clearly see specific things that I don't like about Email::Filter and great ways that we can improve Pobox.  The actual changeover to Pobox was a pain in my butt, because of my quirky configuration. Now that it's done, I'm really happy with it, and I look forward to learning a lot from the work I have yet to come -- and to having new things to gripe about. 
