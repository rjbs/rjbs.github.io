---
layout: post
title : from vim to tiddlywiki
date  : 2007-06-01T12:24:21Z
tags  : ["tiddlywiki", "wiki"]
---
I run two RPG groups, and they take place in the same campaign world.  I've got a lot of notes on it, and I'd like to make it easier for the notes to cross-reference one another.  I didn't want to use a server-based wiki, because I wanted to use Vim to edit things, and Mozex seemed like a big pain, at least on OS X.

I looked into some of the Vim-based plain-text wikis, like Viki, but they just got in my way, confused me, and made me angry.  Finally, I started down the left-hand path:  writing my own wiki.

It was sort of interesting:  every page was a text file, divided into sections with .ini-like headers and using a heavily modified Config::INI::Reader.  There was a mandatory 'general' section that provided document metadata, then there were other sections, each of which could have a different content format. The description section was Kwiki format, the charsheet section used the YAML schema I use for d10 character sheets.  The system section was YAML describing the properties of an inhabited star system.  I had a program to go through and, say, generate hyperspace maps or calculate distances between arbitrary stars in real space.  Fun!

The problem was that I still wasn't using any kind of wiki linking.  I really didn't want to have to go put wiki words everywhere, and when I started to write syntax highlighting, which would be a prelude to making links work, I just got sick of it, and my solution was to keep going with text files and ack.

Now, though, I've started getting back to planning the D&D game that I've been puttering at for several years now.  My notes were in two format:  LaTeX and OmniOutliner.  There were also a few text files.

The more I started to add more data to these, the more I wanted a wiki, so I started looking into plain text wikis again, and got more and more annoyed with the wiki offerings for Vim.  I came very close to installing MediaWiki on my laptop, and then looked at VoodooPad again.  VoodooPad looked tolerable, but something in my heart told me that I'd resent the hell out of it after a few hours.  It made me remember the other personal wiki that sprung up some time ago:  TiddlyWiki.

I went to look at it, and I couldn't figure a few things out:  it said you could save, but it had no server component.  I downloaded it and found that it did, in fact, work: it used JavaScript to tell your browser to overwite the file on disk.  Wow, awesome!

How do you configure it?  You edit the content on special pages.  Wow, awesome!

It does tagging, but moreover, tags and page names can be interchangeable, meaning that on the page "Empire of Man" I can see a description of the Empire as well as a link to all pages tagged with that.  Excellent!

It has decent formatting, some crazy little features, and even supports plugins -- though I'm not sure what they can do, yet.

There are two big drawbacks, so far:  one is that there seems to be no mechanism for attachments.  That's probably fine:  I can just use hyperlinks to file:// urls.  The other is that my metadata-on-wiki-page idea is probably right out.  Maybe I'll re-implement it using verbatim blocks on specially named and tagged pages, or maybe I'll just put that kind of data in its own file. TiddlyWiki has unsolved a few solved problems, but solved so many other ones that I don't mind.  Oh, and about editing with Vim... maybe it's time to install Mozex after all.
