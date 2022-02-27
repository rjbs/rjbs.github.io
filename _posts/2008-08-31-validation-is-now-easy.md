---
layout: post
title : "validation is now easy"
date  : "2008-08-31T03:11:18Z"
tags  : ["programming", "rx"]
---
Okay, the title might be a filthy lie, but it's just a reference to my
[previous posting](http://rjbs.manxome.org/rubric/entry/1647) about the fact
that I couldn't find a single data validation system (read: schemata) for
JSON-like data.  I found plenty of schema languages for XML, one for YAML that
was never going to be suitably cross-platform, and one for JSON (json-schema)
that seemed over complicated and likely to become unmaintainable, and then some
other things that don't warrant much mention.

I started sketching a system of my own on the flight back from OSCON, and it's
been close to done for about two weeks now, while I make tweaks and apply some
polish.  I just finished committing what I hope is the final design change, and
starting next week I hope to start making real, installable releases of the
implementations.

I say "releases of the implementations" because there are five.  I've
implemented my schema system, called Rx, in Perl, Python, Ruby, PHP, and
JavaScript.  The test suite for Rx is a set of JSON files that define schemata
and input data and provide expectations of what each schema should accept or
reject.  All you have to do to implement Rx in your language of choice is write
something to load and run these tests.  By way of example, the Ruby test
program is about 2 kB, or 75 non-blank lines.

All of the implementations could use more documentation, polish, packaging, and
refactoring.  Each one was written in an evening, more or less, and then just
tweaked as the design was tweaked.

I'll write much more about Rx as I polish it and begin using it more heavily.
I have a lot of plans for add-on systems that will work in conjunction with Rx
without impacting Rx's own simplicity.

In the meantime, you can read about what it can do, how it works, and how you
can get a copy at [the Rx web site](http://rjbs.manxome.org/rx/).

