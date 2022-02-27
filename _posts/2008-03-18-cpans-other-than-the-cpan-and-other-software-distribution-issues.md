---
layout: post
title : cpans other than the cpan and other software distribution issues
date  : 2008-03-18T03:10:33Z
tags  : ["perl", "programming"]
---
One of our current projects at work involves streamlining the way we deploy
software to our hosts.  The solution in hand is sort of like a much improved
CPAN::Mini::Inject.  It allows us to declare what CPAN modules we use, and to
index our own internal projects as if they were CPAN modules.  It will also let
us automatically run our test suite to see how updates of CPAN modules would
affect our code, and to hard-pin distribution versions so that we never try
testing new versions that we know can't work.

Yes, we'll be releasing it when it's done.

The important thing that people sometimes don't think about is that the CPAN is
really just a bunch of data that conforms (more or less) to a very simple API:
there are a few directories that contain some files that are fairly
machine-readable.  They've gotten even more machine-readable lately with the
addition of META.yml files to many (most?) distributions.  You can very easily
build your own CPAN instance and point a CPAN client at it.  That's all that
CPAN::Mini does: it builds a custom CPAN with a lot fewer tarball files in it.
It doesn't build its own package index, though, and that's part of what we're
working on.

Anyway, testing these sorts of tools requires some test data.  You don't want
to have to maintain a snapshot of the actual CPAN for testing, and you can't
rely on a live mirror, because it changes.  Ideally, you'll have a set of data
that is as small as it can be while still exhibiting every quirk you've had to
test for.  Right now, I've been slapping together tools for building fake CPAN
instances out of simple descriptions.  Happily enough, META.yml files can serve
as pretty good descriptions of what a distribution should contain, so
CPAN::Faker (which uses Module::Faker) builds an entire CPAN instance from a
collection of META.yml files, more or less.

It's very weird, actually:

    $ fake-dist ./example.yaml
    Wrote dist to Example-Dist-0.001.tar.gz

    $ tar zxf Example-Dist-0.001.tar.gz
    $ cd Example-Dist-0.001
    $ perl Makefile.PL && make dist

You end up with nearly identical dist files.  Neat!

It seemed pretty clear to me that this would serve as the basis for a newer,
better Module::Starter engine.  I haven't gotten thinking about that much, yet.
Instead, I did some of the most boring coding I've done in years.  I rewrote a
bit of code from ExtUtils::ModuleMaker, a Module::Starter competitor, making
Software::License.  Basically, you can say:

    use Software::License::Perl_5;
    print Software::License::Perl_5->new({ holder=>"Ricardo Signes" })->fulltext;

...and you get the complete text to put in your new dist's LICENSE file.
There's also a method to generate the snipped to put in your POD.

I'll probably release it pretty soon, although I'm not really happy with how it
works.  The interface is okay, though, so I can fix the guts later.  At any
rate, it's in our [git
repository](http://git.codesimply.com/?p=Software-License;a=summary) now.

All three of my recent dists have been under-documented and under-tested.  I
feel less than awesome about that, but... sometimes it's better to get things
started and out there than to agonize over things that can be put off for a bit
longer.

