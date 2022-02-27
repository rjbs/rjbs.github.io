---
layout: post
title : rjbs vs. the perl email project
date  : 2006-02-02T04:44:30Z
tags  : ["email", "perl", "programming"]
---
I really like the Perl Email Project, in theory.  Lately it's been getting my goat, due to weird interfaces, backwards compatibility glitches, and one particularly troublesome bug.

Tomorrow I plan to go on the offensive against Email::Send, trying to improve the interface, at least for my own benefit.  I want to be able to specify the envelope sender and recipient, I more standard return values, and maybe just a more standard argument passing system.  Simple is good, but I can't afford to box anything into something so simple as to be constrictive.  Anyway, time will tell whether I should actually be worried.  Hopefully just twenty-four hours will be enough.

Today's bug was a serious pain.  Let me remind all you Perl programmers:  if you print to a filehandle, check the result of print.  If you didn't get a true value back from print, you didn't really put data in the file.  Even if you could create the file and close the filehandle successfully, if you didn't print, you didn't deliver your mail!

Hopefully Email::LocalDelivery will soon be patched... and now I see that some other useful patches need to be applied, like the one to make Email::Send::SMTP fork-safe.  Maybe tomorrow will be a good day for Perl Email, if I can get my butt in gear. 
