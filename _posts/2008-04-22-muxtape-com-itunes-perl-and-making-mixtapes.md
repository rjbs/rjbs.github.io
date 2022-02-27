---
layout: post
title : muxtape.com, itunes, perl, and making mixtapes
date  : 2008-04-22T04:11:57Z
tags  : ["music", "perl", "programming"]
---
[muxtape.com](http://muxtape.com/) is a site where you can build mix tapes by
uploading mp3 files.  You can find other people's uploads and listen to them.
It's the flea market tape swape of 2008.  I like it.

A lot of people seem to be using it (I think) like a very, very high-latency
radio station.  Once in a while they upload a new song, bumping an old one.
That's cool, but it's hardly a mix tape.  I'd rather put together a collection
of songs that play well together, then replace my whole tape with those.

The uploading interface requires that I delete and upload tracks one at a time.
It also wants them in reverse order, since new tracks get the first position in
the tape.  Blech!

What I really want is to build a mix in iTunes, where I can drag things around,
preview, and re-think selections.  Then, I want to upload that whole playlist
at once.  I wrote a program to do that.  Its source is listed below.  The
muxtape.com API isn't published or clearly-defined, so who knows how long this
will work.

[My new muxtape](http://rjbs.muxtape.com), the first I uploaded with `mux-up`,
is now online.

    use strict;
    use warnings;

    use WWW::Mechanize;
    use Mac::Glue qw(:glue);

    my $title = $ARGV[0];

    my $iTunes = Mac::Glue->new('iTunes');

    my $playlist = $iTunes->obj(
      playlist => whose(name => equals => $title)
    );

    my @tracks = @{ $playlist->obj('tracks')->get || [] };
    die "couldn't find tracks in playlist <$title>" unless @tracks;

    die "too many tracks" if @tracks > 12;

    for (@tracks) {
      die "track too large" if $_->prop('size')->get > 10_000_000;
    }

    my $mech = WWW::Mechanize->new;

    $mech->get('http://muxtape.com/login');

    $mech->submit_form(
      with_fields => {
        name => 'USERNAME',
        pass => 'PASSWORD',
      },
    );

    $mech->get('http://muxtape.com/organize');

    my @ids = $mech->content =~ m{li id="(song[0-9a-f]{32})"}g;

    for my $id (@ids) {
      $id =~ s/^song//;
      print "deleting $id\n";

      $mech->post(
        'http://muxtape.com/organize/ajax',
        Content => "command=delete&args=$id",
      );
    }

    for my $track (reverse @tracks) {
      $mech->get('http://muxtape.com/upload');
      my $path = $track->prop('location')->get;
      print "uploading $path\n";
      $mech->submit_form(with_fields => { file => $path });
    }

    my @month = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    my @lt    = localtime;
    my $date  = "$month[ $lt[4] ] $lt[3]";

    $title =~ s/.+: //;
    $mech->post(
      'http://muxtape.com/settings/ajax',
      Content => qq{command=bannercaption&args="none"&banner=$date: $title},
    );

    print $mech->content;

