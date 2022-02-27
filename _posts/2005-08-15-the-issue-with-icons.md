---
layout: post
title : "the issue with icons"
date  : "2005-08-15T00:50:48Z"
tags  : ["icons"]
---
We use Kwiki::Icons::Crystal at work, because (to quote John) "otherwise the toolbar ends up taking two rows!"  I don't want a multi-row toolbar, but neither do I want a huge array of tiny icons that often have little bearing on their link's action.

See, the issue with icons is this: it's hard to make icons that are actually iconic and suggest, to the user, what they mean.  If you want to make an icon for a text editing application, it might be pretty straightforward: some text, maybe on a piece of paper, maybe with a pencil near it.  An icon for a video player is simple: a length of film, a projector, maybe a TV.  How do you make an icon for a concept like "show diffs?"  Mac OS provides a good one, actually, although it doesn't scale well to 16 by 16.  What about "keywords?"

Now, I think that someone could come up with an icon for a lot of these concepts, given some time and creativity.  The problem is that there's a secret third requirement: the ability to transform the idea into an icon.  Most programmers don't have that ability, which means that they resort to the Worst Possible Option: they find the free icon sets (GNOME, Crystal, etc) and look for icons that are sort of kind of indicative of what they want, then use those.

It leads to users hovering over unhelpful icons, reading the tooltip, and then moving on to try the next icon until the right one is found.  Now the user has to learn an association between each icon and its purpose, and then he must remember it.  This defeats the entire idea of creating automatically understood visual clues.

I keep trying to make friends with someone who'll want to make icons to my specifications, but so far it hasn't worked out.  Until then, I'm sticking with text. 
