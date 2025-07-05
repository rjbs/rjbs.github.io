---
layout: post
title : "streaming updates to Nanoleaf"
date  : "2023-08-24T12:00:00Z"
tags  : ["hardware","programming"]
---

In my [last post about Nanoleaf]({% post_url
2023-08-24-nanoleaf-getting-started %}), I ended by saying that I wrote a
program to light up each panel a different color, to help me pick out which
panel had which panel id.  I *also* said that I didn't make that program using
the custom animation API.  It's true!  I used the streaming interface.  I
actually got that going before the custom animations.  It felt like what I'd
want: a way to send a never-ending stream of instructions doing something like
tracking log events or keystrokes or I don't know what.

To get started, you need the same thing: a way to make HTTP requests to the
controller.  The request to make here is simple.  To the same `/effects`
endpoint you send your custom animation to, you PUT:

```json
{
  "write": {
    "command": "display",
    "animType": "extControl",
    "extControlVersion": "v2"
  }
}
```

Once you do this, the `.effects.select` value in the device status JSON will be
`*ExtControl*`.

This doesn't actually put anything on the display.  Instead, it puts the system
into "external control" mode.  Instead of running an animation on its own, it
expects to be sent instructions in real time.  This is what I was looking for!

Instructions are sent via UDP.  Once the device is in external control mode,
you can send it datagrams to port 60222.  Unlike the HTTP API port, which in
theory could vary in the mDNS service discovery data, this port is provided in
the API definition and there's no means to get a different one.

The streaming instructions are very similar to the custom animation data.  The
format is like this:

```
nPanels
    [0] panelId_0
        r g b w time
    [1] panelId_1
        r g b w time
    …
    [n] panelId_n
        r g b w time
```

Unlike the custom animation data, there's no `nFrames`, so every panel can only
display one frame.  If you want to animate the panels, you just keep sending
updates!  That's why they call it streaming!  The manual suggests you shouldn't
try to exceed updating more than ten times per second.  Maybe that explains why
transition times are measured in deciseconds… 🤔

Really, the good news is how short this post is!  The streaming interface gives
you pretty complete control over what's displayed.  If you don't need to worry
about coping with lots of different panel configurations, this feels like the
way to do stuff.  All you'll need to do is:

1. discover the address for the device with mDNS, described in earlier posts
2. create an authentication token (described in the previous post)
3. maybe run my cool panel identifying program (currently [on
   GitHub](https://github.com/rjbs/Nib/blob/main/demo/panel-ident)) to figure
   out panel ids
4. PUT to the effects endpoint to put the device in external control mode
5. send a zillion datagrams that do cool stuff

That's it!

There's some more stuff to post about, like the seemingly unusable touch
interface.  (I might be wrong about it, but I don't think I am.)

I'd also like to do some work on visualizing the configuration of the panels,
just for fun.  More importantly, though, I'd like to know how to implement
things like "sweep colors left to right" based on the arrangement and
orientation data.  I'll look at that in a couple weeks, maybe.

Until then, here is an extremely thrilling video of streaming mode being used
to cycle through colors around a set of panels:

<center>
<a href="https://www.flickr.com/photos/rjbs/53137890469/in/dateposted/" title="nanoleaf spinner"><video src="https://www.flickr.com/photos/rjbs/53137890469/play/720p/25a6db5549/" width="720" height="405" poster="https://live.staticflickr.com/31337/53137890469_25a6db5549_c.jpg" controls=""></video>
</center>
