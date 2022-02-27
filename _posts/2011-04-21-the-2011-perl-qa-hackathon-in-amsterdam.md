---
layout: post
title : "the 2011 Perl QA Hackathon in Amsterdam"
date  : "2011-04-21T14:06:45Z"
tags  : ["perl", "perlqa2011", "programming"]
---
I was very privileged to attend the first QA Hackathon in Oslo in 2008 and also
the second in Birmingham in 2009.  Last year I couldn't attend, but this year
things fell in line nicely, and I was very glad to accept the invitation and
find my way to Amsterdam and Booking.com's offices for this year's event.  As
always, we had an excellent space to work in, lodgings convenient to the
office, and good dinners organized each night.  I didn't have to think about
anything but code, and that's just how I like it!

## From Newark to Amsterdam

Things got off to a bit of an uncertain start for me, though.  Feeling like an
old hand at short conferences, I did my packing just shortly before leaving
home for the bus to the airport.  I did very well, too, with one minor
exception:  I forgot my laptop charger.  I had all my other charging gear for
my iPhone, camera, and Kindle.  Unfortunately, these all plug into USB.  If I
didn't get an adapter, I'd be without power until I could find one in
Amsterdam.  Sure, I could spend my Friday there trying to find an electronics
store, or I could hope that someone at Booking had one... but I was not keen on
the idea.  I arrived quite early at the Newark airport and scoured every gadget
shop in the place.  One or two claimed to *carry* the adapter I needed, but no
one had it *in stock*.  I despaired for a while, and considered trying a daring
sortie into Manhattan or Newark, but then I tried plan B.  I started to wander
Terminal C, looking for passengeers with Apple laptops.  I asked each one
whether he would consider selling his charger.  Some said no, some looked at me
like I was a lunatic, and one young college student said she would, as long as
she could determine that her sister -- also headed home for spring break -- had
brought *her* laptop charger.  Unfortunately, the sister was at the beach,
and couldn't be reached, so...

Just as I gave up on that student, a young man of about 12 asked whether the
thing he was holding aloft was what I needed.  With his parents' blessing, he
sold it to me -- at first he guessed at a fair price, but guessed under what it
would cost to replace it.  I decided not to be cruel, and made a better offer.
I think we both ended up quite happy.

