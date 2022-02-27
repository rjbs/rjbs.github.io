---
layout: post
title : how I spent my Perl QA Hackathon
date  : 2012-04-03T14:36:16Z
tags  : ["perl", "perlqa2012", "programming"]
---
I've been a big fan of the Perl QA Hackathon since the first one in Oslo in
2008.  I always walk away from them feeling like I've finished a lot of work
that I would otherwise have let go unfinished, and with refreshed interest in
the general work of Making CPAN Stuff Go.  This year, I was sent to the
hackathon by a grant from the Perl Foundation, and I promised to write up what
I got done.  That works out just fine, since I'm pretty pleased with how it all
went, and I'm looking forward to writing my report.

This started pretty well.  I started by talking with Dominique from Debian about
some patches for Software::License.  We negotiated and he said he'd (very
graciously!) rework his patches to fit my whims.  After that, my plan was to
resume some old work I'd been doing on [PAUSE](http://github.com/andk/pause).
PAUSE, the Perl Author Upload SErver, is the collection of tools that build the
CPAN index files that allow things like CPAN.pm and cpanminus to do their job.
Without PAUSE, the CPAN would just be a fileserver.  It was written by Andreas
König, who takes great care of it – which is good, since there aren't many
people who know the code very well, in case Andreas ever decides to retire to
the Schwartzwald and enjoy the simple life.  Last year, David Golden and I
[spent a lovely day doing some refactoring and testing of
PAUSE](http://rjbs.manxome.org/rubric/entry/1904).  We got quite a big of work
done on getting a grip on how everything had to work, and the tests made it
easy to start making minor changes without fear.

At the hackathon, I was hoping to continue improving those tests, refactoring
the code, and creating a few new indices that we'd theorized would make things
easier in the future.  I spent about a half hour getting my local testing
environment working again (running PAUSE, now, under 5.15.9) and just as I
started to sketch out how I'd proceed, I heard talk of PAUSE indexing from the
other side of the room.  David, Andreas, and some others were talking about a
generic API for CPAN dist locators.  I've been suggesting we needed such a
thing for years, so I sprang up and over to listen in.  It sounded like we were
all on the same page, which was exciting, and it sounded like one of the
locators someone wanted (for dealing with [BACKPAN](http://backpan.perl.org/))
would be much easier to deal with if we had historical records of what was
indexed when.  I'll elaborate.

Right now, when you tell your CPAN client to install Foo::Bar, it effectively
looks up the entry for that package in a simple text file called
`02packages.details.txt`.  Some clients use a web service for these lookups,
but it really all comes down to the 02packages file.  ("02packages" was a bit
of jargon heard constantly at the hackathon.)  This file maps package names to
the distribution file – generally a tarball – that contains the latest
authorized version of the package.  Anyone can upload any package, but it won't
get indexed unless the uploader has the right permissions.

02packages was being regenerated every hour, and every time the new version was
written, the old version was lost forever.  We had no real historical data on
what the CPAN's "latest authorized packages" looked like for past dates.  This
has come up many times before for many other projects, but we've never done
anything about it.  Fixing this seemed like a much more useful project than the
speculative one I'd been planning, so I went back to my workstation and got
cracking.

After a few false starts, [I got things going very
nicely](https://github.com/andk/pause/pull/13), and was delighted to hear that
Andreas declared my code clear and unobjectionable.  It was merged into the
PAUSE master shortly after lunch.

From there, things went south.

My next plan was to make some improvements to indexes so that CPAN.pm could
load them faster and cut down on memory usage.  I struggled to make any
progress, but I couldn't focus.  I hadn't slept well on the flight over, or the
night before the hackathon, and I was feeling really run down.  I started
feeling nauseous, and all the snack food started to repel me.  The room felt
hot, and I tried to drink more water, to stay hydrated and cool, but even
sipping water was an effort.  Finally, I left the hackathon early, went back to
the hotel, and spent the rest of the evening quite ill.  I learned that you
can't find Gatorade or other sports drinks at convenience stores or small
groceries in Paris, so I settled for drinking 1.5 liters of 7-Up.  I watched [a
depressing documentary about D&D
players](http://en.wikipedia.org/wiki/The_Dungeon_Masters).  I felt hot and
cold and weird, and I wrapped myself in a blanket and tried to sleep.  I slept
terribly and had a never-ending dream about how I would've done things
differently from the DM in the movie.

It was a really lousy day, except for the great part where I got PAUSE storing
its historical data in git.  The next day, I found out it was worse than I
thought:  first off, I'd missed a duck dinner.  Secondly, the git stuff wasn't
working in production.

By the time Andreas told me about the git code not working, I'd gotten deep in
other projects, to which I'll return later.  Andreas (bless him) held off
bothering me at first, but pretty soon he just knew something was very wrong
and told me I had to fix it, because otherwise my code was preventing PAUSE
from working.  At [Pobox](http://pobox.com/), where I work, the cardinal rule
is that the mail must always flow and never be lost or stopped.  The report
that "you are blocking the dists from flowing" set off my learned response to
mail problems.  I gritted my teeth and got to work.

In my patch, whenever PAUSE was going to reindex, its first job was to clean up
the git repository where it stores its historical data.  The idea here is that
it wants to make sure that no partially-written files from a previous run get
committed on the next run.  It's a good idea, and it was implemented something
like this:

    # $self->git is a Git::Wrapper object
    $self->git->reset({ hard => 1 }) if $self->git->status->is_dirty;

When Andreas ran the indexer, it would get to this line and the program would
then exit.  It exited silently, every time, right there.  It was clear that
this line was the only problem.  If we removed it (since it was only needed as
a precautionary measure) things worked just fine.  After suggesting a few other
things that didn't pan out, I wrote the following test program:

    use strict;
    use warnings;
    use 5.10.1;
    use Git::Wrapper;
    say "making git object...";
    my $git = Git::Wrapper->new( "/home/ftp/pub/PAUSE/PAUSE-git" );
    say "checking status...";
    my $status = $git->status;
    say "checking is_dirty...";
    my $dirty = $status->is_dirty;
    say "resetting...";
    $git->reset;
    say "resetting hard...";
    $git->reset({ hard => 1});
    say "all done.";

It would die every time it called `status`.  I dug and dug and turned up a few
key facts:

* the PAUSE server was running a pre-1.7 git and upgrading wasn't an option
* prior to git 1.7 (or so), "git status" would return non-zero in many cases that didn't represent failure to run properly
* when a git command returns non-zero, Git::Wrapper throws an exception
* the exception stringifies to the STDERR output of the program
* "git status" was only printing to STDOUT

So, the program was throwing an exception of the class Git::Wrapper::Exception,
which was being dutifully printed to the screen -- but its string
representation was empty!

I filed [a pull request for these
problems](https://github.com/genehack/Git-Wrapper/pull/10), and we applied them
locally, but then we hit another problem.  The `status` method can't return a
useful object (with that `is_dirty` method) with older gits.  Fortunately, now
I knew just what to do... but before I say what it was, maybe some readers are
wondering why I didn't just reset unconditionally.  The problem is that you
can't reset if HEAD doesn't point at a ref, and in a newly-initialized
repository, HEAD is set to point at `refs/heads/master`, which does not exist.
Trying to reset is fatal.  I could've required that the repository be given a
bogus root commit before any indexer runs happen, but it would've required
changes to the tests and other things.  Instead, I just replaced `is_dirty`
with a simpler check:

    $self->git->reset({ hard => 1 })
      if -e dir($self->gitroot)->file(qw(.git refs heads master));

With that done, the indexer ran swimmingly.  Even better, a few minutes later,
Andreas updated the indexer to run *every few minutes* instead of every hour.
The 02packages history began to grow.  It was all very exciting!  When I
reported this development to IRC, BinGOs pointed out that he already had a
program that would take a git-generated diff of an 02packages file and report
what dists should be retested.  I'm looking forward to seeing whether it can be
adapted to make a CPAN::Mini install run much, much faster.

This success got me raring to go on to more work, so I did!  David Golden had
figured out how to greatly improve the efficiency of CPAN.pm's reading of
02packages, and wanted to apply the same technique to 01mailrc, but he
couldn't.  The file wasn't sorted.  Worse, some code relied on the particular
nature of its non-sortedness.  I added a new (better, I'd say) index,
`02authors.txt`, which *is* sorted, and which is *not* pretending to be a
`mutt` address book file.

Earlier, I mentioned that Andreas didn't bring me the git problem first thing.
Before he did, I'd been working on another part of PAUSE: the YAML-handling
code.  All through PAUSE, there was code dealing with YAML this and YAML that.
I spent a good bit of effort over the last few years trying to pave the way to
eliminate CPAN's dependency on pseudo-YAML files.  These days, META.json is
preferred over META.yml by just about everything.  PAUSE, though, only ever
looked at the YAML.  It also had code to cope with having almost any YAML
parser from CPAN, trying each in turn to figure out which could be used.  I
wanted to make PAUSE act like everything else is meant to:  it should use
Parse::CPAN::Meta, preferring JSON to YAML.

This seemed quite daunting at first, so I started with something small:  I
renamed a whole mess of variables and hash keys.  YAML_CONTENT became
META_CONTENT.  The method `extract_readme_and_yaml` became
`extract_readme_and_meta`.  With that done, things suddenly seemed much less
daunting.  In part, it became clear how many things wouldn't need any real
change.  I also got a bit better view on how the methods worked while flipping
through them.  After all the renaming and some other refactoring of methods I
didn't quite follow, my git logs suggest that updating PAUSE to use
Parse::CPAN::Meta, and to look for META.json first, only took about half an
hour!  My [pull request for META.json support in
PAUSE](https://github.com/andk/pause/pull/14) has already been merged.  You'll
see some minor changes in your PAUSE indexer reports reflecting this!

I spent a little time applying patches I'd received, and even prepared a trial
release of the next version of Data::Rx (the Perl implementation of [my schema
language Rx](http://rx.codesimply.com/)), incorporating some *long* overdue
improvements to its error reporting from Ronald Kimball.

I was feeling good.  Not great – I was still tired and a little worried about
pushing myself – but I was starting to feel my usual Hackathon mood emerging.
I'd stuck to biscuits, bananas, baguette, and butter all day, and I think it
helped.

As we walked back to the hotel before dinner, I asked Miyagawa how his
hackathon was going.  He said he wanted to get better support for all of
META.json's prereq types (suggestions, test requirements, etc.) into cpanminus,
but had been stymied by ExtUtils::MakeMaker's lack of support for test
requires.  One big motivator for him was to speed up the `--notest` option by
skipping test prereqs, but that wouldn't work if EUMM had no mechanism for
them.

"You know what, I bet if you bring it up tomorrow, some sucker will volunteer
to do it."  He seemed dubious, and I felt smug.  "You know," I said, "I use
Dist::Zilla, which write its *own* META.json, so the test requirements are
there even though you use ExtUtils::MakeMaker."

"Sure," he said, "but when you rebuild the MYMETA file on the installer's
machine, isn't that getting done by EUMM, so it'll then lose those?"

I stammered and sputtered.  "I ... don't know.  But I guess I'll be your sucker
and fix EUMM just in case."

Testing at the hotel made it clear: EUMM wasn't losing the DZ-configured test
requirements, but it *was* merging them into the build requirements, which
would screw up Miyagawa's `--notest` improvements.  I decided to tackle this
problem, even though it would mean patching ExtUtils::MakeMaker, where many
hackers fear to patch.

For dinner, we went to a nearby Lebanese restaurant, and I ate everything.
Well, actually, I declined to try the hot pink probably-a-vegetable-thing that
no one could identify.  (Garu ate it instead.)  I also declined to drink any
arrack, although I would have liked to.  I decided to take it easy.  As we
left, Philippe did remind me that I should stop by the hotel lounge for some
chartreuse, and I did, because it seemed like an opportunity that would not
come again.

The chartreuse was *amazing*, but I limited myself to about an ounce.  I looked
for a bottle at the duty free shops when I headed home, but there was none to
be found.  Ah, well!

The next day, I was finally feeling at full strength.  I ate a real breakfast,
had some tea, and stormed into the hackathon venue ready to do some damage to
ExtUtils::MakeMaker.  It took me a few iterations to get the changes right,
because it took me a while to understand the nature of the problems in my way,
but it still didn't take too long to get done.  I was lucky, of course, that I
was not touching anything related to Makefile generation.

At first, I expected things to be quite simple:  I'd duplicate the
implementation of the `BUILD_REQUIRES` option and edit it.  This didn't pan
out.  The build requirements work by shoving stuff into EUMM's internal META
structure, which uses the 1.4 version of the spec.  There's nowhere to *put*
test requirements.  I started going through a lot of convolutions before I
realized that things were even weirder than this.  EUMM would write out
MYMETA.json in v2, by up-converting.  If your META.json file was already in v2,
this meant it would read it in, down-convert to 1.4, *do nothing to it*, and
then up-convert to 2.  EUMM couldn't just switch *everything* to v2,
unfortunately.  The existence of the `META_ADD` and `META_MERGE` options means
that there are Makefile.PLs that assume very strongly that the structure in
question is one thing or another.  These are never used, though, to merge data
into the MYMETA structure when you've got data loaded from your META, so the
*MYMETA* structure could use v2 internally.

I filed a [pull request for adding TEST_REQUIRES with
tests](https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/pull/29).
It's a bit of a mess, but that seems to be life with EUMM.  One weirdness is
that because the META.json file is generated from the v1.4-based internal
structure, it will report any test requirements as build requirements.  Once
rebuilt as MYMETA.json, though, it will properly separate them.  This should
really be fixed in the long run, but it will take some careful planning to get
right.  I think the simplest thing will be to try to outlaw the add and merge
options, but they're not always avoidable, right now.  (Fortunately for *me*,
at least, my Dist::Zilla-based dists will now have accurate META *and* MYMETA
files.)

The rest of the day was spent on a number of smaller tasks.

I talked with Tux and Abe about their ongoing work to overhaul the CPAN Smokers
system.  CPAN Smokers are like CPAN Testers, but instead of doing automated
test runs of CPAN modules, they just try to build and test the Perl core
itself.  The smokers are *vital* to detecting all kinds of problems introduced
into the core, and making their reports easier to scan, analyze, store, and
inspect is a *huge* deal.

I answered some questions here and there about Dist::Zilla, and some about
the state of things in perl 5.15, 5.16, and 5.17.  There were some good
discussions about minimum toolchain version support (right now, 5.6.0; soon,
probably 5.8.1).  Ovid found a really interesting bug in Module::Build's use of
version.pm, and I tried to help diagnose it.  There were a dozen other similar
little things, most of which have slipped my mind, but I was feeling pretty
productive and good.

By the end of the day, I had pulled up the bug queue for Test::Deep, one of my
favorite test modules, and started to go through it writing patches for
reported bugs.  When we were told that it was time to go, I was disappointed.
I felt like I could've cleared the whole thing.  I resolved that *next* year,
I'd avoid being debilitatingly ill during the hackathon.

At dinner, I somehow got launched into an absurdly overlong lecture on the
vicissitudes of Dungeons and Dragons over the decades, and Nick Perez suggested
that as long as a bunch of us were D&D dorks and all in one place, we should
play.  I *did* have dice and character sheets, so I agreed, and after dinner we
went back to the hotel and played.  I may write up the game in detail later,
but the only party member death was very early and affected a henchman.

The party:

    Aloysious the Medium   - David Golden      - whispered a lot, wore black
    Hercamer the Dwarf     - Leon Timmermans   - aka "Grumpy"
    Kaga the Aspirant      - Breno de Oliveira - beheaded a zombie with a club
    Logarth the Dwarf      - Nick Perez        - spent an hour interrogating a golem
    Snape the Apprentice   - Kenichi Ishigaki  - got whacked out on blue moss
    Zendora the Apprentice - n/a               - vaporized by a jet of flame

It was a lot of fun, and was good practice for the D&D I hope to run at YAPC
and OSCON this year.

This morning, as we headed off to the airport, Matthew Horsfall asked whether I
felt I'd gotten as much done as I'd wanted, despite being sick.  I told him
that I didn't know.  My feeling is often that one arrives at the hackathon with
four goals and tends to complete sixteen, most of which were not on the
original list, and to feel that if only the hackathon went on *forever*, one
could complete *ALL THE GOALS*.  I'm really pleased with what I got done, and
I'm really pleased that a number of things I worked on now feel more open for
more work, to me.  It would've been nice to have been feeling my best, but I
wasn't, and I don't think my weekend was even *remotely* a loss.  I guess maybe
I have two regrets: I didn't do any site-seeing, and I didn't get to eat any of
the duck dinner.  On the Perl front, I feel pretty good about things.

The hackathon had an [impressive list of sponsors](http://2012.qa-hackathon.org/qa2012/sponsors.html) who made it possible by paying for things like airfare, lodging, food, the venue, and more food.  Take a look at that list of companies, because they're people who are showing that they know how important the CPAN system is to the continued success of Perl.
