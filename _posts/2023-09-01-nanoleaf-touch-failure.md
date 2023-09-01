---
layout: post
title : "either the Nanoleaf touch API is broken, or I am"
date  : "2023-09-01T14:21:00Z"
tags  : ["hardware","programming"]
---

When I bought my Nanoleaf panels, which I wrote about in my [previous]({%
post_url 2023-08-24-nanoleaf-getting-started %}) [two]({% post_url
2023-08-25-nanoleaf-streaming-updates %}) posts, I didn't realize that they're
not just programmable lights.  They're also touch sensors.  *Or so they claim!*
The truth is, I haven't been able to use the touch interface reliably.  This
post will recount my efforts.

I should say up front:  I haven't really tried to use the default touch
programming.  That is: I haven't gone into the Nanoleaf iOS app to set events
onto touch events.  I know that isn't what I want to do long term, and I didn't
have any good ideas about how to use it for diagnostic purposes.  I do know
that the touch sensors seem to work to *some* extent, because when touched, the
panels brighten.

## server-sent events

Anyway, here's the deal:  There's an HTTP endpoint in the Nanoleaf Shapes API
that provides you [Server-sent
events](https://en.wikipedia.org/wiki/Server-sent_events) providing updates on
the device's status.  I don't like server-sent events.  It's fine, I know how
they work, and they're not terrible.  It's just that I don't like reading the
spec.  This is a *me* problem, not a server-sent events problem, but there it
is.  Anyway, your client needs to GET
`/api/v1/{your-auth-token}/events?id=1,2,3,4` and read chunks.  The `id`
parameter doesn't have to be exactly that.  It's a comma-separated list of
event types.  What are the event types?  Well, at first, it depends on which
part of the documentation you believe.

Section 3.5.1 says:
> For example if a client wished to register for the state (id=1), layout
> (id=2) and touch (id=3) events, it would sent the following request:

Section 3.5.2 gives a table with the following ids:
> * **State**: 1
> * **Layout**: 2
> * **Effects**: 3
> * **Touch**: 4

In the end, I don't think this is actually a contraction, just a terrible
choice.  Here's why…

Server-sent-events are sequences of key/value lines separated by blank lines.
So, you might get this:

```
id: 1
data: {"events":[{"attr":1,"value":false}]}

id: 3
data: {"events":[{"attr":1,"value":"Beatdrop"}]}
```

That's two events.  The `id` value is meant to let you synchronize with the
server.  When you connect, you're told the last event id, and then each
subsequent event tells you its id, and you can keep up to date with the event
stream.  In the Nanoleaf API, that's all thrown out the window.  The `id`
field, here, is actually *event type id*.  It tells you what kind of event is
described by the JSON in the data.  Why abuse the `id` field for this instead
of putting it in the JSON?  I don't know.

Anyway, it could make sense that the `id` query parameters were for one kind of
type and the event ids were a different id type.  It doesn't appear to be the
case, though.  If I want effect events, I subscribe with the `id` parameter set
to 3, not … well, they didn't give a value for effects in the parameter type
definition.  It seems to just be an error.  Now we know, and we'll trust §3.5.2
over §3.5.1.

Back to the events!  Being able to get notified when the layout, state, or
active effect changes sounds like it could be useful for some things, but I had
no need.  I wanted to know about touch events.  Why? I don't know, it just
sounded neat.

## server-sent touch events

A touch event, like every other event, is provided as JSON in the data
attribute of the server-sent event.   Here's an example:

```
id: 4
data: {"events":[{"panelId":-1,"gesture":5}]}

id: 4
data: {"events":[{"panelId":-1,"gesture":4}]}
```

The `gesture` key is another numeric id, with the following definitions:

* 0: single tap
* 1: double tap
* 2: swipe up
* 3: swipe down
* 4: swipe left
* 5: swipe right

When you get a tap, the `panelId` is the panel id of the tapped panel.  When
you get a swipe, the panel id is -1, because a swipe is defined as swiping
across two or more panels.

I have never seen the server-sent events provide a tap event.  Also, I find
their reporting of swipe events very unreliable.  They're reported with a large
delay, and often not reported at all.  I'd say the other event types have
delays also, but I find it less of a problem that there's a 700ms delay between
power off and power off event than that there's a 700ms delay between touching
the device and seeing the touch event.

This was not going to be useful.  Fortunately, there's a *touch stream*, where
you can get "fine resolution, low latency" touch data streamed to you.

## the touch stream

It works like this.  You still have to start up your event stream connection,
even though you won't be reacting to the events.  It's just a way to tie the
duration of the streaming to something else.  When you make the request,
though, provide the HTTP header `TouchEventsPort`.  This tells the Nanoleaf
controller where to stream the events.  It will send datagrams to the
requesting IP at that port, and it will send them in real time.  Sound great?
Well, in my experience, it isn't.

First, I had some frustration setting up the whole program, all of which was my
fault.  I have a weird mental block about quickly writing UDP listeners with
IO::Async, and I don't know why.  Fortunately, I recognized that I was hitting
that problem and switched to plain old Socket, which worked great, except I
needed to initiate the long-running HTTP request with curl.  Silly, but fine.
None of this is why I found the end result unsatisfying.

The first problem is the binary format of the datagram.  Why aren't the
datagrams JSON?  My guess is that the onboard processor isn't up to real time
encoding of arbitrary multi-panel touch events into JSON, and I can respect
that.  Who doesn't enjoy writing a little binary data parser once in a while,
right?  The problem for me came first from the documentation.  Again!

The documentation says the format of the datagrams is as follows:

```
  <(touchType = 3bits |
touchStrength = 4bits)1 = 1B>

 <(touchType = 3bits | touchStrength = 4bits)2 =
1B>

 <(touchType = 3bits | touchStrength = 4bits)3 =
1B>

 <(touchType = 3bits | touchStrength = 4bits)4 =
1B>
.
.
.
 <(touchType = 3bits | touchStrength = 4bits)_n
= 1B>
```

First off:  what?  The first line seems like it might make sense:  three bits
for "touch type", then four bits for "touch strength", then a set bit.  Repeat.
But then the second byte replaces the 1, which I took for "a set bit" with a 2.
You can't have 7 bits, then a 2, and have it make one byte.  What??

This is okay, because the documentation continues, contradicting itself but
providing much more useful information.

> The first 2 Bytes represents the number of panels that are currently
> undergoing a touch event. After that follows nPanels number of 5B packets,
> each packet representing touch data for that panel.
>
> The first 2B of the packet represents the panelId of the panel that is
> currently undergoing a touch event. The next 1 byte is a combination of the
> Touch Type and Touch Strength:
>
> [ diagram ]
>
> The last 2 bytes represent the panelId of the panel swiped from only in case
> of a swipe event. This value is otherwise set to 0xFF

Okay!  Now we're getting somewhere.  We get (2 + 5n) bytes, where *n* is the
number of touched panels.  The first two bytes provide *n*.  Great!

Now we just need to know how to interpret the per-panel touch type and
strength, helpfully given in a diagram.  Here it is:

![mostly-worthless diagram](/assets/2023/09/bad-packet-diagram.png)

Oh.

It looks to me like this is another unfortunate problem with Nanoleaf's API
site renderer.  The table header is probably meant to have markers for "this
header spans *n* columns", but it doesn't make it into the HTML.  So, which
bits are part of which field?  Hard to say.  The good news was that I *did*
receive datagrams, so all I had to do was inspect the packets, right?  This was
pretty easy, basically a pretty printer plus this:

```perl
my $sock = IO::Async::Socket->new(
  on_recv => sub ($self, $dgram, $addr) {
    state $counter = 1;
    Nib::TouchUtil->dump_dgram($dgram, $counter++); # <-- pretty printer
  },
);
```

A couple events get dumped like this:

![much better diagram](/assets/2023/09/good-packet-diagram.png)

I got everything working, it seems, but it's really not satisfactory.  First
off, I can tap as much as I want, I get "hover" events.  I can get a swipe (as
you can see in the diagram), but basically never a tap.  I hoped that this was
going to turn out to be a misunderstanding of that confusing packet definition,
but I don't think it is.  You can tell an event is a swipe because the last two
bytes aren't 0xFF.  Given that, the type/strength byte needs to have an `100`
in it to represent the touch type for swipe.  That only happens in one place in
swipes: the right three bits of the left nybble.  That leaves the right four
for touch strength, which never seems like a useful value.

Beyond that, the delivery of these datagrams isn't reliable.  I don't mean "UDP
isn't reliable", I mean that it feels like the Nanoleaf controller only sends
these events when it feels like it.  If I hold my finger on the panel, I get
repeated hover events… sometimes… for a while.  It's not terrible, but it
doesn't feel like something I could really rely on for anything but a goof.
For a goof, though, I'd have built it to show somebody, and I wouldn't want it
to fall flat!

There's one more problem.  For a while, during development, I stopped getting
the datagrams at all.  It happened when I was trying to move the HTTP event
stream code into Perl, and my initial theory was that initiating the HTTP
request with Perl wasn't starting the streaming datagrams, but initiating with
curl was.  I tested this over and over, I fired up Wireshark, I fiddled with
parameters, IP version, I asked friends.  Finally, I did some things in a
different order and realized that as best as I could tell, it didn't matter
what HTTP client I used.  The problem was that I needed *two* HTTP connections
active for the UDP stream to begin.  It was easy to reproduce with a bunch of
different combinations.

A week later, that symptom was gone, but the weird and unreliable datastream
was still there.  I was never particularly attached to doing anything with the
touch events, so I just gave up on the branch and decided my next hunk of work
would be about putting colors on panels.  At least I made a pretty packet
dumper!
