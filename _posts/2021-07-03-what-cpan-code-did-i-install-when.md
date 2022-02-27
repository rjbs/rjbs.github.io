---
layout: post
title : "what CPAN code did I install when?"
date  : "2021-07-03T17:56:11Z"
tags  : ["perl", "programming"]
---
When I upgrade my perl, which I do pretty often, the first thing I do is
install [Task::BeLike::RJBS](https://metacpan.org/pod/Task::BeLike::RJBS) (by
running `cpanm rjbs`).  This installs most of the stuff I'm going to need to do
my normal work.  Over time, I tend to find that it needs an update, because
over the course of the last year or so I started using some new libraries that
didn't get into the bundle.  (This will happen less now that I'm using the
monthly blead snapshots day to day again, but it's a real thing.)

I don't use plenv's "install everything I had before onto the new one," because
I want to keep track of what I install every time.  That means that for the
first few days after installing a new perl, I end up having to install some
library that's not there when I go to run some program that I run now and then.
When that happens, I don't want to pull up a notepad and write down what's
missing from my bundle.  Instead, I wrote a little program to look at my
installation history and show me clusters of installed libraries.  After a week
or two, I look at the output from this program and consider updating my bundle
accordingly.

Here it is:

```perl
#!perl
use v5.34.0;
use warnings;

use File::stat;
use Term::ANSIColor;

my @perl_inc = `perl -E 'say for grep { m{/.plenv/versions/} } \@INC'`;
chomp @perl_inc;

my @lines = `find @perl_inc -name MYMETA.json`;
chomp @lines;

my %mtime;

for my $line (@lines) {
  my ($dist) = $line =~ m{/([^/]+)/MYMETA.json\z};
  my $mtime  = stat($line)->mtime;
  $mtime{$dist} = $mtime;
}

my $prev = 0;
for my $dist (sort { $mtime{$a} <=> $mtime{$b} } keys %mtime) {
  my $mtime = $mtime{$dist};
  if ($mtime - $prev > 3600) {
    print "\n";
    printf "%s %s %s\n",
      colored(['bright_cyan'], '==['),
      colored(['bright_yellow'], scalar localtime $mtime),
      colored(['bright_cyan'], ']==');
  }
  $prev = $mtime;
  say "$dist";
}
```
