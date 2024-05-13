---
layout: post
title : "Data::Fake::CPAN (a PTS 2024 supplement)"
date  : "2024-05-12T12:00:00Z"
tags  : ["perl", "programming"]
---

One of the things I wrote at the first PTS (back when it was called the Perl QA
Hackathon) was Module::Faker.  I [wrote about it back
then](https://rjbs.cloud/blog/2008/03/cpans-other-than-the-cpan-and-other-software-distribution-issues/)
(way back in 2008), and again [eleven years
later](https://rjbs.cloud/blog/2019/04/pts-2019-module-faker-3-5/).  It's a
library that, given a description of a (pretend) CPAN distribution, produces
that distribution as an actual file on disk with all the files the dist should
have.

Every year or two I've made it a bit more useful as a testing tool, mostly for
PAUSE.  Here's a pretty simple sample of how those tests use it:

```perl
$pause->upload_author_fake(PERSON => 'Not-Very-Meta-1.234.tar.gz', {
  omitted_files => [ qw( META.yml META.json ) ],
});
```

This writes out `Not-Very-Meta-1.234.tar.gz` with a `Makefile.PL`, a manifest,
and other stuff.  The package and version (and a magic true value) also appear
in `lib/Not/Very/Meta.pm`.  Normally, you'd also get metafiles, but here we've
told Module::Faker to omit them, so we can test what happens without them.
When we were talking about testing [the new PAUSE
server](https://rjbs.cloud/blog/2024/05/pts-2024-lisbon/) in Lisbon, we knew
we'd have to upload distributions and see if they got indexed.  Here, we
wouldn't want to just make the same test distribution over and over, but to
quickly get new ones that wouldn't conflict with the old ones.

This sounded like a job for Module::Faker and a random number generator, so I
hot glued the two things together.  Before I get into explaining what I did, I
should note that this work wasn't very important, and we really only barely
used it, because we didn't really need that much testing.  On the other hand,
*it was fun*.  I had fun writing it and seeing what it would generate, and I
have plans to have more fun with it.  After a long day of carefully reviewing
cron job logs, this work was a nice goofy thing to do before dinner.

## Data::Fake::CPAN

[Data::Fake](https://metacpan.org/pod/Data::Fake) is a really cool library
written by David Golden.  It's really simple, but that simplicity makes it
powerful.  The ideas are like this:

1. it's useful to have a function that, when called, returns random data
2. to configure that generator, it's useful to have a function that returns the
   kind of function discussed in #1
3. these kinds of functions are useful to compose

So, for example, here's some sample code from the library's documentation:

```perl
my $hero_generator = fake_hash(
    {
        name      => fake_name(),
        battlecry => fake_sentences(1),
        birthday  => fake_past_datetime("%Y-%m-%d"),
        friends   => fake_array( fake_int(2,4), fake_name() ),
        gender    => fake_pick(qw/Male Female Other/),
    }
);
```

Each of those `fake...` subroutine calls returns another subroutine.  So, in
the end you have `$hero_generator` as a code reference that, when called, will
return a reference to a five-key hash.  Each value in the hash will be the
result of calling the generators given as values in the `fake_hash` call.

It takes a little while to get used to working with the code generators this
way, but once you do, it comes very easy to snap together generators of random
data structures.  Helpfully, as you can see above, Data::Fake comes with
generators for a bunch of data types.

What I did was write a Data::Fake plugin,
[Data::Fake::CPAN](https://metacpan.org/pod/Data::Fake::CPAN), that provides
generators for version strings, package names, CPAN author identities, license
types, prereq structures and, putting those all together, entire CPAN
distributions.  So, this code works:

```perl
use Data::Fake qw(CPAN);

my $dist = fake_cpan_distribution()->();

my $archive = $dist->make_archive({ dir => '.' });
```

When run, this writes out an archive file to disk.  For example, I just got
this:

```
$ ./nonsense/module-blaster
Produced archive as ./Variation-20010919.556.tar.gz (cpan author: MDUNN)
- Variation
- Variation::Colorless
- Variation::Conventional
- Variation::Dizzy
```

There are a few different kinds of date formats that it might pick.  This time,
it picked `YYYYMMDD.xxx`.  That username, MDUNN, is short for Mayson Dunn.  I
found out by extracting the archive and reading the metadata.  Here's a sample
of the prereqs:

```json
{
  "prereqs" : {
    "build" : {
       "requires" : {
          "Impression::Studio" : "19721210.298"
       }
    },
    "runtime" : {
       "conflicts" : {
          "Writer::Cigarette" : "19830107.752"
       },
       "recommends" : {
          "Error::Membership" : "v5.16.17",
          "Marriage" : "v1.19.6"
       },
       "requires" : {
          "Alcohol" : "v12.16.0",
          "Competition::Economics" : "v19.1.7",
          "People" : "20100228.011",
          "Republic" : "20040805.896",
          "Transportation::Discussion" : "6.069"
       }
    }
  }
}
```

You'll see that when I generated this, I ran `./nonsense/module-blaster`.  That
program is in the Module-Faker repo, for your enjoyment.  I hope to play with
it more in the future, changing the magic true values, maybe adding real code,
and just more variation — but probably centered around things that will have
real impact on how PAUSE indexes things.

Probably very few people have much use for Module::Faker, let alone
Data::Fake::CPAN.  I get that!  But Data::Fake is pretty great, and pretty
useful for lots of testing.  Also, generating fun, sort of plausible data makes
testing more enjoyable.  I don't know why, but I always like watching my test
suite fail more when it's spitting out fun made-up names at the same time.  Try
it yourself!
