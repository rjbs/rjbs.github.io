---
layout: post
title : "what the heck is distzilla?"
date  : "2008-10-27T15:58:02Z"
tags  : ["distzilla", "perl", "programming"]
---
At the Pittsburgh Perl Workshop this year, I gave a [lightning talk about
Dist::Zilla](http://www.slideshare.net/rjbs/distzilla-presentation/), the
system I am increasingly using to manage my CPAN distributions.  I'm using it
instead of writing a `Makefile.PL`, but it doesn't do the same thing as
Module::Build or ExtUtils::MakeMaker.  I'm using it instead of running
`module-starter`, but it doesn't do the same things as Module::Starter.  I've
had some people say, "So should I stop using X and use Dist::Zilla instead?"
The answer is complicated.

(Well, actually, for now the answer is simple: probably not.  Dist::Zilla is a
lot of fun and I really, really appreciate the amount of work it saves me, but
it's really young, underbaked, and probably full of bugs that I haven't noticed
yet.  Still, the adventurous may enjoy it.)

The idea behind Dist::Zilla is that once you've configured it, all you need to
do to build well-packaged CPAN distributions is write code and documentation.
If you're thinking, "but that's what I've been doing anyway!" then first
consider this:  If you are writing `=head1 NAME\n\nMyModule - awesome module by
me` then you are not just writing code and documentation.  If you are adding a
license to every file, again, you are not just writing code and documentation.

If you use, say, Module::Starter to get all this written for you, then you're
safe from writing that boilerplate stuff.  Unfortunately, if you need to change
the license, or you want to add a 'BUGTRACKER' section to every module,
Module::Starter can't help you.  It creates a bunch of files and then its job
is done.  It never, ever looks at your module-started distribution and fixes up
things.  This also means that if you realize that your templates have failed to
include `use strict` for your last three module-started distributions, you have
to fix them by hand.  The same goes for the stock templates, which until
recently didn't include a license declaration in the `Makefile.PL`.

With Dist::Zilla this content is not created at startup.  It is not stored in
your repository.  Instead, the files in your repo are just the code,
documentation, and the Dist::Zilla configuration. When you run `dzil build`,
your files are rebuilt every time, adding all the boilerplate content from your
current setup.  If you want to change the license everywhere, you change one
line.  If you want to start adding a VERSION header, you tweak the Pod::Weaver
plugin's configuration.

So, there does exist a `dzil new` command for starting a new distribution.  All
it really does, though, is make a directory (maybe) and add a stock
configuration file.  Why would it add anything else?  If you want any code, you
would only be writing the actual code needed, not any boilerplate, so adding
*anything* would be foolish.

There's also `dzil release`, which goes beyond what Module::Starter (and its
competitors) do and into the realm of ShipIt or Module::Release.  I'm hoping I
can integrate with or steal from one of those sort of tools.  Right now, it
exists, but all it does is build a dist and upload it.  In the future, it will
have at least two more kinds of plugins to make the release phase more useful:
VCS (so it can check in and tag releases) and changelog management.  It has a
changelog thing now, but it stinks and isn't very useful.  In the future, you
won't need to edit a changelog.  It will be able to read changes out of your
commits, or you will just tell it to record a changelog entry.  Then the
Changes file can be generated as needed.

For now, I am manually editing my Changes file.

So, eventually Dist::Zilla could obsolete Module::Starter for people who like
what Dist::Zilla does.  Then again, people might still want to have starter
templates that add minimal boilerplate for using certain frameworks.  We'll see
what happens.

