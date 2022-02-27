---
layout: post
title : "more cpan metrics"
date  : "2008-11-04T15:47:51Z"
tags  : ["cpan", "perl", "programming"]
---
For a while, I've been keeping track of the total usage of my code on the CPAN.
It helps me see what people have found useful, and lets me decide how scared to
be of introducing back-incompat changes.  Sometimes people talk about the sort
of catastrophe that can occur if a highly-required module is broken.  For
example, over 11,000 dists require the code in Getopt-Long.  If it broke badly
and people installed the new code, it would be a nightmare.

So, I applied my "who needs me?" script to the whole CPAN.  It produces a list
of every author with dists, showing how many other dists (recursively) use
that dist.  When an author uses his own dist, it is not counted as a
prerequisite.  The "total cpan-breaking power" score is more accurate that way.

This scoreboard is quite different to [Simon Wistow's CPAN
Leaderboard](http://www.thegestalt.org/simon/perl/wholecpan.html).  Here's a
comparison:

    author   | volume | requiredness
    ZOFFIX   | 1      | 145
    ADAMK    | 2      | 32
    RJBS     | 3      | 43
    MIYAGAWA | 4      | 82
    NUFFIN   | 5      | 85
    GBARR    | 114    | 1
    PMQS     | 221    | 2
    PETDANCE | 31     | 3
    MSCHWERN | 40     | 4
    SAPER    | 32     | 5

**[Edit:** I've had to clarify this to a few people, so here is a bit of explanation. The above numbers are ranks of the analyzed data. In other words, GBARR is 114th most prolific (well, he is tied in the 114th rank) but is the author with the most relied-upon code. They are not scores. Each dist is counted, so if you uploaded 100,000 dists, none of which were required by anything, your requiredness rank would still become 1. This may change.**]**

The program is included below.  It's a quick and dirty hack, but it was fun to
write and look at.

    #!/usr/bin/perl
    use strict;
    use warnings;
    use 5.010;
    use DBI;
    use JSON::XS;

    my $dbh = DBI->connect('dbi:SQLite:dbname=cpants_all.db', undef, undef);

    my $authors = $dbh->selectall_arrayref(
      "SELECT id, pauseid
      FROM author
      WHERE pauseid IS NOT NULL
      ORDER BY pauseid"
    );

    my @results;

    for my $author (@$authors) {
      my ($author_id, $pauseid) = @$author;

      my $dists = $dbh->selectall_arrayref(
        "SELECT id, dist FROM dist WHERE author = ? ORDER BY dist",
        undef,
        $author_id,
      );

      my %analysis;

      analyze_dist(\%analysis, $author_id, $_) for @$dists;

      my $sum = 0;
      $sum += $_ for values %analysis;

      next unless $sum;

      warn "$pauseid,$sum\n";
      push @results, {
        pauseid => $pauseid,
        result  => $sum,
        dists   => \%analysis,
      };
    }

    my $JSON = JSON::XS->new;
    for my $author (sort { $b->{result} <=> $a->{result} } @results) {
      say $JSON->encode($author);
    }

    sub analyze_dist {
      my ($analysis, $author_id, $dist, $seen, $add_to) = @_;
      $seen ||= {};
      $add_to ||= $dist->[1];

      my @queue = $dist;

      $analysis->{ $add_to }++;

      my $needed_by = $dbh->selectall_arrayref(
        "SELECT p.dist, d.dist AS name
        FROM prereq p
        JOIN dist d ON d.id = p.dist
        WHERE p.in_dist = ?
        AND author <> ?",
        undef,
        $dist->[0],
        $author_id
      );

      for my $needed (@$needed_by) {
        next if $seen->{ $needed->[1] };
        $seen->{ $dist->[1] }++;
        analyze_dist($analysis, $author_id, $needed, $seen, $add_to);
      }
    }

You can find the [results of the
results](http://dl.getdropbox.com/u/88746/cpan-prereqs.json.txt) as of last night in my drop box.

