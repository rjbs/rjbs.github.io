#!/usr/bin/env perl
use v5.20;
use warnings;
use utf8;

use Encode qw(encode_utf8);
use Getopt::Long::Descriptive;
use HTTP::Tiny;
use POSIX qw(strftime);
use Time::Local qw(timegm);
use XML::LibXML;

my ($opt, $usage) = describe_options(
  '%c %o',
  [ 'user|u=s',  'Letterboxd username', { required => 1 } ],
  [ 'from|f=s',  'first watched date, YYYY-MM-DD (inclusive)',
    { required => 1 } ],
  [ 'to|t=s',    'last watched date, YYYY-MM-DD (inclusive)',
    { required => 1 } ],
  [ 'output|o=s', 'where to write the draft (default: _posts/YYYY-MM-DD-slug.md)' ],
  [ 'title=s',   'post title', { default => 'Horror Movie Month' } ],
  [ 'tag=s@',    'tag for the post (repeatable)',
    { default => ['horror-movie-month', 'movies'] } ],
  [ 'force',     'overwrite the output file if it exists' ],
  [],
  [ 'help|h', 'show this help and exit', { shortcircuit => 1 } ],
);

if ($opt->help) { print $usage->text; exit 0; }

my $from_ymd = check_ymd($opt->from);
my $to_ymd   = check_ymd($opt->to);
die "--from must not be after --to\n" if $from_ymd gt $to_ymd;

my $username = $opt->user;
my $rss_url  = "https://letterboxd.com/$username/rss/";

my $http = HTTP::Tiny->new(
  agent   => 'rjbs-letterboxd-draft/0.1 ',
  timeout => 30,
);

my $res = $http->get($rss_url);
die "fetching $rss_url failed: $res->{status} $res->{reason}\n"
  unless $res->{success};

my $doc = XML::LibXML->load_xml(string => $res->{content});

my $xpc = XML::LibXML::XPathContext->new($doc);
$xpc->registerNs('letterboxd', 'https://letterboxd.com');
$xpc->registerNs('dc',         'http://purl.org/dc/elements/1.1/');
$xpc->registerNs('tmdb',       'https://themoviedb.org');

my @entries;
for my $item ($xpc->findnodes('//item')) {
  my $watched = $xpc->findvalue('./letterboxd:watchedDate', $item);
  next unless length $watched;
  next if $watched lt $from_ymd;
  next if $watched gt $to_ymd;

  my $title = $xpc->findvalue('./letterboxd:filmTitle', $item);
  my $year  = $xpc->findvalue('./letterboxd:filmYear',  $item);
  my $link  = $xpc->findvalue('./link', $item);

  my $film_url = film_url_from_entry_link($link);

  push @entries, {
    watched => $watched,
    title   => $title,
    year    => $year,
    link    => $film_url,
  };
}

die "no diary entries for $username between $from_ymd and $to_ymd\n"
  unless @entries;

@entries = sort {
     $a->{watched} cmp $b->{watched}
  || $a->{title}   cmp $b->{title}
} @entries;

my $today = strftime('%Y-%m-%d', gmtime);
my $now   = strftime('%Y-%m-%dT%H:%M:%SZ', gmtime);

my $output = $opt->output // do {
  my $slug = lc $opt->title;
  $slug =~ s/[^a-z0-9]+/-/g;
  $slug =~ s/^-+|-+$//g;
  "_posts/$today-$slug.md";
};

die "$output already exists; pass --force to overwrite\n"
  if -e $output && ! $opt->force;

my $tags = join(',', map { qq{"$_"} } @{ $opt->tag });

my @body;
push @body, <<"HEADER";
---
layout: post
title : "@{[ $opt->title ]}"
date  : "$now"
tags  : [$tags]
---

HEADER

for my $entry (@entries) {
  my $day_label = day_label($entry->{watched});
  my $link      = $entry->{link}
               // "https://letterboxd.com/search/films/"
                  . uri_escapeish("$entry->{title} $entry->{year}") . "/";

  push @body, sprintf(
    "### %s: [%s (%s)](%s)\n\nTODO: write about this one.\n\n",
    $day_label,
    $entry->{title},
    $entry->{year},
    $link,
  );
}

open my $fh, '>:raw', $output or die "can't write $output: $!\n";
print $fh encode_utf8(join('', @body));
close $fh or die "can't close $output: $!\n";

printf "wrote %d entries to %s\n", scalar(@entries), $output;

sub check_ymd {
  my ($s) = @_;
  die "date must look like YYYY-MM-DD, got: $s\n"
    unless $s =~ /\A(\d{4})-(\d{2})-(\d{2})\z/;
  return $s;
}

sub film_url_from_entry_link {
  my ($link) = @_;
  return undef unless defined $link && length $link;

  # A diary entry link looks like
  #   https://letterboxd.com/<user>/film/<slug>/
  # or, for repeat viewings
  #   https://letterboxd.com/<user>/film/<slug>/<n>/
  if ($link =~ m{\Ahttps?://letterboxd\.com/[^/]+/film/([^/]+)/}) {
    return "https://letterboxd.com/film/$1/";
  }
  return $link;
}

sub day_label {
  my ($ymd) = @_;
  my ($y, $m, $d) = split /-/, $ymd;
  my $epoch = timegm(0, 0, 12, $d, $m - 1, $y - 1900);
  my $month = strftime('%B', gmtime $epoch);
  return sprintf('%s %d', $month, $d + 0);
}

sub uri_escapeish {
  my ($s) = @_;
  $s =~ s/([^A-Za-z0-9\-._~])/sprintf('%%%02X', ord $1)/ge;
  return $s;
}
