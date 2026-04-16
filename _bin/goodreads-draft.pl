#!/usr/bin/env perl
use v5.20;
use warnings;
use utf8;

use Encode qw(encode_utf8);
use Getopt::Long::Descriptive;
use HTTP::Tiny;
use POSIX qw(strftime);
use XML::LibXML;

my %MONTH = do {
  my $i = 1;
  map { $_ => sprintf('%02d', $i++) }
    qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
};

my ($opt, $usage) = describe_options(
  '%c %o',
  [ 'user|u=s', 'Goodreads numeric user id', { required => 1 } ],
  [ 'key|k=s',  'Goodreads RSS key (needed if your shelf is not public)' ],
  [ 'shelf=s',  'shelf to pull from', { default => 'read' } ],
  [ 'from|f=s', 'first read date, YYYY-MM-DD (inclusive)',
    { required => 1 } ],
  [ 'to|t=s',   'last read date, YYYY-MM-DD (inclusive)',
    { required => 1 } ],
  [ 'output|o=s', 'where to write the draft (default: _posts/YYYY-MM-DD-slug.md)' ],
  [ 'title=s',  'post title', { default => 'the books I read' } ],
  [ 'tag=s@',   'tag for the post (repeatable)', { default => ['books'] } ],
  [ 'group-by-shelf', 'group entries under ## headings by user shelf' ],
  [ 'max-pages=i', 'how many RSS pages to walk (20 items each)',
    { default => 20 } ],
  [ 'force',    'overwrite the output file if it exists' ],
  [],
  [ 'help|h', 'show this help and exit', { shortcircuit => 1 } ],
);

if ($opt->help) { print $usage->text; exit 0; }

my $from_ymd = check_ymd($opt->from);
my $to_ymd   = check_ymd($opt->to);
die "--from must not be after --to\n" if $from_ymd gt $to_ymd;

my $http = HTTP::Tiny->new(
  agent   => 'rjbs-goodreads-draft/0.1 ',
  timeout => 30,
);

my @entries;
my %seen_book;
PAGE: for my $page (1 .. $opt->max_pages) {
  my $url = rss_url($opt->user, $opt->shelf, $opt->key, $page);

  my $res = $http->get($url);
  die "fetching $url failed: $res->{status} $res->{reason}\n"
    unless $res->{success};

  my $doc = XML::LibXML->load_xml(string => $res->{content});
  my @items = $doc->findnodes('//item');
  last PAGE unless @items;

  for my $item (@items) {
    my $read_ymd = rfc822_to_ymd($item->findvalue('./user_read_at'));

    # Without user_read_at we cannot place the book in a date range.
    next unless defined $read_ymd;
    next if $read_ymd lt $from_ymd;
    next if $read_ymd gt $to_ymd;

    my $book_id = $item->findvalue('./book_id');
    next if $book_id && $seen_book{$book_id}++;

    my $title  = trim($item->findvalue('./title'));
    my $author = trim($item->findvalue('./author_name'));
    my @shelves = grep { length && $_ ne $opt->shelf }
                  map { trim($_) }
                  split /,/, $item->findvalue('./user_shelves');

    my $link = $book_id
             ? "https://www.goodreads.com/book/show/$book_id"
             : trim($item->findvalue('./link'));

    push @entries, {
      read_at => $read_ymd,
      title   => $title,
      author  => $author,
      link    => $link,
      shelves => \@shelves,
    };
  }
}

die "no entries for user " . $opt->user
  . " between $from_ymd and $to_ymd on shelf " . $opt->shelf . "\n"
  unless @entries;

@entries = sort {
     $a->{read_at} cmp $b->{read_at}
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

if ($opt->group_by_shelf) {
  my %by_shelf;
  for my $entry (@entries) {
    my @keys = @{ $entry->{shelves} } ? @{ $entry->{shelves} } : ('other');
    push @{ $by_shelf{$_} }, $entry for @keys;
  }
  for my $shelf (sort keys %by_shelf) {
    push @body, "## " . pretty_shelf($shelf) . "\n\n";
    push @body, entry_block($_) for @{ $by_shelf{$shelf} };
  }
} else {
  push @body, entry_block($_) for @entries;
}

open my $fh, '>:raw', $output or die "can't write $output: $!\n";
print $fh encode_utf8(join('', @body));
close $fh or die "can't close $output: $!\n";

printf "wrote %d entries to %s\n", scalar(@entries), $output;

sub entry_block {
  my ($entry) = @_;
  my $by = length $entry->{author} ? " by $entry->{author}" : '';
  return sprintf(
    "### [%s](%s)%s\n\nTODO: write about this one.\n\n",
    $entry->{title},
    $entry->{link},
    $by,
  );
}

sub rss_url {
  my ($user, $shelf, $key, $page) = @_;
  my $url = "https://www.goodreads.com/review/list_rss/" . uri_escape($user);
  my @qs = ('shelf=' . uri_escape($shelf), 'page=' . $page);
  push @qs, 'key=' . uri_escape($key) if defined $key && length $key;
  return $url . '?' . join('&', @qs);
}

sub check_ymd {
  my ($s) = @_;
  die "date must look like YYYY-MM-DD, got: $s\n"
    unless $s =~ /\A(\d{4})-(\d{2})-(\d{2})\z/;
  return $s;
}

sub rfc822_to_ymd {
  my ($s) = @_;
  return undef unless defined $s && length $s;
  # e.g. "Tue, 12 Feb 2025 00:00:00 +0000" or "Tue, 12 Feb 2025 00:00:00 -0800"
  return undef unless $s =~ /(\d{1,2})\s+(\w{3})\s+(\d{4})/;
  my ($d, $mon, $y) = ($1, $2, $3);
  my $mm = $MONTH{$mon} or return undef;
  return sprintf('%04d-%s-%02d', $y, $mm, $d);
}

sub trim {
  my ($s) = @_;
  return '' unless defined $s;
  $s =~ s/\A\s+//;
  $s =~ s/\s+\z//;
  return $s;
}

sub uri_escape {
  my ($s) = @_;
  $s =~ s/([^A-Za-z0-9\-._~])/sprintf('%%%02X', ord $1)/ge;
  return $s;
}

sub pretty_shelf {
  my ($s) = @_;
  $s =~ tr/-_/  /;
  return $s;
}
