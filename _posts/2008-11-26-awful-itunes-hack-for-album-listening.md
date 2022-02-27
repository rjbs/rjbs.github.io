---
layout: post
title : awful itunes hack for album listening
date  : 2008-11-26T18:00:58Z
tags  : ["itunes", "perl", "programming"]
---
It's bugged me that iTunes makes it hard to listen to things as albums.  Sure,
it has shuffle-by-album, but smart playlists are all per-track.

After years of meaning to, this morning I wrote a (very very slow) Mac::Glue
script to build a playlist of unrated or highly-rated albums that I haven't
listened to lately.  When I was nearly done and looked into one little bug, I
found some other similar scripts.  Oh well!

I'll eventually update this to avoid having it pick all albums by one artist,
but for now, it's good.  Thanks to it, I am re-listening to Method Man's Tical.

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Mac::Glue qw(:glue);
    use List::Util qw(sum);

    my $itunes = Mac::Glue->new('iTunes');

    my $pl = $itunes->obj(
      playlist => whose(name => equals => 'Regular Music')
    )->get;

    my $albumen = $itunes->obj(
      playlist => whose(name => equals => 'Albumen')
    )->get;

    die "no albumen" unless $albumen;

    {
      my $tracks = $itunes->obj(
        'track' => gAll,
        playlist => $albumen->prop('index')->get,
      );

      for my $t ( $tracks->get ){
        $t->delete;
      }
    }

    print "getting tracks\n";
    my @tracks = $pl->obj('tracks')->get;

    my %album;

    while (my $track = shift @tracks) {
      my $trackid = $track->prop('database ID')->get;
      my $album   = $track->prop('album')->get;
      my $artist  = $track->prop('compilation')->get
                  ? '-'
                  : $track->prop('artist')->get;

      next unless defined $album and defined $artist;
      next unless length  $album and length  $artist;

      my $rec = $album{ $album, $artist } ||= [];

      printf "storing record of $trackid ($album/$artist); %s remain\n",
        scalar @tracks;

      push @$rec, {
        id     => $trackid,
        rating => scalar $track->prop('rating')->get,
        played => scalar $track->prop('played date')->get, # epoch sec
        size   => scalar $track->prop('size')->get, # in bytes
      };
    }

    my $DEFAULT_TIME = time - 30 * 86_400;
    my %avg_age;

    ALBUM: for my $key (keys %album) {
      my ($album, $artist) = split $;, $key;
      printf "considering (%s/%s)\n", $album, $artist;

      my @tracks = @{ $album{ $key } };

      unless (@tracks > 4) {
        printf "skipping (%s/%s); too few tracks\n", $album, $artist;
        delete $album{$key};
        next ALBUM;
      }

      my @lp_dates = map { undef $_ if $_ eq 'msng'; $_ || $DEFAULT_TIME }
                     map { $_->{played} }
                     @tracks;

      my $avg_age  = time - (sum(@lp_dates) / @lp_dates);
      $avg_age{ $key } = $avg_age;

      if ($avg_age < 86_400 * 30) {
        printf "skipping (%s/%s); too recent\n", $album, $artist;
        delete $album{$key};
        next ALBUM;
      }

      my @ratings    = grep { $_ > 0 } map { $_->{rating} } @tracks;
      my $avg_rating = sum(@ratings) / @ratings if @ratings;

      if ($avg_rating and $avg_rating < 60) {
        printf "skipping (%s/%s); too lousy\n", $album, $artist;
        delete $album{$key};
        next ALBUM;
      }

      printf "keeping (%s/%s) @ %s\n", $album, $artist, $avg_rating || '(n/a)';
    }

    my $total_size = 0;
    ADDITION: for my $key (sort { $avg_age{$b} <=> $avg_age{$a} } keys %album) {
      my @tracks = @{ $album{ $key } };

      for my $track (@tracks) {
        $total_size += $track->{size};

        my $t = $itunes->obj(
          track => whose('database id' => equals => $track->{id})
        )->get;
        
        $itunes->duplicate($t, to => $albumen);
      }

      last ADDITION if $total_size > 500_000_000;
    }

