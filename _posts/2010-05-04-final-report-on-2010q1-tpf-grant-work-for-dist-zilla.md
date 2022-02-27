---
layout: post
title : final report on 2010Q1 TPF grant work for Dist::Zilla
date  : 2010-05-04T18:36:17Z
tags  : ["distzilla", "perl", "programming"]
---
Here's the meaningless top-level lines-of-code changes performed during my
grant work:

    151 files changed, 4568 insertions(+), 1371 deletions(-)

Some of that work came from people other than me, but almost all of it is
by me and directly the result of the Perl Foundation grant.  As each milestone
was completed, more and more people seemed to begin to show interest.  Dozens
of new plugins were written and the whole system was shown to be capable of
working in ways I hadn't imagined.

Just before I started work on the grant, there were 284 distributions on the
CPAN identifiably using Dist::Zilla, from 45 distinct authors.  Now there are
513 distributions from 77 authors, and usage still seems to be growing.  I hope
the Perl Foundation's investment appears successful to TPF and its donators as
it does to me.  They made it possible to do a lot of work that would probably
have otherwise sat, for a long time, in the "too boring to contemplate doing"
pile.

Here's a summary of deliverables included in the original grant proposal:

## Testing and Logging

    proper logging facility                                                       
    reusable testing tools                                                        
    extensive testing of the core                                                 

The logging and testing changes happened first, and what a relief that was.
Having regression tests for your old code makes new code easier to add with
confidence.  It was easy to get Dist::Zilla pretty far without tests, but so
much work needed to be done refactoring guts, rather than just adding more
features, that tests were crucial to have.  As for extensive testing of core, I
think coverage is pretty good.  There's plenty of room for improvement, but
now those additional tests should be easy to write.  More importantly, other
plugin authors can now use the core testing libraries to test their plugins,
which was, previously, an incredibly hairy process.  Dist::Zilla was written in
part to replace other, very hard to test systems, and I didn't want it to be another
one.

Also, with other plugins made testable, I could feel more at liberty to break
them by making incompatible changes to Dist::Zilla.  It would make tests fail,
quickly identifying breakage and making it possible to quickly release a fixed
version.  I broke backward compatibility a few times, once quite significantly,
and I plan to do so again in the future, although in increasingly limited
scopes.  Having the test system should be a huge boon.

## Refactoring and Code Re-use

    simplification of the command line tool's code                                
    core set of well-known FileFinder plugins                                     
    event structure for distribution creation                                     

The command line tools have definitely been simplified.  Very few of them do
anything more complicated than call a method after some slight argument
munging.  We haven't gotten many gains from this yet, but I feel it's been a
good change.  It makes it easier to share behavior like testing, and when we
end up with more interesting forms of Chrome (interface delegates), we'll be
able to instrument Dist::Zilla without wrapping a command line program.

The core file finders has been a big win, too, by making it easy to refer to a
conceptual notion of files.  For example, you can write a plugin that will do
something to "all the libraries we're going to install" or to "all the
executable programs we ship."  It also got us the notion of plugin names that
get default-configuration plugin objects dropped in when no plugin is given.
This has paid off in other areas already, and will probably keep doing so.

One payoff was in the newly-released `dzil new` command, which can be used to
build a new distribution using Dist::Zilla.  This takes the place of tools like
Module::Starter, making it easy to do build new distributions that have none of
the boilerplate that Module::Starter centers around.  Because minting new
distributions centers around the same sort of plugin/event system that powers
distribution building, it's easy to add plugins to do all sorts of things, like
import your new distribution into version control.  Because Dist::Zilla plugins
can be used across multiple actions, it will be possible to re-use things like
Perl module making plugins later to add new modules to existing distributions.

At first, I was baffled when people wanted a distribution starter tool built
into Dist::Zilla, because Dist::Zilla had been created to avoid needing
boilerplate.  Now that I have `dzil new` working, I can definitely see the
benefits on the horizon.

## New Features

    improved prerequisite handling                                                
    improvements for authoring distributions containing XS                        

Prereq handling was a big win, and it hasn't yet been entirely realized.  I
wrote Version::Requirements to handle comparing versions to the weird
conditions that META.yml allows and used that to replace the lousy "hash of
versions" that was being used.  Jerome Quelin's excellent AutoPrereqs plugin
was updated to interact well with it, and then the libraries that implement
META.json 2.0 were built on it, too.  It's now extremely easy to deal with the
big blob of different kinds of prereqs, and once a few changes are made to
CPAN::Meta, it will become even easier.

The XS improvements made by me have been minimal, and boil down to two things:
I gave Ævar some tiny amount of help while he worked in the Makemaker::Awesome
plugin, and I made a large set of notes and todo items for making XS
distributions easier to manage in the future.  It will take quite a while to
get through those notes, but the whole system will benefit.  In the meantime, a
number of XS dists have been released using Dist::Zilla, showing that it's now
possible to do.

## Documentation

    documentation: improved new user's guide                                      

Well, there is one!  [dzil.org](http://dzil.org/) now exists, and has a
tutorial and some other helpful information.  The tutorial is designed to be
easy to expand, and I'm sure it will over the next few weeks and months.  I
also hope to find a way to distribute it, in somewhat altered form, as
installable Pod in a CPAN distribution.  I'll also be giving presentations on
Dist::Zilla at [YAPC](http://yapc2010.com/yn2010/talk/2591) and
[OSCON](http://www.oscon.com/oscon2010/public/schedule/detail/13632), and once
those are complete I'll update the slides with feedback received from the
audiences and I'll publish the slides -- hopefully with an audio track.

So, all told, I think this was a very successful bunch of work.  It's already
very clear, too, what the next big obstacles to overcome are, and I look
forward to working on them to make Dist::Zilla more powerful, more flexible,
and easier to maintain.

