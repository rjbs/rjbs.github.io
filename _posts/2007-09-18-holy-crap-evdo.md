---
layout: post
title : "holy crap, evdo!"
date  : "2007-09-18T21:13:29Z"
tags  : ["networking", "phone"]
---
Sprint PCS was my very first cell phone provider.  Shortly after we moved back to Pennsylvania, though, I got rid of them and switched to VoiceStream.  With some brief outages (while using awful Nextel phones at IQE), I've been with VoiceStream (now T-Mobile) since then.

When I started working at Pobox, I began making a two hour commute, two ways, three times a week.  That's twelve hours on the bus, and I wanted to be able to make checkins, grab files I was missing, and so on.  I got T-Mobile Total Internet, which is basically unlimited hotspots and unlimited data over GPRS.  Bluetooth dialup and GPRS are awesome when all you had before was "sync before heading to work."  It's not even so bad for sending messages over SMTP or using a very, very small amount of IRC.  For anything else, though, it is painful.

With GPRS, I had ping times around 1000 to 3000 milliseconds.  I get data transfer about 5 KB/s, give or take a bit.  I tried to upgrade to a phone with EDGE, which is just GPRS++, but the difference didn't register.  For years, T-Mobile has been saying they're going to get 3G coverage, but they still haven't set a date.

I've been getting really tired of the awful connection I get, and at YAPC this year, Jason Crome shared out his EVDO connection to the table.  There were a half dozen of us on his connection, and it felt like we were using DSL.  I've been waiting and waiting to hear from T-Mobile, but finally I just about gave up, and looked into other options.  (I wrote about this recently, complaining about web pages.)

Today, my Sprint EVDO modem arrived.  It's a Sierra Wireless AirCard 595U.  To use it, I had to install a really ugly compiled-for-PowerPC program that made me reboot when it was finished.  I sighed and slogged through the install.  It was worth it.

With EVDO, I get sustained downstream transfer rates of 70 KB/s and ping times around 100 milliseconds.  It's just like being on my home network, except possibly for very, very large downloads.  I haven't tested upstream yet, but I don't often need to upload very large files from the bus.  I'll be very amused, though, if my EVDO is much faster than my lousy Speakeasy DSL.

The real test comes Friday, when I try out the modem on the bus, and see how actual coverage compares to the coverage map. 
