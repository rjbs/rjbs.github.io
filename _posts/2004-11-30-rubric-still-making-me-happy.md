---
layout: post
title : rubric still making me happy
date  : 2004-11-30T02:49:00Z

---
I'm happy that I haven't been distracted by some other object, yet.  There are a number of reasons, the most important are probably that I've got a real use for Rubric, I'm taking it slow, and there are a few other people who have requests of it.

It's really getting there, but slowly.  I really need to get new user registration working, and then formalize a database upgrade script.  Those are sort of boring things that don't interest me, but they'll make life easier on me and other people, too.  Most recently I got the Rubric-as-notepad and -as-blog features working pretty nicely.  I need to do a little work on formatting entries, but that's all little stuff.  I also started breaking the output renderer from the CGI::Application class, to get RSS output working. Right now, it's horribly ugly, but I'll get it better as time goes on.  I liked a good bit of Bryar's renderer, and will probably steal some of its interface.

Really, I learned a lot from Bryar, and I'm glad to have hacked on it enough to get ideas from it.

What I'm really enjoying, though, is refactoring.  Probably because it's the most whole-application piece of software I've worked on outside of work, I've really had a lot of opportunity for moving things from place to place in my code.  As I work on things, I keep asking myself, "So, to implement this feature, how many places do I need to make a change?"  The answer keeps being one or two, and it keeps surprising me.  At work, it's always five or six or more, generally answered with grep.

The only thing that keeps biting me is the need to write my Class::DBI code with TT2 in mind.  I can't need to pass undef, and I can't return lists of arrayrefs.  TT2 can't pass undef, and it thinks that a list containing just one arrayref should just be the arrayref as a list.  Still, I'm starting to take those quirks as facts of life and coding for them to begin with.

I also wrote a little clone of extisp.icio.us, too, which has always really tickled me.  I'm not sure what's next after a better renderer and user registration.  Suggestions?

In other news, I've made a lot of progress in Metroid Prime 2.  Having gotten past a few really, really annoying bosses, I've been cruising through a lot of really fun stuff, and life is good again.  I think I now have every suit upgrade, save one optional one.  Now I'm just collecting keys to unlock the final battle.  No rush, though.  Pretty soon I'll probably hit that weird "put the almost-finished game back on the shelf" phase I tend to get to.

