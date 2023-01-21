---
layout: post
title : "talking to Philips Hue lights, part 3: bonus post"
date  : "2023-01-21T17:54:00Z"
tags  : ["hardware", "programming"]
---

I made two recent posts about writing code to [connect
software](/blog/2023/01/talking-to-philips-hue-lights-1/) and [connect
hardware](/blog/2023/01/talking-to-philips-hue-lights-2/) to Philips Hue
lights.  I thought I was done, except maybe for something really
straightforward: making a tiny web service for the lights.  Here I am, though,
making a (quick) third post.

I *did* write that little web interface.  It's called Huell.  You can [get Huell
from GitHub](https://github.com/rjbs/Huell).  It's sort of a thrown-together
mess, but one with enough room for me to fiddle more in the future.  It's not
really the point of this post, but while I'm here, here's what it is.

There's a little client for the Hue API.  It provides a little abstraction over
the HTTP parts and some of the resource types.  A little bit of code that
applies preset lighting settings to a whole room looks like this:

```perl
my $agent  = Huell::Agent->from_config_file('hue.yaml');

my $preset = $agent->preset_named($ARGV[0]);

die "unknown setting\n" unless $preset;

my @rooms = await $agent->get_rooms;

my ($room) = grep {; $_->name eq $opt->room } @rooms;

die "Couldn't find requested room!\n" unless $room;

await $room->set_state($preset);
```

Then there's a *very* [half-baked little Plack
app](https://github.com/rjbs/Huell/blob/main/lib/Huell/WebService.pm) that
takes PUT requests and passes them on to the right bridge.  I wrote this so I
could make my Hammerspoon talk to the lights more easily.  I also wrote an even
*less* baked [client](https://github.com/rjbs/Huell/blob/main/bin/huell-client)
for that service, which is what Triggerhappy now runs so it can run faster.
(I'll make it use shell and curl later.)

While doing this, though, I learned some other things.

## the v1 API is going away

Actually, I already knew this, I just didn't care.  But while writing this
above, I went through a process like this:

* the v1 API call "get all groups" returns a JSON object where the values don't
  also contain the keys
* this annoys me because I want to grep through groups like all-inclusive
  objects, not key/value pairs
* I abstracted that into a Group object first
* then I decided maybe this was better in the v2 API that I saw mentioned
* I looked into it, and it was

Cool, so I converted everything to the v2 API.  It's better.  How much better?
Well, for my trivial purposes, very modestly.  Some things are just a little
easier to deal with, and rooms are better separated from groups and zones.
Mostly, though, I figured I'd just get it over with now, rather than wait until
some future date when it became a requirement.

Two bonus things I looked into while doing this:

1. There's a mechanism called Hue Entertainment that allows you to stream
   continuous updates to lights.  This is used for things like their "[make my
   room look like an extension of my
   TV](https://www.philips-hue.com/en-us/explore-hue/propositions/entertainment/sync-with-home-theater)"
   system.  Weird!  Maybe I'll try it sometime, although I dunno.  Might be a
   nice goof.
2. They support streaming updates to the client using [Server-Sent
   Events](https://en.wikipedia.org/wiki/Server-sent_events), so you can
   connect your service to the bridge and listen for any lighting changes.  I
   don't think I'll use this, but it would be a funny way to troll your
   roommate.  When they change the lights, your service changes them back.

## the whole UPnP thing I wrote up is being replaced

I had fun writing about the weirdness that was HTTPMU and SSDP, so I'm
satisfied.  But also, I don't need to know that stuff anymore, because the UPnP
SSDP discovery mechanism has been deprecated.  Philips says it "will be
disabled in Q2 2022", which clearly didn't happen, but I'd hate to be pointing
people *after* it's planned go-dead date!

The new mechanism is much less weird.  It's
[mDNS](https://en.wikipedia.org/wiki/Multicast_DNS)!  Multicast DNS is a little
weird, because DNS is a little weird, and because most of us don't spend a lot
of time doing multicast.  Still, it's not that weird.  I may write more about
it later, but the very siple version is:

```
$ dns-sd -B _hue._tcp
```

…will find your nearby Hue interfaces, giving you a name like `Philips Hue
1234`.

```
$ dns-sd -L 'Philips Hue 1234' _hue._tcp
```

…will give you the location of that service, like this:
`ecb5fa846158.local.:443`.  With that, you're back to using HTTPS.  That name
is likely to be constant "forever", so you only need to rediscover rarely,
unlike UPnP, where the DHCP service controlling your bridge's address could be
fickle (unless you tell it not to be).

There is also an alternate discovery mechanism.  Your Hue bridge is phoning
home somtimes.  (I am choosing to believe this is only to check for software
updates, and not to tell Philips about my lighting habits.)  When it does this,
Philips notes the IP it comes from.  Since you're almost certainly behind a
network address translation inside your house, any device in your house will
have the same public IP.  That means you can ask Philips "What bridges appear
to have the same public IP as me, and what is their private IP?"

If you have a Hue bridge in your house, try fetching from [the discovery
endpoint](https://discovery.meethue.com/) in your browser and you might see
what I mean.  This is very neat!  But also makes me look at the whole thing
with a serious side-eye.  I mean, once I'm on the same network, I can already
perform that mDNS discovery, right?  But still, I dunno.

## the end?

That might relaly be it.  I still do want to do more, like make these services
reinstallable.  I might look at their OAuth setup for shared services.  But for
now, I'm happy with what I've done.
