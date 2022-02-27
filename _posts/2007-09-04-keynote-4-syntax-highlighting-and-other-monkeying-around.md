---
layout: post
title : "keynote 4, syntax highlighting, and other monkeying around"
date  : "2007-09-04T15:52:54Z"
tags  : ["apple", "keynote", "macosx", "rtf", "software", "syntax"]
---
I was pretty sure I was going to buy iWork '08 before it was announced.  Every
version of Keynote has had a few improvements that made it worth having, even
though I only produce two or three slideshows a year.  Keynote 4 adds a feature
I've often wanted: the ability to make an object on a slide move around.  I've
wanted to use this for code samples:  I'd create a text box with code in it,
then put a rectangle on top of it, translucent and one line high, and have that
move from one important line to the next.

I've already tried this, and I think it works pretty well.  I'm a little
disappointed that I can't have it grow to twice its height while doing this,
but the only action that would come close is scale.  I don't want to scale the
box, I want to change one dimesion.

This brings me to the one big issue that I have with Keynote.  Its AppleScript
support, as far as I can tell, really sucks.  Now, this is a big improvement
from Keynote 1.0, in which there was no scriptability.  There still isn't much.
It focuses mainly on automating the playing of slideshows.  It would be nice to
have a way to alter the contents of the slide.  I can set the "body" property,
but setting up the body text area is sort of annoying and stupid.  Worse, I can
only set the content of the body not, as far as I can tell, its formatting.

I don't really want to set any formatting except for the coloring, but I can't
do that with AppleScript.  I will probably have to resort to generating RTF or
(ugh) PDF (via LaTeX) and then putting it on the slide.

See, I want to syntax highlight my code samples, at least some of the time, and
probably most of the time.  Doing this by hand is problematic and painful,
especially if I realize, later, that I need to change a small problem on fifty
similar but different slides.

My current best hope is to marry RTF::Writer and
Syntax::Highlight::Engine::Kate, which so far looks something like this:

    my $str = '';
    my $hl  = Syntax::Highlight::Engine::Kate::Perl->new;
    my $rtf = RTF::Writer->new_to_string(\$str);

    my %color = (
      _default => [ 0, 0, 0 ],
      Keyword  => [ 0, 0, 255 ],
    );

    my %color_pos;
    my @colors;

    for (keys %color) {
      my @rgb = @{ $color{ $_ } };

      my $pos = $color_pos{ @rgb };

      unless (defined $pos) {
        push @colors, \@rgb;
        $pos = $color_pos{ @rgb } = $#colors;
      }

      $color_pos{ $_ } = $pos;
    }

    $rtf->prolog(
      fonts  => [ 'Courier New' ],
      colors => [ sort ],
    );

    while (my $in = <>) {
      my ($text, $type) = $hl->highlight($in);
      my $pos = $color_pos{ $type } // $color_pos{ _default };

      $rtf->print(
        \"\\cf$pos",
        \'\fs40\b\i',  # 20pt, bold, italic
        $text,
      );
    }

    $rtf->close;

    print $str;

It needs some work, but the big problem I have now is that input that looks
like this:

    $obj->method

Comes out like this:

    $obj>method

There's some kind of escaping of the dash, turning it into a backslashed
underscore.  I've sent the Sean Burke an email, but I'll probably have a look
at the code and spec myself soon.

Even if I can't parlay this into a syntax highlighter for Keynote, maybe I'll
end up with a good syntax highlighting engine that outputs to RTF.  I guess
that might be useful.

