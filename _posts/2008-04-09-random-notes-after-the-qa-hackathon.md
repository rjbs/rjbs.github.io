---
layout: post
title : random notes after the qa hackathon
date  : 2008-04-09T13:05:36Z
tags  : ["perl", "programming"]
---
This is not a coherent, reflective look back.  This is a braindump.

Adam Kennedy got us to agree on some general princples of distribution building and behavior, which he called the Oslo Accords.  (Actually, he called it the Oslo Agreement, which I think is less amusing, so I'm changing his mind.)  Of the things I cared about, I was in favor of all the things that were accepted, so I am happy.

One of these things was the recognition of the right of the 'xt' testing directory to exist.  It also declared that the best way to specify release tests not in xt was to use the environment variable `RELEASE_TESTING`.  In light of some of the discussions around this, I am going to drop Module::Install::AuthorTests and create Module::Install::XtraTests (probably ExtraTests, once I've had some sleep) and it will let you set up, easily:

    ./xt
    ./xt/author   # run if you are the author
    ./xt/release  # run if you are doing make disttest
    ./xt/smoke    # run if $ENV{AUTOMATED_TESTING} is true

I think this will be great.

I'm sad that a few things didn't get put into the spec (which may or may not be really published by now) for TAP version 14.  I am dying for nested TAP.  I am sad that a few things won't be available until Test::Builder's replacement is around.  I really want to have ubiquitous metadata streams.  I am sad that there is no well-documented, feature rich YAML module for Perl -- either in the core or otherwise -- because it would make those streams even better.

That said, I am very happy with the outcome of the TAP stuff.  Nested TAP didn't go in because it wasn't possible to get it in without causing an unknown (but non-zero) number of serious problems out in the CPAN and the darkpan.

The improvements to Test::Reporter have made it easy for us to add more transports as needed, including a write-to-file transport, which I think Dave released yesterday.  I have not yet decided what kind of bizarre transport to implement to show off.  Someone suggested an IPC::MorseCode transport.

It looks like Scalar::Util::weaken is going to work on default Debian perl soon.  That's great.  I have hopes that their perlified OSSI UUID code will soon be on the CPAN, too, meaning that Data::UUID's unlicensed code can go away.

With Data::UUID replaced with code that is under a clear license, I'll be in a position to get my CPANTS board all green.  It will take a while, though, because they've added a bunch of new metrics.  It's driving me to make it easier to do a mostly automated release, since so often the fix is "correct a bogus packaging file."  I started using the `perl-reversion` script bundled with Perl::Version and found a few choice bugs, which Dieter fixed in extremely short order.  It now replaced my previous tool, the incredibly tedious:

    $ perl -pi -e 's/1.234/1.235/g' lib/**/*.pm

`perl-reversion` is more accurate, and it's easier to say:

    $ perl-reversion -bump

...and be done with it.

The metadata repositor that David Golden and I have been working on has been going well.  I'm taking a break from it for now, and I think in a few minutes, I'll try to establish a 45 minute cycle of USB keydrive updating.  See, we're on the plane and working with git, so it's easy for us to keep working, then both push to and pull from a little clone of our repo.  I hear there's a zeroconf system for sharing git stuff, which I imagine would be just fantastic, if we both had it and were able to use our wireless.  Oh well.

We've both gotten a good bit better at doing things with git, which has been a great boon to us both.  I got to show David how to use `screen`, which is always nice.  It's like any other sort of evangelization, but the person on the other side of the conversation basically always ends up converting.

I'm sure I'll think of more things to write about later, but for now it's time to go get a git clone and then do more hacking.
