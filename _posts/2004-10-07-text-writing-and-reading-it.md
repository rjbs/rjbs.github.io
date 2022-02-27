---
layout: post
title : text: writing and reading it
date  : 2004-10-07T01:15:00Z

---
Shawn S. sent me a link to TextMate, a new OS X editor.  Their web page promises that "It's time to turn envy into pride and end your desire for Windows- and UNIX-based editors once and for all."  In case you think that's great, let me advise you: it's bullshit.

First of all, "UNIX-based" seems bizarre, since Mac OS X is UNIX.  Fine, though, whatever.  I know what they're trying to get across.

Their big features: project files and a file explorer, tabs, mutiple clippings, macros, abbreviations, autocompletion, "column typing."  They also have syntax highlighting.  Vim does all of this.  So does emacs.  The more important fact, though, is that Vim and emacs are easily exensible.  I can write new syntax rules.  I can make keybindings that rewrite auto-completion.  I can change the way automatic folds are computed.

I am /all for/ a new text editor with the flexibility and power of Vim or emacs.  Hey, if it only runs on OS X, I can live with that.  I just don't know why so much mediocre software is out there claiming to be the big new thing and demanding money for it.  I'd pay for something that did 95% of what Vim does, if it was slicker and more flexible.  Asking me to pay for a non-portable Vim Lite with no Perl highlighting and broken Ruby highlighting, though, is pretty ballsy.

As for the reverse, I've been working on code to parse Project Gutenberg's Roget's Thesaurus.  It's a wildly broken file.  The notes act like they want to make it easier for people to parse it, but that's a laugh.  It's a mess of awful.

Still, I think I have the vast majority of it working.  There are some cases where I had to cope with being wrong, but not too many.  I need to fix some of the bracket- and quote-matching, but it's a pretty small impact.  Shawn B and I are talking about using its output to make some awesomer Roget interfaces.  I'm looking forward to it.

