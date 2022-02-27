---
layout: post
title : "internalizing and automating"
date  : "2006-07-24T12:28:25Z"
tags  : ["christianity", "perl", "programming", "religion"]
---
My problem with the Mass, I think, is that it does not change.  On one hand, this is a great strength: you can go anywhere and know the Mass.  (This is less true since the introduction of the vernacular.)  On the other hand, out of your hour or so at the church, only something like twenty minutes is spent on material that is likely to be instructive.

The Mass, reworked into new proportions, could provide a well-known set of tropes and idioms for providing more instruction and education.  It could serve as a framework for new celebrations and a pattern language for new explanations of the endless mysteries of Creation.  Instead, it is largely the same literal script, copied and pasted from one day to the next with only a few changes here and there.  I know that the Church's symbology is used in the way I imagine, but its theological applications are rarely seen by (or presented to) the average parishoner.  Instead, he is presented with the same, well-known ritual each day or each week.  He has learned it, can recognize it, and can participate in it without even thinking about it.

Maugham called recognizition "the lowest of the aesthetic pleasures," and I think he is right -- and I think that the Mass should be able to appeal more regularly to higher pleasures.

I didn't actually mean to write about the Mass, though.  I meant to write about RT.  The CPAN ticket tracker, rt.cpan.org, doesn't have a simple way to view all open tickets for all distributions for which you are an admin.  That has led me to have a little ritual whereby I open my page on search.cpan.org, open all my modules in tabs, close all the tabs that say "zero bugs," click the "view bugs" links in the remaining tabs, and then review the open bugs.

This takes a few minutes, especially when search.cpan or RT is being slow, and I can now do it without paying much attention to each window, or even thinking about what I'll click next.  There's a sort of Tetris Mind associated with this activity: I can forget what I'm doing and just move my fingers until everything stops spinning.  The difference is that Tetris is fun and challenging, while my Rite for Checking Bugs is just mind-numbing.

Yesterday, I wrote a script to do this for me.  It goes through the CPAN catalog, finds my dists, checks their bug queues, parses the HTML, and builds a sorted text summary, suitable for emailing.  This took about an hour and a half, but it can be (and has been) tweaked to do the same thing for all the email-related code, for PEP.  I can put it in a cron job and get the listing every day.  I can use the time I used to spend doing something that is fun and challenging, and I can actually make more progress on getting things done and learning more.

I need to make a promise to myself, that once I have internalized a pattern of behavior -- whether it's ritual, procedure, or rote -- I will accept what I've learned, automate the dross, and move on to new problems.

And, of course, I will share what I've learned:

    http://rjbs.manxome.org/hacks/perl/bugagg 
