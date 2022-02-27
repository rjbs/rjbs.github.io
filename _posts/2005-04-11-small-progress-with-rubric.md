---
layout: post
title : small progress with rubric
date  : 2005-04-11T02:45:46Z
tags  : ["perl", "programming", "rubric"]
---
I released 0.08 of Rubric the other day, which had quite a few improvements over 0.06.  There weren't any really major changes, but the little changes added up to, in my opinion, a greatly improved user experience.

I'm working on a few larger features now, but also on fixing some more subtle or stubborn bugs.  This has led me to a better understanding of RDF and RSS.  I understood the idea of RDF as a resource description framework, but I hadn't ever really read its spec and tried to understand how it worked.  As I got reports of errors stemming from "duplicated rdf:about" entries, I started to get annoyed, because RDF couldn't do something as simple as have two entries about one link.  Once I bothered reading the spec, though, I found that I was an idiot and that I could just point the rdf:about link at the entry, but the link at the bookmarked URI.

I also got to use Encode in something useful for the first time.  I now validate UTF-8 for input from the WebApp.  It's not a big thing, but it should go one step further toward making the feeds always validate.

I need to work more on autocompletion of tags in the tag entry field, but to do it the way I really want to, I need to figure out how to select a range of text in a text box.  I've seen ways to do this in Mozilla (and IE, I think), but not in WebKit.  Since that's what I use, and since I write Rubric primariliy for myself, that's the blocker.

I also made a few little updates to my journal posting script, to make it simpler to post multiple entries at once.  Now that I'm getting some use from tagging my entries, I'll probably be posting more and smaller entries, to keep the tagging accurate.

Hm, also on the short list: a calendar.  Given the /created_on query element, this should be pretty simple.  Oh, also, custom sorting.
