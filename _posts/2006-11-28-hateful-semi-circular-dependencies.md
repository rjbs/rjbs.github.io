---
layout: post
title : "hateful semi-circular dependencies"
date  : "2006-11-28T00:39:26Z"
tags  : ["email", "perl", "programming"]
---
Recently, I've been trying to help do my part to prevent needless memory
consumption.  Today, at work, Dieter and I were talking about ways to reduce
Email::Simple's significant memory consumption.  Here's an example:  I created
an eight megabyte email (50 lines of headers, 10,000 of body) and wrote a
program that slurps it and makes a new Email::Simple, giving a crude (ps-based)
memory check as it goes.  

    knight!rjbs:~/code/pep/Email-Simple/trunk$ perl readmail big.msg
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  17876    44336
    after require Email::Simple :  17936    44336
    after construction          :  57060    83416

Those numbers are resident set size and vsize.  This means that when creating a
new Email::Simple for this message, we're using eight times its size in memory
while constructing, and end up still using four times its size when we've got
the object built.

Some smart-but-not-clever (I hope) optimization cuts this down drastically:

    knight!rjbs:~/code/pep/Email-Simple/trunk$ perl -I lib readmail big.msg   
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  17880    44336
    after require Email::Simple :  17940    44336
    after construction          :  25800    52152

We end up using about the message's size in resident memory, having peaked at
using about four times its size during construction.  This optimization,
though, is based on referring to the body as a reference.  If we're willing to
give up the scalar that held the slurped content, and pass it to the
constructor as a reference, we can save even more memory:

    knight!rjbs:~/code/pep/Email-Simple/trunk$ perl -I lib readmailref big.msg
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  17876    44336
    after require Email::Simple :  17936    44336
    after construction          :  17988    44336

We end up only using about 50kB more for the object, and during construction
don't exceed the vsize that we'd reached slurping the file!  Fantastic!

Well, except for one thing.  Email:: code has a habit of exposing its guts, in
lieu of a sufficient API.  Maybe the original idea was that this would only be
done internal to Email:: development, but that hardly helps once the code is
popular!  See, we're changing what's stored in `$self->{body}`, which users
should only access with the `body` and `body_set` methods.  Sadly, though,
Email::MIME feels itself to be above these restrictions, and fiddles with the
guts directly.

This is a pain because if I were to release this optimized version as a normal
upgrade to Email::Simple, it would break Email::MIME on any system on which it
was installed.  I can't just up the version of Email::Simple that Email::MIME
requires, because, well, that won't help.  I don't want to make Email::MIME a
prerequisite of Email::Simple because (a) that's stupid and (b) it would create
a circular dependency.  I don't really want to distribute them together either.

If I weren't also maintaining Email::MIME, I could just take some kind of
sadistic glee in punishin the wicked: if you stick you hand into my objects'
guts, you should expect bad things to happen.  I think my only option is this
ugly hack:  when Makefile.PL is run, if an older Email::MIME is installed,
require a newer one.  Otherwise, do nothing.  I just have horrible visions of
accidentally creating a circular dependency in the future.

I think I'm going to need to go through all the Email:: code and deal with this
kind of gut-touching before it causes me, or anyone else, future grief.

