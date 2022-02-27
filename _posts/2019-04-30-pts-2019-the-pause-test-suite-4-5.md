---
layout: post
title : "PTS 2019: The PAUSE Test Suite (4/5)"
date  : "2019-04-30T00:45:11Z"
tags  : ["perl", "programming"]
---
## PAUSE and case insensitivity

All that Module::Faker and Getopt work was really in furtherance of PAUSE work.
When I arrived in Marlow, I had been given just request by Neil:  sort out
[PAUSE!320](https://github.com/andk/pause/pull/320), a change in behavior we've
been slowly getting right for years now.

Once upon a time, the PAUSE index was case sensitive.  [Andreas
König](https://github.com/andk), the author and maintainer of PAUSE, says he's
not sure whether or not this was actually intentional.  At any rate, it meant
that if one person uploaded the package "Parse::PERL" and another uploaded
"Parse::Perl", the indexer would let them each have permissions on the name
they uploaded.  This is a problem because not all filesystems are
case-sensitive.  So a user might rely on Parse::PERL, install Parse::Perl, and
then get bizarre errors when trying to use Parse::PERL in their code.  The
runtime, after all, does not verify that when you load the module Foo::Bar, it
actually defines the package Foo::Bar.  D'oh!

We've made various changes to address this problem, with the basic rule being
that permissions are case-preserving and not case-sensitive.  If you have
permissions on Foo::Bar, then you also own foo::bar and FOO::BAR and foO::bAr
and whatever else you like.  The index and permissions data will show
"Foo::Bar", because that's what you uploaded.  Maintainers of the Foo::Bar
namespace are free to rename it to fOO::BAr, if they want, by uploading a new
distribution, but nobody else can sneak their way into the namespace.

This was basically implemented at last year's PTS, but wasn't deployed because
it was broken in subtle ways.  The fix was easy, once I worked out what the
problem was, which required a bunch of testing.  More on that shortly!

The upshot was that I did get the behavior changed successfully.  Neil who had
been working for years to eliminate all the case conflicts in the permissions
list, had gotten things down to a few enough to count on one hand.  With the
bug fixed and the last few conflicts resolved, we believe we have ended the age
of conflicting-case index entries.  This was a nice milestone to reach.  There
was high-fiving, and Neil may have shed a single tear, though I couldn't swear
to it in court.

As an aside: you might be wondering, "Why didn't you just put case-insensitive
unique indexes in the database?"  PAUSE's indexer is sort of a strange beast,
which simultaneously updates the database, analyzes the contents of uploads,
and decides what to do as it goes along.  Triggering a database error would
jump past a lot of behavior, and we could've done it, but it felt saner to try
to detect the problem.  I have plans for the future to tease apart the
indexer's several behaviors.

## testing PAUSE

In August 2011, David Golden and I got together in Brooklyn and began writing a
test suite for the indexer.  To be fair, a couple tests existed already, but
they tested very, very few things.  By just a bit before four in the afternoon
on that day in 2011, David and I had a passing test that looked like this:

      my $result = PAUSE::TestPAUSE->new({
        author_root => 'corpus/authors',
      })->test;

      ok(
        -e $result->tmpdir->file(qw(cpan modules 02packages.details.txt.gz)),
        "our indexer indexed",
      );

      my $pkg_rows = $result->connect_mod_db->selectall_arrayref(
        'SELECT * FROM packages ORDER BY package, version',
        { Slice => {} },
      );

      my @want = (
        { package => 'Bug::Gold',      version => '9.001' },
        { package => 'Hall::MtKing',   version => '0.01'  },
        { package => 'XForm::Rollout', version => '1.00'  },
        { package => 'Y',              version => 2       },
      );

      cmp_deeply(
        $pkg_rows,
        [ map {; superhashof($_) } @want ],
        "we indexed exactly the dists we expected to",
      );

Further refinements would come, but many of the tests still look quite a lot
like this.  Note how it begins:  we name an `author_root`  This is a directory
full of pretend CPAN uploads by pretend CPAN authors.  Every file in the
directory is copied into the test PAUSE, simulating an upload, and then the
indexer is run.  To understand these tests, you need to know what's in that
directory.  It's not just a matter of running `ls`, either.  The directory
contains tarballs, and those tarballs are more or less opaque unless you unpack
them.  Ugh.  In this test, the contents were all entirely uninteresting, but in
later tests, you'd end up wondering what was being tested.  Something would
import `corpus/mld/009` and then assert that the index should look one way or
another, rarely noting that one dist in the directory had strange properties
known only at the time of test-writing.

To make matters worse, the tests were split into two files.  In one, each
tested behavior was tested with a distinct TestPAUSE, so no two tests would
interact.  In the *other* file, though, every behavior was tested on top of the
tests for the previous test, resulting in a very cluttered test file in which
the intent of any given test might be pretty hard to determine, especially when
you're reading it five years later.

Splitting those tests up so that each would use a distinct TestPAUSE wasn't
going to be difficult as a matter of programming, but it meant each one needed
to be teased apart from the one before it, meaning its intent needed to be
sussed out, which meant unpacking tarballs and reading their contents.  I shook
my fist and cried, "Never again!"

By 2019, test had changed so that rather than this:

      my $result = PAUSE::TestPAUSE->new({
        author_root => 'corpus/authors',
      })->test;

You'd be likely to write:

      my $pause = PAUSE::TestPAUSE->new;

      $pause->import_author_root('corpus/authors');

      my $result = $pause->test_reindex;

(This means you'd be able to later add more files, index again, and see what
changed.  Useful!)

To make the tests clearer, I added a new method, `upload_author_fake`:

      $pause->upload_author_fake(JBLOE => {
        name     => 'Example-Dist',
        version  => '1.0',
        packages => [ qw(Example::Dist Example::Dist::Package) ]
        more_metadata => { x_Example => 'This is an example, too.' },
      });

Hey, it's using `from_struct` like we saw in [my Module::Faker report from this
PTS](https://rjbs.manxome.org/rubric/entry/2115)!  Now you can always know
exactly what is interesting about a fake.  Sometimes, though, you don't need
an interesting fake, you just need totally boring dist to be uploaded.  In
those cases, now you can just write

      $pause->upload_author_fake(JBLOE => 'Example-Dist-1.0.tar.gz');

...and Module::Faker will know what you mean.

With this tool available, and the new Module::Faker features to help produce
weird distributions, I was able to rewrite the tests to be entirely isolated.
I also deleted quite a few of the prebuilt tarballs from the corpus directory,
but not all of them yet.  One or two are a bit tedious to produce with Faker,
and one or two others I just didn't get to.

I look forward to replacing those, in part because I know it will mean cool
improvements to Module::Faker, and in part because every time I make the test
suite saner, I make it easier to get more people confident that they can write
more PAUSE code.

