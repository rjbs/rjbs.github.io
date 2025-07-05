---
layout: post
title : "I went to the Perl QA Hackathon in Rugby!"
date  : "2016-04-27T02:45:38Z"
tags  : ["perl", "programming"]
---
I've long said that the Perl QA Hackathon is my favorite professional event of
the year.  It's better than any conference, where there are some good talks and
some bad talks, and some nice socializing.  At the Perl QA Hackathon, *stuff
gets done*.  I usually leave feeling like a champ, and that was generally the
case this time, too.

I flew over with Matthew Horsfall, and the trip was fine.  We got to the hotel
in the early afternoon, settled in, played some chess (stalemate) and then got
dinner with the folks there so far.  I was delighted to get a (totally
adequate) steak and ale pie.  Why can't I find these in Philly?  No idea.

<a href="https://www.flickr.com/photos/rjbs/26641264166/in/dateposted-public/" title="steak and ale pie!!"><img src="https://farm2.staticflickr.com/1509/26641264166_22e05ed59c_z.jpg" alt="steak and ale pie!!" /></a>

The next day, we got down to business quickly.  We started, as usual, with
about thirty seconds of introduction from each person, and then we shut up and
got to work.  This year, we had most of a small hotel entirely to ourselves.
This gave us a dining room, a small banquet hall, a meeting room, and a bar.  I
spent most of my time in the banquet hall, near the window.  It seemed like the
easiest place to work.  Although there were many good things about the hotel,
the chairs were not one of them!  Still, it worked out just fine.

The MetaCPAN crew were in the dining room, a few people stayed at the bar
seating most of the time, and the board room got used by various meetings,
most of which I attended.

The view over my shoulder most of the time, though, was this:

<a href="https://www.flickr.com/photos/rjbs/26574786172/in/dateposted-public/" title="getting to work!"><img src="https://farm2.staticflickr.com/1713/26574786172_2b2014dddb_z.jpg" alt="getting to work!" /></a>

Philippe wasn't always there with that camera, though.  Just most of the time.

I think my work falls into three categories:  Dist::Zilla work, meeting work,
and pairing work.

## Dist::Zilla

Two big releases of Dist::Zilla came out of the QAH.  One was v5.047 (and the
two preceeding it), which closed about 40 issues and pull requests.  Some of
those just needed application, but others needed tests, or rework, or review,
or *whatever*.  Amusingly enough, other people at the QAH were working on
Dist::Zilla issues, so as I tried to close out the obvious branches, more
easy-to-merge branches kept popping up!

Eventually I got down to things that I didn't think I could handle and moved
on to my next big Dist::Zilla task for the day:  version six!

My goal with Dist::Zilla has been to have a new major version every year or
two, breaking backward compatibility if needed, to fix things that seemed worth
fixing.  I've been very clear that while I value backcompat quite a lot in most
software, Dist::Zilla will remain something of a wild west, where I will
consider nothing sacred, if it gets me a big win.  The biggest change for v6
was replacing Dist::Zilla's use of Path::Class with Path::Tiny.  This was not a
huge win, except insofar as it lets me focus on knowing and using a single API.
It's also a bit faster, although it's hard to notice that under Dist::Zilla's
lumbering pace.

