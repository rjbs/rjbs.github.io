---
layout: post
title : "I went to the Perl Toolchain Summit in Oslo!"
date  : "2018-04-27T23:58:34Z"
tags  : ["perl", "progamming"]
---
The last time I wrote in this journal was in January, and I felt committed, at
the time, to make regular updates.  Really, though, my first half 2018 has been
pretty overwhelming, and journal posts are one of the many things I planned
that didn't really happen.  I'm hoping I can get back on track for the second
half, for reasons I'll write about sometime soon.  Maybe?

But I just got back from Oslo and the Perl Toolchain Summit, and it's
practically a rule that if you go, you have to write up what you did.  I like
the PTS too much to snub my nose at it, so here I am!

This was the 11th summit, and the second to be held in Oslo, where the first
one was held in 2008.  I've attended ten of them, including that first one, and
they've all been great!  They're small events with about thirty people, all of
whom are there by invitation.  The idea is that the invitees are people who do
important work on "the toolchain," which basically means "the code used to
distribute, install, and test Perl software modules."  People show up with
plans in mind, and then work on them together with the other people whose work
will likely be affected or involved.  There's always a feeling that everyone is
working hard and getting things done, which helps me feel energetic.  Also, I
like to take breaks and walk around and ask what people are doing.  Sometimes
they're stuck, and I can help, and then I go back to my own work feeling like a
champ.  It's good stuff.

I've worked on a number of parts of the toolchain, over the years, but most
often I spend my time on PAUSE, with just a little time on Dist::Zilla.  That's
where my time went again this year.  I wasn't at PTS last year, as I was in
Melbourne for work.  In the last two years, I've been doing much less work on
CPAN libraries.  That, plus some recent tense conversations on related mailing
lists, had me feeling unsure about the value of my going.  By the end, tough, I
was very glad I went, and felt like I can be twice as productive next year if I
spend just a little time preparing my work before I head out.

Here's what I actually did, more or less.  Mostly less, as it's been a few
days.  I should have kept day to day notes as I've done in the past!  There's
another way to improve for next year.

## Arrival

I got to Oslo on Tuesday the 17th and walked around the city with David Golden.
We didn't do much of anything, but I bought some things I'd forgotten to pack —
this was my worst travel packing in years — and ate dinner with Todd Rinaldo.
Mostly, my goal was to stay awake after taking a redeye flight, and I
succeeded.  The next day, we did more of the same, but also went to the
National Gallery, which was a good stop.  I wish I'd gone to the contemporary
art museum down near the shore, but instead I got sidetracked into
conversations about Perl.  It could've been worse!

## PAUSE work

PAUSE is the Perl Author Upload SErver.  When you upload a file "to the CPAN,"
PAUSE decides whether you had permission to do what you're doing and then
updates the indexes used by CPAN clients to install things.

Two years ago, in Rugby, we added a feature to PAUSE that would normalize
distribution permissions on new uploads, making sure that if a co-maintainer
uploaded a new version of a distribution, including some new package for the
first time, the new package got the same permissions as the distribution's main
module had.  This is part of the slow shuffle of PAUSE from dealing only in
package permissions to having a sense of distribution permissions.

I think the change was a good idea, but it had a few significant bugs.  Andreas
König had fixed at least some of them since then, but he had seen one file
recently that hit a security problem.  Unfortunately, his reproducer no longer
worked, and we weren't sure why.  While Andreas tried to reproduce the bug, I
sat down and read the related code closely until I had a guess what the problem
was.

I was delayed by an astounding bug in DB_File that manifested on my machine,
but not his.  This code:

      tie my %hash, 'DB_File', ...;

      $hash{ $_ } = $_ for @data;

      say "Exists" if exists $hash{foo};
      say "Grep"   if grep {; $_ eq 'foo' } keys %hash;

...would print "Grep" but not "Exists".  In other words, `exists` was broken on
these tied hashes.  Rather than go further down this rabbit hole, we removed
the tie.  There's a lot more memory available for processes now than when the
code was written maybe twenty years ago!

When Andreas had a reproducer working, we tried my fix… and it failed.  The
theory was right, though, and I had a real fix pretty quickly.  Once we knew
just what the problem was, it was pretty easy to write a simple test case for
the PAUSE test suite.

After that, Andreas mentioned we'd seen some errors with transaction failures.
I did a bit of work to make PAUSE retry transactions when appropriate and,
while I was doing that, made what I thought were significant improvements to
the emails PAUSE sends when things go wrong.

Doing this work, like a lot of PAUSE work, involved working out a lot of issues
of action at a distance and vestigal code.  In fact, the bug boiled down to a
piece of code being added in the wrong phase, and the phase to which it was
added should've been deleted a year before the bug was introduced.  Since it
wasn't, it was a deceptively inviting place to add the new feature.  I decided
I would try to purge some code that was long overdue for purging, and to
refactor some large and confusing methods.

