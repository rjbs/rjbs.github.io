---
layout: post
title : "talking to Philips Hue lights, part 1: connecting"
date  : "2023-01-18T13:18:00Z"
tags  : ["hardware", "programming"]
---

Last time, I posted about goofing around with little LED lights.  This time,
I'm posting about goofing around with larger LED lights.  Specifically, Philips
Hue lights.

Very early in the COVID-19 lockdown, I realized that I was going to be spending
a lot more time in my home office, and that I should make it a bit more
pleasant to spend time in.  How early?  I was suprised when I checked my order
history: March 25, 2020.  I did a bunch of things over the first few months,
but that was my earliest week of ordering home office improvements.  I ordered
a monitor mounting arm, a green screen (ha!) and two Philips Hue bulbs.

The bulbs were fine.  I paired my phone to them with Bluetooth.  For a week or
so, I fiddled with the colors for fun and to make myself look better on Zoom.
Doing this with my phone stank, though, and doing it with anything else was
going to require I shell out for the Philips Hue Hub (also known as the
bridge).  I found this irritating, and put off getting one for exactly a year.
I don't know why I broke, but my theory is that I finally looked into how the
lights worked and what the hub would make possible and realized I had cut off
my nose to spite my face.

So, what's the hub for, anyway?  Well, like I said, it's also called a bridge,
and I think that's a better name.  Although the Hue lights can do Bluetooth,
they also work over [Zigbee](https://en.wikipedia.org/wiki/Zigbee), a personal
area networking protocol.  It's also called 802.15.4, but I've never heard
anyone call it that.  The Hue bridge is a wired ethernet device that also
speaks Zigbee.  It provides an HTTP interface that lets you control the Zigbee
devices by sending and receiving JSON.  This is pretty good stuff!  The API is
fine, and there were only two tedious parts.

I will now tell you about those tedious parts!

## discovery: UPnP and HTTPMU

<div class='update'>
### an update: this is obsolete (but still interesting)

I had done the discovery work on this years ago, and just yesterday I found out
that this means of discovery has been deprecated.  I have [written about its
replacement](/blog/2023/01/talking-to-philips-hue-lights-3/) in a later post.
But hey, this stuff below is still neat to read about~
</div>

So, how do you find the bridge?  I have a number of little servers on my home
network, and I generally rely on them showing up as `whatever.local`, or I make
a DHCP reservation for them.  In those cases, I'd have set the hostname or
looked at the MAC address somewhere.  How, on this interfaceless box?

I knew, though, that the thing had to be findable to be useful!  It would be
getting a DHCP address, which I wouldn't see, so how was I supposed to find it?
It turns out the answer was
[UPnP](https://en.wikipedia.org/wiki/Universal_Plug_and_Play).  I'd heard of
"universal plug and play" for years, and in my head it was "that thing that
seems to work okay but I don't know how."  What's not to like about that!  Now,
though, I had to leave behind blissful ignorance and proceed into loathsome
understanding.  It wasn't all that bad.

There are lots of parts to UPnP, but all I had to learn about was HTTPMU.  As a
professional handler of CalDAV, I am already a connoisseur of "weird variants
of HTTP".  DAV is a much bigger change than HTTPMU, but it feels like a less
weird one.  It's just *more*.  HTTPMU is *different*.  But maybe I should talk
about how it's different!

HTTPMU is HTTP but Multicast UDP.  Yup!

So, you want to know what UPnP stuff is on your network?  Just broadcast a
request for them to sing out.  Find your local broadcast address, and send a
UDP datagram to it on port 1900.  The datagram should contain an HTTPMU
request, which will look recognizably like an HTTP request:

```
M-SEARCH * HTTP/1.1
Host: 239.255.255.250:1900
Man: "ssdp:discover"
ST: upnp:rootdevice
MX: 1
```

We're not doing a GET or a POST.  This is HTTPMU, and we're doing an M-SEARCH,
searching for … machines.  Multiple things?  M's, anyway.  Also, can we take a
minute to enjoy that this bizarro multicast UDP message announces itself as
HTTP/1.1?  Yeah, and my iOS Safari is Mozilla/5.0, sure thing.

Anyway, we provide the broadcast name as the Host header, although I'm not sure
why.  Things seem to work without it.  The Man field is always the same,
`ssdp:discover`.  SSDP is the [Simple Service Discovery
Protocol](https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol).  I
have declined to learn much more about it, but I probably should.  I think you
can sit around listening for broadcast updates.  I just haven't.

The MX field is weird.  The idea (as I understand it) is that devices might not
send a reply immediately, but may wait a bit.  MX says "don't wait more than
this many seconds before replying".  It doesn't seem like I really need this,
but since I didn't want to just wait forever, I told things to send them within
a second.

ST is the service type we're looking for.  It would be convenient if we could
just put `hue:bridge` or something, here, but I don't think there's such a
service type to request.  (What we get back from the bridge is ST
`uuid:2f402f80-da50-11e1-9b23-ecb5fa846158` and on general principle I refuse
to query for this random-seeming constant.)

Okay, so we send this out into the void, what do we get back?  Quite a few
things!  I get a bunch of replies from my Hue bridge, some from my home
internet router, and one from my NAS device.  Here's a reply from my bridge:

```
HTTP/1.1 200 OK
HOST: 239.255.255.250:1900
EXT:
CACHE-CONTROL: max-age=100
LOCATION: http://192.168.1.162:80/description.xml
SERVER: Hue/1.0 UPnP/1.0 IpBridge/1.55.0
hue-bridgeid: ECB5FAFFFE846158
ST: uuid:2f402f80-da50-11e1-9b23-ecb5fa846158
USN: uuid:2f402f80-da50-11e1-9b23-ecb5fa846158
```

First, I should point out one last bit of goofiness.  I call this a reply,
which it is, but it is notably *not* a *response*.  See that first line?  It's
not an HTTP response header, nor is it a request line (there's no method or
path).  It's just another datagram we get.

Lots of stuff here, but it's the `LOCATION` that's most interesting.  That
tells us where to find out what this thing really is.  After all, without being
sure that we can send a big fat datagram, the protocol needs a way to shift us
from UDP to TCP so we can fetch a large service definition.  That's what we
find at the referred-to location.  And, because UPnP comes from the late
nineties, of course it's XML.

Go ahead, try it yourself.

```perl
#!perl
use v5.32.0;
use warnings;

use Socket;

my $SSDP_ADDR = '239.255.255.250';
my $SSDP_PORT = 1900;

my $DEFAULT_ST = q{upnp:rootdevice};
my $DEFAULT_MX = 1;

my $ssdp_header = <<"END_REQUEST";
M-SEARCH * HTTP/1.1
Host: $SSDP_ADDR:$SSDP_PORT
Man: "ssdp:discover"
ST: $DEFAULT_ST
MX: $DEFAULT_MX
END_REQUEST

$ssdp_header =~ s/\r//g;
$ssdp_header =~ s/\n/\r\n/g;

socket(my $ssdp_sock, AF_INET, SOCK_DGRAM, getprotobyname('udp'));
my $ssdp_mcast = sockaddr_in($SSDP_PORT, inet_aton($SSDP_ADDR));

send($ssdp_sock, $ssdp_header, 0, $ssdp_mcast);

print "sending broadcast...\n";

my $rin = '';
my $rout;

vec($rin, fileno($ssdp_sock), 1) = 1;
while( select($rout = $rin, undef, undef, ($DEFAULT_MX * 2)) ) {
  recv($ssdp_sock, my $ssdp_res_msg, 4096, 0);

  say "┌─── BEGIN REPLY ───";
  say $ssdp_res_msg =~ s/\s+$//r =~ s/^/│ /grm;
  say "└─── END REPLY ─────";
}

close($ssdp_sock);
```

## authentication: the link button

Now that you found your Hue bridge, you'll want to make API calls against it to
do stuff like make your office lights turn red when you have too many
unreviewed pull requests.  Even though it's only on your local network, the
bridge won't pass along requests unless you've got authentication.  You'll need
to create a user account for your automations.  That's easy!  HTTP and JSON!

The API end point is `/api`, and you want to post this to it:

```javascript
{
  "devicetype": "MyCoolApp"
}
```

…and this will fail!  You can't just post "add an admin to this device" and
expect it to happen, right?  You need permission from an authorized person.
How does that work?  Well, you know how people say "if you have physical access
to the computer, you've basically compromised it already?"  That's the
operating principle here.  There's a button on the top of the bridge.  When you
tap it, a ring of blue lights up around it for a few seconds.  While that link
button is lit up, *then* the POST above will work!

You'll get back something like this:

```javascript
[ { "success": { "username": "d1f7f044954a11ed913a" } } ]
```

That username gets infixed to your API URLs.  So, when you want to futz with
the lights, you post to `/api/d1f7f044954a11ed913a/lights`.  By the way, if you
think it's weird that you're putting your credentials in the URL, remember that
if you're not careful, it'll be worse than you think.

Your bridge provided its location as an `http` URL, so no transport layer
security.  The good news is that it *does* listen on port 443 for secure HTTP.
The bad news is that it doesn't know how to get a trusted certificate, and even
if it could, it doesn't have a verified name, just a private IP space address.
You should probably talk to it over HTTPS with certificate verification
disabled.  If there's a better way to do this, I don't know it.

## the API itself

Hey, we're past the tedious stuff!  The API itself is just fine, and I'm not
going to get much into it.  The [API
documentation](https://developers.meethue.com/develop) is okay.  It's not
terrific, but it's adequate.  Annoyingly, you need to be logged into your
Philips Hue account to read it.  I don't know why.  Something something
business intelligence, I suppose.

To set my lights to their usual everyday setting, I post to
`https://$bridge_ip/api/$username/lights/$id/state` with a JSON payload.  I
should probably update that code.  Right now, it updates each light
individually.  The API would let it update the whole "office lights" group, but
I didn't do it that way.  But this is boring "use a JSON API" stuff.  The last
interesting thing is the payload, which looks like this:

```javascript
{
  "on":  true,
  "xy":  [ 0.4574, 0.41 ],
  "bri": 254,
  "colormode":  "xy",
  "alert":      "none",
  "effect":     "none"
},
```

Boring, right?  The light's on.  There's no alert or effect, meaning the light
isn't cycling or pulsing.  The brightness is at its max, because it ranges from
1 to 254.  (What happened to 0 and 255?  I have no idea.)  Then there's color.
That's the last, bonus bit of tedium.  You can specify your light colors either
in color temperature (you know, the "this is a 5000K bulb" thing you see on
normal light bulbs these days) or in "xy".  The xy mode is actually the [CIE
1931 xy color space](https://en.wikipedia.org/wiki/CIE_1931_color_space), which is
easy.  It's like this:

> In the CIE 1931 model, Y is the luminance, Z is quasi-equal to blue (of CIE
> RGB), and X is a mix of the three CIE RGB curves chosen to be nonnegative.
> Setting Y as luminance has the useful result that for any given Y value, the
> XZ plane will contain all possible chromaticities at that luminance.
>
> The unit of the tristimulus values X, Y, and Z is often arbitrarily chosen so
> that Y = 1 or Y = 100 is the brightest white that a color display supports.
> In this case, the Y value is known as the relative luminance. The
> corresponding whitepoint values for X and Z can then be inferred using the
> standard illuminants.

I have no idea what this means.  I would be interested to have an expert
explain it to me over a beer.  I do not want to go do the research.  On the
other hand, I found some math, and I converted that math into this
subroutine:

```perl
sub rgb_to_xy ($r_i, $g_i, $b_i) {
  my sub enh_color ($norm) {
    return $norm / 12.92 if $norm <= 0.04045;

    my $enh = (($norm + 0.055) / (1.0 + 0.055)) ** 2.4;
    return $enh;
  }

  my $r = enh_color($r_i / 255);
  my $g = enh_color($g_i / 255);
  my $b = enh_color($b_i / 255);

  my $x = $r * 0.649926 + $g * 0.103455 + $b * 0.197109;
  my $y = $r * 0.234327 + $g * 0.743075 + $b * 0.022598;
  my $z = $r * 0.000000 + $g * 0.053077 + $b * 1.035763;

  return (0,0) if $x + $y + $z == 0;

  my $xy_x = $x / ($x + $y + $z);
  my $xy_y = $y / ($x + $y + $z);

  return ($xy_x, $xy_y);
}
```

Feed this `(0xff, 0x8c, 0x00)` and you get a nice orange light's xy values.

## end of part one!

That's it!  Now I can find, authenticate with, and talk to my Hue bridge so
that I can use the boring API to control my lights.  I'm going to write at
least one more post, though, where I'll talk about how I went from "I can POST
instructions to the bridge!" to "I can easily control my lights while doing
other stuff."
