---
layout: post
title : "progress with syntax-to-rtf"
date  : "2007-09-05T14:25:02Z"
tags  : ["perl", "programming", "rtf", "syntax"]
---
I had really wanted to use the Kate syntax stuff, because it's pure Perl, but
after I had it working, I decided that its Perl syntax highlighting wasn't good
enough, and I wanted Vim's.  So, I did what I had wanted to avoid and used
Text::VimColor.  I worked out some bugs, learned a lot about RTF, and added
nice little things like proper option parsing.

I put it [on my hacks page](http://rjbs.manxome.org/hacks/perl/#synrtf), along
with [a sample output file](http://rjbs.manxome.org/hacks/perl/synrtf.rtf).
Reading the RTF::Writer source with a clearer head made the problem I'd had
with dashes clear.  (It also makes me think that RTF::Writer needs to stop
doing what it's doing.)

There's just one big thing bugging me, now.  I can't find a way to change the
background color of the document, which I think will have to be done with a
default stylesheet or something.  I'd create a file with a black background to
inspect its contents, but I don't even see how to do that in TextEdit.

With a white background, the margins are white, and extra whitespace at the end
of the file is white.  I really want to be able to set the default background,
to address this problem correctly.

Next up, I may attempt to write a *very* crude Vim colorscheme parser.  With
that done, it just becomes a matter of automating the highlighting of text in a
Keynote text box.

