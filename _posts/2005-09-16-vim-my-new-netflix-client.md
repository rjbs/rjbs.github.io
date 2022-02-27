---
layout: post
title : "vim, my new netflix client"
date  : "2005-09-16T04:21:22Z"
tags  : ["html", "movies", "perl", "programming", "web"]
---
Tonight, I was struck by an urge to JFDI.  For a long time, I've wanted a better way to organize my Netflix queue.  There used to be Netflix Freak, which was decent, but cost money, and I think it went away.  I think it had other problems, I just can't remember anymore.

Anyway, what I really wanted was a way to save my queue to a text file, edit the file, and then upload it again.  It should have been simple, but the form used on Netflix is pretty ugly, and I was having a hell of a time figuring out how to deal with it using TokeParser, which is built in to Mech.  I knew it wasn't the right sort of parser, but I didn't know what was better.  Finally, I asked #perl where I could get something to say "for each div of class foo, do X."  DrForr pointed me toward HTML::Tree, which made this task incredibly simple.

Now I can save my queue, rearrange the file, and update my queue.  No more trying to remember what number I put in front of what, no more trying to keep lots of changes in my head at once.  I put the lines in the order I want and hit "go!"  It doesn't delete or add movies yet, but I may (or may not) add that.  Tomorrow I'll probably collect these two little hacks into one program with some command line switches.

In the meantime, I would like everyone to know that Sean Burke and Andy Lester deserve candy and hugs for giving away such great toolkits. 
