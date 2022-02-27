---
layout: post
title : obsidian portal and me
date  : 2009-07-12T03:13:57Z
tags  : ["dnd", "game", "programming", "rpg", "software", "wiki"]
---
A while ago, someone directed me to [Obsidian
Portal](http://obsidianportal.com/).  It's a website where you can
collaboratively develop an RPG campaign.  A camapign has a wiki, PC and NPC
tracking, an adventure (b)log, an item tracker, a map archive, and forums.
There might be some other stuff, too.

It's a structured wiki, at least somewhat, so every page has hunks like
"DM-only content."  Characters have "background" hunks, and so on.  It's easy,
when writing up an adventure log, to link to a PC's wiki page by the PC's short
identifier.

Obsidian Portal is a really fantastic idea.  Unfortunately, the implementation
is incredibly frustrating to use.

The problems are hard to describe, but it comes down to "the interface gets in
the way of getting things done."  Creating NPCs is annoying, and there is a
largely obnoxious distinction between PCs and NPCs.  The "short name" used to
link to characters must be universally unique, rather than unique within a
campaign.  I could not, for example, make it possible to link to
`[[:valentine]]` because someone else in some other campaign had used it.

I don't create a character by clicking "add" on my campaign.  I have to go to
the global character browser and create one there.  A small dropdown allows me
to add the character as a PC in a campaign if I want -- but not as an NPC.  To
do that, I'd need to do a bunch of editing later.

These kind of little irksome problems are absolutely everywhere in Obsidian
Portal, making it anything but a joy to use.  It has so many great ideas,
though.  I love the notion that I can have my DM-only hunk of notes on a given
adventure (or any other wiki page) or that I can write up pages and reveal them
later.

All the "share your campaign with others" stuff is neat, but seems incredibly
unimportant compared to the "manage your campaign for your players."  Despite
this, things seem optimized for other people instead of your players.  Maybe
I'm wrong or maybe that's what the authors want, but it frustrates me.

Because of this and other ideas, I've been looking a lot at various content
repositories, document databases, and structured wikis.  So far,
[Wagn](http://wagn.org/) looks, by far, the most likely to be useful.  Even it
is sort of a half-fit, but it might be good enough to let me get on with
running my game.  If that falls through, I might be willing to try implementing
something, but my time is awfully short to spend writing new structured wikis
optimized for Dungeons and Dragons!

Tomorrow I'm hoping to write up what I want for my game and what I'd want to
provide if I were writing Onyx Portal (or whatever) for a living.

In the meantime, my players recently got [their latest
adventure](http://www.obsidianportal.com/campaign/ethos/adventure-log) logged
onto Obsidian Portal.

