---
layout: post
title : "kwiki kampfen"
date  : "2005-08-01T13:33:04Z"
tags  : ["kwiki", "perl", "programming", "wiki"]
---
I made some remarks like this on #perl recently:  Every time I make a new Kwiki, I dislike it because it has no features.  Then I install a few plugins, and I like it a little, because it's nearly what I need.  Then I decide to write a few plugins to add the last few features I want, and I hate Kwiki because I realize that I need to deal with some part of plugin writing that isn't documented, even on the Kwiki Kwiki.  Finally, I get things working and I love Kwiki because I have conquered it.  The thing is, I want to love it because writing plugins is so easy, not because it's an ordeal that I can survive.

I was talking to John about this yesterday, and we laughed about the fact that the final working code for any Kwiki plugin is usually just a few lines of code.  Kwiki and Spoon are damned elegant, but only the select few who bother reverse engineering them get to learn that!  I suggested, to Ingy, that a "Kwiki Plugin Developer's Notebook" might be a good idea, and now I think I might do some work in that area.

This recent bout of Kwiki hacking began because of YAPC and work.  We have a wiki at work, and I wanted to make it a little more useful.  I was encouraged by the short visit I made to the Kwiki talk at YAPC, so I got to work. Everything I did there was pretty painless, and I felt ready to have another go at making a personal wiki for jotting down some things that don't quite fit into the Rubric model of note-keeping (yet).  Using some code from John (which used some code from Ian), I made Kwiki respect Rubric logins.  Now if you wanted a username, you needed an account on my Rubric.

Next, mostly for work, I wanted to get rid of the (obnoxious, in my opinion) Kwiki::Keywords feature of automatic keywords.  Keywords are like tags, but the default behavior of K::K is to add a keyword for any user who edits a page.  If JoeBloggs edits HomePage, HomePage gets the JoeBloggs keyword.

Well, this should have been a tiny change, and trivial to implement.  It was, really, except that it didn't work.  A few more experienced Kwiki hackers from #kwiki had a look, but they were stumped, too -- briefly.  It turned out that when I was calling the "hub" method on $self in the automatic keywords method, it wasn't getting the same hub as it would get if I called it on another object.  Or at least that's how I understood the problem.  I thought that the hub was the hub was the hub, but... anyway, I made it work, despite much grumbling on my part.

Next up, I wanted a login to be mandatory to make any changes. Kwiki::Edit::RequireUsername did this, but I didn't know that.  I implemented my own module to do it, which caused me a little trouble again -- but not much -- as I figured out how hooks worked, and read up on the useful methods in Spoon::DataObject.  I had also looked at Kwiki::PagePrivacy, but it seemed like overkill: I didn't need special levels and groups.  I just wanted to keep the unwashed masses out!  It also required views, and I'm operating under the assumption that I will find views really annoying.  That's just a guess, though.

When John pointed out RequireUsername to me, I decided I'd stick with my version.  I think it's better for my purposes, but I need to double-check.

My next victim was Kwiki::ShortcutLinks.  It lets you define WAFL phrases that act like Mozilla's quicksearch links.  I had installed that at work, and it seemed incredibly useful.  I wanted to hack it to be incredibly usefuller. First I made it possible to override the automatic link text, which was trivially easy.  Next I wanted to be able to mark some shortcuts as accepting un-escaped parameters.  See, I wanted a shortcut link so that {_:/foo/bar.txt} would turn into http://my.server.name/foo/bar.txt -- the problem was that the slashes were being escaped.  So, I thought this would be easy, too.  ShortcutLinks stores each shortcut's definition in a string, and it just splits the string on whitespace.  The left hand is the URI and the right hand is used to prefix the link text.

"Well," I thought, "I'll just store some shortcuts as hashes, and convert the string versions into hashes on first read.  That way, shortcuts can be done in the old way or the new way."  I just couldn't get it working, though.  I started getting really weird behavior on my new-style shortcut, so I had a look at the registry.  My nested hash in shortcuts.yaml was being converted into a series of top-level hash entries whose keys began with whitespace.  The YAML was not being parsed correctly.

A little bit of digging showed that Spoon::Config doesn't use YAML.pm, it just uses a few regular expressions to parse a sort of YAML-like syntax.  I patched Spoon::Config to read real YAML, Kwiki::Toolbar to write real YAML to its configuration file, and that was that.  Everything worked.  Using real YAML for configuration files is a real win, I think, and it blew my mind that Spoon didn't.  I think it must just be an artifact of the days when YAML.pm was sort of lousy.

I've got a few todo items for Kwiki hacking left.  I want to make Keywords respect the page:is_writable field, so that JoeBloggs won't start tagging my pages for me.  I might try to write a better keyword search, but I'm not whether it's worth it, yet.  I'm also considering making each page consist of two parts: the body and the margin, so JoeBloggs can write to the margins, but only I (or other users with logins, of which there are none) can write to the body.

Now, if only Kwiki were fast... 
