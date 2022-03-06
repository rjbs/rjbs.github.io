---
layout: post
title : "drawing (but not generating) mazes"
date  : "2019-05-06T02:26:57Z"
tags  : ["programming"]
---
I've started a sort of book club here in Philly.  It works like this:  it's for
people who want to do computer programming.  We pick books that have
programming problems, especially language-agnostic books, and then we commit to
showing up to the book club meeting with answers for the exercises.  There, we
can show off our great work, or ask for help because we got stuck, or compare
notes on what languages made things easier or harder.  We haven't had an actual
meeting yet, so I have no idea how well this is going to go.

Our first book is [Mazes for Programmers](http://www.mazesforprogrammers.com),
which I started in on quite a while ago but didn't make much progress through.
The book's examples are in Ruby.  My goal is to do work in a language that I
don't know well, and I know Ruby well enough that it's a bad choice.  I haven't
decided yet what I'll do most of the work in, but I didn't want to do it all in
Perl 5, which I already know well, and reach for when solving most daily
problems.  On the other hand, I knew a lot of the early material in the book
(and maybe lots of the material in general) would be on generating mazes, which
would be fairly algorithmic work and produce a data structure.  I didn't want
to get all caught up in drawing the data structure as a human-friendly maze,
since that seemed like it would be a fiddly problem and would distract me from
the actual maze *generation*.

This weekend, I wrote a program in Perl 5 that would take a very primitive
description of a maze on standard input and print out a map on standard output.
It was, as I predicted, sort of fiddly and tedious, but when I finished, I felt
pretty good about it.  I put my [maze-drawing
program](https://github.com/rjbs/Codebook/blob/master/mazes/draw-maze) on
GitHub, but I thought it might be fun to write up what I did.

First, I needed a simple protocol.  My goal was to accept input that would be
easy to produce given any data structure describing a maze, even if it would be
a sort of stupid format to actually store a maze in.  I went with a
line-oriented format like this:

```
1 2 3
4 5 6
7 8 9
```

Every line in this example is row of three rooms in the maze.  This input would
actually be illegal, but it's a useful starting point.  Every room in the maze
is represented by an integer, which in turn represents a four-bit bitfield,
where each bit tell us whether the room links in the indicated direction

```
 1
8•2
 4
```

So if a cell in the maze has passages leading south and east, it would be
represented in the file by a 6.  This means some kinds of input are
nonsensical.  What does this input mean?

```
0 0 0
0 2 0
0 0 0
```

The center cell has a passage east, but the cell to its east has no passage
west.  Easy solution:  this is illegal.

I made quite a few attempts to get from that to a working drawing algorithm.
It was sort of painful, and I ended up feeling pretty stupid for a while.
Eventually, though, I decided that the key was not to draw cells (rooms), but
to draw lines.  That meant that for a three by three grid of cells, I'd need to
draw a four by four grid of lines.  It's that old fencepost problem.

```
  1   2   3   4
1 +---+---+---+
  | 0 | 0 | 0 |
2 +---+---+---+
  | 0 | 2 | 8 |
3 +---+---+---+
  | 0 | 0 | 0 |
4 +---+---+---+
```

Here, there's only one linkage, so really the map could be drawn like this:

```
  1   2   3   4
1 +---+---+---+
  | 0 | 0 | 0 |
2 +---+---+---+
  | 0 | 2   8 |
3 +---+---+---+
  | 0 | 0 | 0 |
4 +---+---+---+
```

My reference map while testing was:

```
  1   2   3   4
1 +---+---+---+
   10  12 | 0 |
2 +---+   +---+
  | 0 | 5 | 0 |
3 +---+   +---+
  | 0 | 3  12 |
4 +---+---+   +
```

This wasn't too, too difficult to get, but it was pretty ugly.  What I actually
wanted was something drawn from nice box-drawing characters, which would look
like this:

```
  1   2   3   4
1 ╶───────┬───┐
   10  12 │ 0 │
2 ┌───┐   ├───┤
  │ 0 │ 5 │ 0 │
3 ├───┤   └───┤
  │ 0 │ 3  12 │
4 └───┴───╴   ╵
```

Drawing this was going to be trickier.  I couldn't just assume that every
intersection was a `+`.  I needed to decide how to pick the character at every
intersection.  I decided that for every intersection, like (2,2), I'd have to
decide the direction of lines based on the links of the cells abutting the
intersection.  So, for (2,2) on the *line* axes, I'd have to look at the cells
at (2,1) and (2,2) and (1,2) and (1,1).  I called these the northeast,
southeast, southwest, and northwest cells, relative to the intersection,
respectively.  Then determined whether a line extended from the middle of an
intersection in a given direction as follows:

```perl
# Remember, if the bit is set, then a link (or passageway) in that
# direction exists.
my $n = (defined $ne && ! ($ne & WEST ))
     || (defined $nw && ! ($nw & EAST ));
my $e = (defined $se && ! ($se & NORTH))
     || (defined $ne && ! ($ne & SOUTH));
my $s = (defined $se && ! ($se & WEST ))
     || (defined $sw && ! ($sw & EAST ));
my $w = (defined $sw && ! ($sw & NORTH))
     || (defined $nw && ! ($nw & SOUTH));
```

For example, how do I know that at (2,2) the intersection should only have
limbs headed west and south?  Well, it has cells to the northeast and
northwest, but they link west and east respectively, so there can be no limb
headed north.  On the other hand, the cells to its southeast and southwest do
not link to one another, so there is a limb headed south.

This can be a bit weird to think about, so think about it while looking at the
map and code.

Now, for each intersection, we'd have a four-bit number.  What did that mean?
Well, it was easy to make a little hash table with some bitwise operators and
the Unicode character set…

```perl
my %WALL = (
  0     | 0     | 0     | 0     ,=> ' ',
  0     | 0     | 0     | WEST  ,=> '╴',
  0     | 0     | SOUTH | 0     ,=> '╷',
  0     | 0     | SOUTH | WEST  ,=> '┐',
  0     | EAST  | 0     | 0     ,=> '╶',
  0     | EAST  | 0     | WEST  ,=> '─',
  0     | EAST  | SOUTH | 0     ,=> '┌',
  0     | EAST  | SOUTH | WEST  ,=> '┬',
  NORTH | 0     | 0     | 0     ,=> '╵',
  NORTH | 0     | 0     | WEST  ,=> '┘',
  NORTH | 0     | SOUTH | 0     ,=> '│',
  NORTH | 0     | SOUTH | WEST  ,=> '┤',
  NORTH | EAST  | 0     | 0     ,=> '└',
  NORTH | EAST  | 0     | WEST  ,=> '┴',
  NORTH | EAST  | SOUTH | 0     ,=> '├',
  NORTH | EAST  | SOUTH | WEST  ,=> '┼',
);
```

At first, I *only* drew the intersections, so my reference map looked like
this:

```
╶─┬┐
┌┐├┤
├┤└┤
└┴╴╵
```

When that worked -- which took quite a while -- I added code so that cells
could have both horizontal and vertical fillter.  My reference map had a width
of 3 and a height of 1, meaning that it was drawn with 1 row of vertical-only
filler and 3 columns of horizontal-only drawing per cell.  The weird map just
above had a zero height and width.  Here's the same map with a width of 6 and a
height of zero:

```
╶─────────────┬──────┐
┌──────┐      ├──────┤
├──────┤      └──────┤
└──────┴──────╴      ╵
```

I have no idea whether this program will end up being useful in my maze
testing, but it was (sort of) fun to write.  At this point, I'm mostly
wondering whether it will be proven to be *terrible* later on.

As a side note, my decision to do the drawing in text was a major factor in the
difficulty.  Had I drawn the maps with a graphical canvas, it would have been
nearly trivial.  I'd just draw each cell, and then start adjacent cells with
overlapping positions.  If two walls drew over one another, it would be the
intersection of drawn pixels that would display, which would be exactly what we
wanted.  Text can't work that way, because every visual division of the
terminal can show only one glyph.  In this way, a typewriter is more like a
canvas than a text terminal.  When it overstrikes two characters, the
intersection of their inked surfaces really is seen.  In a terminal, an
overstriken character is fully replaced by the overstriking character.

It's all on GitHub, but here's my program as I stands tonight:

```perl
#!perl
use v5.20.0;
use warnings;

use Getopt::Long::Descriptive;

my ($opt, $usage) = describe_options(
  '%c %o',
  [ 'debug|D',    'show debugging output' ],
  [ 'width|w=i',  'width of cells', { default => 3 } ],
  [ 'height|h=i', 'height of cells', { default => 1 } ],
);

use utf8;
binmode *STDOUT, ':encoding(UTF-8)';

#  1   A maze file, in the first and stupidest form, is a sequence of lines.
# 8•2  Every line is a sequence of numbers.
#  4   Every number is a 4-bit number.  *On* sides are linked.
#
# Here are some (-w 3 -h 1) depictions of mazes as described by the numbers
# shown in their cells:
#
# ┌───┬───┬───┐ ╶───────┬───┐
# │ 0 │ 0 │ 0 │  10  12 │ 0 │
# ├───┼───┼───┤ ┌───┐   ├───┤
# │ 0 │ 0 │ 0 │ │ 0 │ 5 │ 0 │
# ├───┼───┼───┤ ├───┤   └───┤
# │ 0 │ 0 │ 0 │ │ 0 │ 3  12 │
# └───┴───┴───┘ └───┴───╴   ╵

use constant {
  NORTH => 1,
  EAST  => 2,
  SOUTH => 4,
  WEST  => 8,
};

my @lines = <>;
chomp @lines;

my $grid = [ map {; [ split /\s+/, $_ ] } @lines ];

die "bogus input\n" if grep {; grep {; /[^0-9]/ } @$_ } @$grid;

my $max_x = $grid->[0]->$#*;
my $max_y = $grid->$#*;

die "not all rows of uniform length\n" if grep {; $#$_ != $max_x } @$grid;

for my $y (0 .. $max_y) {
  for my $x (0 .. $max_x) {
    my $cell  = $grid->[$y][$x];
    my $south = $y < $max_y ? $grid->[$y+1][$x] : undef;
    my $east  = $x < $max_x ? $grid->[$y][$x+1] : undef;

    die "inconsistent vertical linkage at ($x, $y) ($cell v $south)"
      if $south && ($cell & SOUTH  xor  $south & NORTH);

    die "inconsistent horizontal linkage at ($x, $y) ($cell v $east)"
      if $east  && ($cell & EAST   xor  $east  & WEST );
  }
}

my %WALL = (
  0     | 0     | 0     | 0     ,=> ' ',
  0     | 0     | 0     | WEST  ,=> '╴',
  0     | 0     | SOUTH | 0     ,=> '╷',
  0     | 0     | SOUTH | WEST  ,=> '┐',
  0     | EAST  | 0     | 0     ,=> '╶',
  0     | EAST  | 0     | WEST  ,=> '─',
  0     | EAST  | SOUTH | 0     ,=> '┌',
  0     | EAST  | SOUTH | WEST  ,=> '┬',
  NORTH | 0     | 0     | 0     ,=> '╵',
  NORTH | 0     | 0     | WEST  ,=> '┘',
  NORTH | 0     | SOUTH | 0     ,=> '│',
  NORTH | 0     | SOUTH | WEST  ,=> '┤',
  NORTH | EAST  | 0     | 0     ,=> '└',
  NORTH | EAST  | 0     | WEST  ,=> '┴',
  NORTH | EAST  | SOUTH | 0     ,=> '├',
  NORTH | EAST  | SOUTH | WEST  ,=> '┼',
);

sub wall {
  my ($n, $e, $s, $w) = @_;
  return $WALL{ ($n ? NORTH : 0)
              | ($e ? EAST : 0)
              | ($s ? SOUTH : 0)
              | ($w ? WEST : 0) } || '+';
}

sub get_at {
  my ($x, $y) = @_;
  return undef if $x < 0 or $y < 0;
  return undef if $x > $max_x or $y > $max_y;
  return $grid->[$y][$x];
}

my @output;

for my $y (0 .. $max_y+1) {
  my $row = q{};

  my $filler;

  for my $x (0 .. $max_x+1) {
    my $ne = get_at($x    , $y - 1);
    my $se = get_at($x    , $y    );
    my $sw = get_at($x - 1, $y    );
    my $nw = get_at($x - 1, $y - 1);

    my $n = (defined $ne && ! ($ne & WEST ))
         || (defined $nw && ! ($nw & EAST ));
    my $e = (defined $se && ! ($se & NORTH))
         || (defined $ne && ! ($ne & SOUTH));
    my $s = (defined $se && ! ($se & WEST ))
         || (defined $sw && ! ($sw & EAST ));
    my $w = (defined $sw && ! ($sw & NORTH))
         || (defined $nw && ! ($nw & SOUTH));

    if ($opt->debug) {
      printf "(%u, %u) -> NE:%2s SE:%2s SW:%2s NW:%2s -> (%s %s %s %s) -> %s\n",
        $x, $y,
        (map {; $_ // '--'  } ($ne, $se, $sw, $nw)),
        (map {; $_ ? 1 : 0 } ($n,  $e,  $s,  $w)),
        wall($n, $e, $s, $w);
    }

    $row .= wall($n, $e, $s, $w);

    if ($x > $max_x) {
      # The rightmost wall is just the right joiner.
      $filler .=  wall($s, 0, $s, 0);
    } else {
      # Every wall but the last gets post-wall spacing.
      $row .= ($e ? wall(0,1,0,1) : ' ') x $opt->width;
      $filler .=  wall($s, 0, $s, 0);
      $filler .= ' ' x $opt->width;
    }
  }

  push @output, $row;
  if ($y <= $max_y) {
    push @output, ($filler) x $opt->height;
  }
}

say for @output;
```

