---
layout: post
title : "i am going to break your app::cmd code (not really)"
date  : "2009-08-28T00:51:17Z"
tags  : ["perl", "programming"]
---
The next release of App-Cmd, 0.300, will break backwards compatibility with
App::Cmd::Simple.  Nothing on the CPAN is registered as using it but I'm sure
it's being used.  *All other uses of App::Cmd should be fine.*

The issue is that I foolishly used the method name `run` for both apps and
commands.  In other words, when you ran this:

    ~$ myapp somecmd --xyzzy

...the result was that `MyApp->run` was called, which then called
`$some_command->run`.  This was not a huge deal, except in App::Cmd::Simple,
which combines being an app and a command into one class.  The existing hack
was really gross.  If you want to see how it worked, check the code.
Basically: it was yuck.

The new code is much better, and reduces the ugliness to a much smaller level,
and can probably be further improved without further breakage.

From here on out, commands are expected to have an `execute` method, not a
`run` method.  Normally, if you call `run` it will find `execute` and invoke it
-- and if you're running your test suite, it will complain that you're using
the wrong method name, to encourage you to update to the new name.

Simple can't do that, though.  I could have allowed both, but it would have
defeated the purpose of simplifying.  Instead, I'm declaring it busted and
fixing it.  After all, this warning appeared in App::Cmd::Simple:

    This should be considered experimental!

See?  My experiment partly failed.  Please adjust your code accordingly.

