---
layout: post
title : rm birthdaycal.app
date  : 2004-05-31T20:18:00Z
tags  : ["code"]
---
I had been using an application called BirthdayCal.app to keep a calendar in iCal updated with the birthdays in my Address Book.  I figured this would be a nice application to replace in my attempt to make more non-Free software obsolete.  (I know, I know, as long as it requires iCal...)

BirthdayCal is free like beer, but I can do better.  Right now, the script isn't very flexible, but all the options that BirthdayCal provides should be easy to add.  Since I don't use any of them, I'm not sure when I'll get to it. I was stuck on this until pudge pointed out the reason that my make command wasn't working.  AppleScript sure does stink!

If you're interested in playing with this stuff, you might find "AppleScript: The Definitive Guide" really useful.  I sure have!  The author (Matt Neuberg) is very honest about the fact that AppleScript is totally messed up, and shows how it's insane and how to trick it into acting sane.  While I'm trying to avoid relying on scripts in AppleScript, it's useful in the lifecycle of a Mac::Glue script.  I can figure out how it would work in AppleScript, then translate it.  It helps me detect errors and other weirdness; Mac::Glue seems less likely to die on errors than AppleScript, but that just might be because I don't know how to catch exceptions yet.

Oh, the script is here: <a href='/hacks/perl/bdcal'>/hacks/perl/bdcal</a>

