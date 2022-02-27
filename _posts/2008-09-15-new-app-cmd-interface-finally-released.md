---
layout: post
title : new app cmd interface finally released
date  : 2008-09-15T12:30:59Z
tags  : ["perl", "programming"]
---
One of the earliest libraries I wrote for Pobox is ICG::CLI.  It makes it easy to write CLI programs by tying together Getopt::Long::Descriptive with some common options (like help and verbose) and a few bits of code to make them work.  So, you got three routines, `whisper`, `say`, and `yell`, which were like `printf`, but respected the verbose and quiet flags.  (This got refactored into Log::Speak, which I don't think was ever released.  Oh well.)

Later, I pulled out Rubric's subcommand dispatch code out into App::Cmd, and that was a big success, and used GLD, but didn't get you the printing builtins for verbose operation.  Also, building them in wasn't going to be easy, because App::Cmd was OO instead of just a few imported routines.  I finally decided on a way to make it happen, about six months ago, and it was a lot of fun to implement.  It makes writing App::Cmd programs even easier, introduces fun uses for Sub::Exporter and lets you write plugins that provide exported functions into all your commands magically.  That means that this is now possible:

    package MyApp::Command::purge;   use MyApp -command;

    sub run {     my ($self, $opt, $args) = @_;

      debug for $args->flatten;   }

    1;

...because you can have (for example) a `debug` routine and autobox imported into every command automatically.  I have a number of plugins to write to make this possible, and I've basically been putting off the release for months, waiting to get them written, but I had enough people saying, "Seriously, can you release what's in your git repo?" that I finally broke down and did it.

Hopefully I'll get some cool plugins written, real soon now. 
