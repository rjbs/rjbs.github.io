---
layout: post
title : "testing and logging with Dist::Zilla"
date  : "2010-03-08T15:02:32Z"
tags  : ["distzilla", "perl", "programming"]
---
I feel like I'm making enough progress, right now, to make a grant update every
day.  I don't know how long this will last, but I'm glad that it's going so
well, so far.

I got a lot of preliminary improvements done to logging, mostly described in
[yeserday's post](http://rjbs.manxome.org/rubric/entry/1820).  They scrunched
the default output way down to fit on the screen and be readable.  Now that I
had logging working, it seemed like time to bite the bullet and really get to
work on testing.

I made some improvements to
[App::Cmd::Tester](http://search.cpan.org/dist/App-Cmd-Tester), trying to
capture the exit code of applications that call `exit`.  I'm not entirely happy
with how it works -- it interferes with Test::Builder sometimes, it seems.
Still, it's better than nothing.  I made a few other changes, too, making the
App::Cmd::Builder easier to extend and providing more information back in the
results.  For example, you can now say:

    my $results    = test_app(AppClass => \@my_argv);
    my $app_object = $results->app;

This is really useful when the app object is a Dist::Zilla::App, because you
can do things like:

    my $app_object = $results->app;
    my $zilla      = $app_object->zilla;
    my $build_dir  = $zilla->built_in;

Obviously, this makes testing Dist::Zilla a lot easier.

I've also written a subclass of Dist::Zilla just for testing, which will copy
the source material to a temporary directory and then build to another part of
that temporary directory.  Then the programmer can inspect the files written to
disk, the state of the Dist::Zilla object, and more.  I also hope to write a
simple way to ask, "Did anything alter the source tree?"  (That will often
constitute a bug, but not always.)

Unfortunately, I've exposed one bug and one (recent) design flaw.  The bug is
something I've basically known to be there all along, and hasn't mattered
at all for normal use.  In short, you can't build a dist unless the dist root
(the place with the `dist.ini` file) is your current working directory.  If you
try, things break, because too many things work with relative paths and never
properly make them absolute.  This, I hope, will not be very hard to fix.
Fortunately, I can work around it with judicious use of
[File::chdir](http://search.cpan.org/dist/File-chdir/) for now.

The more annoying problem is that the logger design is a problem.  I still like
Log::Dispatchouli and plan to keep using it as the default logger, but the
way the existing logging framework works is just too leaky.  It acts like the
logger can be replaced, but it clearly can't, and even doing things like
logging everything to a test object isn't easy enough.  I have a few possible
solutions to this, ranging from the brutal-but-easy to the
complicated-but-maybe-more-useful.

I think I'll start with the latter, assuming that I won't actually need the
added complexity.  At any rate, I think it's extremely likely that before the
end of the week I will have a nice simple way to test Dist::Zilla's behavior in
automated tests without copying and pasting a lot of ugly code.  This is
really exciting, because it means I can start writing tests for Dist::Zilla.
It's also really scary, because I'm pretty sure that writing tests for
Dist::Zilla is going to be a big drag.  That's okay, though, because it's what
I'm getting paid to do.

Finally, I thought I'd note one other really exciting thing.  Dist::Zilla has a
lot of dependencies, mostly because I've tried to factor out any code that can
be useful elsewhere, but also because I've tried to use existing tools when
they exist.  Now that I'm trying to get these improvements made to Dist::Zilla,
I'm finding that a lot of them need to go in external libraries.  That means
that this grant to improve Dist::Zilla is also going to improve App::Cmd,
Log::Dispatchouli, Pod::Weaver, and probably a bunch of other libraries.  That
makes me pretty happy about the decisions I've made so far.

