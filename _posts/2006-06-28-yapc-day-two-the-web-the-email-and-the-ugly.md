---
layout: post
title : yapc day two: the web, the email, and the ugly
date  : 2006-06-28T14:51:36Z
tags  : ["perl", "yapc"]
---
Today there were two ugly talks -- I don't mean talks that disgusted.  Really, they were just talks that made me wince.  Cog talked about Acme modules (Acme::ProgressBar made his list!), and he showed a few modules I hadn't seen before.  Acme::Octarine was amusing.  I think the biggest laughs were for Acme::Lingua::NIGERIAN.

chromatic gave a talk on Perl hacks, which included some really cool stuff, including P5NCI, which makes using C in Perl much easier.  It also made me want to do more with attributes again.

The "what's next in Perl" talks were also yesterday.  Damian and Larry's Perl 6 update alternated between the exciting, the disturbing, and the disgusting.  I feel like it's going to be very difficult to hold all of Perl 6 in my head.  I know that it's allowed to speak in baby talk Perl, but I like to think that I can realistically aspire to understand most of the language.  Maybe I'm wrong: maybe I only know as much Perl 5 as I'll ever learn of Perl 6, and maybe that's plenty for me.  I guess I'll find out, eventually.  In the meantime, I fear Larry's colon.

The Perl 5.10 talk was quite a bit shorter, and showed off some of the Perl 5.10 things that I'm looking forward to: lexical pragmata, the defined-or operator, and a few other tid bits.  This led Dieter and me to complain to each other about the fact that new releases can be a bummer: you can't really rely on the great new features for modules that you want to see wide use, because so many people are stuck on the last (or older) major release.  Heck, I still worry about 5.6, and I'm trying to make sure some modules will work on 5.004.

At lunch I wandered off with the Test::Builder BOF and ended up talking with Dave O'Neill, who works with a lot of Perl email code and uses Rubric!  It sounded like he had done some really neat stuff with it.  It made me want to return to adding some of the long-left-todo features.  It also made me want to spend more time back in the CGI::App community.  I started this by going to a few Catalyst talks... oops.  I didn't learn too much about Catalyst, but that's OK.  Later I managed to get to a talk about CGI::App plugins, which reminded me of a lot of the things I liked (and disliked) about the current state of CGI::Application.  These thoughts would stew in my mind until later in the night.

After the last talk, it was time for the PEP BOF.  PEP is the Perl Email Project, which began as Simon Cozen's attempt to replace much of the existing Mail:: namespace with the Email:: namespace.  Lately, it's been quiet, but we're hoping to turn it around.  I think the BOF went really well, and I'm excited about the things we'll be working on... I'll write more about that as it occurs.

From the BOF we went to the YAPC banquet, still talking about email the whole way.  Once at the banquet, though, we split up and found drinks and video games.  I played a sit-down land luge game, which was completely weird.  The food was really pretty good, and I probably ate too much.  The dessert included a chocolate mousse with some sort of berries in the bottom (I think they were raspberries, but John says strawberries).  Dessert led into the auction. Frankly, this year's auction was less enticing than previous years'.  The only things that interested me were the things that were so big-ticket that I couldn't even realistically bid on them.  Due to some of those items, though, TPF seemed to make a pretty good haul.  (I have no idea if this is true, but it seemed that way.)  Still, I hope we get more book donations again, next time.

At dinner and at the auction, I sat with a bunch of my friends from #cgiapp. (They were all Canadian, with the exception of CromeDome, who has been made an honorary Canadian.  This led John to release Acme::Canadian.  It's cool, eh?) We talked a lot about the module, and about where we'd love to see it go.  We were going to meet to talk about it on Wednesday, but Toronto.pm ended up winning the auction to have lunch with Larry.  In response, we rescheduled our brainstorming for after the auction.  A little after we got back from Dave and Buster's, we got together and started poking at some code and thinking about some ideas.  I wrote some patches, but mostly our deliverable was a set of simple ideas.  I'm hoping to implement one of them before the week is out.

We broke it up around two.  When I got back to the dorm, John was just releasing his new module and it was time to crash.

It was a good day!  I learned some stuff.  I got to chat with a bunch of people I almost never do, at least in person, like Casey, Adam, Allison, and Shawn (and the rest of the #cgiapp crew), and Jeff.  I ate good food, and I went to bed when I was really tired.  That's what a conference should be like! 
