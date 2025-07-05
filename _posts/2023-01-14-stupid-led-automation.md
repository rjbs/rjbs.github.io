---
layout: post
title : "my stupid LED blinking server"
date  : "2023-01-14T16:17:11Z"
tags  : ["hardware", "perl", "programming"]
---

I decided, today, to spend thirty minutes trying to get my little blinking LED
working again.  Now, six hours later, I am ready to tell you about it.

I have some blink(1) LEDs.  These are weird little devices.  Or, maybe, they're
not weird at all, but the fact that they're not dirt cheap and ubiquitous has
led them to be kind of weird to work with.  It's two RGB LEDs mounted on a USB
stick with a translucent plastic case.  You plug it in and control it to do
*whatever you want*.  Here's a toy application, picked to show because it's the
only video I already had ready.

<center>
<a href="https://www.flickr.com/photos/rjbs/52588732190/in/photostream/" title="KITT, but blink(1)"><video src="https://www.flickr.com/photos/rjbs/52588732190/play/720p/83fd1938d9/" width="720" height="405" poster="https://live.staticflickr.com/31337/52588732190_83fd1938d9_c.jpg" controls=""></video></a>
</center>

The hardware and software for blink(1) are open source.  The code is [all on
GitHub](https://github.com/todbot/blink1-tool), and I even have [some
commits](https://github.com/todbot/blink1-tool/commit/b2dee72d769ee011ba0dcbab333f2c2d950f015f)
in it (but nothing interesting).  The little command line tool is fine for
things like "make it blue" or "make it flash yellow and green for a few
seconds", but a little unwieldy for anything more complicated.  My video,
above, could be done, but you'd have to futz around a bit more than I wanted.

I decided I'd learn how to do this over USB, but… I didn't really want to dive
to far down.  I did a bunch of work on that front a few years ago, and a bit
more today, and I think I learned a lesson that I should have learned in the
past during other projects:  sometimes, you should just go learn the thing
you're trying to avoid having to learn.

## Wink

In the end, I did built something fun, though, and I'll probably go back to do
better later.  The thing I build is [Wink](https://github.com/rjbs/Wink), a
library and web service for managing a bank of blink(1) LEDs.  Here's a simple
piece of Lua code talking to that service as part of my pomodoro timer system:

```lua
local program = {}

for i = 1, pattern.times or 1 do
for j, subpattern in ipairs(pattern) do
  local rgb       = subpattern.rgb or error("no subpattern rgb")
  local litTime   = subpattern.litTime  or 300
  local darkTime  = subpattern.darkTime or 300
  local times     = subpattern.times    or 1

  for k = 1, times do
    table.insert(program, { cmd = "set", color = rgb })
    table.insert(program, { cmd = "sleep", ms = litTime })
    table.insert(program, { cmd = "off" })
    table.insert(program, { cmd = "sleep", ms = darkTime })
  end
end
end

local url = "http://blinkserver.local:5000/"

local json = hs.json.encode(program)
http.doAsyncRequest(url, 'POST', json, nil, function () end, 'ignoreLocalCache')
```

This creates an array of instructions telling the server how to manage the
lights.  These instructions are simple, looking something like:

```javascript
[
  { cmd: "set", color: "ff0000" },
  { cmd: "sleep", ms: 500 },
  { cmd: "off" },
  { cmd: "sleep", ms: 250 },
  { cmd: "set", color: "00ff00" },
  { cmd: "sleep", ms: 250 },
  { cmd: "off" },
  { cmd: "sleep", ms: 250 },
]
```

The server gets these instructions and manages turning the lights off and on
and pausing as needed.  Cool.

What this example doesn't show is that the Wink server is actually managing
*four* blink(1) devices.  Those commands can all take a `device` key to pick
which of several devices to target.  Along with some other keys, here's the
KITT (or Cylon, if you prefer) demo program:

```perl
my @west = map { (
  [ set  => { device => $_, rgb => '880008', led => 1, fade => 100 } ],
  [ sync => {} ],
  [ set  => { device => $_, rgb => '000000', led => 1, fade => 100 } ],
  [ set  => { device => $_, rgb => '880008', led => 2, fade => 100 } ],
  [ sync => {} ],
  [ set  => { device => $_, rgb => '000000', led => 2, fade => 100 } ],
) } qw( 3 2 1 0 );

my @east = map { (
  [ set  => { device => $_, rgb => '880008', led => 2, fade => 100 } ],
  [ sync => {} ],
  [ set  => { device => $_, rgb => '000000', led => 2, fade => 100 } ],
  [ set  => { device => $_, rgb => '880008', led => 1, fade => 100 } ],
  [ sync => {} ],
  [ set  => { device => $_, rgb => '000000', led => 1, fade => 100 } ],
) } qw( 0 1 2 3 );

my $program = $bank->build_program([
  @west, [ sync => {} ], @east,
  [ sync => {} ],
  @west, [ sync => {} ], @east,
]);

$program->execute;
```

There are four devices, numbered 0 to 3.  (Their names are names, I just picked
numbers because it was convenient.)  Each device has two LEDs, one on either
side.  This program fades each LED on each device up and then down, from right
to left, then left to right.  The `fade` argument is how many milliseconds it
should take to come to full brightness.  The `sync` command will wait for any
time-based commands to finish before continuing.

The whole thing is a bit of a mess, the time-delay stuff doubly so, but it gets
the job done.  I might make it do more, but first I'll need to decide what to
actually *do* with it.  For the most part, I blink just one LED to let me know
that my pomodoro is progressing.  I find it really useful, but it's not making
much use of the full might of this LED blinking framework!

## other stuff under the hood

So, how does this actually interface with the blink(1) USB device?  *Badly!*

Like I said, I didn't want to just run `blink1-tool` repeatedly.  The Wink
system *can* work that way, but I didn't want to.  Instead, I wanted to "use
USB", whatever that meant.  In the end, I got things working, but it's all sort
of stupid.  (That's okay!  I feel like writing software that is stupid but very
clear and functional is a strength of mine, and I don't mind leaning into it
sometimes.)

I should provide a warning before I keep going:  **Everything I am going to
tell you should be considered half-baked and suspect.**  I don't think I'm
going to lie or even get much terribly wrong, but I can only describe to you
the things I have sussed out, as a novice.  This is not a guide from an expert
to help train up more experts!

The blink(1) is a [HID](https://en.wikipedia.org/wiki/Human_interface_device),
or "human interface device".  Specifically, I mean that it implements the
[USB-HID](https://en.wikipedia.org/wiki/USB_human_interface_device_class)
interface.  I hoped this would make things easy.  It made things *something*.

To access a device using HID, you can use its entry in `/dev`, as (for example)
`/dev/hidraw2`.  I wanted to access these devices without needing to be root,
so I had to deal with [udev](https://en.wikipedia.org/wiki/Udev).  udev is the
userspace device manager.  I remember when it was added to Linux, and went for
a good twenty years or so not thinking about it.  Not bad!  Anyway, what I had
to do was add a "udev rule" that helps tell udev what to do with devices when
they show up.  I wrote two, only one of which I ended up needing:

```
# The wrapping is just for nice display.  These go on single lines, really.

ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed",
  MODE:="666", GROUP="plugdev"

ENV{ID_MODEL}=="blink_1__mk3", ENV{ID_SERIAL_SHORT}=="?*",
  SYMLINK+="blink/$env{ID_SERIAL_SHORT}"
```

The first says "When you see a blink(1) device, make it mode 0666 and the gid
for `plugdev`.  My user is in the plugdev group, so I can deal with the device.
Great!  The second line was chasing a problem that I only solved by deciding to
go stupid: reliable device names.

Reliable device names are probably not a new problem to many sysadmins, but
here, they felt worse than usual.  Think about it like this: you want to write
a program to make a way cool red pulse go back and forth across your four LEDs.
That means you need to know which one is all the way to the left and which one
is all the way to the right.  One simple way is to use each `/dev/hidrawX`
device in turn, making note of which is which.  Works great!

Later, though, you reboot the whole computer.  The kernel assigns all the
devices to different names.  They're still probably the same four names, all
told, just not applied to the same devices.  This makes your light show look
really weird.  How do you make it consistent?  udev rules!

The second rule, above, says "if you got a blink(1) device and can see its
short-form serial number, add a symlink at `/dev/blink/$serial`".  Perfect,
right?  Then you'd just store the order of the devices in a config file, by
serial number.  You can address each device directly by its id!  In fact, *this
works*!  The only problem is that you don't get the HID device, you get the USB
device.  If you're confused, you can join me right here on the confused bench.

I think there are about three ways to talk to an HID device: using the USB
interface, using the raw HID interface, and using the cooked HID interface.
I'd been using the second one.  (More on that later.)  I'm sure it's possible
to use the first kind, but *I don't know how* and I didn't want to learn, since
I'd gotten the second one working already.  The problem was that no matter what
combination of conditions I put in place, the symlink I'd get would always be
to the /dev entry for the USB interface, which doesn't work the same way as the
hidraw one.

So, maybe I could give up on making deterministic names appear and, instead,
look them up at the boot time of my service.  To get information about your
hidraw device, you can use `udevadm`:

```
$ udevadm info /dev/hidraw4
P: /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3.3/1-1.3.3:1.0/0003:27B8:01ED.0005/hidraw/hidraw4
N: hidraw4
L: 0
E: DEVPATH=/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3.3/1-1.3.3:1.0/0003:27B8:01ED.0005/hidraw/hidraw4
E: DEVNAME=/dev/hidraw4
E: MAJOR=244
E: MINOR=4
E: SUBSYSTEM=hidraw
```

It's nice that there's some information here, but notably *not* present is the
serial number.  You can get it by using the `-a` switch, which climbs up the
tree of USB devices and shows all their attributes.  Unfortunately, it's not
really a silver bullet.  It's slow, and you need to know which parent to go up
through, because the tree takes you all the way up through your hub and to the
controller.  Here you can see the USB device tree on my system, printed by
`lsusb -t`:

```
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=dwc_otg/1p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/5p, 480M
        |__ Port 1: Dev 3, If 0, Class=Vendor Specific Class, Driver=smsc95xx, 480M
        |__ Port 2: Dev 4, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M
        |__ Port 2: Dev 4, If 1, Class=Human Interface Device, Driver=usbhid, 1.5M
        |__ Port 3: Dev 5, If 0, Class=Hub, Driver=hub/4p, 480M
            |__ Port 1: Dev 6, If 0, Class=Human Interface Device, Driver=usbhid, 12M
            |__ Port 2: Dev 7, If 0, Class=Human Interface Device, Driver=usbhid, 12M
            |__ Port 3: Dev 8, If 0, Class=Human Interface Device, Driver=usbhid, 12M
            |__ Port 4: Dev 9, If 0, Class=Human Interface Device, Driver=usbhid, 12M
```

Even this isn't quite right, though.  You can't see the parent/child
relationship between the HID device and its USB-ness.  Still, there's useful
information here.  Those bottom four entries are my blink(1) devices.  We can
see the port number being used by each one, and I think we could just learn
whether port 1 is left or right.  I didn't really want to rely on that,
although it might have worked.  Instead, I looked at the bus and device
numbers.

At the top left of the device tree, you can see this is USB bus 1, and that the
bottom four devices are devices 6 through 9.  These will correspond directly to
the path `/dev/bus/usb/001/006` (through `009`).  Good, but how do I know that
these devices are really the LEDs?  Turns out you can tell `lsusb` to only show
devices of a certain type:

```
$ lsusb -d 27b8:01ed
Bus 001 Device 009: ID 27b8:01ed ThingM blink(1)
Bus 001 Device 008: ID 27b8:01ed ThingM blink(1)
Bus 001 Device 007: ID 27b8:01ed ThingM blink(1)
Bus 001 Device 006: ID 27b8:01ed ThingM blink(1)
```

Now we got the exact list of blink(1) devices along with how to find their
`/dev/bus/usb` path.  That still hasn't gotten us our `/dev/hidrawX` path,
though.  So!  Remember this, from earlier?

```
$ udevadm info /dev/hidraw4
P: /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3.3/1-1.3.3:1.0/0003:27B8:01ED.0005/hidraw/hidraw4
[ many more lines of nonsese ]
```

Well, what if we look at the same output for one of our USB devices?

```
$ udevadm info /dev/bus/usb/001/009
P: /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3.4
N: bus/usb/001/009
[ a bunch of stuff  ]
E: ID_SERIAL_SHORT=3597a3ff
[ more stuff ]
```

Look at the two "P" lines.  The hidraw path is a descendant of the USB path.
So, the code now works like this:

1. note down the serial numbers, in your desired order
2. use `lsusb` to find all the blink(1) device and their /dev paths
3. use `udevadm` to get the serial number and device path of the blink(1)s
4. use `udevadm` to get the device path of every device matching `/dev/hidraw*`
5. correlate the two lists and provide the hidraw paths, in order by serial
   number

The [code is stupid, but it
works](https://github.com/rjbs/Wink/blob/3958ba721885212e7dd28476e948493a8a0831f8/lib/Wink/Util.pm#L21).

It works, but is it the right solution?  Well, for my goal of "just make it
go", sure.  But in reality, it seems like it'd actually be easier to learn to
use the C interface, open the HID devices, and ask them directly for their
identifiers.  While doing that, I could also switch to using the standard HID
interface, which would make it easier to do more things than issue the basic
commands I issue.  Again: maybe next time.  For now, though, how *does* it
work?

<div class='update' markdown=1>
### an update: Cunningham's Law

This section has been added a little less than a day after the first
publication of this post.  Let us recall the great Ward Cunningham, from whom
we have Cunningham's Law:

> The best way to get the right answer on the Internet is not to ask a
> question; it's to post the wrong answer.

After posting this (and in part after rambling about it in private), I received
suggestions from [Andrew Rodland](https://cleverdomain.org/) and [Tom
Sibley](https://tsibley.net/), both of whom suggested very similar ways to
avoid a lot of my nonsense.  Thanks, you two!

Andrew's explanation was great, because it affirmed that my theory was right:
all the data was available, I just didn't know how to get at it all at once.
Even better, both of them *told me how to do so*.  The rule now in my udev
rules is:

```
SUBSYSTEM=="hidraw",
  ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed", ATTRS{serial}=="?*",
  SYMLINK+="blink/$attr{serial}", MODE:="0666", GROUP="plugdev"
```

This rule has to fire when dealing with the hidraw subsystem, where we can't
get the `ID_MODEL` or `ID_SERIAL_SHORT` properties.  We *can* get the
`idProduct` and `serial` attributes, though.  Why?  Best not to ask.  (It's not
interesting, best I can tell.  Different layers of the USB system have
different data, and getting it up the ancestor tree isn't trivial)

So:  I have `/dev/blink/${serial}` paths now, and they go to the hidraw
devices, and I will now go [delete a bunch of
code](https://github.com/rjbs/Wink/commit/e1d68933100e2784268022dfedfa26eed87a8325)!

</div>

## sending commands to the device

HID works (as far as I sort of vaguely understand) by sending binary "reports"
back and forth.  If you use [hidapi](https://github.com/libusb/hidapi), this is
nice and simple.  I didn't.

Don't worry, it's still simple, as long as you stick to doing almost nothing,
which is what I did.  We open the device, then use `ioctl` to send command
reports.

```perl
my $HIDIOCSFEATURE = 3221833734; # I looked it up in a .h file ;-)

open my $dev, '+>', '/dev/hidraw1' or die "can't open device: $!";

sub send_command ($cmd, @six_args) {
  ioctl(
    $dev,
    $HIDIOCSFEATURE,
    pack("C*", 1, ord($cmd), @sixargs, 0),
  );

  return;
}
```

Sending a command is a chr, and I only send two: `c`, which does a fade to a
color, and `n`, which sets a color now.  The arguments are the RGB values,
optionally time, and which of the two LEDs on the device are being set.
There's [documentation for the whole hardware API for the
blink(1)](https://github.com/todbot/blink1/blob/main/docs/blink1-hid-commands.md),
and it's not terrible.  Looking at the commands, it's clear that more commands
could send with just the lousy `send_command` above, but who needs them?

## probably I'm done now

I imagine that if I do anything more with Wink or these LEDs in the near
future, it will just built on this library and its goofy little webserver.  If
I find cool things to do, maybe I'll make them better, or finally move to use
hidapi instead of being ridiculous.
