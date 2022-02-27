---
layout: post
title : another plea to test and use strict
date  : 2008-08-07T16:06:02Z
tags  : ["perl", "programming", "stupid"]
---
A few months ago, I spend a few days (yes, days) rewriting an extremely complex set of procmail programs into modern Perl.  Replacing procmail with Moose? Priceless.

Anyway, the procmail program largely existed to send mail to a program written for Perl 4.  It had no strictures and no useful tests.

When I finally threw the big switch and started to send mail through the real Perl 4 program instead of the mock version, I ended up with mail records like this:

    From: icardo Signes   Subject: his is a test

What?  Why did that happen?  Well, this line exists in the code.

    $subject = substr($subject, 1) if ($subject[0] == " ");

The intent is "clearly" to remove a single leading whitespace if it exists.  Of course, that's not what the code actually says.  It says, "If the first element of an array called @subject is a single space, then remove the first character from the scalar $string."

This didn't throw a compile-time error (about @subject not being declared) because the program didn't (and more or less cannot, yet) use strict.  This didn't display any bad behavior because all of the program's input had one leading whitespace.

The fix was easy.  I threw in a `s/^\s+//'.  Still... what an excellent demonstration of the power of strictures to remind you that HEY! you're programming Perl here, not Python. 
