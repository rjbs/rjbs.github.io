---
layout: post
title : "smarkmail: now almost usable"
date  : "2008-02-25T02:59:14Z"
tags  : ["email", "perl", "programming"]
---
A while ago, I [wrote about smarkdown]({% post_url 2007-04-09-smarkmail-sending-multipart-alternative-html-mail-from-mutt %}), my little program that "upgrades" email from plaintext to multipart alternative mail with plaintext and HTML alternatives.

I finally got around to updating it to handle messages with attachments.  I punted on a few problems, like deciding who gets HTML mail and who doesn't (everyone does) and how to deal with deficiencies in Email::Send (I just use the ever-unreleased Email::Sender).  A few more problems will require that I figure out how to abuse mutt some more.  Smarkdown should really alter the message before mutt sends it to sendmail, because then mutt can still let me digitally sign the message.  Unfortunately, none of the `send-hook`s in mutt seem to make this possible.

Anyway, I'm not quite ready to use this all the time, yet, but now anybody else can, because [it's on the CPAN](http://search.cpan.org/dist/App-Smarkdown/). It relies on Email::Sender, which isn't, but [Email::Sender is in Subversion](http://emailproject.perl.org/svn/Email-Sender/trunk/), so there's that.

I'll hopefully be able to use this as some minor reason to get Email::Sender, and related code, released.
