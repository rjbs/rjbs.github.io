---
layout: post
title : "my stupid CPAN \"meta analyzer\""
date  : "2015-04-30T04:08:06Z"
tags  : ["perl", "programming"]
---
Just about exactly five years ago, I wrote a goofy little program that walked
through all of the CPAN and produced a CSV file telling me what was used to
produce most dists.  That is: it looked at the `generated_by` field in the META
files and categorized them.  Here's what the first report, from April 11, 2010,
looked like:

      generator             | dists | authors | %
      ExtUtils::MakeMaker   | 7864  | 2193    | 39.49%
                            | 5273  | 2228    | 26.48%
      Module::Install       | 3149  |  465    | 15.81%
      Module::Build         | 3104  |  618    | 15.59%
      Dist::Zilla           |  475  |   64    | 2.39%
      ExtUtils::MY_Metafile |   25  |    3    | 0.13%
      __OTHER__             |   20  |    8    | 0.10%
      software              |    5  |    1    | 0.03%

Over time, I puttered around with it, but mostly I just ran it once in a while
to see how things changed.  (The above data is actually a truncation.  The
"other" category is all the generators used by fewer than 5 dists.)

Here's what the data look like for last month, only generators with at least
100 dists:

      generator                    | dists | authors | %
      ExtUtils::MakeMaker          | 10419 | 2997    | 34.27%
      Dist::Zilla                  |  6225 |  836    | 20.48%
                                   |  4807 | 2299    | 15.81%
      Module::Build                |  3931 |  918    | 12.93%
      Module::Install              |  3549 |  622    | 11.67%
      __OTHER__                    |   792 |  189    | 2.61%
      Dist::Milla                  |   225 |   54    | 0.74%
      Dist::Inkt::Profile::TOBYINK |   141 |    3    | 0.46%
      The Hand of Barbie 1.0       |   106 |    1    | 0.35%
      Minilla/v2.3.0               |   104 |   55    | 0.34%
      Minilla/v2.1.1               |   103 |   46    | 0.34%

The program that generates this data is (now) pretty fast.  It generates all
the data for a minicpan in about fifteen minutes.  Generating the above table
takes a second or two.

Back in 2010, all the data went into a CSV file, but now it goes into an SQLite
database.  It's faster, easier to query, and can store a bunch of data that
would've been a real drag to put into CSV.  For example, there's a table that
tells me prerequisites.  I can write a pretty simple program to print a
dependency tree.  This can show you all kinds of stuff.  For example,
installing the should-be-lightweight Sub::Exporter ends up having to bring in
Module::Build because `constant`, part of core, is also on CPAN.  If you ever
have to upgrade to the CPAN version, you'll find that it has a configure-time
requirement on Module::Build, despite not really needing it.

Maybe we'll fix that in the next CPAN release, due this week...

The data generated isn't perfect, but it's still darn useful.  It's very
similar, in fact, to Adam Kennedy's old
[CPANDB](https://metacpan.org/pod/distribution/CPANDB/lib/CPANDB.pod) library,
which I used for similar things.

My code isn't on the CPAN yet, because it's sort of a mess.  It was a gross
hack for years and only now am I trying to make it sort of semi-reusable.  Give
it a try yourself!  You can clone [the
CPAN-Metanalyzer](https://github.com/rjbs/CPAN-Metanalyzer) GitHub repo, edit
`meta-gen.pl` to point to your own repo, and have a look at the messy results.

I'll probably write more about some of the fun of implementing this in the next
week or so.  Until then, have fun!

