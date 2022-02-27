---
layout: post
title : send me your bounces
date  : 2006-05-26T20:10:00Z
tags  : ["email", "perl", "programming"]
---
I am taking over Mail::DeliverStatus::BounceParser development for some of our internal uses of it, and I want to make it better. The first thing I need to do is clean up some of the code so that I can read it. Once that's done, though, I'll need to start writing new tests! Most of the tests for this module will work like this: given a bounce that a human has already analyzed and described, make sure that BounceParser comes to the same conclusions.

I need bounces! Obviously, Pobox and Listbox already have scads of bounces, and I'll be mining them for choice examples. Still, if you have seen some weird bounces, I'd love to see them. Drop me an email with bounces attached. Information about the bounce's pathology, origin, and nature would be greatly appreciated, too.
