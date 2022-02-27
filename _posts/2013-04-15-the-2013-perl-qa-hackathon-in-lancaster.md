---
layout: post
title : the 2013 Perl QA Hackathon in Lancaster
date  : 2013-04-15T23:34:56Z
tags  : ["perl", "perlqa2013", "programming"]
---
I got home from Lancaster, this morning.  I'd been there for the sixth annual
Perl QA Hackathon.  As usual, it was a success and made me feel pretty
productive.  Here's an account of most of the things I did:

### Meetings!

There were many discussant-hours spent in room C-7C hashing out a bunch of
things that needed hashing out.  Although I was very interested in the outcome,
and had some strong opinions about one or two things, I didn't want to get too
tangled up in the discussion, so I split my attention between (mostly) coding
and (a little) joining in.  Others will surely write up the decisions of these
meetings, so I won't, but in the end I felt that it was useful for me to be
there and that I wasn't unhappy with any of the resolutions.

### PAUSE!

At my first two QA Hackathons, I worked mostly on the CPAN Testers Metabase.
Since then, my most common recurring project has been PAUSE.  More
specifically, I've mostly worked on the indexer.  That's the program that looks
at new files to decide whether it should put their contents into the
`02packages` file used by CPAN clients to install packages by name.  It's a
really important program, and I remain very interested in improving its
maintainability.  Once again, though, I wasn't just adding tests, but also
doing some tweaks to how the PAUSE indexer works.

A few months ago at [the NY Perl
Hackathon](http://www.meetup.com/The-New-York-Perl-Meetup-Group/events/100656292/),
David Golden and I got to work fixing letter case behavior in PAUSE.  The
problem was that PAUSE treated package permissions case-insensitively even
though not all supported Perl platforms would.  The most commonly discussed
problem was the conflict between File::stat, a core module, and File::Stat,
a non-core module.  If a user ran `cpan File::Stat` on Win32, he or she would
end up with `File/Stat.pm` installed, and `use File::stat` would pick that up
instead of the core module.

We'd done about three quarters of the work for this in New York, but I didn't
send a pull request.  I knew that we had an untested case: what happens when
someone who owns Foo::Bar now uploads Foo::bar?  We decided that it would
replace the old entry.  I wrote tests, which showed it didn't work, then David
made it work.  We also wrote a few more tests for other edge cases, and were
pleased to find them all handled the way we wanted.

We also discussed problems with the non-uniqueness of distribution names on
the CPAN.  In short, non-maintainer of Text::Soundex should not be able to
upload a dist called `Text-Soundex` and have it indexed.  I implemented this,
which ended up being a bit tricker to do than I expected, although the code
changes weren't too bad.  It was just getting there that took time.
Unfortunately, over 1,000 distributions on the CPAN have names that don't match
a contained package, so those had to be grandfathered in.  I may send out a
"consider changing your dist name" email, but I haven't decided.  It isn't
really such a big deal, but it nags at me.

I also did some work on the code that generates `03modlist.data`, the
registered module list.  The future of this feature is unclear, and will have
to get sorted out soon, probably over the next month or two.

### Pod!

The thing I came to the hackathon knowing that I *had* to work on was
Pod::Checker.  In fact, *most* of the PAUSE work I did had to wait until I
finished dealing with Pod::Checker.  I was really not looking forward to the
work, but I didn't want it to continue to languish, undone.  I'm glad I started
with it, because it only took about a day, and finishing it made me feel
excited for the rest of my time: I'd be able to work on other things!

In 2011, there was a Perl project in the Google Summer of Code whose goal was
to replace all core uses of Pod::Parser with Pod::Simple.  Pod::Html was
overhauled, but Pod::Usage and Pod::Checker weren't completed.  Pod::Checker
was mostly done, but not quite, and unfortunately languished in that state for
some time.  Since I'm keen to get Pod::Parser out of the core distribution, and
since I know that nobody really *wants* to do this work, I decided it would be
a good task to force myself to do while stuck in a room with nothing but my
laptop and a bunch of sympathetic ears.

There were n kinds of Pod::Checker checks that needed to be implemented,
reimplemented, or moved to Pod::Simple itself:

* tests needed updating for the new mismatched =item type check from Pod::Simple
* the totally broken "unescaped <" warning had to go
* a warning for "no closing =back" got put into Pod::Simple, eliminating use of Pod-Parser's Pod::List
* warnings for ambiguous constructs in `L<>` like leading spaces, unquoted slashes, and so on
* the check for internal hyperlink resolution had to be reimplemented

...and a few other little things, like hash randomization bugs.  I've filed [a
pull request with Pod-Simple](https://github.com/theory/pod-simple/pull/48) for
the patches that would go there, and [my branch of
Pod-Checker](https://github.com/rjbs/Pod-Checker/tree/pod-simple-checker) based
on Marc Green's original work is also now on GitHub, waiting to get a trial
release.

Once this is done, we'll get Pod::Usage converted, then we're done with
everything but the actual warnings and subsequent removals!

### Other Stuff!

I made a [new release of
CPAN::Mini](https://metacpan.org/source/RJBS/CPAN-Mini-1.111013/Changes),
closing quite a few very old tickets.  I also went ahead and made `--remote`
optional.  Maybe in the future, I might make `--local` optional, too!  The
biggest outstanding question is whether I will add any alternate configuration
filename and location for Win32, rather than `~/.minicpanrc`.  I'm still
conflicted.

I [applied some patches to
Router::Dumb](https://metacpan.org/diff/release/RJBS/Router-Dumb-0.003/RJBS/Router-Dumb-0.004),
exposing (I think) an [annoying missing behavior in
Test::Deep](https://github.com/rjbs/Router-Dumb/commit/99139e2fa461c5b677598afc60e4856d05f4a641).
I'd like to figure out how to fix that Test::Deep problem soon, but it didn't
happen this weekend.

I made a few other releases, including a release to Dist::Zilla that will make
it always upload to PAUSE using HTTPS.  I decided not to try to tackle anything
bigger at the hackathon.

### Free-Floating Helping!

This year, I think I spent less time than ever looking at other people's code
to be a fresh set of eyes.  On the other hand, I spent more time answering
questions related to coordinating changes with blead and other future releases.
"Is this a blocker?" was asked quite a few times as the rest of the room found
some interesting bugs in bleadperl.  "Shall I commit this to 5.19.0?" came up
often, too.

### The End!

I'm hoping to get some more work done on the Pod and PAUSE fronts, hopefully
very soon, but maybe at YAPC.  I'm looking forward to seeing the fruits of all
the labors performed by the other hackers at the hackathon, too.  (I started,
here, to list "especially abc, xyz, …" but the list got far too long.  Lots of
good stuff is coming!)  I also clearly found plenty of things I'd like to do,
but not just yet.  In other words, I'm ready for next year already!

I might write up some of the social bits of the trip a bit later.  The short
version of that is that I had a great time, enjoyed seeing old friends and
making some new ones, and ate four servings of black pudding.

