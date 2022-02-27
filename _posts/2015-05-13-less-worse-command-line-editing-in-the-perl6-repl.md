---
layout: post
title : less worse command line editing in the perl6 repl
date  : 2015-05-13T13:56:51Z
tags  : ["perl", "perl6", "programming"]
---
I've been doing more puttering about with perl6 lately.  One of my chief
complaints has been that the repl is pretty lousy, keyboard-wise.  There's no
history, so I do a lot of copy and paste, and there's no way to move left
non-destructively.  If you notice a typo at the beginning of your line, you're
stuffed.

This isn't that surprising.  Rakudo doesn't ship with a readline
implementation, and that's totally reasonable.  You have to install something
to make it go, and the common suggestion is
[Linenoise](https://github.com/hoelzro/p6-linenoise/).  It's easy to install
with [Panda](https://github.com/tadzik/panda/), the perl6 package manager.
Panda is installed with [rakudobrew](https://github.com/tadzik/rakudobrew), if
you're using it.  If not, you can just clone panda and follow the instructions.

After that:  `panda install Linenoise`

I hit a couple problems getting it to work subsequent to that.  Some of them
are fixed.  (**Update**: It looks like *all* of this has now been fixed if you use rakudobrew and install a fresh moar! tadzik++ FROGGS++)  For one, it tried to load `liblinenoise.so`, even though OS X
dynamic libraries are generally `.dylib` files.  That's fixed in the repo, and
`panda` installs from the repo.

On the other hand, the OS X dynamic loader needs some help getting paths right.
I had to fix the installed library's identity and register a path with the
MoarVM binary so that it would look for installed dynamic libraries.

For the first:

    cd ~/perl6/share/perl6/site/lib
    install_name_tool -id $PWD/liblinenoise.dylib liblinenoise.dylib

That sets the library file's idea of its own identity to its installed
location, rather than its build location.

For the second:

    install_name_tool -add_rpath $PWD $(which moar)

...which adds the cwd to the `moar` binary's library resolution path.

Now when I run `perl6`, I get a repl with somewhat working line editor.  I can
go back and forward in the line with ^B and ^F, and I back and forward in
history with ^P and ^N.  Unfortunately what I *can't* do is use the arrow keys.
I know, I know, I should probably be avoiding them, because I'm a Vim user.
Too bad, I'm used to it, except when in Vim.

Strangely enough I found that the arrow keys work under tmux.  It turns out
that my iTerm2 profile was set to default to "application keypad mode."  Why?
No idea.  To turn it off, I went to Preferences → Profiles → (my default) →
Keys → Load Preset… → xterm Defaults.

The simple test to see what was going on was to hit ^V then ←.  If I saw
`\eOD`, I was in keypad mode.  The right thing to see was `\e[D`.

Now I can edit my repl entry line easily!  There's also very rudimentary tab
completion, but frankly I'm not much of a tab completer.  I just wanted to be
able to fix my typos.  (I like to pretend that my typos all come from bumpy bus
rides, but sadly that's just not true.)

Although I did a little bit of my own digging to figure the above out, almost
all the real answers came from geekosaur++ and hoelzro++ and others on #perl6.
Thanks, friends!

