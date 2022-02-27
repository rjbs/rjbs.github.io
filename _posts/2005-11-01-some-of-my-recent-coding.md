---
layout: post
title : some of my recent coding
date  : 2005-11-01T22:02:30Z
tags  : ["perl", "programming", "work"]
---
I finally released 0.12 of Rubric.  It's not everything it could be, but it's better than nothing.  All of its tests pass, due to a better cleanup routine before testing.  It uses strict in the (pointless) Rubric.pm module, which gets rid of that one black mark on my CPANTS score.  I was really wondering when domm would update the scores, but now I want him to wait until I fix my most recent upload.

That recent upload is Net::Domain::TLD.  I needed it at work, recently, to do some data validation, and I was fairly unexcited by its interface.  It used objects pointlessly, memoized badly and for no reason, and was just sort of a drag to use.  Insteead of whining (well, instead of -just- whining), I did what I've been trying to do in these sort of situations: I emailled the author and asked if I could help.

He gave me rights, I wrote a simpler interface and made a release, and am preparing to make it easier to update the module.  Awesome!  It's always nice when people are willing to help or be helped.  (Sudden flashback to the Breakfast Club: "Why are you being so nice to me?" -- "Because you're letting me.")

Last week was a big week at work.  We launched phase one of the new Listbox interface, and I'm pretty happy with how it's gone.  Developing the frameworks that power it was a lot of fun, and it made everything really easy to put together.  It needs more tests, it needs more documentation, and it needs more refactoring.  All of those will be easy, though, because we've built a straightforward system that doesn't try to do everything in one place.  It is the exact opposite of some of the code it's replacing, and I feel good about that.

This week I'm trying to implement some features at Pobox that I'm pretty excited about, so I think it will be a fun week.  I also was really pleased with this bit of code that I was playing with today while experimenting with some ideas.  The question is: are all the switches in a given set doing the same thing in this configuration?  If so, we can replace them with a set object:

    $setting{$_}++ for grep { defined } map { $config{$_} } @switches;   my @settings = keys %setting;

    next if (@settings != 1) or ($setting{ $settings[0] } != @switches);

It's not amazing or mind-altering, but it sort of poured naturally out of my fingers and made me think, "You know, Perl is a very pleasant language to work in."  (This minor munging of the code has also not been tested.)

Finally, I think I've got to do something about some Email::Send things I've wanted to do for a while.  One of those will probably be "bug Casey" because... how much longer do we have to wait for a real release of Email::Send 2.0?  I want that shiny new non-clever interface! 
