---
layout: post
title : "PTS 2019: Getopt::Long::Descriptive (2/5)"
date  : "2019-04-30T00:37:51Z"
tags  : ["perl", "programming"]
---
One non-PAUSE thing I worked on was
[Getopt::Long::Descriptive](https://metacpan.org/pod/Getopt::Long::Descriptive).
I added a small new feature.  It supports something like this:

      describe_options(
        "%c %o ARG...",
        [ "foo",  "should we do foo?" ],
        [ "bar",  "should we do bar?" ],
        [ <<~'EOT' ],

          How should you know whether to use --foo and --bar?  Well, the choice
          is simple.  If you want to foo, use --foo, and if you want to use bar,
          don't, because --bar hasn't been implemented.
          EOT
      );

This is okay, but when you run it, you get:

      examine-program [long options...] ARG...
        --foo  should we do foo?
        --bar  should we do bar?
        How should you know whether to use --foo and --bar?  Well, the
        choice
      is simple.  If you want to foo, use --foo, and if you
        want to use bar,
      don't, because --bar hasn't been implemented.

Waaaa?  Well, GLD is helpfully trying to word wrap and indent text for you, and
it does a terrible job in the case of large hunks of text that you want
displayed verbatim.  I added a way to tell it to trust you, the author, on the
indenting.

      describe_options(
        "%c %o ARG...",
        [ "foo",  "should we do foo?" ],
        [ "bar",  "should we do bar?" ],
        [ \<<~'EOT' ],

          How should you know whether to use --foo and --bar?  Well, the choice
          is simple.  If you want to foo, use --foo, and if you want to use bar,
          don't, because --bar hasn't been implemented.
          EOT
      );

Did you miss it?  It's the `\` turning there heredoc string into a reference.

Of course, the code to implement this was nearly trivial.  I spent more time on
figuring out what was going on where than I did fixing it.  I expect to start
using this feature in other code more or less immediately.

