---
layout: post
title : oslo qa hackathon day 2
date  : 2008-04-06T21:57:15Z
tags  : ["perl"]
---
Today was draining, but I think it was also good and productive.

The hotel TV has a menu option: "To order a pleasant TV wake up, press 3." I've done that the past two nights.  A pleasant TV wake up means that at the appointed time, the TV switches on and emits a high-pitched screeching sound.

This morning, as the television began to scream, I was unsure I'd be able to find the strength to get up and turn it off, but I managed.  By the end of breakfast, I was feeling much better, and ready to get to work.

For the first hour or two, David Golden and I did some refactoring and polishing of our work from yesterday on Test::Reporter.  Test::Reporter now has a concept of a transport class, with a defined (but simple) API.  If you want to write your own transport, it's easy, and you can submit your tests however you like -- including via the new HTTP gateway server.

With that completed, it was time for work on the metabase.  The concept is fairly simple: it's a system to which users can submit data of registered types, all of which describe CPAN distributions.  One type of data is a test report, much like CPAN Testers collects now.  Another might be reviews, or coverage tests, or supplementary documentation or annotation.

These data are stored, indexed, and made available for search, query, and replication.  The system is installable on any network, so your company can run its own metabase to track this information about its own internal CPAN.  For CPAN Testers, this will replace the current database of test reports, which is stored in USENET archives.

Another important feature (which will be implemented shortly after the utter basics, currently under development) is the ability to submit a bundle of related metadata.  For example, a test report will not actually be one item, but a collection.  A test report will contain (for example) a prerequisite analysis, a test environment, a build tool analysis, a TAP archive, and possibly other bits of data.  Because these will be discrete data, it will be possible to compare (for example) the prereq analysis done by CPAN.pm to that done by CPANTS or any other tool that does this kind of analysis and can submit a report to the metabase.

I'll try to give a more detailed example in the next few days, and to get some of our whiteboard photos online.  For now, I've been hacking on this or that for about fifteen hours, and I'm hardly coherent at all.

All throughout the day, there were many excellent distractions -- and I don't mean the surprisingly good pizza.  People would pop into our room to ask questions about things that Dave and I knew, and we'd get dragged into discussions about other important topics.  I feel like every once in a while, I walked away from my work to take a break, overheard a discussion, and got to contribute some ideas to other people's work while taking a break from my own. I know we also got some good feedback from people who wandered in and out of our room.  While working full time at a company with all the QA hackers here might quickly become a holy terror, it has been a hugely beneficial venture so far.

The work that I've been doing has been made possible by ABC Startsiden, who sponsored by trip; Linpro, our excellent venue host; and the Perl Foundation, who helped sponsor David's trip.  There are many other sponsors involved in the hackathon, and I hope they all get told how much they've helped to progress development on our QA tools. 
