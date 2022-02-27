---
layout: post
title : "trust no one"
date  : "2015-08-14T22:06:44Z"
tags  : ["security"]
---
At work recently moved from our own office space to a coworking space.  Bryan
said, "remember to lock you laptop screen when you're not using it."  I
said, "I use [Mobile Mouse](http://mobilemouse.com/) so I can lock it with a
hot corner from across the room."

He asked, "How does Mobile Mouse connect?"

The importance of the question was obvious.  I knew it was wi-fi, and the wi-fi
is shared with the rest of the coworkers.  Surely anything that can remote
control my computer will be a secure connection, right?  Right?  The docs said
nothing, so I fired up a packet sniffer.

    $ sudo tcpdump -i en0  -w mouse.packet port 9090
    [ connect with Mobile Mouse, mouse around a little ]
    $ strings mouse.packet

What did I find?  Here's a sample:

    WELCOME
    CONNECT
    my-password-in-plain-text
    C97B5F9F-1840-4546-AFD9-AA90FEE09FE4
    rjbsPhone
    CONNECTED
    jubjub
    Welcome
    A4:5E:60:BB:12:11
    10.10.5
    SETOPTION
    PRESENTATION
    SETOPTION
    CLIPBOARDSYNC
    HOTKEYS
    APPICON
    Finder
    /System/Library/CoreServices/Finder.app
    [ a bunch of base64-looking stuff; I think it's the Dock icon images ]
    MOVE
    1.50
    -8.50
    MOVE
    4.50
    -12.00
    ...

There's my phone's device name, the password, my laptop's name, and a bunch of
other identifying information.  Anybody who sniffed the network for a while
could find this traffic and then remote-control my laptop when I looked away.
(Or, more amusingly, when I wasn't looking away.)

I asked the makers of Mobile Mouse why they didn't use a secure connection, and
whether they would.  They said, "Well, it's really intended for a secure local
network, but we'll think about adding this feature."  Still, they link to
people who review this device as a presentation remote.  This sounds like a
recipe for at least hilarity, if not disaster.  "Hey, the consultant is
presenting with his phone on the guest wi-fi.  Let's sniff it!"

My point here is not that Mobile Mouse is bad software.  It's really good
software with this one enormous flaw.  My point is that nobody really cares
about protecting you except for, hopefully, you.  You had better pay attention!

