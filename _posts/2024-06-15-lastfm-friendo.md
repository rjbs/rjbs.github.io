---
layout: post
title : "listening to your friends' jams with last.fm"
date  : "2024-06-15T12:00:00Z"
tags  : ["music","perl","programming"]
---

Quite a while ago, I wrote some Spotify code that would find places when my
Discover Weekly playlist would intersect with those of my friends and
coworkers.  This was fun.  Every once in a while, I talked about other things
that might be fun, along those lines.  I tend not to do too much with those
ideas, because the Spotify API is often missing exactly the method I want, and
I can work around it, but it becomes too much of a pain.  Also, I'm a little
lazy when the project will need other people to be interested, unless I'm sure
they will be.  Who wants to launch a flop to their friends?

Anyway, yesterday I was talking to my friend [Joe](https://joewoods.dev/) and
he mentioned some recent [last.fm](https://last.fm/) crossovers.  See, Joe stil
uses last.fm, and seems to be one of the last people I know who does so.  But I
do so, too, so always interested in the stuff he says about it.  Us last.fm
users have to stick together.  If you don't know what last.fm is:  it tracks
the music you listen to and keeps records.  You can mine your own history, or
the history of most other users, and like… do stuff.  Clients to log plays are
built into a number of music apps, including Spotify, so why not turn it on
today, so I can look over shoulder while you listen?  You'll love it!

Apparently last.fm is now owned by CBS, who probably would be asking themselves
why they bought it, if they ever bothered to think about it at all.

One of the ideas that Joe and I talked about was:  What if you could get a
report of the music that your friends have been listening to, but that you've
never logged a play for.  I really liked this idea, because I like knowing what
my friends like, even when they like bad music.  The report was actually really
easy to write, although the last.fm API definitely felt like a trip back in
time to 2002.  It feels a lot like the Flickr API, and all the example code
uses "http" and not "https" in the URLs.  (Michael said "still, better than
OAuth!" but I'm not sure I agreed.)

I spent a bunch of time on weird little blind alleys.  For example, I showed
Joe a report and he said, "This is saying I've never heard *The Distance* by
Cake, but I definitely have."  The problem was that his listens and mine had
different `mbid` values.  That's the [MusicBrainz](https://musicbrainz.org/)
id, and you can click that link if you want to be further transported back in
time to the early aughts.  MusicBrainz, as I understand it, was created to help
deal with the proliferation of nonstandard ID3-tagging of peer-to-peer shared
music.  If a hunk of people said that "Stand" was by "REM" and another hunk
said "R.E.M.", they'd look like two songs.  The solution?  Give every song a
GUID-like identifier.

…except then Joe and I had the same song logging under two different
identifiers.  I'm not sure what happened, and I'm not sure I'm going to dig.  I
think if I found the answer, submitting a report would go nowhere, and I'd feel
worse than just saying "guess this doesn't work right".

In the end, my program is very simple.  I'll probably make it smarter and
cooler, but just in case I don't, I'm posting it now, as is.  I'll probably put
it on GitHub, and when I do, I'll add a link here.  Until then…

```perl
use v5.36.0;

use Digest::MD5 qw(md5_hex);
use Getopt::Long::Descriptive;
use IO::Async::Loop;
use JSON::XS;
use Net::Async::HTTP;
use Path::Tiny;
use URI;

my ($opt, $usage) = describe_options(
  '%c %o',
  [ 'target=s',   'find songs listened to by target' ],
  [ 'listener=s', 'find songs not yet played by listener' ],
);

# This should use Password::OnePassword::OPCLI but doesn't yet.
my $api_key = path('api-key.txt')->slurp;
my $secret  = path('secret.txt')->slurp;

my $loop = IO::Async::Loop->new;
my $http = Net::Async::HTTP->new;

$loop->add($http);

# decode a JSON payload from an HTTP::Response object
sub djr ($res) {
  decode_json($res->decoded_content(charset => undef));
}

sub uri ($param, $sign = 1) {
  state $base = "https://ws.audioscrobbler.com/2.0/";

  my $uri = URI->new($base);
  my $str = q{};

  for my $name (sort keys %$param) {
    $uri->query_param($name => $param->{$name});
    $str .= "$name$param->{$name}";
  }

  # Nothing in this program uses this, but while writing this program, I wrote
  # *other* last.fm-API-using code that did need signed URLs, so I left this
  # here.  It really belongs in rjbs::LastFM::Util or something…
  if ($sign) {
    $str .= $secret;
    my $sig = md5_hex($str);
    $uri->query_param(api_sig => $sig);
  }

  return $uri;
}

my @tracks;

# This loop is here because the next phase would get the top tracks for all my
# friends and produced a combined output.
for my $user ($opt->target) {
  my $top_tracks_res = $http->do_request(
    uri => uri({
      method  => 'user.getTopTracks',
      api_key => $api_key,
      format  => 'json',
      user    => $user,
      period  => '3month',
    }, 0)
  )->get;

  my $top_tracks = djr($top_tracks_res);

  my %got_artist;

  TRACK: for my $track ($top_tracks->{toptracks}{track}->@*) {
    unless ($track->{mbid}) {
      # say "$track->{name} ($track->{artist}{name}) @ $track->{playcount}";
      # say "^-- no mbid?!\n";
      next TRACK;
    }

    if ($got_artist{$track->{artist}{mbid}}) {
      # Already saw this artist.  I don't need a list of 69,105 Reznor
      # masterpieces.
      next TRACK;
    }

    my $seen = saw_track($track);

    unless ($seen) {
      $got_artist{$track->{artist}{mbid}}++;
      say "$track->{name} ($track->{artist}{name}) @ $track->{playcount}";
    }
  }
}

sub saw_track ($track, $debug = 0) {
  my $key = join q{--}, $track->{name}, $track->{artist}{name};

  state %know;
  return $know{$key} //= do {
    my $uri = uri({
      method    => 'track.getInfo',
      api_key   => $api_key,
      format    => 'json',
      username  => $opt->listener,

      # Originally, I used "mbid" instead of these two parameter, but it
      # wasn't reliable enough.
      track     => $track->{name},
      artist    => $track->{artist}{name},
    }, 0);

    my $trackinfo_res = $http->do_request(
      uri => $uri,
    )->get;

    my $info = djr($trackinfo_res);

    if ($debug) {
      print Dumper($info);
    }

    return 0 if $info->{error} && $info->{error} == 6;
    return 0 if $info->{track}{userplaycount} == 0;
    return 1 if $info->{track}{userplaycount} > 0;

    die "!?";
  };
}
```