Karen Etheridge and I puzzled over some encoding issues, specifically around
PPI.  The PPI plugin had changed, about two years ago, to passing octets rather
than characters to PPI, and we weren't sure why.  Karen was convinced that PPI
did better with characters, but I had seen it hit a fatal bug that using octets
avoided.  Eventually, with the help of `git blame` and IRC logs, we determined
that the problem was... a [byte order
mark](https://en.wikipedia.org/wiki/Byte_order_mark).  Worse yet, a BOM on
UTF-8!

When parsing a string, PPI does in fact expect characters, but does *not*
expect that the first one might be `U+FEFF`, the space character used at offset
0 in files to indicate the UTF encoding type.  Perl's UTF-16 encoding layers
will notice and use the BOM, but the UTF-8 layer will not, *because a BOM on a
UTF-8 file is a bad idea.*  Rather than try to do anything incredibly clever, I
did something quite crude:  I strip off leading `U+FEFF` when reading UTF-8
files and, sometimes, strings.  Although this isn't always correct, I feel
pretty confident that anybody who has put a literal `ZERO WIDTH NO-BREAK SPACE`
in their code is going to deserve whatever they get.

With that done, a bunch of encoding issues go away and you can once again use
Dist::Zilla on code like:

    my $π = 22 / 7;

This also led to some fixes for Unicode text in `__DATA__` sections.  As with
the Path::Tiny change, a number of downstream plugins were affected in one way
or another, and I did my best to mitigate the damage.  In most cases, anything
broken was only working accidentally before.

Dist::Zilla v6.003 is currently in trial on CPAN, and a few more releases with
a few more changes will happen before v6 is stable.

Oh, and it requires perl v5.14.0 now.  That's perl from about five years ago.

## Meetings!

I was in a number of meetings, but I'm only going to mention one:  the Test2
meeting.  We wanted to discuss the way forward for Test2 and Test::Builder.  I
think this needs an entire post of its own, which I'll try to get to soon.  In
short, the majority view in the room was that we should merge Test2 into
Test-Simple and carry on.  I am looking forward to this upgrade.

Other meetings included:

* renaming the QAH (I'm not excited either way)
* using Test2 directly in core for speed (turns out it's not a big win)
* getting more review of issues filed on Software-License

A bit more about that last one:  I wrote Software-License, and I feel I've done
as much work on it as I care to, at least in the large.  Now it gets a steady
trickle of issues, and I'm not excited to keep doing it all myself.  I
recruited some helpers, but mostly nothing has come of it.  I tried to rally
the troops a bit to encourage more regular review just leading to each person
giving a +1 or -1 on each pull request.  Otherwise, Software-License is likely
to languish.

## Pairing!

I really enjoy being "free floating helper guy" at QAH.  It's something I've
done a lot ever since Oslo.  What I mean is this:  I look around for people who
look frustrated and say, "Hey, how's it going?"  Then they say what's up, and
we talk about the issue.  Sometimes, they just need to say things out loud, and
I'm their rubber duck.  Other times, we have a real discussion about the
problem, do a bit of pair programming, debate the benefits of different
options, or whatever.  Even when I'm not really involved in the part of the
toolchain being worked on, I feel like I have been able to contribute a *lot*
this way, and I know it makes me more valuable to the group in general, because
it leaves me with more of an understanding of more parts of the system.

This time, I was involved in review, pairing, or discussion on:

* fixing Pod::Simple::Search with Neil Bowers
* testing PAUSE web stuff with Pete Sergeant
* CPAN::Reporter client code with Breno G. de Oliveira
* DZ plugin issues with Karen Etheridge
* Log::Dispatchouli logging problems with Sawyer X
* PAUSE permissions updates with Neil Bowers
* PAUSE indexing updates with Colin Newell (I owe him more code review!)
* improvements to PAUSE's testing tools with Matthew Horsfall
* PPI improvements with Matthew Horsfall

...and probably other things I've already forgotten.

<a href="https://www.flickr.com/photos/rjbs/26602149941/in/dateposted-public/" title="more hard work"><img src="https://farm2.staticflickr.com/1622/26602149941_a50853c4b1_z.jpg" alt="more hard work" /></a>

## Pumpking Updates

A few weeks ago, I announced that [I'm retiring as
pumpking](http://www.nntp.perl.org/group/perl.perl5.porters/2016/04/msg235825.html)
after a good four and a half years on the job.  On the second night of the
hackathon, the day ended with a few people saying some very nice things about
me and giving me both a lovely "Silver Camel" award and also a staggering
collection of bottles of booze.  I had to borrow some extra luggage to bring it
all home.  (Also, a plush camel, a very nice hardbound notebook, and a book on
cocktails!)  I was asked to say something, and tried my best to sound at least
slightly articulate.

Meanwhile, there was a lot of discussion going on — a bit at the QAH but more
via email — about who would be taking over.  In the end, Sawyer X agreed to
take on the job.  The reaction from the group, when this was announced, was
strong and positive, except possibly from Sawyer himself, as he quickly fled
the room, presumably to consider his grave mistake.  He did not, however,
recant.

## perl v5.24.0

I didn't want to spend too much time on perl v5.24.0 at the QAH, but I did
spend a bit, rolling out RC2 after discussing Configure updates with Tux and
(newly-minted Configure expert) Aaron Crane.  I'm hoping that we'll have
v5.24.0 final in about a week.

## Perl QAH 2017

I'm definitely looking forward to next year's QAH, wherever it may be.  This
year, I had hoped to do some significant refactoring of the internals of PAUSE,
but as the QAH approached, I realized that this was a task I'd need to plan
ahead for.  I'm hoping that between now and QAH 2017, I can develop a plan to
rework the guts to make them easier to unit test and then to re-use.

## Thanks, sponsors!

The QAH is a really special event, in that most of the attendees are brought to it on the sponsor's dime.  It's not a conference or a fun code jam, but a summit paid for by people and corporations who know they'll benefit from it.  There's a [list of all the sponsors](http://act.qa-hackathon.org/qa2016/sponsors.html) on the event page, including, but not limited to:

* [FastMail](https://www.fastmail.com)
* [ActiveState](http://www.activestate.com)
* [ZipRecruiter](https://www.ziprecruiter.com)
* [Strato](https://www.strato.com)
* [SureVoIP](http://www.surevoip.co.uk)
* [CV-Library](http://www.cv-library.co.uk)
* [OpusVL](http://opusvl.com)
* [thinkproject!](https://www.thinkproject.com)
* [MongoDB](https://www.mongodb.com)
* [Infinity](https://www.iinteractive.com/)
* [Dreamhost](https://www.dreamhost.com/)
* [Campus Explorer](http://www.campusexplorer.com)
* [Perl 6](http://www.perl6.org/)
* [Perl Careers](https://opensource.careers/perl-careers/)
* [Evozon](https://www.evozon.com/)
* [Booking](http://www.booking.com)
* [Eligo](eligo.co.uk)
* [Oetiker+Partner](http://www.oetiker.ch/)
* [CAPSiDE](http://capside.com/en/)
* [Perl Services](http://www.perl-services.de/)
* [Procura](https://www.procura.nl/)
* [Constructor.io](https://constructor.io/)
* [Robbie Bow](https://metacpan.org/author/BABF)
* [Ron Savage](https://metacpan.org/author/RSAVAGE)
* [Charlie Gonzalez](https://metacpan.org/author/ITCHARLIE)
* [Justin Cook](https://twitter.com/jscook2345)

Raise a glass to them!