I spent a fair bit of Thursday afternoon on this, as a first pass.  I think I
made some good improvements.  My biggest target was "the big loop", a `while`
loop labeled `BIGLOOP` in `PAUSE::mldistwatch` *aka* "the indexer".  I pulled
this code apart into a few subroutines, and then did the same thing to some of
the routines it called.  More and more, I felt confident that there were (And
still are) two main problems to address:

* Distinct concerns like permissions and side-effects are interwoven and
    difficult to separate out.  I started to discuss the idea of making the first
    phase of indexing construct a plan of side effects which would then all be
    taken in a second phase.  Easier said than done!  Later in the week, David
    Golden did some work toward this, though, and I think next year we can make
    big strides.
* Often, decisions are made at a distance.  During phase 1, a check might cause
    a variable on some parent object to be set.  Later, in phase 6, a different
    object might go and find that parent and check the flag in order to make a
    decision.  This is all somewhat ad hoc, so it's often unclear why a flag is
    being set or what the full implications of setting it might be.  Achieving a
    desired effect late in the program might require changing the actions taken
    very early.

On Friday, I carried on work to deal with this, but eventually I stopped short
of any major changes.  It was going to take me all of Friday come up with a
solution I'd like, and I didn't think I could have the implementation done in
time to want to deploy it.  The last thing I wanted was to push Andreas to
deploy a massive refactoring on Sunday night before we all went home!  Instead,
this problem is on my list of things to think hard about in the weeks leading
up to the 2019 PTS.

Finally, I had a go at the final (we hope) change needed for the full
case-desensitization of PAUSE.  Right now, if you've uploaded `Foo::Bar`, PAUSE
prevents you from later uploading `FOO::BAR`.  This was a conscious decision to
avoid case conflicts, but we've since decided that you should be able to change
the case, if you have permissions over the flattened version, but we must keep
everything consistent.  I made some good progress here, but then hit the
problems above:  side effects and checks happen in interleaved ways, so getting
everything just right is tricky.  I have a branch that's nearly done, and I
hope to finish it up this year.

While doing that, I also made some improvements to the test system.  I'm proud
of the PAUSE test suite!  It's easy to add new tests, and now it's even easier.
In the past, if you wanted to test how the indexer would behave, you'd build
some fake CPAN distributions and mock-upload them.  These distributions could
be made by hand, or by using Module::Faker.  Either way, they took the form of
tarballs sitting in a `corpus` directory.  Making them was a minor drag, and
once they're made, you'd not always sure what their point is.

I added a new method, `upload_fake`, that takes a `META.yml` file, builds the
dist that that file might represent, and uploads that file for indexing.  For
example, given this metafile:

    # filename: Foo-Bar-0.001.yml
    name: Foo-Bar
    version: 0.001
    provides:
      Foo::Bar:
       version: 0.001
       file: lib/Foo/Bar.pm
    X_Module_Faker:
      cpan_author: FCOME

...the test suite will make a file with `lib/Foo/Bar.pm` in it with the code
needed: package statements, version declarations, and so on.  The it will
upload it to `F/FC/FCOME/Foo-Bar-0.001.yml`.  This uses Module::Faker under the
hood, and I took a little time to make some small tweaks to Module::Faker.  I
have some good ideas for my next round of work on it, too.

Oh, and finally: we want to add a new kind of permission, called "admin", which
lets users upload new versions of code and to grand uploading permissions to
others, but is clearly not the primary owner.  Right now, we don't have that.
David and I both made some inroads to making it possible, but it's not there
yet.

## Dist::Zilla

First, I applied a bunch of small fixes and made a new v6 release.  These were
all worthy changes, but fairly uninteresting, with the possible exception of an
update to the configuration loader, which will now correctly load plugins from
`./inc` on perl v5.26, where `.` is not in `@INC`.

After that, I made a new release of v5.  It includes a tiny tweak to work
better with newer Moose, so you can still get a working Dist::Zilla on a
pre-5.14 perl.  Don't get too excited, though.  I still don't support v5.  This
release was made at the request of Karen Etheridge, but I'm not sure she's
eagier to field any support requests, either.  Consider upgrading to v6!

After *that*, I started work on v7.  At work, newer code is being written
against perl v5.24, and we use lots of new features: lexical subroutines,
pair slicing, postfix dereferencing, subroutine signatures, `/n`, and so on.
If practical, I wanted to be able to start doing that in Dist::Zilla.

