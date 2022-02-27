---
layout: post
title : "\"dzil setup\" for first-time users"
date  : "2010-06-25T11:56:23Z"
tags  : ["distzilla", "perl", "programming"]
---
I've just finished, but not released, a `dzil setup` command.  If a user runs `dzil` (for most purposes) without a `config.ini` present, this warning is displayed:

    ~/code/cs/Dist-Zilla$ dzil build
     WARNING: No global configuration file was found in ~/.dzil -- this limits the
     ability of Dist::Zilla to perform some tasks.  You can run "dzil setup" to
     create a simple first-pass configuration file, or you can touch the file
     ~/.dzil/config.ini to suppress this message in the future.

If you run `dzil setup`, you see this:

    ~/code/cs/Dist-Zilla$ dzil setup
     What's your name? Ricardo Signes
     What's your email address? rjbs@cpan.org
     Who, by default, holds the copyright on your code?  [Ricardo Signes]: 
     What license will you use by default (Perl_5, BSD, etc.)?  [Perl_5]: 
     Do you want to enter your PAUSE account details?  [y/N]: y
     What is your PAUSE id?  [RJBS]: 
     What is your PAUSE password? PeasAreDelicious
     config.ini file created!

...and after doing that, you have a `~/.dzil/config.ini`:

    [%User]
    name  = Ricardo Signes
    email = rjbs@cpan.org

    [%Rights]
    license_class    = Perl_5
    copyright_holder = Ricardo Signes

    [%PAUSE]
    username = RJBS
    password = PeasAreDelicious

Hopefully this will make it a bit easier to get started directly out of the box.
