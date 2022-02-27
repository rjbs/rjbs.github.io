---
layout: post
title : "look back on the birmingham qa hackathon"
date  : "2009-04-05T18:51:50Z"
tags  : ["perl", "programming"]
---
The QA Hackathon was, just as it was last year, fantastic.  It felt really
productive, and left me feeling really professionally refreshed and ready to
try to get more things done in general.  How long until I am crushed back into
grist beneath the grinding wheel?  Only time will tell.

The weakest part of the event was the venue, and the venue was just fine.  It
might have been nicer to have a few more rooms and better networking, but in
practice, the venue was totally fine.  Having a bunch of people in one room
working on different things wasn't a problem, because for the most part, we
weren't all yammering on and distracting one another.  (Or, possibly, only my
group was doing much yammering.)

On the day I arrived, Ovid said, "I think I have a solution to all previous
objections to nested TAP."  It turned out to be imperfect, but still pretty
good, and I think we should see nested TAP as a real option pretty soon.  This
is fantastic, especially because Adrian Howard was there, and is on board
getting Test::Class using nested TAP, which will make interpreting the TAP
output of a Test::Class suite much eaiser.

Schwern also did a lot of work on Test::Builder 2, which I haven't yet had a
chance to play with.  I'm hoping to play with moving some of my (public and
not) Test:: code to Test::Builder 2, even if only to see how it works.

Abigail published [Test::Regexp](http://search.cpan.org/dist/Test-Regexp/),
which looks like it will be pretty useful in slowly replacing a bunch of
lousier versions of it that I've bodged together over the years.

Michael Peters got [Smolder](http://search.cpan.org/~wonko/Smolder-1.35/)
released as a CPAN-able distribution, which was pretty fantastic.  I really
need to work on integrating Smolder with our build system; it's been ages since
I cajoled bda into setting up our Smolder box.

Andreas and Tux did some work on defining structured data to be included in the
next revision of CPAN Testers reports, and produced
[Config-Perl-V](http://search.cpan.org/dist/Config-Perl-V).  (This is the
config from `perl -V`, but I still like reading it as "Perl 5" in Roman
numerals.)  This was part of the whole "next generation CPAN testing" work,
which is also where I was working.

David Golden and I basically continued our work from last year.  Although we'd
planned to keep hacking on it after Oslo, we were both just too busy to make
enough time, and nothing much happened.  In Birmingham, we got to spend most of
our time on it, and we got quite a lot done.  Not only did we work on it, but
we had other people helping.  Andreas and Tux, of course, and also Barbie, Rich
Dawe, Léon Brocard, Chris Williams, and others.

Our work had two big goals:

1. finish enough of the "CPAN metabase" to be able to use it to receive and store test reports 
2. define the new format for structured test reports

Neither was entirely completed, although 2 is probably very close to being
acceptable.  The metabase, though, made great progress, and mostly needs to be
polished and prepared to handle larger amounts of data than just system test
facts.

I'll write more about the metabase (again) later today, but I think David and I
were both very happy to find that the idea still seemed sound, and that the
implementation was still fairly reasonable.

During some of the refactoring of the metabase code, I spun off
[URI::cpan](http://search.cpan.org/dist/URI-cpan/), now available on the CPAN.
It's a variation on something we use internally at Pobox, and it's often been
useful.  It was another chance for me to grumble and roll my eyes at the guts
of URI.pm, but it got written, and that's good.

As for all non-hacking things: the city was quite nice, and the weather, too.
All the dinners were great, including good burgers and pizza, which are quite a
rarity in England.  I had a burger with pickled onion on it, and it was
delicious.  I also ended up with a list of music to listen to, booze to sample,
and bizarre Italian television programs to find.  It was a great event, and I'm
again looking forward to seeing it happen next year.

I offer my great thanks to the Birmingham Perl Mongers for getting me over
there, and I hope they end up getting some use out of the work I did!

Finally, after the hackathon, I headed out of BHX and into Frankfurt, and from
there to visit my family in Hesse.  I'll write a bit more about that later,
too.  In short: I had a good time, saw a bunch of people I hadn't seen in
nearly 20 years, and managed to not get lost on the Deutsche Bahn.  My photos are on Flickr.
