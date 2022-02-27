---
layout: post
title : testing work on Dist::Zilla to begin
date  : 2010-03-14T04:24:58Z
tags  : ["distzilla", "perl", "programming"]
---
Guess what I worked on today in Dist::Zilla?  Logging!  I'm beginning to think
I may have a logging-tweaking addiction.

Actually, the logging changes I made were quite minor.  Most of today's work
was in re-documenting Getopt::Long::Descriptive, which was only tangentially
related to Dist::Zilla -- but it was pretty sorely needed.

The big win in the final(?) set of logging changes is that I can now enable
debugging logs per-plugin, or just for the core Dist::Zilla library, or
globally.  For example:

    $ dzil build -v
    [ absolutely all debugging output ]

    $ dzil build -v PodWeaver
    [ normal logging, plus debug output from PodWeaver plugin ]

    $ dzil build -v PodWeaver -v AllFiles
    [ normal logging, plus debug output from PodWeaver and AllFiles plugins ]

    $ dzil build -v -
    [ normal logging, plus debug output from Dist::Zilla core behavior ]

As I write tests, I will be adding a lot more debugging output, and getting at
just the debugging output I want will be (I predict) extremely useful.  I
improved the way I access log messages when testing, which should be similarly
helpful.  Finally, I added a means to suppress the logging of fatal messages to
selected output streams, meaning that `log_fatal` no longer prints the error
message and then dies with it.

I did make one other quick addition:  I added a new `dzil nop` command, which
does nothing but initialize the Dist::Zilla object.  This makes it easy to run:

    $ dzil nop -v

...and see all the "plugin foo (package v1.23) online" messages.

Tomorrow, assuming I can stay awake, I'll probably start getting to work on
writing useful tests.  If I had remembered that daylight saving changes
tonight, I would've gone to bed earlier!

