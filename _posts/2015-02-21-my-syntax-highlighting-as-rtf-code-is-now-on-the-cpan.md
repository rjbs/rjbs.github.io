---
layout: post
title : "my \"syntax highlighting as RTF\" code is now on the CPAN"
date  : "2015-02-21T01:04:50Z"
tags  : ["perl", "programming"]
---
In 2007, I wrote code to generate RTF that syntax highlights code, using Vim's
syntax highlighting.  I wrote about it in [an earlier
post](http://rjbs.manxome.org/rubric/entry/1509) [or
two](http://rjbs.manxome.org/rubric/entry/1507).  After that, I didn't think
about it much, apart from fixing a couple things once in a while or running it
once every year or so.

Earlier this week, David Golden tweeted a link to [Joshua Timberman's blog](http://jtimberman.housepub.org/blog/2015/02/10/awesome-syntax-highlighting-in-keynote/), in
which he was using a different tool, called
[highlight](www.andre-simon.de/doku/highlight/en/highlight.php), for the same
purpose: getting highlighted code into Keynote slides.  He sounded pretty
excited about it, so I thought maybe somebody would be excited about my
program.  (Over time, I've come to *really* appreciate having the same
highlighting on my slides as in my editor!)

Rather than point at my GitHub repository in a tweet or something, I decided to
make a proper CPAN release, which meant improving the code a fair bit and
writing at least a very thin bit of documentation.

I've now released [RTF::VimColor](http://metacpan.org/release/RTF-VimColor) on
the CPAN.  You can install it and you end up with `synrtf`, a program that
reads source code from a file and prints out RTF.  You can (as Joshua points
out) do something like:

    synrtf lib/Awesome/Code.pm | pbcopy

...and then paste it into Keynote.  Or whatever!  Use it for printable code
listings!  Or do other cool stuff!  Just have fun!

