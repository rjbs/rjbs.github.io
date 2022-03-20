---
layout: post
title : "the Zork Standard Code for Information Interchange"
date  : "2013-09-15T15:33:07Z"
tags  : ["int-fiction", "perl", "programming"]
---
I always feel a little amazed when I realize how many of the things that really
interest me, today, are things that I was introduced to by my father.  Often,
they're not even things that I think he's passionate about.  They're just
things we did together, and that was enough.

One of the things I really enjoyed doing with him was playing text adventures.
It's strange, because I think we only did three (the Zork trilogy) and I was
not very good at them.  I got in trouble for sneaking out the Invisi-Clues hint
book at one point and looking up answers for problems we hadn't seen yet.  What
was I thinking?

Still, it's stuck with me, and I'm glad, because I still enjoy [replaying those
games](http://rjbs.manxome.org/rubric/entries/user/rjbs/tags/infocom-replay),
trying to write my own, and [reading about the
craft](http://www.lulu.com/us/en/shop/kevin-jackson-mead-and-j-robinson-wheeler/if-theory-reader/ebook/product-17551190.html).
Most of my (lousy, unfinished) attempts to make good text adventures have been
about making the game using existing tools.  (Generally, [Inform
6](http://inform-fiction.org/index.html).  Inform 7 looks amazing, but also
like it's not for me.)  Sometimes, though, I've felt like dabbling in the
technical side of things, and that usually means playing around with the
[Z-Machine](https://en.wikipedia.org/wiki/Z-Machine).

Most recently, I was thinking about writing an assembler to build Z-Machine
code, and my thinking was that I'd write it in Perl 6.  It didn't go too badly,
at first.  I wrote a Perl 6 program that built a very simple Z-Machine
executable, I learned more Perl 6, and I even got [my first
commit](https://github.com/rakudo/rakudo/commit/0d261a3afb7963dad903a29aa0dcac3878eb0695)
into the Rakudo project.  The very simple program was basically "Hello, World!"
but it was just a bit more complicated than it might sound, because the
Z-Machine has its own text encoding format called ZSCII, the Zork Standard Code
for Information Exchange, and dealing with ZSCII took up about a third of my
program.  Almost all the rest was boilerplate to output required fields of the
output binary, so really the ZSCII code was most of the significant code in
this program.  I wanted to write about ZSCII, how it works, and my experience
writing (in Perl 5)
[ZMachine::ZSCII](https://metacpan.org/module/ZMachine%3A%3AZSCII).

First, a quick refresher on some terminology, at least as I'll be using it:

* a *character set* maps abstract characters to numbers (called *code points*)
    and back
* an *encoding* maps from those numbers to octets and back, making it possible
    to store them in memory

We often hear people talking about how Latin-1 is both of these things, but in
Unicode they are distinct.  That is: there are fewer than 256 characters in
Latin-1, so we can always store an character's code point in a single octet.
In Unicode, there are vastly more than 256 characters, so we must use a
non-identity encoding scheme.  UTF-8 is very common, and uses variable-length
sequences of bytes.  UTF-16 is also common, and uses different variable-length
byte sequences.  There are plenty of other encodings for Unicode characters,
too.

The Z-Machine's text representation has distinct character set and encoding
layers, and they are weird.

### The Z-Machine Character Set

Let's start with the character set.  The Z-Machine character set is not one
character set, but a per-program set.  The basic mapping looks something like
this:

| 000-01F | unassigned, save for (␀, ␡, ␉, ␤, and "sentence space") |
| 020-07E | same as ASCII                                           |
| 07F-080 | unassigned                                              |
| 081-09A | control characters                                      |
| 09B-0FB | extra characters                                        |
| 0FC-0FE | control characters                                      |
| 0FF-3FF | unassigned                                              |

There are a few things of note:  first, the overlap with ASCII is great if
you're American:

| 20-2F |  ␠ ! " # $ % & ' ( ) * + , - . /                      |
| 20-39 |  0 1 2 3 4 5 6 7 8 9                                  |
| 3A-40 |  : ; < = > ? @                                        |
| 41-5A |  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z  |
| 5B-60 |  [ \ ] ^ _ `                                          |
| 61-7A |  a b c d e f g h i j k l m n o p q r s t u v w x y z  |
| 7B-7E |  { \| } ~                                             |

The next thing to note is the "extra characters," which is where you'll be
headed if you're *not* just speaking English.  Those 96 code points can be
defined by the programmer.  Most of the time, they basically extend the
character repertoire to cover Latin-1.  When that's not useful, though, the
Z-Machine executable may provide its own mapping of these extra character by
providing an array of words called the Unicode translation table.  Each
position in the array maps to one extra character, and each value maps to a
Unicode codepoint in the [basic multilingual
plane](https://en.wikipedia.org/wiki/Basic_multilingual_plane).  In other
words, the Z-Machine does not support Emoji.

So:  ZSCII is not actually a character set, but a vast family of many possible
user-defined character sets.

Finally, you may have noticed that the basic mapping table gave (unassigned)
code points from 0x0FF to 0x3FF.  Why's that?  Well, the encoding mechanism,
which we'll get to soon, lets you decode to 10-bit codepoints.  My
understanding, though, is that the only possible uses for this would be
*extremely* esoteric.  They can't form useful sentinel values because, as best
as I can tell, there is no way to read a sequence of decoded codepoints from
memory.  Instead, they're always printed, and presumably the best output you'll
get from one of these codepoints will be �.

Here's a string of text: `Queensrÿche`

Assuming the default Unicode translation table, here are the codepoints:

| Unicode | 51 75 65 65 6E 73 72 FF 63 68 65 |
| ZSCII   | 51 75 65 65 6E 73 72 A6 63 68 65 |

This all seems pretty simple so far, I think.  The per-program table of extra
characters is a bit weird, and the set of control characters (which I didn't
discuss) is sometimes a bit weird.  Mostly, though, it's all simple and
reasonable.  That's good, because things will get weirder as we try putting
this into octets.

### Z-Machine Character Encoding

The first thing you need to know is that we encode in *two layers* to get to
octets.  We're starting with ZSCII text.  Any given piece of text is a sequence
of ZSCII code points, each between 0 and 1023 (really 255) inclusive.  Before
we can get to octets, we first built *pentets*.  I just made that word up.  I
hope you like it.  It's a five-bit value, meaning it ranges from 0 to 31,
inclusive.

What we actually talk about in Z-Machine jargon isn't pentets, but
Z-characters.  Keep that in mind:  a character in ZSCII is distinct from a
Z-character!

Obviously, we can't fit a ZSCII character, which ranges over 255 points, into a
Z-character.  We can't even fit the range of the ZSCII/ASCII intersection into
five bits.  What's going on?

We start by looking up Z-characters in this table:

```
0                               1
0 1 2 3 4 5 6 7 8 9 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
␠       ↑ ↑ a b c d e f g h i j k l m n o p q r s t u v w x y z
```

In all cases, the value at the bottom is a ZSCII character, so you can
represent a space (␠) with ZSCII character 0x020, and encode that to the
Z-character 0x00.  So, where's everything else?  It's got to be in that range
from 0x00 to 0x1F, somehow!  The answer lies with those "up arrows" under 0x04
and 0x05.  The table above was incomplete.  It is only the first of the three
"alphabets" of available Z-characters.  The full table would look like this:

```
    0                               1
    0 1 2 3 4 5 6 7 8 9 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
A0  ␠       ↑ ↑ a b c d e f g h i j k l m n o p q r s t u v w x y z
A1  ␠       ↑ ↑ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
A2  ␠       ↑ ↑ … ␤ 0 1 2 3 4 5 6 7 8 9 . , ! ? _ # ' " / \ - : ( )
```

Strings always begin in alphabet 0.  Z-characters 0x04 and 0x05 mark the next
character as being in alphabet 1 or alphabet 2, respectively.  After that
character, the shift is over, so there's no shift character to get to
alphabet 0.  You won't need it.

So, this gets us all the ZSCII/ASCII intersection characters… almost.  The
percent sign, for example, is missing.  Beyond that, there's no sign of the
"extra characters."  Now what?

We get to the next layer of mapping via A2-06, represented above as an
ellipsis.  When we encounter A2-06, we read two more Z-characters, join the two
pentets, interpret the resulting dectet as a little-endian 10-bit integer, and
that's the ZSCII character being represented.  So, in a given string of
Z-characters, any given ZSCII character might take up:

* one Z-character (a lowercase ASCII letter)
* two Z-characters (an uppercase ASCII letter or one of the symbols in A2)
* four Z-characters (anything else as 0x05 0x06 X Y, where X-Y points to ZSCII)

So, now that we know how to convert a ZSCII character to Z-characters without
fail, how do we store that in octets?  Easy.  Let's encode this string:

```
»Gruß Gott!«
```

That maps to these twenty-four Z-characters:

| » | 05 06 05 02 |
| G | 04 0C       |
| r | 17          |
| u | 1A          |
| ß | 05 06 05 01 |
| ␤ | 00          |
| G | 04 0C       |
| o | 14          |
| t | 19          |
| t | 19          |
| ! | 05 14       |
| « | 05 06 05 03 |

We start off with a four Z-character sequence, then a two Z-character sequence,
then a few single Z-characters.  The whole string of Z-characters should be
fairly straightforward.  We *could* just encode each Z-character as an octet,
but that would be pretty wasteful.  We'd have three unused bits per
Z-character, and in 1979 every byte of memory was (in theory) precious.
Instead, we'll pack three Z-characters into every word, saving the word's high
bit for later.  That means we can fit "!«" into two words like so:

| ! | 05 14       | 0b00101 0b01110                 |
| « | 05 06 05 03 | 0b00101 0b00110 0b00101 0b00011 |

…so…

<center>
<div class='code'>
    <span style='color:#0A0'>0</span><span style='color:red'>001 01</span><span style='color:blue'>01   110</span><span style='color:red'>0 0101</span>
    <br />
    <span style='color:#0A0'>1</span><span style='color:blue'>001 10</span><span style='color:red'>00   101</span><span style='color:blue'>0 0011</span>
</div>
</center>

Red and blue runs are the bits of our Z-characters.  You can see that each word
is three complete Z-characters.  The green bits are the per-word high bits.
This bit is always zero, except for the last word in a packed string.  If we're
given a pointer to a packed string in memory (this, for example, is the
argument to the `print_addr` opcode in the Z-Machine instruction set) we know
when to stop reading from memory because we encounter a word with the high bit
set.

Okay!  Now we can take a string of text, represent it as ZSCII characters,
convert those to Z-characters, and then pack the whole thing into pairs of
octets.  Are we done?

Not quite.  There are just two things I think are still worth mentioning.

The first is that the three alphabet tables that I named above are *not
constant*.  Just like the Unicode translation table, they can be overridden on
a per-program basis.  Some things are constant, like shift bits and the use of
A2-06 as the leader for a four Z-character sequence, but most of the alphabet
is up for grabs.  The alphabet tables are stored as 78 bytes in memory, with
each byte referring to a ZSCII code point.  (Once again we see code points
between 0x100 and 0x3FF getting snubbed!)

The other thing is abbreviations.

Abbreviations make use of the Z-characters I ignored above: 0x01 through 0x03.
When one of these Z-characters is seen, the next character is read.  Then this
happens:

```
if (just_saw in (1, 2, 3)) {
  next   = read_another
  offset = 32 * (just_saw - 1) + next
}
```

`offset` is the offset into the "abbreviations table."  Values in that table
are pointers to memory locations of string.  When the Z-Machine is printing a
string of Z-characters and encounters an abbreviation, it looks up the memory
address and prints the string there before continuing on with the original
string.  Abbreviation expansion does not recurse.  This can save you a lot of
storage if you keep referring to the "localized chronosynclastic infundibulum"
throughout your program.

### ZMachine::ZSCII

The two main methods of ZMachine::ZSCII should make good sense now:

```perl
sub encode {
  my ($self, $string) = @_;

  $string =~ s/\n/\x0D/g; # so we can just use \n instead of \r

  my $zscii  = $self->unicode_to_zscii($string);
  my $zchars = $self->zscii_to_zchars($zscii);

  return $self->pack_zchars($zchars);
}
```

First we fix up newlines.  Then we map the Unicode string's characters to a
string of ZSCII characters.  Then we map the ZSCII characters into a sequence
of Z-characters.  Then we pack the Z-characters into words.

At every point, we're dealing with Perl strings, which are just sequences of
code points.  That is, they're like arrays of non-negative integers.  It
doesn't matter that `$zscii` is neither a string of Unicode text nor a string
of octets to be printed or stored.  After all, if someone has figured out that
esoteric use of `Z+03FF`, then `$zscii` will contain what Perl calls "wide
characters."  Printing it will print the internal ("utf8") representation,
which won't do anybody a lick of good.  Nonetheless, using Perl strings keeps
the code simple.  Everything uses one abstraction (strings) intead of two
(strings and arrays).

Originally, I wrote my ZSCII code in Perl 6, but the Perl 6 implementation was
very crude, barely supporting the basics of ASCII-only ZSCII.  I'm looking
forward to (someday) bringing all the features in my Perl 5 code to the Perl
6 implementation, where I'll get to use distinct types (Str and Buf) for the
text and non-text strings, sharing some, but not all, of the abstractions as
appropriate.

Until then, I'm not sure what, if anything, I'll use this library for.  Writing
more of that Z-Machine assembler is tempting, or I might just add abbreviation
support.  First, though, I think it's time for me to make some more progress on
my Great Infocom Replay…

