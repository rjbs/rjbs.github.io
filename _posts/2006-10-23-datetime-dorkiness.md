---
layout: post
title : "datetime dorkiness"
date  : "2006-10-23T15:21:24Z"
tags  : ["perl", "programming", "rpg", "time"]
---
I have long avoided DateTime.  It's not that I had any specific reason to dislike the module's interface or offerings, except that it could not be easily installed via PPM on ActivePerl.  When I was developing code that I deployed onto Windows via PPM, this was a major problem, and so I stuck to other Date:: and Time:: modules.

Installing DateTime kept me away from it for a few other uses, too.  It often seemed easier to just use something ugly like Date::Calc or Date::Parse (but never Date::Manip) than to install DateTime.

This week, I've finally started using it.  Actually, I've written a DateTime::Calendar module.  What has driven me to start using it?  Well, my RPG, of course!  Official interplanetary timekeeping is done in Standard Time, which is generally expressed in years since the Standard epoch.  So, for example, the execution of Nazar Barbari occurred at approximately 160.400.  We could also express that as 160:05:23:09:36:00 or 4656476160 sec.  I can also convert it to various other "real life" calendar systems.

The only thing I haven't implemented yet is the semi-mandatory from_object method that will let me convert other DateTime dates to Standard Time.  I'm looking forward to that, since it will (hopefully) let me store the entire game timeline in a standard format.

The next level of dorkiness will be more gruelling: local calendars.  After all, while having a standard timekeeping system is useful, people still want a roughly solar year.  DateTime should make it simple to construct similar-but-distinct planetary (or municipal) calendars driven by some YAML files. 
