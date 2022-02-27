---
layout: post
title : "the 2014 Perl QA Hackathon in Lyon: the work"
date  : "2014-03-19T02:37:27Z"
tags  : ["perl", "perlqa2014", "programming"]
---
Today is my first full day back in Pennsylvania after the Perl QA Hackathon in
Lyon, and I'm feeling remarkably recovered from four long days of hacking and
conferring followed by a long day of travel.  I can only credit my quick
recovery to my significantly increased intake of
[Chartreuse](https://en.wikipedia.org/wiki/Chartreuse_(liqueur)) over the last
week.

The QA Hackathon is a small, tightly-focused event where the programmers
currently doing work on the CPAN toolchain get together to get a lot of work
done and to collaborate in ways that simply aren't possible for most of the
rest of the year.  I always come out of it feeling refreshed and invigorated,
partly because I feel like I get so much done and partly because it's such an
inspiration to see so many other people getting *even more* done all in one
place.

I'm not going to recount the work I did this year in the order that I did it.
You might be able to reconstruct this by looking at my git logs, but I'll leave
that up to you.  Also, I'm sticking to technical stuff here.  I might make a
second post later about non-code topics.

For this year's hackathon, I wasn't sure exactly what my agenda would be.  I
thought I might be working on the conversion of the perl 5 core's `podcheck.t`
to Pod::Checker 1.70.  In the end, though, I spent most of my time on
[PAUSE](http://pause.perl.org/).  PAUSE, the Perl Author Upload SErver, is a
cluster of programs and services, mostly thought of as two parts:

* a web site for managing user accounts and receiving archive uploads
* a program that scans for new uploads and decides whether to put their
    contents into the CPAN indexes

I didn't do any work on the web site this year.  (I would like to do that next,
though!)  Instead, I worked entirely on the indexer.  The indexer is
responsible for:

* deciding whether to index new uploads at all
* deciding what packages, at what versions, a new upload contains
* checking the uploading user's authorization to update the index for those
    packages
* actually updating the master database and the on-disk flatfile indexes

In the summer of 2011, [David Golden](http://www.dagolden.com/) and I got
together for a [one-day
micro-hackathon](http://rjbs.manxome.org/rubric/entry/1904).  Our goal was to
make it possible to write tests for the indexer's behavior, and I think we
succeeded.  I'm proud of what we accomplished that day, and it's made all my
subsequent work on PAUSE possible.

I also [worked on PAUSE change last
year](http://rjbs.manxome.org/rubric/entry/1992), and a few of the things we'd
done then had not ever been quite finished.  I decided that my first course of
action would be to try to get those sorted out.

## PAUSE Work

### 03modlist

The "module list" isn't talked about a lot these days.  It's a header-and-body
format file where the body is a "safe to eval" (ha ha) Perl document that
describes "registered" modules and their properties.  You can see it here:
[http://www.cpan.org/modules/03modlist.data](http://www.cpan.org/modules/03modlist.data)

Most modules on the CPAN are only in "the index," also known as "02packages."
There's very little information indexed for these.  Given a package name, you
can find out which file seems to have the latest version of it, and you can
find who has permission to update it.  That's it.  Registered modules, on the
other hand, list a description, a category, a programming style, and other
things.  The module list isn't much used anymore, and the kinds of data that it
reports are now found, instead, in the `META.json` files meant to be included
with every distribution.

I had filed [a pull request to produce an empty
03modlist](https://github.com/andk/pause/pull/37/files) in 2013, but it wasn't
in place.  Andreas, David, and I all remembered that there was a reason we
hadn't put it in place, but we couldn't remember specifics or find any
evidence.  We decided to push forward.  I got in touch with a few people who I
knew would be affected, rebased my work, and got a schedule in place.  There
wasn't much more to do on this front, but it will happen soon.  The remaining
steps are:

1. write an announcement
2. apply the patch
3. post the announcement that it's been done

I expect this to be done by April.

After that's done, and a month or two have passed with no trouble, we'll be
able to start deleting indexer code, converting "m" permissions to "f" or "c"
permissions (more on that later), and eliminating unneeded user interface.

### dist name permissions

Generally, if I'm going to release a module called Foo::Bar at version 1.002,
it will get uploaded in a file called `Foo-Bar-1.002.tar.gz`.  In that
filename, `Foo-Bar` is the "dist name."  Sometimes people name their files
differently.  For example, one might upload LWP::UserAgent in
`lwp-perl-5.123.tar.gz`.  This shouldn't matter, but does.  The PAUSE
indexer only checks permissions on packages, and nothing else.  Unfortunately,
some tools work based on dist names.  One of these is the CPAN Request Tracker
instance.  It would allow distribution queues to clash and merge because of the
lax (read: entire lack of) permissions around distribution names.

Last year, I began work to address this.  The idea was that you may only use a
distribution name if you have permissions on the matching module name.  If you
want to call your distribution `Pie-Eater`, you need permissions on
`Pie::Eater`.  We didn't get the work merged last year, because only at the
last minute did we realize that there were over 1,000 cases where this wasn't
satisfied.  It was far more than we'd suspected.  (This year, when I reminded
Andreas of this, he was pretty dubious.  I wasn't: I remembered the stunned
disbelief I'd already worked through last year!)

A small group of us discussed the situation and realized that about 99% of the
cases could be solved easily:  we'd just give module permissions out as needed.
A few other cases could be fixed automatically or were not, actually,
problematic.  The rest were so convoluted that we left them to be fixed as
needed.  Some of them dated to the 1990's, so it seemed unlikely that it would
come up.

I filed [a pull request](https://github.com/andk/pause/pull/80) to make this
change, in large part based on the work from last year.  It was merged and
deployed.

Unfortunately, there was a big problem!

PAUSE does not (yet!) have a very robust transaction model, and its database
updates were done one by one, with AutoCommit enabled.  There was no way to
entirely reject a file after starting work, prior to this commit, and I thought
the simplest thing to do would be to wrap the indexing of each dist in a
transaction.  It made it quite easy to write the new check safely, although it
required some jiggery-pokery with `$dbh` disconnect times.  In the end, all the
tests were successful.

Unfortunately, the tests and production behaved differently, using different
database systems.  Andreas and I spent about an hour on things before rolling
back the changes and having dinner.  The next morning, everything was clear.
We knew that a child process was disconnecting from the database, but couldn't
find out where.  We'd set InactiveDestroy on the handle, so it shouldn't have
been disconnecting… but it turned out that another object in the system had its
own `DESTROY` method which disconnected *explicitly*.  That fixed things, and
after nearly a year, the feature was in place!

### package name case-changing

Last year, we did a fair bit of work to make permission checks
case-insensitive.  The goal was that if "Foo" was already registered, nobody
else could claim "foo".  We wanted to prevent case-insensitive filesystems from
screwing up where case-sensitive filesystems would work.  Of course, this isn't
a real solution, but it helps discourage the problem.

When we did this, we had to decide what to do when someone who had permissions
on Foo tried to switch to using "foo".  We decided that, hey, it's your package
and you can change it however you like.  This turned out to be a mistake, best
demonstrated by [some recent trouble with the Perl ElasticSearch
client](http://www.elasticsearch.org/blog/renaming-perl-client/).  We decided
that if you want to change case, you have to be very deliberate about it.
Right now, that means dropping permissions and re-indexing.  In the future, I
hope to make it a bit simpler, but I'm in no rush.  This is not a common thing
to *want* to do.  I filed a [pull request to forbid case-mismatching
updates](https://github.com/andk/pause/pull/85).

I also filed a [pull request to issue a warning when package and module names
case-mismatch](https://github.com/andk/pause/pull/97).  That is, if you upload
a dist containing `lib/Foo/Bar.pm` with `package foo::bar` in it, you'll get a
warning.  In the future, we may start rejecting cases like this, but for now,
it's really not good enough.  We only handle some cases where the problem might
be there, but it's probably most of them.

Indexing warnings are a new thing.  I'm not sure what warnings we might add in
the future, but it's easy to do so.  Given the kinds of strictness we've talked
about adding, being able to warn about it first will probably come in useful
later.

### fixing bizarro permissions

In the middle of some of the work above, while I was in the middle of some
other discussion, at some point, somebody leaned over and said, "Hey, did you
see [the blog post about how to steal permissions on PAUSE
distributions](http://xaerxess.pl/blog/2014/03/12/how-i-hijacked-a-cpan-module.html)?"
I blanched.  I read the post, which seemed to describe something that should
definitely not be possible, and decided it was now my top priority.  What luck
to have this posted during the hackathon!

In PAUSE, there are three kinds of permission:

* **f**irst-come permission, given to the first person to upload a package
* **c**o-maintainer permission, handed out by the first-come user
* **m**odule list permission, given to the registered owner in the module list

Let's ignore the last one for now, since they're going to go away.

The bug was that when nobody had first-come permissions on a package, the PAUSE
code assumed that nobody could have *any* permissions on it, and would re-issue
first-come.  It wasn't the only bug that inspection turned up, though.

It might sound, from above, like a given package owner would only need either
first-come or co-maint, but actually you always need co-maint.  First-come is
meant to be granted *in addition* to that.  This was required, but not
enforced, and if a user ended up with only `f` permissions, they're sometimes
seem not to exist, and permissions could be mangled.  I filed [a pull request
to prevent dist hijacking](https://github.com/andk/pause/pull/82) along with
some tests.

While running the tests, I started seeing something really bizarre.  Normally,
permission lines in the permissions index test file would look like this:

    Some::Package,USER1,f
    Some::Package,USER2,c

...but in the tests, I was sometimes seeing this:

    Some::Package,USER1,1
    Some::Package,USER2,2

Waaaah?  I was baffled for a while until something nagged at me.  I noticed
that the SQL generating the data to output was using double-quote characters
for string literals, rather than standard single-quotes.  This is fine in
MySQL, which is used in production, but not in SQLite, which is used in the
tests.  I filed a [pull request to switch the
quotes](https://github.com/andk/pause/pull/83/files).  I'll probably file more
of those in the future.  Really, it would be good to test with the same system
as is used in production, but that's further off.

### package NAME VERSION

Almost a year ago, [Thomas Sibley reported that PAUSE didn't handle new-style
package declaration](https://github.com/andk/pause/issues/49).  That is, it
only worked with packages like this:

    package Foo::Bar;
    our $VERSION = '1.001';

...but not any of these:

    package Foo::Bar 1.001;

    package Foo::Bar 1.001 { ... }

    package Foo::Bar {
      our $VERSION = '1.001';
    }

I *strongly* prefer `package NAME VERSION` when possible, but "possible" didn't
include "anything released to the CPAN" because of this bug.  I filed a [pull
request to support all forms of
`package`](https://github.com/andk/pause/pull/102).  I'm really happy about
this one, and look forward to making it possible for more of my dists to use
the newer forms of `package`!

### respecting `release_status` in the META.json file

The `META.json` file has a field called
[`release_status`](https://metacpan.org/pod/CPAN::Meta::Spec#release_status).
It's meant to be a way to put a definitive statement in the distribution itself
that it's a trial release, not meant for production use.  Right now, there are
two chief ways to indicate this, both related only to the name of the file
uploaded to the CPAN.  That file doesn't stick around, and we want a way to
decide what to do based on the contents of the dist, not the archive name.

Unfortunately, PAUSE *totally ignored* this field.  I filed a [pull request to
respect the `release_status` field](https://github.com/andk/pause/pull/90).
Andreas suggested that we should inform users why we've done this, so I filed a
[pull request to add "why we skipped your dist"
reports](https://github.com/andk/pause/pull/94).  I used that facility for the
"dist name much match module name" feature above, and I suspect we'll start
issuing those reports for more situations in the future, too.

### spreading the joy of testing

Neil Bowers was at the hackathon, and had asked a question or two about how the
indexer did stuff.  I took this as a request for me to pester him mercilessly
about learning how to write tests with the indexer's testing code.  Eventually,
and presumably to shut me up, he stopped by and I walked him through the code.
In the process of doing so, we realized that half the tests — while all
seemingly correct — had been mislabeled.  I filed a [pull request to fix all
the test names](https://github.com/andk/pause/pull/100).

I'm hoping to file some other related pulls to refactor the test file to make
it easier to write new indexer tests in their own files.  Right now, the single
file is just a bit too long.

### fixes of opportunity

Lots of the other work exposed little bugs to fix.

Because I was doing all my testing on perl 5.19.9, one of our new warnings
picked up a precedence error in the code.  I filed [a pull request to replace
an `or` with a `||`](https://github.com/andk/pause/pull/78).

Every time I ran the tests, I got an obnoxious flood of logging output.
Sometimes it was useful.  Usually, it was a distraction.  I filed [a pull
request to shut up the noise unless I was running the tests in verbose
mode](https://github.com/andk/pause/pull/79).

Peter Rabbitson had noticed that when PAUSE skips a "dev release" because of
the word `TRIAL` in the release filename, it was happy for that string to
appear anywhere in the name.  For example, `MISTRIAL-1.234.tar.gz` would have
been skipped.  I filed a [pull request to better anchor the
substring](https://github.com/andk/pause/pull/84/files).  I filed a [matching
pull request with
CPAN::DistnameInfo](https://github.com/gbarr/CPAN-DistnameInfo/pull/2) that
fixed the same bug, plus some other little things.  I'm glad I did this (it was
David Golden's idea!) because Graham Barr pointed out that historically people
have used not just `...-TRIAL.tar.gz` but also `...-TRIAL1.tar.gz`.

I found some cases where we were interpolating undef instead of … anything
else.  I [filed a pull request to use a default string when no module owner
could be found](https://github.com/andk/pause/pull/88).

PAUSE has a one second sleep after each newly-indexed distribution.  I'm not
sure why, and assume it's because of some hopefully long dead race condition.
Still, in testing, I knew it wouldn't be needed, and it slowed the test suite
down quite a lot every time I added a new test run of the indexer.  I [filed a
pull request to updated the TestPAUSE system to skip the
sleep](https://github.com/andk/pause/pull/95), shaving off a good 90% of the
indexer's test's runtime.

While testing something unrelated, Andreas and I simultaneously noticed a very
weird alignment issue with some otherwise nicely-formatted text.  I [filed a
pull request to eliminate some accidental
indenting](https://github.com/andk/pause/pull/98).

## Dist::Zilla

I had hoped to spend the last day plowing through relevant tickets in the
Dist::Zilla queue, but it just didn't happen.  I did get to merge and tweak
some work from David Golden to make it easier to run test suites in parallel.
With the latest Dist::Zilla and @RJBS bundle, my tests suites run nine jobs at
once, which should speed up both testing and releasing.

## Version Numbers

One night, Graham Knop, Peter Rabbitson, David Golden, Leon Timmermans, Karen
Etheridge, and I sat down over an enormous steak to discuss how Perl 5's
abysmal handling of module versioning could be fixed.  I hope that we can make
some forward movement on some of the ideas we hammered out.  They can all get
presented later, once they're better transcribed.  I have a lot of them on the
back of a huge paper place-mat, right now.

## perl5.git

I did *almost* nothing on the perl core, which is as I expected.  On Friday morning, though, I was on the train to and from the Chartreuse distillery, with no network access, so I wanted to work on something requiring nothing but my editor and git.  I knew just what to do!

Perl's lexical warnings are documented in two places:  `warnings`, which documents a few things about the warnings pragma, and `perllexwarn`, which documents other stuff about using lexical warnings.  There really didn't seem to be any reason to divide the content, and it has led, over and over, to people being unable to find useful documentation.  I merged everything from perllexwarn into warnings.  Normally, this would have been trivial, but `warnings.pm` is a generated file and `perllexwarn.pod` was an auto-updated file, so I had to update the program that did this work.  It was not very hard, but it kept me busy on the train so that I was still working even while off to do something a bit more tourist-y.

## Is that all?

I know there was some more to all this, and it might come back to me.  I
certainly had plenty of interesting discussions about a huge range of topics
with many different groups of attendees.  They ranged from the wildly
entertaining to the technically valuable.  I'll probably recount some of them
in a future post.  As for this post, meant only to recount the work that I did,
I think I've gotten the great majority of it.

## Thanks!

I was able to attend the 2014 Perl QA Hackathon because of the donations of the
[generous sponsors](http://act.qa-hackathon.org/qa2014/sponsors.html) and the
many donors to The Perl Foundation, which paid for my travel.  Those subsidies,
though, would not have been very useful if there hadn't *been* a conference, so
I also want to thank Philippe "BooK" Bruhat and Laurent Bolvin who took on the
organization of the hackathon.  Finally, thanks to Wendy van Dijk, who began
each day with a run to the market for fresh lunch foods.  I had plenty of good
food while in Lyon, but the best was the daily spread of bread and cheese.
(Wendy also brought an enormous collection of excellent liquor, on which I will
write more another day.)

I'm look forward to next year's hackathon already.  I hope that it will stick
to the same size as this year, which was back to the excellent and intimate
group of the first few years.  Until then, I will just have to stay productive
through other means.

