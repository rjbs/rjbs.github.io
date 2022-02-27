---
layout: post
title : explodingdog, imager, and my desktop
date  : 2006-03-14T17:13:09Z
tags  : ["perl", "programming"]
---
For a very long time, I had a small number of images that I used as my desktop.
Most of them were symmetrical, easy to ignore, and blue.  They were easy on the
eye, provided enough contrast for my desktop icons, and didn't distract or
irritate me.  Too often, I see people running with elaborate landscapes as
their background, or family photos, or women wearing bikinis, or other busy,
distracting images.  The even crazier thing is people who do that _and_ use
transparent terminals.

I'm a big fan of Sam Brown.  He's the artist behind <http://explodingdog.com>
as well as some other projects.  I was given his book, Amazing Rain, for
Christmas, and it was great.  I have explodingdog in my NetNewsWire
subscriptions, and I had downloaded one of his images recently: icantsing.gif.

After letting it sit on my desktop for quite a while, I finally decided to make
it my desktop.  It worked well, didn't bug me, and was a nice change of pace.
I even got some comments: "That's a cute robot."  I decided I'd try using more
of the explodingdog artwork.  I downloaded a big chunk of it and put it all in
a folder and marked it to rotate every fifteen minutes.

Most of the time, this was fine, but every once in a while it would switch to a
really busy image that would get on my nerves.  I thought about going through
and removing any image that looked distracting, but then I had another thought.

Not much of my desktop is actually visible when I'm working.  I use opaque
terminals and I have a bunch of various applications running.  What I saw,
mostly, was the background colors.  Mac OS fades from image to image, so I'd
get a lot of nice transitions from one soft color to another.  I wanted to tell
it to rotate solid colors.

Well, Mac OS doesn't have a built-in way to do this, which isn't surprising.
It does have a "solid colors" option for picking a solid background color, but
it's only a set of small solid-color images that it tiles.  I could've mucked
with those images, but instead I decided to make my own folder for explodingdog
colors.  I went through the images and eye-dropped out the colors I liked --
about 128 in all -- and put them in a text file as RGB values.  Then I wrote
this:

    use Imager;

    my @colors = do { open my $rgb_file, "<", "rgb"; <$rgb_file>; };
    chomp @colors;

    for my $line (@colors) {
      my $img = Imager->new(xsize => 64, ysize => 64, channels => 3);
      my @rgb = split /\s+/, $line;
      my $filename = sprintf "%02x%02x%02x.jpg", @rgb;

      my $color = Imager::Color->new(@rgb);
      $img->flood_fill(x => 1, y => 1, color => $color);

      $img->write(file => $filename);
    }

Neat!  It's my first time using Imager, and it was about as simple as I
could've hoped for.  If I had been really clever, I would've done something to
find all the images used in all the GIFs, but then I think I would've had to
find and eliminate any annoying colors.  Maybe next time I feel compelled to do
something like this I'll remove colorpoints that are too similar or too loud.

I've put all those color swatches into one directory and told Mac OS to rotate
every five seconds.  So far, it's not annoying.  I'll see how I feel at the end
of the day.

