---
layout: post
title : continued vim syntax to rtf conversions
date  : 2007-09-08T03:23:39Z
tags  : ["perl", "programming", "rtf", "syntax", "vim"]
---
I've implemented a very, very crude Vim colorscheme parser.  It's a terrible implementation, but it probably works against most color schemes.  Most importantly, it works against mine.  Patches welcome.

With this, you can now hardcode the path do your preferred colorscheme file and have it use your preferred colors, more or less.  The biggest practical problem is that Text::VimColor, as far as I can tell, will only ever return the generic universal Vim highlight groups.  You can't pick up things like special highlighting for, say, htmlItalic.  That's probably just fine.

    http://rjbs.manxome.org/hacks/perl/#synrtf

I'm dreading the work to make this deal with Keynote directly... but maybe it will end up being a cake walk! 