I have [a program that crawls over the
CPAN](https://github.com/rjbs/CPAN-Metanalyzer), unpacking every distribution
and building a small report about its contents.  Here's an example report on
one dist:

      sqlite> select * from dists where dist = 'Dist-Zilla';
               distfile = RJBS/Dist-Zilla-6.012.tar.gz
                   dist = Dist-Zilla
           dist_version = 6.012
                 cpanid = RJBS
                  mtime = 1524298921
           has_meta_yml = 1
          has_meta_json = 1
              meta_spec = 2
      meta_dist_version = 6.012
         meta_generator = Dist::Zilla version 6.012, CPAN::Meta::Converter version 2.150010
       meta_gen_package = Dist::Zilla
       meta_gen_version = 6.012
          meta_gen_perl = v5.26.1
           meta_license = perl_5
         meta_yml_error = {}
       meta_yml_backend = YAML::Tiny version 1.70
        meta_json_error = {}
      meta_json_backend = YAML::Tiny version 1.70
      meta_struct_error = {}
           has_dist_ini = 1

I originally wrote this to tell me how many people were using Dist::Zilla, but
it's useful for other things, like dependency analysis (not shown, above, is
the dump of all the module requirements in the metafile) or common YAML errors.

The `meta_gen_perl` field looks for a new field I just added to all Dist::Zilla
distributions, telling me the perl used to build the dist.  Failing that, it
looks for output from MetaConfig.  You won't yet see these data for dists not
built by Dist::Zilla.  I looked for what perl version was being used to build
distributions with Dist::Zilla v6:

      sqlite> SELECT SUBSTR(meta_gen_perl, 1, 5) AS perl, COUNT(*) AS dists
              FROM dists
              WHERE meta_gen_package = 'Dist::Zilla'
                AND meta_gen_perl IS NOT NULL
                AND SUBSTR(meta_gen_version,1,1)='6'
              GROUP BY SUBSTR(meta_gen_perl, 1, 5);

      perl        dists
      ----------  ----------
      v5.14       2
      v5.16       5
      v5.18       4
      v5.20       29
      v5.22       98
      v5.23       7
      v5.24       675
      v5.25       204
      v5.26       563
      v5.27       54

This isn't the best data-gathering in the world, but it made me feel confident
about moving to v5.20.  I started a branch, applied the commits that had been
waiting for v5.20, and then got to work with other changes I wanted:

* lexical subroutines
* subroutine signatures
* eliminating circumfix dereference

Lexical subs were only useful in a small number of places, as I expected.  (The
use here is "making the code a bit nicer to read".)  Subroutine signatures were
much more useful, and found a number of bugs or sloppy pieces of code, but they
introduced a new problem.

Subroutine signatures enforce strict arity checking by default.  That is, if
you write this:

      sub add ($x, $y) { $x + $y }

      add(1, 2, 3);

...then you get an error about too many arguments.  This is good!  (It's also
easy to make your subroutine accept and throw away unwanted arguments.)  The
not so good part is that the error you get tells you what subroutine was called
incorrectly, but not by what calling line.  This has been a known problem since
signatures were introduced.  For the most part, even though I use signatures
daily, I hadn't found this to be a major problem.  This time, though, a new
pattern kept coming up:

      around some_method ($orig, $self, @rest) { ... }

Now, if the caller of `some_method` got the argument count wrong, I'd only be
told that `Class::MOP::around` was called incorrectly.  This could be
*anything*!  I'm going to push for the diagnostics to be fixed in v5.30.

In eliminating circumfix dereferencing, what I found was that I was always
happier with postfix — and I knew I would be.  I had already made a
postfix-deref branch of Dist::Zilla years ago when the feature was experimental
in a branch of v5.19.  What I also found, though, was that I often wanted to
eliminate the dereferencing altogether.  Often, Dist::Zilla objects have
attribute accessors that return references, often directly into the objects'
guts.  In those cases the reference doesn't just make things ugly, it makes
things unsafe.  I began converting some accessors to dereference and return
lists.  This broke a few downstream distributions, but nothing too badly.
Karen helped me do some testing on this, along with some other v7 changes, and
will probably end up dealing with more maybe-breakage based on v7 than anybody
but me.  I think I'll definitely keep these changes in the branch, and try to
make sure everything is fixed well in advance.

The attribute I didn't want to just change to flattening, though, was
`$zilla->files`, which returns the list of files in the distribution.  For
years, I've wanted to replace the terrible "array of file objects" with
something a bit more like a filesystem.  This would make "replace this file" or
"delete the file named" or "rename this file" easier to write, check, and
observe.  It felt like fixing that might be best done at the same time as
fixing other reference attributes.

So, v7 isn't abandoned or aborted, but it's definitely going to get some more
thinking before release.  That also gives me more time to collect more perl
version usage data.

## Test::Deep

