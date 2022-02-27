---
layout: post
title : "mail audit and other nightmares"
date  : "2006-06-04T21:05:00Z"
---
I actually did have some bad dreams a few days ago, but I can't remember what made them so bad. I remember being told that I needed a haircut, but that's about it -- and I doubt that was especially traumautic.

This has been a mixed weekend. On one hand, on both Saturday and Sunday I found myself hanging out at St. Nick's Greek Orthodox church with Gloria and other friends, eating delicious Greek food and relaxing. I watched some good movies, ate some ice cream, and relaxed a bit. On the other hand, various computer-related things are making me lose my hair.

On Saturday night, one of our few remaining not-quite-redundant servers went down, which led to a trip to our colocation facility. It really wasn't so bad, except that it happened at all. At least it means that one of our non-standard boxes will soon be history. Also, it gave me a chance to have some diet Mountain Dew, which I haven't had in quite a while.

Both yesterday and today I've been working on Mail::Audit. We use it quite a bit at work, and it's in the Phalanx 100. A lot of people use it, but its behavior isn't very strictly defined, so I'm trying to figure out how much of its behavior is really relied upon. I hate the idea of releasing a "bug fix" version of software that's been stable (or stagnant) for years, only to break a lot of people's email filters. I'm fighting a few things: the interface and behavior aren't always well documented and are entirely untested; further, the existing undocumented behavior is sometimes clearly sub-optimal or just wrong. I really don't want to break existing code, but I also don't want to go ahead and document bad things.

What I really need is a formal deprecation schedule, but those aren't quite so useful when a module has been stagnant so long that people believe it's dead. It would be nice if there were a more uniform, universal way to alert module consumers to news.

    $ cpan-announce Mail-Audit "In six months, the 'noexit' feature will change."

Oh well. For now, I think I'll stick to just documenting things... although I will probably make a list of things I want to change. Is there some useful place I should post such a list, which I just can't think of?  
