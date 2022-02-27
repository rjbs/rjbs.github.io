---
layout: post
title : how to view html mail in mutt
date  : 2007-08-03T15:56:24Z
tags  : ["email", "howto", "mutt"]
---
I found this in my ~/www directory, and I thought I'd file it somewhere that I'm more likely to find it when needed, like in Rubric.  This is a little out of date, as I'd probably use something more versatile than lynx, and I'd probably be using a custom-generated mailcap.  That said, this is still useful information.

Add the following line to /etc/mailcap:

    text/html; lynx -dump %s; nametemplate=%s.htm; copiousoutput

If you already have a line beginning with text/html and ending with copiousoutput, replace it.  This command will cause text/html messages to be parsed by lynx and dumped as formatted text into temporary files.  

Add the following lines to ~/.muttrc:

    auto_view text/html
    set implicit_autoview

If you already have an auto_view line, append text/html to it if it isn't already there.  These lines will tell mutt to automatically invoke lynx as you specified above; mutt will then use lynx's output as the body of the message.

Now, when you reply to the message, mutt will use the dumped text as the body to which you're replying, so you will have that text available to quote.