My flight was about seven hours, and not too bad.  Unfortunately, there was a
conspiracy of small annoyances.  The couple next to me was far too affectionate
with one another.  My seat was behind one of those lumps that prevent me from
properly stowing my bag.  The film I'd wanted to watch in flight was of audio
quality too poor to be understood over the engines.  Worst of all, I just
couldn't sleep.  I arrived at Schiphol about 7:30 local time, having maybe two
or three hours of sleep since the previous morning.  I found my way to the
hotel without serious incident, but I couldn't check in (and sleep) until
15:00, so I spent a few hours wandering around town before catching up on email
in the hotel cafe.  Once I was checked in, though, everything was okay.  I
experienced a sublime happiness on finally putting my head down, and three
hours later I was at [Mankind](http://mankind.nl/) for the pre-dinner meetup.
I was glad, too, to recognize Ovid from a distance as I approached --
otherwise, I'm sure I would've had to fumble through the crowd, looking for a
familiar (or at least sympathetic) face.  The bar was great -- I had my first
taste of bitterballen, which Ovid described aptly as "deep fried gravy."
Obviously, they were good.

To get it out of the way: all the rest of the dining-and-drinking-out organized
by the locals (or Philippe) was good.  I tried a few new beers, had some good
pizza, a good steak, and so on.  Dutch "pancakes" didn't thrill me, but I'd
been warned of their unimpressiveness beforehand by Abigail, and it was still a
great time talking with Andy, Adrian, Steffan, Paul and everyone else.

## The Plan

Of course, the real reason for going wasn't food and smalltalk, although that's
always a great byproduct.  Instead, we were there to *work*.  I always feel
really motivated at the QA Hackathons.  Someone else has paid for me to show up
because they have faith that I'll get something done.  It helps, too, to be
surrounded by people working even harder than I am!

Before the event, my agenda has basically been four items:

* tests for the [PAUSE indexer](http://github.com/andk/pause)
* improvements to [Fake CPAN](http://fakecpan.org/), and its use in real tests
* answer any [Metabase](http://search.cpan.org/dist/Metabase/) questions I could
* be a [rubber duck](http://c2.com/cgi/wiki?RubberDucking) for anybody stuck

As with QA Hackathons past, my results were a mixed bag, but I'm (again) pretty
happy with them.

## What Didn't Happen

Months ago -- January or so -- I asked Andreas what could be done to help make
it easier for me to write tests for PAUSE.  He graciously provided links,
ideas, and a promise of any help I'd ask for.  To my great shame, I did very
little more than read his existing documentation.  Shortly before the event, I
told him, "Well, I'll just pick your brain there," and he reminded me that he
would not be in attendance.

Fortunately, having done a bit more reading on the subject, I think I'm
prepared to get work done on it at home, and I think my Fake CPAN work may also
be useful.

As a Metabase expert, I think I was of limited usefulness.  Abe and Tux asked
me quite a few questions and most of my answers were of the form, "Here's what
needs to be done, and I'm not in a position to do much about it right now."
David Golden's Herculean efforts to get CPAN::Testers 2.0 up and running left
him in the unfortunate position of having the only keys to the production
Metabase castle, and I have only myself to blame.  As one of the few people
with a fairly exhaustive knowledge of how it's meant to work, I should have
long ago made sure I was ready to help as needed.  I'll work with David to make
myself at least a bit more useful in such matters in the future.

It's also worth noting that after doing nothing but Metabase at the 2008 and
2009 events, I was feeling sorely burned out on it in 2010, and sort of glad
that it had launched and left my agenda.  Now that I've had two years doing
other things, I'm feeling much more sanguine about pitching in more time on
Metabase needs.

## What Did Happen

The great majority of my time was spent on Fake CPAN and related work.  Fake
CPAN is a funny thing.  In my experience, reactions are either "why on Earth
would anyone need that" and "wow, that will be really useful for me!"  The
number of people in the second group is small, but the projects they work on
are (in my experience) pretty important:  CPAN clients, CPAN browsing and
searching interfaces, and other similar tools.

I'll write more about the Fake CPAN in the next day or two, but it's a simple
idea:  when writing tools that run against the CPAN, it's not plausible to run
tests against the real CPAN, because it's always changing.  It's not even
always plausible to run tests against a snapshot, because a snapshot of the
CPAN at any given time is huge.  Even a snapshot of a minicpan mirror is really
big.  Worse, if your tool has to cope with crazy things that CPAN authors do,
you'll need to keep updating your test corpus with the new crazy things you've
found in recent uploads.

[Fake CPAN](http://fakecpan.org/) is a set of version-addressable CPAN-like
directories.  They're grouped into "series" or "fakes," each of which has a
purpose or theme and a set of rules that will be used to determine how new
versions will be formed.  For example, we could create an "uninstallable" fake,
in which each distribution should be uninstallable.  For example, a dist in it
might have broken `Makefile.PL`, a dependency on an impossible operating
system, or empty tarballs.  CPAN clients could then try to install each
distribution found in the fake and test for graceful failure.

There were three tools being tested at the hackathon that were likely to
benefit from a fake CPAN.  [CPAN Grep](http://grep.cpan.me/) -- which is
phenomenally useful on its own, and which I used to answer some questions while
hacking -- has already been tested against the "sampler" fake, exposing a
fairly amusing bug:  it didn't quite work if the CPAN was much, much smaller
than a real one!  [MetaCPAN](http://metacpan.org/) also can probably benefit
from a fake, although I don't believe Moritz did a test suite conversion
(yet?).  At any rate, the idea seemed quite welcome, which cheered me.

Finally, [`minicpan`](http://search.cpan.org/dist/CPAN-Mini), which I maintain,
has long been in great need of a more useful test suite.  I'd made a few false
starts at writing one before deciding that Fake CPAN was the hairy yak in my
way.  With the Fake CPAN itself up and running, it took me only minutes to
build a whole fake with two versions for testing `minicpan`.  I wrote a simple
Test::More-based test that mirrors the first version as an initial setup, then
updates to the second version.  With Fake CPAN out of the way, I'd written a
non-trivial set of tests for `minicpan` in under half an hour.

After that, I wanted to start writing more comprehensive tests, but was bogged
down as I discovered the insane logging-level semantics of CPAN::Mini.  I have
no one but myself to blame for those, and have begun fixing them in a branch.

As for my other goal -- wander around and act useful -- I'm actually pretty
pleased with that, too.  I introduced Ovid to XML::Pastor, which he quickly got
to using, and he's been working on clearing out its bug queue and making other
improvements in his own fork of it.  I introduced Abigail to Test::Tester,
which helped him prevent Test::Regexp's own tests from being terminally broken
by Test::Builder2.  I had a bizarrely lucid recollection of a year-old bug that
Max-from-Mozilla had filed against TAP::Parser which, I hope, helped Andy A.
drastically reduce the memory consumed by enormous test suites.  I was also
tickled to get quite a few Dist::Zilla questions, although I was less than
pleased with my ability to answer one about dealing with UTF-8 text in Pod and
`dist.ini` -- but I'll just have to get to work on that soon.

## More Later...

Right now, I'm on the plane from Frankfurt to Philadelphia.  It's been a
surprisingly pleasant flight.  I have an aisle on one side and an empty seat on
the other.  I watched three movies, had two decent meals, and the young girl
two seats away has not had a meltdown until just now.  We're passing over Cape
Cod, now, and I think I'll stow my laptop and, when I publish this later, will
just edit this entry and publish it through here.  Any further thoughts will
come over the next day or two.  I'll definitely have a few more things to say
about the people, food, beer, and accomplishments of the Hackathon -- and about
my short but enjoyable visit with family in Germany, which may be of significantly less interest to some.
