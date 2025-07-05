---
layout: post
title : "I got an Arduino!"
date  : "2013-12-30T14:34:18Z"
tags  : ["arduino", "programming"]
---
For Christmas, Gloria gave me an [Arduino Starter
Kit](http://arduino.cc/en/Main/ArduinoStarterKit)!  It's got an Arduino Uni, a
bunch of wires, some resistors and LEDs and stuff, a motor, and I don't know
what else yet.  I hadn't been very intereted in Arduino until [Rob
Blackwell](http://robertblackwell.com/) was giving a pretty neat demo at the
"Quack and Hack" at DuckDuckGo last year.  Still, I knew it would just be
another thing to eat up my time, and I decided to stay away.  Finally, though,
I started having ideas of things that might be fun, but not too ambitious.  I
put the starter kit on my Christmas wish list and I got the [Arduino
Workshop](http://www.nostarch.com/arduino) book for cheap from O'Reilly.

The starter kit comes with its own book, but there are quite a few passages
that appear verbatim in both books.  I'm not sure of their relationship, but
they're different enough that I've been reading both.  I've gotten a decent
idea of how to accomplish simple things, but I don't really understand the
underlying ideas, yet.  As I sat, squinting at a schematic, I wondered: Is this
what beginning programmers feel like?  "If I write these magic words, I know
what will happen, but not why!"  I already had a lot of sympathy for that kind
of thinking, but it has been strengthened by this experience.

For example, I know that I can put a resistor on either side of a device in my
circuit and it works, and I generally understand why, but then I don't
understand how a rectifying diode helps prevent problems with a spike caused by
a closing relay?  I need to find a good elementary course on electricity and
electronics and I need to really let it sink in.  This is one of those topics,
like special relativity, that I've often understood for a few minutes, but not
longer.  (Special relativity finally sunk in once I wrote some programs to
compute time dilation.)

I'm going to keep working through the books, because there's clearly a lot more
to learn.  I'm not sure, though, what I'm hoping to do after I get through the
whole thing.  Even if I don't keep using it after I finish the work, though, I
think it will have been a good experience and worth having done.

My favorite project so far was one of my own.  The Arduino Workshop has a
project where you build a KITT-like scanner with five LEDs using pulse width
modulation to make them scan left to right.  That looked like it would be neat,
but I skipped the software for left to right scanning and instead wrote a
little program to make it count to 2⁶-1 over and over on its LED fingers.

Here's the program:

    void setup() {
      for (int pin = 2; pin < 7; pin++)  pinMode(pin, OUTPUT);
    }

    void loop() {
      for (int a = 0; a < 64; a++) {
        for (int pin = 2; pin < 7; pin++) {
          digitalWrite(pin, (a & ( 2 << pin-2 )) ? HIGH : LOW);
        }
        delay(250);
      }
    }

I originally got stuck on the `2<<pin-2` expression because I wanted to use
exponentiation, which introduces some minor type complications.  I was about to
sort them out when I remembered that I could just use bit shifting.  That was a
nice (if tiny) relief.

Here's what the device looks like in action:

<center>
<iframe width="560" height="315" src="//www.youtube.com/embed/rEUEBzIkBR4" frameborder="0" allowfullscreen></iframe>
</center>

Working with hardware is different from software in ways that are easy to
imagine, but that don't really bug you until you're experiencing them.  If I
have a good idea about how to rebuild a circuit to make it simpler, I can't
take a snapshot of the current state for a quick restore in case I was wrong.
Or, I can, but it's an actual snapshot on my camera, and I'll have to rebuild
by hand later.

If I make a particularly bad mistake, I can destroy a piece of hardware
permanently.  Given the very small amounts of power I'm using, this probably
means "I can burn out an LED," but it's still a real problem.  I've been
surprised that there's no "reset your device memory between projects" advice.
I keep imagining that my old program will somehow cause harm to my new
project's circuits.  Also, plugging the whole thing into my laptop makes me
nervous every time.  It's a little silly, but it does.

My next project involves a servo motor.  That should be fun.

