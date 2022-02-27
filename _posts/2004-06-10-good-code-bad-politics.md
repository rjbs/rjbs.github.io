---
layout: post
title : good code, bad politics
date  : 2004-06-10T02:48:00Z
tags  : ["code"]
---
I got a lot of stuff done today:

I packaged up and released Math::Calculator, a stack-based calculator class that began as example code during my recent trip to Cardiff.  It's not great, but it works, and I enjoyed writing it.  I may try to use it to build some useful little tools, and I may try to take over Math::RPN and port it.

I pulled a little bit of stupid date handling from some awful code at work, cleaned it up (just a /little/) and stuck it into a module.  It takes two timestamps and returns a bunch of timestamp pairs, splitting the span of time over discrete days.  Actually, I did add a bit of code to provide results as either timestamp pairs or date and duration pairs.  The algorithm looked pretty iffy, but it works and I use it, so maybe it'll save someone else some time. Anyway, now it's Date::Span.

I updated Math::TotalBuilder to allow alternate forms of builder subrefs, and gave it the ability to determine (based on one criterion) the best algorithm to use for any given set.  It's not what I really want, but it makes it easy to do what I want, once I have time to find better algorithms.  I also started my little collection of useful unit sets, but the collection is pretty lame so far.

I got other things done, but they're pretty work-specific and not worth explaining---except to note that we finally determined that the big bug in the Lehighton parser was not my fault or a bug in my software.  It was a procedural problem.

Meanwhile, silly semi-political things started to get on my nerves.  My UK counterpart and I are supposed to settle on a common job title, and I made the mistake of saying that I wasn't terribly concerned about it.  Apparently this translated to "I am willing to accept anything without argument," which I did after this interpretation was made clear.  Still, it got on my nerves.  I tried to keep busy for the rest of the day to focus on things that I do think matter. Anyway, maybe I'll have a new title (and thus business card) by OSCON.  I suggested "just some guy."  Also accepted, "Bastard."

