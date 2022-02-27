---
layout: post
title : "rubric v0.10 released; plans for v0.12"
date  : "2005-06-02T01:23:27Z"
tags  : ["perl", "programming", "rubric"]
---
I released 0.10 last night, and I felt pretty good about it being free of major stupid bugs.  So far, I have only found two major-ish stupid bugs, so I'm not feeling too bad about that.  I thought I'd totally consolidated all checking for validity of a tagstring to one place, but I was wrong.  When getting a query-by-tags from the URI, I'm using outdated logic, which means that tags with hyphens in them are still invalid.  I probably wouldn't have noticed this, if I hadn't wanted to look up my int-fiction links for Thomas, today.

The other bug I have not yet confirmed, and I thought I had confirmed it squashed earlier this week: updating a database to a new schema sometimes nukes the users table.  This is the artifact of a stupid dev release wherein I successfully upgraded the database schema but didn't upgrade the version number.  Then, when upgrading the database later, the code tries to perform the previous upgrade again.  I need to polish the whole update_schema routine, anyway.

This also underlines my need for more tests.  For 0.10, I got coverage back up to fifty-something, which is decent coverage for all the non-web stuff.  Of course, the web stuff is pretty critical, so I really need to get it tested.  I must become familiar with HTTP::Server::Simple, soon.  I should've leaned on hide to do a talk on it, so I could just loaf around on that front until YAPC.

At any rate, I'm not too worried about the existing bugs: I believe that only people who used a dev release will be affected by the latter, and they can darn well update the database by hand, if they don't want to move to 0.11_01 (when it's ready).  As for hyphens in tags, it's not a new bug, so nobody is going to be especially put out by it remaining broken.

I'm looking forward to doing a few really cool (for me) things in 0.12:  I want to support faceted tags.  Part of me hates the idea and wants to sneer at everyone who likes it, but lots and lots of people want it.  I'm not just giving in to public whining, though, I have a secret agenda.  I long meant for tags beginning with the at-sign to be "system tags" with special meaning, and the first one of these, @private, was introduced in 0.10.  In 0.12, I want to introduce @markup as a facted system tag, the value of which tells Rubric::Renderer what plugin to use to render the entry.

This will mean that all my existing entries can remain as they are, and I can continue to use my current renderer (the html_line_break filter in TT2) but I can, when I feel like it, attach the tag "@markup:markdown" to indicate that the body is Markdown text and should be rendered as such.  I look forward to having an easier time of including code snippets in my entries!

There are a few other things I want to get done, but I'm not sure when. They're mostly longstanding ideas that are useful, but for which I am not a primary customer.  (Yes, I admit it: I am more likely to write code I want than the code you want, unless you are going to shower me with wealth.)  Anyway, those feature are: a more complete and documented "API," syncing and an offline mode, URI "overcanonicalization," and pluggable special-case URI rendering.

Sometimes, I look at the snail-paced progress of Rubric beside the amazing progress of (for example) Pugs and feel humbled.  I don't mind, though: I should be humbled by it.  I still get to end up with software I enjoy and to which I am proud to sign my name. 
