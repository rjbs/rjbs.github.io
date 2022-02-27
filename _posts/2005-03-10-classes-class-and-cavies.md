---
layout: post
title : classes, class, and cavies
date  : 2005-03-10T02:25:00Z

---
Ok, I'll seriously try to lay off the guinea pig news after this update! Snoozer and Wookie seem pretty happy.  We took them out for a joint game of "sit on Rik's chest," and Wookie won.  They both seem happy to let us reach into the cage and pet them, although they still run for the pipes when we walk into view.

We've seen them both drinking, and they're eating much better, including their oranges.  Today, Snoozer did some big "I am happy" behavior, "popcorning." When cavies are really happy, they jump up and down while they run, and Snoozer did this a few times while we watched from the other room.  It was pretty exciting, and we're feeling like we're doing A-OK.

Earlier tonight I had my first Spanish class since middle school.  I think that we learned, tonight, everything that I learned in my one trimester at <a href='http://www-ni.beth.k12.pa.us/'>Nitschman</a>: el alfabeto, los numeros, "Como se llama usted?" and "Como esta usted?" Next week, maybe I'll be able to compress everything that most people learn in all of middle school Spanish into that class.

I like the instructor, but the class format is weird for me.  I'm worried that there's going to be a lot of role play and goofiness, which always sort of turns me off.  Maybe it will help me learn, in this instance, though.  Time will tell.  It will also tell how annoyed I'll be about the text book.  It was $50, and the instructor says, "You'll want to use it to work on things away from class, but I won't use it."  Oh well.

Today I started laying my plans down for the next CPAN::Mini architecture. hide asked me if it was a complete rewrite.  Yes, it is. 

The system I'm toying with now, suggested by my current 100-line minicpan2 script, is: you set up many SPAs.  (What's a SPA?  Well, CPAN is a Network of many CPAs.  A SPA is like a CPA, but selective, not comprehensive.)  So, you say "I have a SPA located at this URL."  A SPA needs to have a set of authors, packages, and distributions.  By default, it will look for 01authors, 02packages, and 03modlist files somewhere and use those.  Other SPA classes can be written, of course.

Once the SPAs are set up, a Merger decides what needs to be in the local SPA. Then a Mirrorer (horrible name, that) makes it so: it deletes old things and copies new things from the appropriate SPA.

Anyway, it's mostly diagrams and insinuation now, but I'm feeling good about the idea and will probably move forward with it quickly.

MJD said that he got his advance copy of HOP, today.  I am very much looking forward to receiving it!  (My own copy, that is, not his advance copy.)

