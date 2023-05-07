---
layout: post
title : "PTS 2023: the CPAN Meta Analyzer (5/5)"
date  : "2023-05-07T16:07:01Z"
tags  : ["perl", "programming"]
---

##  my stupid CPAN "meta analyzer" (again)

I looked at whether I'd blogged about my CPAN distribution analyzer before, and
I did.  I [wrote something eight years ago]({% post_url
2015-04-30-my-stupid-cpan-meta-analyzer %}) that began:

> Just about exactly five years ago, I wrote a goofy little program that walked
> through all of the CPAN and produced a CSV file telling me what was used to
> produce most dists.  That is: it looked at the `generated_by` field in the
> META files and categorized them.

So I guess it's thirteen years old now!  Wow.

As an aside: the first run, thirteen years ago, showed that about 2% of indexed
CPAN distributions used Dist::Zilla.  Five years later, it was 20%.  Today,
it's 28%.  With a few more, Dist::Zilla will top ExtUtils::MakeMaker.  I don't
know what I think about that, but there it is.

Anyway, what is this thing?

Right now, it's still not on the CPAN, although I should really get around to
making that happen.  It's [on GitHub](https://github.com/rjbs/CPAN-Analyzer/),
though, and you can clone and install it.  You can also see its output over the
last 13 years (sampled very infrequently) on my possibly-moving-somday [CPAN
data page](https://semiotic.systems/cpandata/).  The key bit is the program
`analyze-metacpan`.  When run, it finds your minicpan clone (as long as it's in
`~/minicpan` where I would put it) and fires up a CPAN::Visitor.  That walks
through the latest version of every distribution on the index.  It extracts
them, looks at the files in them, gathers data, and moves on.  As it goes, it
records one database row per distribution into an SQLite file.  Then, you can
write queries against that SQLite file, like the one that shows what's been
generating META files:

```
$ ./bin/top-meta-generators -f ./dist-2023-04-30.sqlite --min 300
There are 11228 dists by 1135 unique cpan ids using Dist::Zilla.

generator           | dists | authors | %
ExtUtils::MakeMaker | 12900 | 3431    | 33.02%
Dist::Zilla         | 11228 | 1135    | 28.74%
                    |  4666 | 2255    | 11.94%
Module::Build       |  4334 | 1007    | 11.09%
Module::Install     |  3367 |  623    | 8.62%
Minilla             |  1285 |  311    | 3.29%
__OTHER__           |   823 |   98    | 2.11%
Dist::Milla         |   470 |   99    | 1.20%
```

Here's what the SQLite file looks like:

```sql
CREATE TABLE dists (
  distfile PRIMARY KEY,
  dist,
  dist_version,
  cpanid,
  mtime INTEGER,
  mdatetime,
  is_tarbomb INTEGER,
  file_count INTEGER,
  has_meta_yml INTEGER,
  has_meta_json INTEGER,
  meta_spec,
  meta_dist_version,
  meta_generator,
  meta_gen_package,
  meta_gen_version,
  meta_gen_perl,
  meta_license,
  meta_yml_error,
  meta_yml_backend,
  meta_json_error,
  meta_json_backend,
  meta_struct_error,
  meta_provides_defined,
  has_makefile_pl INTEGER,
  has_build_pl INTEGER,
  has_dist_ini INTEGER
);

CREATE TABLE dist_prereqs (
  dist,
  phase,
  type,
  module,
  requirements,
  module_dist
);

CREATE INDEX dist_prereqs_by_dist on dist_prereqs (dist, phase, type);

CREATE INDEX dist_prereqs_by_target on dist_prereqs (
  module_dist,
  phase,
  type
);
```

I use this for lots of little queries.  For example, does *anybody* use the
`provides` entry in META.json to tell PAUSE exactly how to index the dist?

```
sqlite> SELECT meta_provides_defined, COUNT(*) FROM dists GROUP BY 1;

meta_provides_defined  count(*)
---------------------  --------
0                      29170
1                      9903
```

Yes!  Wow, over a quarter of distributions have contents in their META provides
field.  What's *making* those?

```
sqlite> SELECT meta_gen_package, COUNT(*)
        FROM dists
        WHERE meta_provides_defined='1'
        GROUP BY 1;

meta_gen_package               count(*)
-----------------------------  --------
⦰                              253
App::ModuleBuildTiny           75
Dist::Banshee                  1
Dist::Iller                    47
Dist::Inkt::Profile::KJETILK   10
Dist::Inkt::Profile::Simple    2
Dist::Inkt::Profile::TOBYINK   217
Dist::Milla                    73
Dist::Zilla                    3454
Dist::Zilla::Plugin::MetaJSON  1
ExtUtils::MakeMaker            350
Minilla                        1190
Module::Build                  4143
Module::Build::Bundle          1
Module::Install                85
docmaker                       1
```

MakeMaker!  Module::Build!  What's actually making these?  This query got me a
list of dists to investigate:

```sql
SELECT dist
FROM dists
WHERE meta_gen_package = 'ExtUtils::MakeMaker'
  AND meta_provides_defined='1'
ORDER BY dist
```

Looking at the SQL schema above, you might have noticed it also tracks prereqs.
This is really useful!  For example, I wrote a program once to answer this
question:

> Which of my distributions declare a v5.8 prereq (or none), but depend on
> libraries that require something newer?

In those cases, I might feel more eager to bump the minimum version of my
distribution.  Let's say Karen Etheridge is about to do a hunk of code review
and wonders which code she could convert to postfix deferencing while at it.

```
$ ./bin/already-needs \
    ./dist-2023-04-30.sqlite \  # Where's our SQLite db?
    --minimum-target 5.20.0 \   # If we can't bump to v5.20 or better, skip it
    --cpanid ETHER              # We're only considering one author

D-Z-App-Command-weaverconf      (  v5.6.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
D-Z-P-AuthorityFromModule       (  v5.8.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
[ 50 D-Z plugins elided for this blog post!)
D-Z-PB-Author-ETHER             ( v5.13.2) -> ( v5.20.0) via App-Cmd Dist-Zilla Dist-Zilla-Plugin-CheckPrereqsIndexed plus 4 more
D-Z-PB-FLORA                    (  v5.6.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Dist-Zilla-Plugin-PodWeaver plus 3 more
D-Z-PB-Git-VersionManager       ( v5.10.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
D-Z-R-FileWatcher               (  v5.6.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
D-Z-R-ModuleMetadata            ( v5.10.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
D-Z-R-RepoFileInjector          (  v5.6.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
JSON-Schema-Draft201909         ( v5.16.0) -> ( v5.20.0) via JSON-Schema-Modern Test-JSON-Schema-Acceptance
MooseX-App-Cmd                  (  v5.8.5) -> ( v5.20.0) via App-Cmd
Pod-Weaver-Plugin-Encoding      (  v5.6.0) -> ( v5.20.0) via Log-Dispatchouli Pod-Weaver
Pod-Weaver-PluginBundle-FLORA   (       ~) -> ( v5.20.0) via Log-Dispatchouli Pod-Weaver
Task-Kensho-Email               (  v5.6.0) -> ( v5.20.0) via Email-MIME-Kit
Task-Kensho-ModuleDev           (  v5.6.0) -> ( v5.20.0) via App-Cmd Dist-Zilla Log-Dispatchouli
Task-Kensho-Toolchain           (  v5.6.0) -> ( v5.20.0) via App-Cmd
```

The actual output is colorized for skimming.

There are tools for computing river scores and related data:

```
$ ./bin/river-scores dist-2023-04-30.sqlite \
    --format score --format minperl --format dist \ # what columns?
    --min-score 3 \                                 # stop where in the river?
    | head

score minperl  dist
5     5.006    ExtUtils-MakeMaker
5     5.006002 Test-Simple
5     ~        PathTools
4     5.006    Scalar-List-Utils
4     ~        Carp
4     5.006    File-Temp
4     ~        Exporter
4     ~        Data-Dumper
4     ~        Encode
```

## Wait, what does this have to do with the PTS in Lyon?

Hey, great question.

The short version is:  I added a few fields, like the "does it use meta
provides" and "is the archive a tarball?".  I also added a YYYY-MM-DD style
date field, where previously there had only been epoch seconds.  They're both
there now, because the epoch seconds is much easier to use in SQL queries.

I used these to help inform some conversations in deciding PAUSE policies.  How
often does such and thing get used?  If never, it's easier to say we'll drop it
from the code.  I use this code myself when thinking about what I might do when
updating my own code.

I update this program once in a while, or just regenerate the analysis with
today's CPAN.
