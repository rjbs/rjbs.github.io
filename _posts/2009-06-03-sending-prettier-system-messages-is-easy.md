---
layout: post
title : "sending prettier system messages is easy"
date  : "2009-06-03T17:16:23Z"
tags  : ["email", "perl", "programming"]
---
I've always liked
[Email::MIME::Kit](http://search.cpan.org/dist/Email-MIME-Kit), and I just keep
liking it more.  This week, I wrote a [Markdown-based
assembler](http://search.cpan.org/dist/Email-MIME-Kit-Assembler-Markdown/)
class.  Assemblers turn the templates, stash, and other configuration into the
MIME message.  Right now, they're sort of a mess, but they're really, really
useful.

The Markdown assembler is sort of the non-toy version of my
[smarkmail](http://search.cpan.org/dist/App-Smarkmail) program.  You can
produce a kit that contains only a minimal manifest and a file written in
Markdown and EMKit will produce a multipart/alternative message using the
Markdown as the plaintext.  It renders the Markdown into HTML (using
[Text::Markdown](http://search.cpan.org/dist/Text-Markdown) and wraps that in a
static wrapper you provide.

Now if we want to make a system transaction send a pretty email, we only need
to write a small amount of Markdown and we get a nicely formatted, colorful,
just-like-the-rest-of-our-site email that looks great in `mutt` too.  I see
much prettier system messages in our future.

