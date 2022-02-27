---
layout: post
title : openid delegation is easy!
date  : 2007-10-14T21:06:10Z
tags  : ["openid", "perl", "ppw2007"]
---
I'm at the Pittsburgh Perl Workshop this weekend, giving a few talks and listening to a few others.  I'll write more about that later.  Here's the coolest thing I think I've learned so far.

OpenID is a authentication system that lets you have something like single sign-on for the whole wide Internet.  It's not a single service, but rather a standard to adhere to, so it's not like MS Passport, in which MS held your keys, and so always knew just what you were doing.

Kirsten Jones gave a talk called "OpenID is the New Black."  She talked about how OpenID works, how you'd use it to authenticate users, and how it's really great.  It is!  I've wanted to get set up with it for a while, but I didn't really like the idea of being attached to any of the existing OpenID providers. That is, I didn't want to have to establish my username everywhere as rjbs.livejournal.com or anything like that.  I figured I'd either set up an OpenID provider for manxome.org (ugh) or wait to see if Pobox.com will provide OpenID.  Neither option made "open id today" seem likely.  Kirsten's talk reminded me how much I wanted to get OpenID set up.

I mentioned this on IRC, and Jon Rockway said, "You can just delegate any HTTP URL you own to another provided.  That's what I do."  He couldn't remember just how it worked off the top of his head, and I was hungry for it, so I did some googling.

It's right there in the spec, although it doesn't seem well advertised.  I didn't see it talked about much, even though to me it's pretty killer!  It lets you have your own domain use anybody else for authentication, and you can swap out your OpenID provider any time you want!  Awesome!

Basically, I added two lines, like these two (but different) to `/index.html` on my web site:

    <link rel="openid.server" href="http://www.livejournal.com/openid/server.bml">
     <link rel="openid.delegate" href="http://rjbs.livejournal.com/"> 

Now, I can point people at my web page to authenticate via OpenID.  Done!
