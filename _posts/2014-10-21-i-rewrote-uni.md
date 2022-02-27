---
layout: post
title : I rewrote uni
date  : 2014-10-21T14:49:48Z
tags  : ["perl", "programming", "unicode"]
---
For years, I've used [Audrey Tang's uni](https://metacpan.org/pod/App::Uni)
program for [stupid things](http://perladvent.org/2011/2011-12-24.html).  It
helps you find Unicode characters:

    $ uni ☺
    263A ☺ WHITE SMILING FACE

    # Only on Perl 5.14+
    $ uni wry
    1F63C 😼 CAT FACE WITH WRY SMILE

I've never been super happy with searching.  All of the args to the program are
joined on space and searched for.  That means that `uni roman five` won't find
`ROMAN NUMERAL FIVE`.  I also used to like using Carl Masak's little
HTML+JavaScript unicode deconstructor.  This thing would let you type in a
string, and it would display each codepoint.  I've long since lost it… and
anyway, I didn't want to use a web browser.  I thought that maybe [Tom
Christiansen's Unicode-Tussle
tools](https://metacpan.org/release/Unicode-Tussle) would have the answer, but
nothing quite did what I wanted.

After fidgeting unhappily for about ten minutes, I realized that I could've
used those ten minutes to write my own solution.  I'm sure it's awful in some
way, but I'm very pleased with it, and maybe someone else will be, too.

It has four modes:

### Single Character Mode

    $ uni SINGLE-CHAR

This will print out the name and codepoint of the character.

    $ uni ¿
    ¿ - U+000BF - INVERTED QUESTION MARK

### Name Search Mode

    $ uni SOME /SEARCH/ TERMS

This one will look for codepoints where each term appears as a (`\b`-bounded)
word in the name.  If the term is bounded by slashes, it's treated as a regular
expression and is used to filter candidate codepoints by name.

    $ uni roman five
    Ⅴ - U+02164 - ROMAN NUMERAL FIVE
    Ⅾ - U+0216E - ROMAN NUMERAL FIVE HUNDRED
    ⅴ - U+02174 - SMALL ROMAN NUMERAL FIVE
    ⅾ - U+0217E - SMALL ROMAN NUMERAL FIVE HUNDRED
    ↁ - U+02181 - ROMAN NUMERAL FIVE THOUSAND

### String Decomposition

    $ uni -c SOME STRINGS

This prints out the codepoints in each string, with a blank line between each
argument's codepoints.

    $ uni -c Hey リコ
    H - U+00048 - LATIN CAPITAL LETTER H
    e - U+00065 - LATIN SMALL LETTER E
    y - U+00079 - LATIN SMALL LETTER Y

    リ- U+030EA - KATAKANA LETTER RI
    コ- U+030B3 - KATAKANA LETTER KO

### Lookup By Codepoint

    $ uni -u NUMBERS IN HEX

This prints out the codepoint for each given hex value.

    $ uni -u FF 1FF 10FF
    ÿ - U+000FF - LATIN SMALL LETTER Y WITH DIAERESIS
    ǿ - U+001FF - LATIN SMALL LETTER O WITH STROKE AND ACUTE
    ჿ - U+010FF - GEORGIAN LETTER LABIAL SIGN

-----

My [uni program](https://github.com/rjbs/misc/blob/master/uni) is now on GitHub (update: and now [on the CPAN](https://metacpan.org/release/App-Uni))
or, for those who are curious, but not curious enough to click a link, it's
right here:

    #!perl
    use 5.12.0;
    use warnings;

    use charnames ();
    use Encode qw(decode);
    use Unicode::GCString;

    binmode STDOUT, ':encoding(utf-8)';

    my $todo;
    $todo = \&split_string if @ARGV && $ARGV[0] eq '-c';
    $todo = \&codepoints   if @ARGV && $ARGV[0] eq '-u';

    shift @ARGV if $todo;

    die "only one swich allowed!\n" if grep /\A-/, @ARGV;

    @ARGV = map {; decode('UTF-8', $_) } @ARGV;

    $todo //= @ARGV == 1 && length $ARGV[0] == 1
            ? \&one_char
            : \&search_chars;

    $todo->(@ARGV);

    sub one_char {
      print_chars(@_);
    }

    sub split_string {
      my (@args) = @_;

      while (my $str = shift @args) {
        my @chars = split '', $str;
        print_chars(@chars);

        say '' if @args;
      }
    }

    sub print_chars {
      my (@chars) = @_;
      for my $c (@chars) {
        my $c2 = Unicode::GCString->new($c);
        my $l  = $c2->columns;

        # I'm not 100% sure why I need this in all cases.  It would make sense in
        # some, since for example COMBINING GRAVE beginning a line becomes its
        # own extended grapheme cluster (right?), but why does INVISIBLE TIMES at
        # the beginning of a line take up a column despite being printing width
        # zero?  The world may never know.  Until Tom tells me.
        # -- rjbs, 2014-10-04
        $l = 1 if $l == 0; # ???

        # Yeah, probably there's some insane %*0s$ invocation of printf to use
        # here, but... just no. -- rjbs, 2014-10-04
        my $p = $c . (' ' x (2 - $l));

        my $chr  = ord($c);
        my $name = charnames::viacode($chr);
        printf "%s- U+%05X - %s\n", $p, $chr, $name;
      }
    }

    sub codepoints {
      my (@points) = @_;

      my @chars = map {; chr hex s/\Au\+//r } @points;
      print_chars(@chars);
    }

    sub search_chars {
      my @terms = map {; s{\A/(.+)/\z}{$1} ? qr/$_/i : qr/\b$_\b/i } @_;

      my $corpus = require 'unicore/Name.pl';
      die "somebody beat us here" if $corpus eq '1';

      my @lines = split /\cJ/, $corpus;
      my @chars;
      LINE: for my $line (@lines) {
        my $i = index($line, "\t");
        next if rindex($line, " ", $i) >= 0; # no sequences

        $line =~ $_ || next LINE for @terms;

        push @chars, chr hex substr $line, 0, $i;
      }

      print_chars(@chars);
    }