I made a new release of Test::Deep, mostly improving documentation.  I also had
a go at converting it to Test2::API.  This caused some nervous noises from
people who didn't want to see Test2 become required by something so high up the
dependency river.  What I found was that Test::Tester, which Test::Deep uses to
test its own behavior, basically can't be used to test libraries using
Test2::API without Test::Builder.  If nothing else, that puts a significant
damper in my musings about the Test::Deep change.  It was only a quick
side-project, though.  I'm not in a rush or particularly determined to make the
change.

I also talked with Chad Granum about Test2::Compare.  I like parts and other
parts I am not so keen on.  I've wondered whether I can produce a sugar for
Test2::Compare that I'd like.  So far: maybe.

## Discussions

This year, there were fairly few big talking groups, which was fine by me.
Sometimes, they're important, but sometimes they can be a big energy drain.
(Sometimes, they're both.)  We had a talk about building a page to help CPAN
authors prepare for making new releases of highly-depended-upon distributions.
I did a bit of work on that, but mostly just enough to let others contribute.
I'm not sure how much success we've really had int he past with building
how-tos.

There was some talk about converting PAUSE to have more dist-centric, rather
than package-centric permissions.  I agree that we should do that, but I knew
it wasn't going to happen this year, so I stayed out of it as much as I could.

I interrupted a lot of people to ask what they were doing, which was often
interesting and, maybe just once or twice, helpful to my victim.

Nico and Breno found that `\1` is flagged read-only, but `\-1` is not.  "Oh
good grief," I said, "it's going to be because `-1` isn't a literal, it's an
expression."

Sadly, I was right.

Chad showed me the tool he's working on for displaying test suite run results
on the web, and it looked very nice.  I asked if he'd ever heard of Smolder,
and he said no, and I felt like an old-timer.  Smolder was a project by Michael
Peters, who was one of the attendees of the first summit (then the Perl QA
Hackathon).

I talked with Breno about Data::Printer, and was utterly gobsmacked to learn
that he implemented the "multiple Printer configurations in one process"
feature that I've been moaning about (and blowing hot air about implementing)
for years.  I also showed off my Spotify playlist tracker to him and to Babs.
I did not manage to get the Discover Weekly playlist of every attendee, though.
Fortunately, this is easy to follow up on after the fact.

## Downtime

Other things of note:  we went to a bar called RØØR and played shuffleboard.
that was terrific, and I would like to do it again.  We had a number of good
dinners, and the price of beer in Oslo prevented me from overindulging.  I
couldn't find double-edged safety razors anywhere, so didn't shave until I
couldn't stand it anymore and used a disposable razor from the hotel's shop.
It was terrible, but I felt much better afterwards.  I had skyr in Iceland, and
it was good.  I had salted liquorice in Oslo and it was utterly revolting,
every single time I tried another piece.

Unlike some previous hackathons, we had lunch and dinner served at the
workspace most days.  I was worried that this might introduce the "20 hour days
of doing terrible work because you're not sleeping" vibe of some hackathons.
It did not.  We still wrapped up whenever we felt done, but if we wanted to
work just a little later to finish something, we could.  It was good.

## Thanks!

All the organizers did a great job, and it was a great event.  I'm definitely
looking forward to next year (in England), and I realie now that if I do some
more prep work up front, I'll be much more successful.  (I worked like this in
the past, but I have since lost my way.)

The Perl Toolchain Summit is paid for by sponsors who make it possible to get
all these people into one place to work without distraction.  Those sponsors
deserve lots of thanks!  They've helped produce a lot of positive change over
the years.

Thanks very much to Salve, Stig, Philippe, Laurent, Neil, and our sponsors:
<a href="https://www.nuugfoundation.no/en/">NUUG Foundation</a>,
<a href="http://www.teknologihuset.no">Teknologihuset</a>,
<a href="https://www.booking.com">Booking.com</a>,
<a href="https://cpanel.com">cPanel</a>,
<a href="https://www.fastmail.com">FastMail</a>,
<a href="https://www.elastic.co">Elastic</a>,
<a href="https://www.ziprecruiter.com">ZipRecruiter</a>,
<a href="https://www.maxmind.com/en/home">MaxMind</a>,
<a href="https://www.mongodb.com">MongoDB</a>,
<a href="https://www.surevoip.co.uk">SureVoIP</a>,
<a href="https://www.campusexplorer.com">Campus Explorer</a>,
<a href="https://www.bytemark.co.uk">Bytemark</a>,
<a href="https://www.iinteractive.com">Infinity Interactive</a>,
<a href="http://opusvl.com">OpusVL</a>,
<a href="https://eligo.co.uk">Eligo</a>,
<a href="https://www.perl-services.de">Perl Services</a>,
and <a href="https://www.oetiker.ch">Oetiker+Partner</a>.</p>


