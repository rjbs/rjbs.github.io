---
layout: post
title : "blogging better"
date  : "2004-05-20T02:57:00Z"
tags  : ["code"]
---
So, I complained that Bryar isn't making my life full of roses and cherries.  A large part of that is my own fault, I will admit.  The problem, in summary, is something like, "Bryar takes care of all the hard stuff, but now I need to write all the easy stuff!"  I had written a DataSource and Document class, but they were pretty hacky.  So, my blogging experience has been meh.  Also, I've been using WikiFormat, but only sort of.  I really want Mint, but I didn't want to wait or to implement it myself, so WikiFormat was a reasonable alternative. It was just annoying, in a few ways, and didn't map everything I wanted.

I wanted to write a datasource multiplexer, but this was going to be made easier by the refactoring of Bryar's internals to pass configurations around instead of full Bryar objects.  I wrote a patch, which was fired into the void. I didn't want to code against the idea that the changes would be accepted as written, so I didn't want to write the multiplexer.  This gave me a reason to do nothing /and/ blame someone else for it, which is an obnoxiously easy-to-take option.

So, in some ways Simon's new "I'm gonna write a giant new MT-killer" eliminates that excuse, since as far as I can tell it implies "Bryar is abandoned!" Rather than wait for some massive next-generation more-than-I-need software, I'm pressing ahead with better replacement parts for Bryar.

I rewrote my DataSource, which was simple but time consuming, largely because I wasn't sure, when I started, what I wanted it to do.  Then I converted my old journal entries, which let me put to use my newfound (primitive) understanding of awk.  I also made it more specific than it needs to be, but I'll fix that soon enough, when I finally make it multiplex and render the way I want.

I also co-opted Simon's "blog" script, tying it to some of my source's silliness via a Vim script.  This will be my first entry written using it, but not the first to get posted to use.perl.org via it, as it can't do that yet. Soon enough!

I'm feeling semi-optimistic.

