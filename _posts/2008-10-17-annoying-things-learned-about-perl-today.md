---
layout: post
title : "annoying things learned about perl today"
date  : "2008-10-17T02:19:55Z"
tags  : ["perl", "programming"]
---
App::Cmd::Tester lets you test that an App::Cmd program output the right things
to standard error and standard out, and did so in the right order.  It does
stuff Test::Output can do, but also just a bit more.

I had a need to generalize this earlier today, and ran into a bunch of
obnoxious problems.  Most of these center around the "it's hard to get
synchronized but separate output from a spawned program's stderr and stdout"
problem.  Others were less well-known, at least to me.

For example, I was doing something like this:

    tie my $scalar, 'Tie::Class', { common => \$string, private => \$other };

I had a number of things like this, and I thought I'd be able to write:

    tie my $scalar, $object->tie_args;

This didn't work, though, because the `tie_args` method gets called in scalar
context, so it evaluated to the hash reference, which of course had no
`TIESCALAR` method.

Instead, I ended up doing something possibly better anyway:

    tie my $scalar, $object, $argument;

The object has a `TIESCALAR` method that proxies to the correct class with the
correct arguments.  I'm pretty happy with that.

The other problem is this:

    tie my $scalar, 'Some::Tie';
    open my $fh, '>', \$scalar or die "failed to open ref: $!";
    print $fh "this is a test" or die "failed to print: $!;

This code just doesn't do what I mean.  It doesn't raise any exceptions, but
the `STORE` method is never called on the tie.  This seems, to me, like a bug
in perl.  I'll need to investigate.

The code I was working on has been uploaded as IO::TieCombine.

