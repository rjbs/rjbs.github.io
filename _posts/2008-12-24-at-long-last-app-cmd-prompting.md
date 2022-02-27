---
layout: post
title : at long last, app::cmd prompting
date  : 2008-12-24T04:03:03Z
tags  : ["perl", "programming"]
---
At work, we have two kits for writing CLI programs:  App::Cmd and ICG::CLI.  I wrote both of them, and they're not quite compatible.  Oops!

ICG::CLI came first, and mostly bundled up Getopt::Long::Descriptive with a bunch of helpers like `whisper` and `prompt_yn`, along with some standard options like `--verbose`.  App::Cmd came later, spun out of Rubric, and focused on the command-with-subcommand style of application seen in `svn` or `git` or `rubric`.  It didn't have any helpers like `prompt_yn`, because it would have to export them into the classes implementing individual commands, and this seemed like a big pain in the butt.

App::Cmd 0.200 was built with an eye to fixing this, though.  Plugins can be registered with the application, and then any command class will have the plugin's helper routines built into it, properly curried to have reference to the command being executed.  This makes it easy to have lots of helper routines without having to invoke them as method calls.

The first of these is App::Cmd::Plugin::Prompt, which gets you a yes/no prompt, an "any key" prompt, and a generic "gimme some input" prompt.

I'm hoping to get a better "print stuff based on verbosity level" plugin out after I release our internal logging code, which is a nice little wrapper around Log::Dispatch.  Maybe that will even happen before Christmas! 
