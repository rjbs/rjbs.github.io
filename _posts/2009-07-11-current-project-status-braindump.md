---
layout: post
title : current project status braindump
date  : 2009-07-11T18:40:52Z
tags  : ["perl", "productivity", "programming"]
---
Lately, I have a lot going on.  I think I need to recalibrate my "very busy"
alert, because I feel like it's been going off for months, now.  Still, things
are okay.  Here's a bit of a dump on some things I'm working on or should be
working on.

## Data::GUID

I'm definitely behind schedule on getting Data::GUID refactored to allow
different generators and objects, which will allow a pure-perl backend
(currently UUID::Generator::PurePerl) when XS isn't available.  This is mostly
done work, but it needs testing, polish, and some design thinking.

## Email::MIME::Kit

I'm really not happy with the way the standard Assembler class works.  It does
too much and is too hard to extend without reading its source.  I need to
refactor it, document how it works, and maybe break it into a few pieces.  So
far, I've avoided this by writing all my extensions as `around` method
modifiers.  This has been quite effective, actually.

## META.json

I started to do some work on PAUSE to get it to respect META.json, but I need
to work on getting some things integrated, and other things coded and
committed.  Once that's done, the indexer will be able to index based on
META.json, which is huge.  Next up will be CPAN.pm and CPANPLUS.pm, which I
hope will not be to hard to work with.  Once those parts of the toolchain can
all consume META.json, I can start working on getting my hacks to *emit*
META.json into all the dist building tools -- preferably after making them not
be hacks.

At some point in all this, we'll get to "make JSON.pm part of core perl5."

## Other Email Stuff

I really need to fix Email::Valid's tests to skip the DNS tests when coping
with obnoxious ISPs that provide "helpful" lies to DNS resolvers.
`will-never-exist.pobox.com` does not exist, and if there's an `A` record for
it, then the DNS resolver is lying.  (Of course, this also means that anyone
using the "domain part must have A or MX record" rule is going to have false
positives on validity checks.)

Honestly, I can't think of any more irritating change in basic ISP policies in
the last few years.

There are some other bugs with Email::Valid, too, regarding how it uses
Mail::Address.  I'm pondering writing a new Email::Valid that does all the same
stuff, a little better, and with a less unusual interface.  It would be nice to
be able to easily subclass it to add more checks, like `is_address_in_use` or
`contains_forbidden_characters` for application-specific use.

Heck, maybe I can use Classifier for *this*, since the new bounce parser is
still on the back burner, four years later.

## Pod::Weaver and Friends

Basically, I've decided I don't have the time to think about them this week.
This is disappointing, but I'd rather put it off a week than make bad decisions
because I'm brain-fried.

OSCON starts next week, and I'm hoping to have plenty of down time to work on
ideas and implementations.  OSCON is generally, for me, much lower-stress than
YAPC.  I think I will get a lot of hacking done, and if I don't, I will get a
lot of flowcharting done, and for me that's half the battle.

## Finally...

I've also been thinking a lot about structured data storage, ultra-easy git
helpers for small companies, portable testing, pluggable testing, and Rx.  I
keep improving our little git scripts to keep track of our internal git repos,
and I think at some point I might have something I can describe as a
reproduceable ecosystem.  Rx really needs me to finish the structured failures
branch, which will be phenomenally useful.  A lot of that work will be related
to the testing stuff I'm thinking about.  (I would love to write up a
comprehensive appraisal of Ingy's TestML, which I talked to him about quite a
bit during his development of it.)  The structured wiki stuff is largely about
my desire to use something better than Obsidian Portal for my D&D game.  I
should probably write up both what I want and why I don't care much for
Obsidian Portal!

For now, this has just been an exercise in collecting my own thoughts.  Maybe
tonight or tomorrow I'll actually do a little work on some code.  Then again,
maybe I'll do some yard work instead.

