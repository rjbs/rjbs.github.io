---
layout: post
title : "print-ing to UDP sockets: not so good"
date  : "2013-06-28T00:21:16Z"
tags  : ["network", "perl", "programming"]
---
We've been rolling out more and more metrics at work using Graphite and StatsD.
I am in heaven.  I'm not very good at doing data analysis, but fortunately
there are some very, very obvious things I can pick out from our current
visualizations, and I'm finding all kinds of things to improve based on these.

I'm using
[Net::Statsd::Client](https://metacpan.org/module/Net::Statsd::Client), as it
looked convenient.  Under the hood, for now, it uses
[Etsy::StatsD](https://metacpan.org/module/Etsy%3A%3AStatsD).  I found a
*very* confusing bug and when I told the author of Net::Statsd::Client, he
confirmed that he'd seen it.  I've worked out the details, and it has made me
grumpy!  The moral of this story will be:  don't use `print` to send to a UDP
socket.  (I doubt I'll `print` to a socket again, after this.)

As a rule, I was sending very simple measurements to StatsD.  They'd look like
this:

      pobox.host.mx-1.messages|1c

This means: increment the counter with the given name.

StatsD listens for UDP.  In theory, you can send a bunch of these in one
datagram, and they're separated by newlines.  In practice, though, I was
sending exactly one measurement per datagram.  Sometimes, though, the server
was receiving mangled data.  The metric names would be wrong, or the whole
string would be mangled.  I fired up a network sniffer and saw things like
this:

      ost.mx-1.messages|1c␤pobox.host.mx-1.messages|1c␤pobox.host.
      mx-1.messages|1c␤pobox.host.mx-1.messages|1c␤pobox.host.mx-1.
      messages|1c␤pobox.host.mx-1.messages|1c␤pobox.host.mx-1.
      messages|1c␤

Okay, it's a bunch of `+1` operations run together… but what's up with the
first one being truncated?  And, more importantly, what was sending them in one
datagram!?  A review of the StatsD libraries will show that they don't do any
buffering.  All that Etsy::StatsD does is open a UDP socket and print to it.
You can send multiple metrics at once, if you want, but you have to go out of
your way to do it, and I wasn't.

Further, sockets don't buffer their output in Perl!  When you connect to a
socket, it's set to auto-flush.  Why was there buffering happening?  Andrew
Rodland, author of Net::Statsd::Client said that it only happened while the
StatsD server was local and unavailable.  Immediately, things fell into place.

If you're running Linux, you can try this fun experiment.  First, run this
server:

    my $sock = IO::Socket::INET->new(
      Proto      => 'udp',
      LocalHost  => 0,
      LocalPort  => 3030,
      MultiHomed => 1,
    );

    while (1) {
      my $data;
      my $addr = $sock->recv($data, 1024);

      print "<<$data>>\n";
    }

Then, run this client:

      use IO::Socket::INET;
      use Time::HiRes qw(sleep);

      my $sock = IO::Socket::INET->new(
        Proto    => 'udp',
        PeerHost => 'localhost',
        PeerPort => 3030,
      );

      for (1 .. 20) {
        print $sock "1234567890";
        sleep 0.5;
      }

You'll see the server print out the datagrams it's receiving.  It all looks
good.

If you start the server after the client, though, or kill it and restart it
during the client's run, you'll see the server receive datagrams with the
number sequence more than once.  This is bad enough.  My belief, which I
haven't put hard to the test, is that when the buffer to send is full, data is
lost from the left.  Even if your data were capable of being safely
concatenated, it wouldn't be safe.

This is, at least in part, a product of the fact that Linux tries much harder
to deliver UDP datagrams to the local interface.  They are, to some extent,
guaranteed.  I'm not yet sure whether the behavior of `print` in Perl with such
a socket is a bug, or merely a horrible behavior emerging from the
circumstances around it.  Fortunately, no matter which, it's easy to avoid:
just replace `print` with `send`:

      send $sock, "0123456789", 0;

With Etsy::StatsD patched to do that, my problems have gone away.

