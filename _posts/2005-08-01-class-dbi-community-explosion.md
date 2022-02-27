---
layout: post
title : class dbi community explosion
date  : 2005-08-01T18:46:14Z
tags  : ["cdbi", "culture", "dbi", "perl", "programming"]
---
Well, I suppose it was just a matter of time before I said something about this.  I love Class::DBI, I use it all the time, it makes me happy, and it had a very good mailing list community.  For a while, Tony had been taking flak for not having released a new Class::DBI.  He got more and more defensive about it, so the peanut gallery got more and more demanding.

Eventually, Matt Trout mentioned he was going to release a new experimental POOP system called DBIx::Class (or something like that).  It looked potentially interesting, and Tony was friendly to the posts, taking part in the conversation.  Eventually, though, an argument about multiple inheritance and mixins showed up and turned nasty.  There was some banning, some childishness, and eventually the list closed down.  Everyone knows the story by now, or can find it elsewhere.

I think the core question raised by the whole affair is "What is the correct relationship between a CPAN module author and the module users?"  Tony's expressed opinion was something like, "I do what I choose to do and you get to enjoy the fruits of my labor."  I think this is fair, but I don't think it's the normal case, so users get irked.

Some of the people on the list seem to feel like Tony had a number of implicit responsibilities like, "fix the bugs I care about soon" and "release at short regular intervals, no matter what."

In the end, I think the problem was that Tony really did want to provide a great product, but he didn't want to provide what his consumers thought they wanted.  He wanted to work on 1.0, while 0.96 was pretty bug free, but the users wanted a 0.97 with a few tiny changes.  That seems like a recipe for resentment, and that's pretty much what happened.

What a lot of projects do in this situation is not fork, but branch.  Someone maintains Linux 2.4 while Linux 2.5 or 2.6 moves forward.  It would have been simple for Tony to make someone the pumpking of maintcdbi while he worked on bleadcdbi.  I don't know what his reasoning was for not doing that, although it may have just been, "I don't want Class::DBI 0.96 to change in ways I don't like, especially if it becomes less stable."

That's what I would've liked to see, largely because one of my dists, Class-DBI-MSSQL, can't work quite properly without a patch to Class::DBI, because of how defaults and NULLs work in MSSQL.  Of course, this gets back to the question, "What is Tony's responsibility to me?"

I wish I had a good answer for that.  Clearly the most true answer is, "None," but I don't think it's the answer that's the answer I want most people to accept.  Then again, I have an ulterior motive, don't I? 
