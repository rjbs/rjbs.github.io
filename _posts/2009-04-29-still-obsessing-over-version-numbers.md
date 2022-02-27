---
layout: post
title : still obsessing over version numbers
date  : 2009-04-29T03:42:17Z
tags  : ["perl", "programming"]
---
I have been obsessing over how to number versions since I first started writing code for a living, around 2000.  Nothing is satisfactory.  I'd really like to make a decision and stick to it across all my code, and I'm pretty close to doing that.

I considered "the version number is the date and time of release," and that seemed pretty reasonable.  The biggest objections are that people will balk at "stale" software and that there's no way to say "this is a major release!" Since CPAN doesn't provide a useful mechanism for saying that something is not backcompat, major releases of CPAN code are generally discouraged from ever breaking backcompat.  If they do, it needs to be announced with something more substantial than a version number.  If people are worried that software doesn't work because it was last released three years ago, I don't care.

I considered the "versions are integers that increase by one each release" tactic, but it seemed less straightfoward than dates.

I considered x.y.z, but that's just a nightmare in Perl.

I also considered x.yyyymmddn, where x is a constant and n indicates the nth release on the day.  x would be my way of saying, "If I had a way of indicating backcompat breakage, I'd put it here."  I worry, probably needlessly, about something stupid producing float precision loss on a version with nine digits after the decimal point.

The first (yyyymmdd) and last (x.yyyymmddn) schemes are most likely to be adopted and automated with a Dist::Zilla plugin.  If anyone has any genius remarks, now is the time to make them to me. 
