---
layout: post
title : "the 2015 Perl QA Hackathon in Berlin"
date  : "2015-04-23T00:20:51Z"
tags  : ["perl", "perlqah2015", "programming"]
---
I spent last week in Berlin, at the [2015 Perl QA
Hackathon](http://act.qa-hackathon.org/qa2015/).  This is an annual event where
a group of various programmers involved with the "CPAN toolchain" and closely
related projects get together, hash out future plans, write code that is hard
to get written in "free time," and communicate in person the hard that is stuff
to communicate over IRC and email.

I always find the QA Hackathon to be very invigorating, as I get to really dig
into things that I know need work.  That was the case this year, too.  I was a
bit slow to start, by by the last day I didn't really want to stop for food or
socialization, and I spent dinner scowling at my laptop trying to run new code.

The hackathon is an invitational event, and I was fortunate to be invited and
even more fortunate that my travel and lodging was covered in part by The Perl
Foundation and in part by the conference sponsors, who deserve a set of big
high fives:
<a href="http://www.thinkproject.com/">thinkproject!</a>,
<a href="http://aws.amazon.com/de/">amazon Development Center</a>,
<a href="http://www.strato.de/">STRATO AG</a>,
<a href="http://booking.com/">Booking.com</a>,
<a href="http://affinitylive.com/">AffinityLive</a>,
<a href="https://travis-ci.com/">Travis CI</a>,
<a href="http://www.bluehost.com/">Bluehost</a>,
<a href="http://www.gfu.net/">GFU Cyrus AG</a>,
<a href="http://www.evozon.com/">Evozon</a>,
<a href="http://perl.iinteractive.com/">infinity interactive</a>,
<a href="http://neo4j.com/">Neo4j</a>,
<a href="http://frankfurt.pm/">Frankfurt Perl Mongers</a>,
<a href="http://perl6.org/">Perl 6 Community</a>,
<a href="http://mongueurs.pm/">Les Mongueurs de Perl</a>,
<a href="http://www.yapceurope.org/">YAPC Europe Foundation</a>,
<a href="http://perlweekly.com/">Perl Weekly</a>,
<a href="http://www.elasticsearch.com/">elasticsearch</a>,
<a href="https://www.liquidweb.com/">LiquidWeb</a>,
<a href="http://www.dreamhost.com/">DreamHost</a>,
<a href="http://www.procura.nl/">qp procura</a>,
<a href="http://www.mongodb.org/">mongoDB</a>,
<a href="http://www.campusexplorer.com/">Campus Explorer</a>

## Pre-Hackathon Stuff

I arrived in Berlin ahead of time, which helped me overcome jetlag.  Happily
enough, I was on the same flight as David Golden, Matthew Horsfall (+1), and
Tatsuhiko Miyagawa.  We chatted and sat around at Newark and on the way to the
hotel in Berlin.  More than that, Matthew and I set up an ad hoc network on the
plane and chatted using `netcat`.  Eventually I wrote an [incredibly bad file
transfer tool](https://github.com/rjbs/misc/tree/master/airplane-mode) and we
swapped some code and music.  It was stupid, but excellent.  We vowed to do
better on the way back.

Once we'd dropped our bags at the hotel, we went out for a walk around the
neighborhood.  We saw a still-standing hunk of the wall, considered walking to
the big TV tower, and then gave up and got currywurst.  It was okay.  After
that, we caught a train back to the hotel, checked in, and crashed for a little
while.

<center>
<a href="https://www.flickr.com/photos/rjbs/17169383342" title="the wall by
Ricardo SIGNES, on Flickr"><img
src="https://farm8.staticflickr.com/7650/17169383342_9cb6b59213_z.jpg"
width="640" height="480" alt="the wall"></a>
</center>

We found a [totally decent little
restaurant](http://www.yelp.com/biz/restaurant-stiege-am-oranienplatz-berlin)
and got some dinner.  Eventually, I ended up in bed and felt pretty normal the
next morning!

The next day, we did more exploring, this time seeing more of the sorts of
things you're meant to see when you visit Berlin.

<center>
<a href="https://www.flickr.com/photos/rjbs/16983290818" title="Brandenburg
Gate by Ricardo SIGNES, on Flickr"><img
src="https://farm9.staticflickr.com/8741/16983290818_8f605134fb_z.jpg"
width="640" height="480" alt="Brandenburg Gate"></a>
</center>

I wish we'd had more time (and, more importantly, energy) to really explore the
Tiergarten.  There were quite a few things listed on the map that I wanted to
see, but I was barely up for the little exploration we did.  In my defense, the
Tiergarten is ⅔ the size of Central Park!

The hackathon got started that night with the arrival dinner.  I was delighted
to get goulash and spätzle.  Peter Rabbitson was nonplussed.  "Getting excited
about spätzle is like getting excited about… grits!"

"Mmmm," I said, "grits!"

## Topics of Discussion

Last year, we skipped having any long debates about how to move things forward,
and I was *delighted*.  The previous round of them, in Lancaster, had been
gruelling, and I expected much worse from them this year.  Instead, I ended up
thinking that they were pretty much okay.  I think there were a number of
reasons, although chief among them, I think that there were fewer people, and
most of them had more actual stake in the problems being discussed.  David
Golden did an excellent job keeping them on topic and moving forward.

I won't get too deep into how these went, because I know that others will do so
better than I would.  Neil Bowers has already written up some of the final
day's discussions on [the river that is
CPAN](http://neilb.org/2015/04/20/river-of-cpan.html).

In brief, we talked about:

* whether, why, and how to move Test::Builder changes forward
* what promises we want to extract from each other as maintainers of the
    toolchain
* the possibility of a CPAN::Meta::Spec v3
* how we can promote a sense of responsibility and community among CPAN authors
    with many downstream dependents

I felt pretty good about how these talks went, for the most part.  It remains
to be seen how the planned actions pan out, but I'm hopeful on all fronts.

I'm going to throw in one negative thing, though, which came up not just during
the big meetings, but all the time.

<center>
<blockquote class="twitter-tweet" lang="en"><p>Things I am officially tired of:
jokes about how "$X might be a code of conduct violation!" <a
href="https://twitter.com/hashtag/perlqah2015?src=hash">#perlqah2015</a></p>—
Ricardo Signes (@rjbs) <a
href="https://twitter.com/rjbs/status/589761053380182016">April 19,
2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js"
charset="utf-8"></script>
</center>

I get it.  People have feelings about a written and enforceable code of
conduct.  They might feel uncomfortable that they'll accidentally get
themselves kicked out, or they might resent it, or all kinds of other things.
In reality, though, a conference's code of conduct only comes up in three
situations:

1. when you have to accept it to attend
2. when someone actually behaves very badly
3. when endless trivializing jokes are made about it

If everybody would shut up about it, and just take to heart that technical
conferences are places that should be free of abuse and harrassment, I think
things like a written code of conduct would be generally unnoticed except by
people in need of relief for actually being abused.  Instead, there constant
jokes about anyone making a comment with an unintended double meaning. "Hey,
you're violating my cock!"  Yes, phrased like that, because I guess it's *hilarious*
that "code of conduct" acronymizes to sound like a slang phrase for a penis.

It's gross, without even being funny to make up for it.

## Dist::Zilla Hacking

I actually try not to spend too much time on Dist::Zilla stuff at the QA
Hackathon.  I don't think of it as part of the toolchain, precisely, and to me
it's very much a personal project that some other people happen to like.
"Seriously," I say, "you can use it, and it's great, but it's not making you
any real guarantees.  Check its work!"  So, using time at the QA hackathon
seems a bit disingenuous.

This year, though, I planned to spend a day on dealing with its backlog,
because there were quite a few things where I felt that toolchain and QA things
*could* be helped.  As it turned out, though, very little actually went
through.

I merged David Golden's [work to make release_status
plugin-driven](https://github.com/rjbs/Dist-Zilla/pull/438).  This is in
furtherance of implementing a hands-off [semver](http://semver.org/)-like
setup.  Hopefully we'll see something new on that front in the future.  That
was a couple minutes of work re-reading code I'd already reviewed.

Most of the `dzil` time that I spent was on making it possible to build your
to-be-released dist with one perl but then test it with another one.  This was
suggested by Olivier Mengué when I half-jokingly suggested bumping the minimum
perl version for Dist::Zilla to 5.20.  Someone said it would interfere with
Travis CI testing, and Olivier said, "what if you could test with a perl other
than $^X?"

I [implemented it](https://github.com/rjbs/Dist-Zilla/compare/alt-perl), and
also the ability to set a built environment (for things like `PERL5LIB`) and it
worked.  The only problem was that … well, I just didn't feel like it was the
right way forward.

If you want to test with five perls, you'll still have to run the whole
building workflow five times, because of how Dist::Zilla works.  I see a way
out of that, but it wasn't a good project for a single day of unplanned work.
It turned out that there were a few problems like this.  It ended up feeling
like a good idea that just didn't pan out.  I'll probably leave the branch
around, though.  It might be useful eventually anyway.  Maybe I could use it to
use a new perl to "cross-compile" for deployment on an older environment, like
at work.

## PAUSE hacking

Most of my time, as seems traditional at this point, was spent on PAUSE.  I
went into the hackathon with one big goal:  I wanted to get PAUSE running on
Plack.  Until now, PAUSE has been running on mod_perl.  All other potential
objections to mod_perl aside, there's a problem:  it means that testing the
PAUSE website requires a running mod_perl (and, thus, Apache) instance.  What a
pain!

I'd really wanted to work on this, and every once in a while I would have a
look at the code and think about how I'd do it, but never very hard.  When I
finally sat down to do the work, I started to think that it was going to be a
nightmare.  I didn't think I could get it done in time.  I despaired.  I said,
"I think we should look at just starting over, but I know that's usually a
terrible idea."  There was some agreement that I might be right from other
attendees.

Then, this happened:

<center>
<blockquote class="twitter-tweet" lang="en"><p>So, <a
href="https://twitter.com/charsbar">@charsbar</a> says "Are you still
plackifying PAUSE?"
"No, I gave it up as not doable in three
days," I say.
Five hours later, he has it! 😄</p>— Ricardo Signes
(@rjbs) <a href="https://twitter.com/rjbs/status/589052578991833088">April 17,
2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js"
charset="utf-8"></script>
</center>

Amazing!  Now, "he has it" may have been a mild overstatement, but not really.
He showed me the site working right there on the second day.  Charsbar just
needed to keep hacking at the details.  By the end of the fourth day, it was
live!  You can log in and upload to [pause2](http://pause2.develooper.com/pause/query)!

Speaking of logging in, that's where I made my first actual bit of progress.
PAUSE passwords have long been crypted with `crypt`, meaning the long-obsolete
DES algorithm.  I'd been meaning for quite a while to switch it over to
`bcrypt`.  The commits to [switch PAUSE to
bcrypt](https://github.com/andk/pause/compare/de453e1bf4d5047c30293e1517a6f0bcf320bf2f...cd943f8cd6a9bae879e44391f176ef426fdc6a72)
took a few goes, but it got done.  To get your password rehashed, you just need
to log in.  If you've uploaded since the weekend, you've already been rehashed!

I fixed [recursive symlinks killing
reindexing](https://github.com/rjbs/pause/commit/faf379d7b2288ca67a7dbbd119bb397177ea3c16).

Andreas König and I looked into the strange way that perl-5.18.4 still showed
up in the CPAN index for things that perl-5.20.2 should've owned.  This led to
two small changes:  we [fixed bizarre error
messages](https://github.com/andk/pause/pull/159) that appeared when you
couldn't get your Foo module indexed because of somebody else's Bar.pm file;
we [allowed versions with underscores to be
indexed](https://github.com/andk/pause/pull/159) if (and only if) the module
was only available through perl, and was found in the latest perl release.
This shouldn't really happen, but when it does, better to index than to not!

I did a lot of work, through all this, on improving the TestPAUSE library
that's used to test the indexer.  It makes it almost trivial to test the
indexer.  You can write code like this:

<script src="https://gist.github.com/rjbs/830916f6406b0489abe7.js"></script>

It starts a brand new PAUSE, uploads a file, indexes all the recent uploads,
and gives you a "result" object that can do things like tell you what mail was
sent, what's in the various index files, what's in the database, what got
written to the logs, and what's in the PAUSE-data git repository.

It was really worth working on, in part because it let me write the (still
under development)
[`build-fresh-cpan`](https://github.com/rjbs/pause/blob/6e2caf9a56c0ea7552e440db819c6ac592291dbe/one-off-utils/index-one-dist)
tool.  This tool takes a list of cpanid/dist pairs and uploads them to a new
fake CPAN, indexing them as often as you specify.  It's great for seeing what
the indexer would do on a dist you haven't uploaded, or after a potential
bugfix.  I've been looking at using it to do a historical replay of subsets of
the CPAN.  It's clearly going to be useful for testing improvements to the
indexer over time.

I've still got a few tasks left over that I'd like to get to, including
warnings to users who don't have license or metafile data.  I'd also like to
implement the "fast deletion" feature to let you delete files from your CPAN
directory sooner than three days from now — and charsbar's Plackification work
should make that *so much* easier!

## CPAN-Metanalyzer

A few years after I published Dist::Zilla, I wanted to see how many indexed
distributions had been built by it.  I wrote a really crummy script using David
Golden's excellent [CPAN::Visitor](https://metacpan.org/pod/CPAN::Visitor) to
crawl through all of the CPAN and report on what seemed to have been used to
build the dist.  Every once in a while, I'd re-run the script to get newer
data, occasionally making a small improvement to the code.

The big problem, though, was its speed.  It took hours to run.  This was, in
part, because it ran in strict series.  I'd tried to parallelize it one night,
but it was a half-hearted attempt, and it didn't quite work.  At the QAH,
though, a task came up for which it was going to be well-suited.  The gang
voted to begin requiring a META file of some sort for indexing, and I wanted to
see how many dists already had one, and of what kind.  My script would provide
this!  I got it running in parallel, taking it down to about 90 minutes of
runtime.  David Golden remarked that he'd just been writing something similar,
and had it running in about 75 minutes.

It was *on*!

We both worked on our code off and on while solving other problems, trading bug
reports and optimizations.  Maybe it wasn't very cutthroat, but I felt
motivated to improve the code more and more.  Last I checked, we both had our
indexers gathering tons more information and running (across the whole of the
CPAN index) in *fifteen minutes*.

I'm pretty sure we can both get it faster, yet, too.

I have [my CPAN-Metanalyzer](https://github.com/rjbs/CPAN-Metanalyzer), in very
rough form, up on GitHub.  I'll probably keep working on it, though, and use it
instead of CPANDB in the ancient code I once had using that.

## CPAN-Meta-Stuff

Early on, Miyagawa asked whether we could provide structured data from
CPAN::Meta::Requirements objects.  These are the things that tell you what
versions of what modules your code needs to be tested, built, run, and so on.
You could only get the string form out, leading to re-parsing stuff like `>= 4.2,
< 5, != 4.4`, which is a big drag.  I suggested an API and that maybe I
could do it the next day.  The next day...

<center>
<blockquote class="twitter-tweet" lang="en"><p>So, <a
href="https://twitter.com/miyagawa">@miyagawa</a> asks, "Can you implement
this?" I say, "Maybe tomorrow."

Turns out I'd done
it 3 yr ago in an unmerged branch. <a
href="https://twitter.com/hashtag/perlqah2015?src=hash">#perlqah2015</a></p>—
Ricardo Signes (@rjbs) <a
href="https://twitter.com/rjbs/status/589383742780768256">April 18,
2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js"
charset="utf-8"></script>
</center>

The API was even exactly what I'd suggested.  Woah!

I also found some *really* weird-o problems.  I had my meta-analyzer looking
for valid or invalid `META.json` files, and I found an extremely high number of
bogus ones.  Why?  Well, there were two common cases:

* a bunch of META.json files had [missing commas in JSON objects](https://metacpan.org/source/PLOCKABY/TAP-Formatter-BambooExtended-1.01/META.json#L16)
* a few [escaped characters incorrectly](https://metacpan.org/source/LIKHATSKI/Ubic-Watchdog-Notice-0.31/META.json#L4)

What?!  I still have no idea where this came from, and I couldn't produce this
behavior by re-testing old releases of JSON::PP.  There was no report of
behavior like this in changelogs.  I don't know!

Part of the problem is that you can't tell from a dist just which JSON emitter
was used to make its `META.json`.  I've got a [trial release of
CPAN-Meta](https://metacpan.org/changes/release/RJBS/CPAN-Meta-2.150003-TRIAL)
that adds an `x_serialization_backend` to store this data.  Too bad I didn't
think of this nine months ago!  (Most or many of these errors, if not all, were
in September 2014.)  Hopefully that will go into production in about a week.

## The Trip Home

After the end of the QAH, we got dinner and went back to the hotel.  We tried
to go to the conference space ([betahaus](http://www.betahaus.com/berlin/) in
Berlin) but it was locked up with some of our hackers still inside.  This had
actually happened to me one night:  without somebody with keys around, you
could get stuck inside.  I'm told that some people had to jump the fence.  I
was luckier than that.

At the hotel we sat around, talked about what we'd gotten done, and I did just
a little more coding on my CPAN crawler.  Eventually, though, I got to bed so
that I could get up bright and early for the flight home.  We left the hotel
around seven.

I didn't really try to sleep on the plane.  Instead, I poked at code that I
could think about with my sleep-deprived brain.  I ran an
[ngircd](http://ngircd.barton.de/) IRC daemon on my laptop and chatted with
some fellow travelers.  I watched the entire Back to the Future trilogy.
It was a decent flight.  (Except for lunch.  Lunch was really lousy.)
Only yesterday, I found out that there's been a sudden crackdown on people
doing suspicious computer things on the plane.  "Look out for plane hackers!"
I can only imagine what would've happened if we had, as I considered doing,
set up [Mumble](http://www.mumble.com/) to voice chat during the flight.

Now that I'm home, I've got plenty of other stuff to catch up on, but I'm
trying to keep my momentum going.  I've got plenty of my usual post-QAH energy,
and a fair number of remaining things to do, and I think I can actually do
them.

We don't yet know where QAH 2016 will be, but I hope to make it there!

<center>
<a href="https://www.flickr.com/photos/rjbs/16963638407" title="checkpoint
charlie by Ricardo SIGNES, on Flickr"><img
src="https://farm8.staticflickr.com/7600/16963638407_0bac296f7f_z.jpg"
width="640" height="480" alt="checkpoint charlie"></a>
</center>

