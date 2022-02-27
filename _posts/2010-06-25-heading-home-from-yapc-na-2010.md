---
layout: post
title : "heading home from YAPC::NA 2010"
date  : "2010-06-25T23:30:44Z"
tags  : ["perl", "yapc"]
---
I'm finally on the last leg of my trip home from YAPC.  The travel home was
slightly chaotic, and I worked a full day before actually getting onto the road
home, but it's been fine.  The planes were fine, I was seated next to Walt (by
chance!) and I didn't suffer any extreme delays.  That might change, as it
looks like I'm going to be over an hour late getting home, but maybe that won't
come to pass.  It would be nice to get to see Martha awake before tomorrow
morning.  Still, Gloria will be awake, and hopefully we can relax and maybe
catch up on Top Chef a little.

The trip was good.  The venue and housing were good, there was a good selection
of talks, there was a lot of good food in the area, and I got to see almost
everyone I had expected to.  Every year I find it harder to summarize what I
did, because more of it was conversation and less was attending talks with
specific technical deliverables.

I had a number of good talks about API design, Perl language feature wishlists,
English orthography, liquor, metaprogramming, and other topics technical and
otherwise.  I ate a pizza with caramelized onions, gorgonzola, pecans, and
dried sour cherries.  It was great.  I had four local beers, and they were all
good.  I spent a lot of the conference with a wicked headache, and it helped
send me to bed at reasonable times, which was probably for the best.

I gave three talks:  one on [Git](http://git-scm.com/), one on
[Dist::Zilla](http://dzil.org/), and one on [Perl
5.12](http://perldoc.perl.org/perl5120delta.html).  I think they all went
fairly well, although I had mixed feelings about each of them.  I'll be giving
[my Dist::Zilla talk at
OSCON](http://www.oscon.com/oscon2010/public/schedule/detail/13632) later this
year, and I think I can make some significant improvements.  (One of these will
just be talking about the newly-added `dzil setup` command.)

I wanted to use my time away from work to get some of my backlogged personal
projects worked on.  I tried to get some serious progress made on
[Rx](http://rx.codesimply.com/), and I did, but there were a number of steps
backwards as well as forward.  (Also, Rx is something that will definitely help
with word more, so I wasn't even entirely avoiding work work.)  I updated all
the non-Perl implementations to consume the new-style test suite that I'd put
together, but then realized that the error model was really awful and redid it.
Then I realized that updating each implementation yet again was going to be a
nightmare, so I wrote a test suite generator.  It generates a very simple
spec test datafile from my much more human-friendly input files.  Now, of
course, I need to update everything to use that.  It will be a bunch of work,
but mostly deleting.

The big pain is going to be implementing the new error trees in a reusable way
that I can manage in more or less every language I want.  Hopefully I'll get
Perl done soon, and then everything but PHP will follow shortly thereafter.  I
might try to cajole someone else to do PHP for me, so I can avoid it a bit
longer.

When I got fed up with Data::Rx work, I decided to get through a few random
bits of work I had lined up.  I integrated a number of changes to
[Git-Megapull](http://search.cpan.org/dist/Git-Megapull/) from Ævar and wrote
my stupid little ["cherry pick a whole remote branch"
script](http://github.com/rjbs/misc/blob/master/git-bcc) for dealing with
multiple contributed feature branches.  Then, despite my initial plan to take a
break from Dist::Zilla, I did a bit of work on that, too.  I released some
changes that had been languishing for a few days and added the input methods
for Chrome.  This is something I've been waffling over for a long time, because
all terminal input libraries are horrible.  I finally settled with
[Term::UI](http://search.cpan.org/dist/Term-UI/lib/Term/UI.pm#HOW_IT_WORKS) and
plunged forward.  I think this will help lessen the new user's confusion at
least a bit.

Tonight, I'm going to relax with Gloria and possibly set up my new phone.  This
weekend, I will play with my daughter and go to my nephew's birthday party.
Pretty soon, though, it will be time to really get cracking on [my Moose is
Perl talk at
OSCON](http://www.oscon.com/oscon2010/public/schedule/detail/13673), which is
on stage in about three weeks.  I'll probably also continue my troubled efforts
to document Dist::Zilla more fully, both in the tutorial and its shipped Pod.
Oh, and I need to work on recording audio for a slidecast of my Dist::Zilla
talk.

