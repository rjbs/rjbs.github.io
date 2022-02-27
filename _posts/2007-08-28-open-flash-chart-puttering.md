---
layout: post
title : open flash chart puttering
date  : 2007-08-28T01:55:54Z
tags  : ["chart", "flash", "programming", "web"]
---
A few weeks ago, I found [Open Flash
Chart](http://teethgrinder.co.uk/open-flash-chart/) and put it in my list of
things to look at.  It's pretty slick-looking.  What I found, though, is that
the helper libraries are sort of wretchedly interfaced.  Basically, they
all output data files that the flash plugin uses to build charts.

Lines in the data file seem to work like this:

    &method=param1,param2,param3,...&

The format of the data file is very similar to the PHP methods, but there's
often a difference or two.  For example, here's a PHP method prototype:

    line_dot(
      int $line_width, int $dot_size, string $colour, string $key_text, 
      [ int $key_size ]
    );

The line in the file, though, looks like this:

    &line_dot=$line_width,$colour,$key_text,$key_size,$dot_size&

The documentation on the web page is only for the PHP library, and it's very
strangely organized.  I'm trying to decide whether it's worth the effort to
figure out the data file format from the PHP and document it, and possibly
construct a better Perl interface.

I'd be more interested if I had more of a need for charts!

