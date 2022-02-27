---
layout: post
title : "never bounce mail again (kinda)"
date  : "2009-04-25T17:25:33Z"
tags  : ["email", "perl", "programming"]
---
I am an idiot.

Yesterday, I finally re-installed the always-praiseworth [Mac::Glue](http://search.cpan.org/dist/Mac-Glue), meaning that I could finally update my [mutt](http://mutt.org) address book with [addex](http://search.cpan.org/dist/App-Addex).  I did so, forgetting that I'd (for *some* reason) fixed a bug in my email sorting program *in place* rather than in my git repo.  When I reinstalled my mail config, I started bouncing mail.  I didn't notice until one of the messages was bounced back to another of my addresses.

This is stupid.  I am an idiot, but usually I know how to not bounce mail. "Make sure we don't bounce mail" is practically my prime directive.

One of the ways we do that is that we always use a piece of code, in all our pipemailers, that turns uncaught fatal exceptions into deferrals.  (We also monitor our logs for any unusual deferrals.)  We don't like using pipemailers -- it's the equivalent of using a "vanilla CGI" process instead of a long-running daemon -- but sometimes we do.

If I had been using that code, I would not have bounced any mail.

That code has now been released to the CPAN.  It will show up there soon as [Email::Pipemailer::DieHandler](http://search.cpan.org/dist/Email-Pipemailer), but for now, it's also [in my GitHub account](http://github.com/rjbs/email-pipemailer).  Enjoy!
