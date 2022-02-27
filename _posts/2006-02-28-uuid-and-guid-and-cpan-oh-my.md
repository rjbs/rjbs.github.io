---
layout: post
title : "uuid and guid and cpan, oh my!"
date  : "2006-02-28T02:05:53Z"
tags  : ["cpan", "perl", "programming"]
---
I keep getting questions about what the hell I'm doing, so I'm going to try and answer them here.

Data::UUID is, as far as I've been able to tell, the most portable and capable implementation of universally unique identifiers on the CPAN.  It has, unfortunately, a few problems.

1. It doesn't compile out of the box on Mac OS or a few other platforms.
2. It doesn't install under CPANPLUS (and maybe CPAN.pm).
3. Its interface stinks.
4. It has no license.

After years of trying to get various bugs fixed, I finally requested and got maintainership of the module.  Despite #4, I uploaded a new version of the dist, hoping for the best.  All it does is fix the most obnoxious bugs -- #1, #2, and some quirkier ones.

The bigger problem is that I can't just fix #3 or #4.  I've been trying to get in touch with the author, and I might just end up calling the phone number on his domain's WHOIS data.  It'll be great to get a nice license on there and more confidently fix things.  The thing that can't be fixed, though, is the interface.  Too many things rely on it.

So, I wanted a interface for globally unique identifiers that was simple and Perlish.  There exist a pile of UUID-generating modules on the CPAN, but most of them have a much smaller set of features and are far less portable.  That's why there are also a few adapter classes, on the CPAN on in people's private toolkits, that provide one interface to whichever module is available. Unfortunately, these need to cater to the smallest feature set, so they tend to just provide a `uuid_string` routine and leave it at that.

Anyway, it seemed to me like a good interface to a UUID object was pretty straightforward.  Adam, who had the same thought that I did, basically rattled off exactly what I planned to do, confirming to me that I was on the right track.  I put together a little spike of it, Data::GUID, and uploaded it.  I've made a few revisions, and I'm getting to be pretty happy with it.  Right now it uses Data::UUID for actually doing the work of creating and stringifying unique id's, but that should change as soon as there is an alternate, portable, licensed implementation.  That means that I basically have two things left to do:

1. Replace the XS implementation of Data::UUID with something licensed and portable, and use it in both Data::UUID and Data::GUID (or just GUID and make UUID a wrapper around it). 
2. Write a pure Perl implementation for GUID generation so that on systems where nobody wants to port the C library, GUIDs can still be generated.

I guess there's also a third: deal with implementing namespaces.  I need to re-read the UUID/GUID spec before doing this, but I'm not in a rush.

I'm open to comments on the GUID interface, or any other part of this!
