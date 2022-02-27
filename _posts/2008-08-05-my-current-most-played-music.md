---
layout: post
title : "my current most played music"
date  : "2008-08-05T14:20:30Z"
tags  : ["itunes", "music", "perl", "programming"]
---
Bryan posted [his most played
tracks](http://mirrorshades.org/overflow/2008/08/itunes_top_25_most_played.shtml)
to his blog.  I used to publish a daily log of what tracks I'd played in
iTunes, but its records bugged me and I gave up on it.  Still, it seemed like
very slightly entertaining information to share.  For example, Bryan listened
to The District Sleeps Alone about three times as often as the next contender.
Either he needs to obsess less or use smart playlists more!

See?  Now if I share this data, you will be able to give me a hard time.  So,
here it is:

    name                      artist               album           count last      
    Sleeping In               The Postal Service   Give Up         32    2008-06-25
    Golden Slumbers           The Beatles          Abbey Road      31    2008-06-29
    The District Sleeps Al... The Postal Service   Give Up         31    2008-01-09
    We Will Become Silhoue... The Postal Service   Give Up         26    2008-06-25
    The Choice Is Yours (R... Black Sheep          A Wolf In Sh... 25    2007-10-04
    Land Of Sunshine          Faith No More        Angel Dust      25    2008-06-06
    Under African Skies       Paul Simon           Graceland       25    2008-05-13
    Such Great Heights        The Postal Service   Give Up         25    2008-06-11
    Definition                Black Star           Black Star      24    2008-02-19
    The Deportees Club        Christy Moore        Bespoke Song... 24    2008-04-22
    London Calling            The Clash            London Calling  24    2008-05-21
    Vibrate                   Mr. Scruff           Trouser Jazz    24    2008-05-29
    Downtown Train            Tom Waits            Rain Dogs       24    2008-06-25
    Look At That Old Grizz... Unknown              Royal Tenenb... 24    2008-05-22
    (I Can't Get No) Satis... Devo                 Now It Can B... 23    2008-05-09
    See                       The Kleptones        A Night at t... 23    2008-05-21
    Ms. Jackson               Outkast              Stankonia       23    2008-05-21
    We Luv Deez Hoez          Outkast              Stankonia       23    2008-01-24
    I Know What I Know        Paul Simon           Graceland       23    2008-06-06
    We Will Rock You          Queen                ?               23    2007-11-28
    Lucky                     Radiohead            OK Computer     23    2008-06-06
    Fingertips (Reprise)      They Might Be Giants Apollo 18       23    2008-05-14
    Alice                     Tom Waits            Alice           23    2008-06-10
    I'm Still Here            Tom Waits            Alice           23    2008-06-10
    Dirt in the Ground        Tom Waits            Bone Machine    23    2008-06-06

Rather than just post a screenshot, though, I did the easy to reproduce thing
and wrote a program to generate a nice dump.  Later, I may incorporate this
into my `blog` script to post it for me when it's changed enough to be
interesting.  Or not.


    use strict;
    use warnings;
    use Date::Format;
    use Mac::Glue qw(:glue);
    use String::Truncate qw(elide);
    use Text::Table;

    my $itunes = Mac::Glue->new('iTunes');

    my $pl = $itunes->obj(playlist => whose(name => equals => 'Most Played'))->get;
    my @tracks = $pl->obj('tracks')->get;

    my @cols   = qw(name artist album played_count played_date);
    my @labels = qw(name artist album count last);
    my $tt = Text::Table->new(@labels);

    for my $track (@tracks) {
      my @data = map { $track->prop($_)->get } @cols;
      $data[0] = elide($data[0], 25);
      $data[2] = elide($data[2] || '?', 15);
      my @lt = localtime $data[-1];
      $data[-1] = strftime('%Y-%m-%d', @lt);
      $tt->add(@data);
    }

    print $tt;

