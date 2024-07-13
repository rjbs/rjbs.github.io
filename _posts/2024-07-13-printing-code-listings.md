---
layout: post
title : "I still like printing code listings"
date  : "2024-07-12T12:00:00Z"
tags  : ["programming"]
image : /assets/2024/07/vim.png
---

I used to program on paper, then type it in later.  Not all the time, but
sometimes.  Sometimes I'd write pseudocode.  Sometimes I wrote just the code I
would type in later.  Sometimes just flow charts and subroutine signatures.
These days, I only really do the last version, because I always have a computer
nearby now.  I'm not stuck in a boring lecture, for example, with only a legal
pad.

Back then, and later, I'd also review code on paper.  This was before I was
doing formal "code review" for work.  Sometimes I just wanted to look at my own
code, out of the context of my computer, and think about it.  Sometimes I
wanted to look at somebody else's code.  Either way, putting it on paper was
really useful.  I could read it away from the rest of the distractions of my
computer, and I could draw circles and arrows in a bunch of different colors.

The way I did it, then, was to use Vim's `:hardcopy` command.  Like the rest of
Vim, it has [slightly strange but actually very good
documentation](https://vimdoc.sourceforge.net/htmldoc/print.html).  I worked on
Windows in the early 2000s, and I could enter `:ha` and get a printout.
Sometimes, though, I'd use [the `a2ps`
program](https://www.gnu.org/software/a2ps/) instead.  That was a bit more work
to use, but it produced better listings (as I recall), especially because it
would print two pages of code on one piece of paper, while remaining quite
legible.

Over time, I printed code less often.  This was partly, but not entirely,
because I was coding less.  Lately, I've been coding a bit more.  On top of
that, I do a lot of it sitting not twenty feet from [Mark
Dominus](https://blog.plover.com/), who seems to print out nearly every hunk of
code he reviews.  This has brought back memories of how much I got out of
printing code.  It also led to him asking me a question or two about `a2ps`
that left me a little surprised and embarrassed that I had forgotten how to use
it well.

Over the last twenty four hours, I've tried to get back up to speed, and to
find (and simplify) a method for printing code listings on demand.  This blog
post is a bit of a recounting of that work, and what I found.

## PostScript

I wanted to start with `a2ps` but I have to write a prelude about PostScript.

The "a" in `a2ps` stands for "any".  The idea is that you feed it basically any
kind of source code (or plain text) and it will build a PostScript file for
printing.  [PostScript](https://en.wikipedia.org/wiki/PostScript) is a
programming language created by Adobe and used (mostly but not entirely) to
drive printers.  It's a bit of a weird language, but it's postfix and
stack-based, so I have a soft spot in my heart for it.  You can see three books
on PostScript on shelf three in my [post about my technical bookshelf]({%
post_url 2024-01-15-bookshelf-snapshot %}).  Ten years ago, showing the kid
different kinds of programming, we wrote this program:

```postscript
/text {
  /Times-Roman findfont exch scalefont setfont
} def

newpath 24 text 200 400 moveto
        (You're standing on my neck!) show

newpath 284 284 72 0 360 arc stroke
newpath 265 300 12 0 360 arc fill
newpath 303 300 12 0 360 arc fill
newpath 250 225 moveto 275 225 lineto
        275 200 lineto 250 200 lineto
        250 225 lineto stroke
newpath 275 225 moveto 300 225 lineto
        300 200 lineto 275 200 lineto
        275 225 lineto stroke

newpath 300 225 moveto 325 225 lineto
        325 200 lineto 300 200 lineto
        300 225 lineto stroke
```

It draws a skull with the caption "You're standing on my neck!".  Try it!

But how?  Well, in theory you can send it directly to your printer with `lp`,
but on current macOS (unlike older versions) you will get this error:
**Unsupported document-format “application/postscript”.**

I'm not sure exactly where the problem lies.  My suspicion is that it's in the
CUPS service that serves as the mediator between the user and the printer on
macOS.  Probably I could get around this by using mDNS and
[IPP](https://en.wikipedia.org/wiki/Internet_Printing_Protocol), and honestly I
am tempted to go learn more.  But there was a simpler solution:  `ps2pdf`
converts a PostScript program to a PDF file.  It's shipped with
[Ghostscript](https://www.ghostscript.com/) and is easy to get from
[Homebrew](https://brew.sh/).

PDF is actually based on PostScript, but I don't know the details.  PostScript
has also been used for rendering graphical displays, using a system called
Display PostScript (DPS), which was developed by both Adobe and NeXT, and later
became the basis for the MacOS X display system.  So, why doesn't macOS support
PostScript well anymore?  Honestly, I don't know.

Anyway: lots of the things I tried using for printing output PostScript, which
is meant to be easy to send on to the printer.  With `ps2pdf` installed,
printing these files isn't so hard.  It's just a drag that they can't be send
right to the `lp` command.

## a2ps

Right, back to a2ps!  Given a piece of source code, it will spit out a
PostScript program representing a nice code listing.  Unfortunately, running it
out of the box produced something pretty awful, and I had to fumble around a
good bit before I got what I wanted.  I didn't save a copy, so if you want to
see it, you can try to reproduce it on your own.  The problems included being
off center, running off the page margins, using a mix of different typefaces in
one source listing, using awful colors, and probably other stuff.  So, I had to
consult the manual.  Unfortunately, I started doing that by running `man a2ps`,
immediately hitting the problem that has infuriated geeks for decades:  I got a
pretty mediocre man page with a footnote saying the real docs were in Texinfo.
And `info` isn't installed.

Eventually I found myself reading the [a2ps manual as a
PDF](https://www.gnu.org/software/a2ps/manual/a2ps.pdf) on the web.  With that
(and with some help from Mark), I found that much of what I needed would come
down to putting this in `~/.a2ps/a2psrc`:

```
Options: --medium=letter
Options: --line-numbers 1
Options: --prologue color
```

This set my paper size, turned on line numbering on every line, and said that I
wanted highlighting to be expressed as color, not just font weight.

There were two problems that I could not get over:

1. Typeface mixing!  Everything was in fixed text except for literal strings,
   which were (to my horror) represented in a proportional font.
2. Awful colors.  For example, subroutine names were printed in black on a
   bright yellow background.  Probably some people think this is fine.  I did
   not.  (The a2ps manual admits: "It is pretty known that satisfying the
   various human tastes is an NEXPTIME-hard problem.")

So, how to fix it?  By hacking on a PostScript file!

a2ps combines (roughly) two things to build the final PostScript program: the
prologue, and the program.  (There's also the header ("hdr"), but that's
included directly by the prologue.  Let's not split hairs.)

The program is a series of PostScript instructions that will print out your
listing.  The prologue is a set of function definitions that the program will
used.  The `a2ps` binary (written in C) reads your source document, tokenizes
it for syntax highlighting, and then emits a program.  For example, here's a
hunk of output for the Perl code that I'll be using in all the samples in this
post.

```postscript
0 T () S
(sub) K
( ) p
(richsection) L
( \(@elements\) {) p n
(185) # (  Slack::BlockKit::Block::RichText::Section->new\({) N
0 T (    elements => _rtextify\(@elements\),) N
0 T (  }\);) N
0 T (}) N
0 T () N
(190) # () S
```

The parentheses are string delimiters, and because PostScript is a postfix
language, when you see `(richsection) L` it's calling the function `L` with the
string "richsection" on the stack.  True, there may be other things on the
stack, but I happen to know that `L` is a one-argument function.  It looks like
this:

```postscript
/L {
  0 0 0 FG
  1 1 0 true BG
  false UL
  false BX
  fCourier-Bold bfs scalefont setfont
  Show
} bind def
```

This prints the string on the stack to the current position on the page *in
black on bright yellow*.  Yuck.  This function comes from the "color" prologue,
which is installed in `share/a2ps/ps`.  There's no way to change parameters to
it, so the recommended practice is to copy it into `~/.a2ps` and edit that.
This would be more horrifying if there were new version of a2ps coming out with
notable changes, but there aren't, so it's … fine.

I hacked up a copy of `color.pro` and changed the prologue option in my
configuration file to `rjbs.pro`.  I renewed my PostScript programmer
credentials!  While doing this, I also fixed the typefaces, replacing
Times-Roman with Courier in the definition of `str`, the string literal
display function.

This got me some pretty decent output, shown here, and linked to a PDF:

[![a page of code from a2ps](/assets/2024/07/a2ps.png)](/assets/2024/07/a2ps.pdf)

By the way, all the samples in this post will be from formatting [this copy of
Slack::BlockKit::Sugar](https://github.com/rjbs/Slack-BlockKit/blob/0.002/lib/Slack/BlockKit/Sugar.pm).

This was fine, but I had two smaller problems:

1. The syntax highlighting is a bit anemic (but not so bad).
2. The line spacing is a little tight for me.

Fixing the first one means editing the "style sheet" for Perl.  This isn't like
CSS at all. It doesn't define the style, it defines how to mark up tokens as
being one thing or another.  The functions in the prologue will do the styling.
I looked at what might be worth putting here as a sample, but I think if you
want to see what they look like, you should check out [the perl.ssh file
itself](https://github.com/akimd/a2ps/blob/master/sheets/perl.ssh).  It's fine,
but it's also obvious that making it better would be an ordeal.  I bailed.

Fixing line spacing felt like it should be easy, though.  Surely there'd be an
option for that, right?  Sadly, no.  I decided to use my PostScript expertise
to work.  Here's the `N` function, which renders a line and moves to the next
position:

```postscript
/N {
  Show
  /y0 y0 bfs sub store
  x0 y0 moveto
} bind def
```

`bfs` is the "body font size".  We're moving a little down the page by reducing
the `y` position of the cursor by the font size.  What if we did this?

```postscript
/y0 y0 bfs 1.1 mul sub store
```

That should add a 10% line spacing increase, right?  Well, yes, but the problem
is this: remember how the `a2ps` binary is responsible for spitting out the
PostScript program?  That's where it computes how many lines per page.  By
mucking with the vertical spacing, we start running off the end of the page.
We need to change the number of lines that `a2ps` puts on the page.  No
problem, we'd just tweak this code:

```c
job->status->linesperpage =
  (int) ((printing_h / job->fontsize) - BOTTOM_MARGIN_RATIO);
```

…at which point I realized I had to install `automake`.  I did, and I went a
few steps further, and finally gave up.  It was too annoying for a Saturday.

What if instead I changed the default style?  I won't bore you with the
PostScript, but I made a new function, `vbfs`, defined as 0.9 of `bfs`.  I
updated all the rendering functions to use that value for size, but the full
value was still used for line spacing.  This worked!  But changing the font
size mean that I was ending up with horizontal dead space. I was scaling
everything down, when all I wanted to scale up was the *vertical space*.  It
was unsatisfactory, and I decided to settle for the tight line spacing.

…for about five minutes.  And then I decided to try the *other* GNU program for
turning source code into PostScript.

## enscript

[GNU Enscript](https://www.gnu.org/software/enscript/) bills itself as "a free
replacement for Adobe's enscript program".  I don't know what that was, but I
can tell you that `enscript` is basically "`a2ps`, except different".  It
serves the same function.  I fed it the same hunk of code, but not before
reading the manual and finding `--baselineskip`, which is exactly what I
wanted: a way to control line spacing.  I used this invocation:

```
enscript lib/Slack/BlockKit/Sugar.pm \
  --columns=2       \
  --baselineskip=2  \
  --landscape       \
  --color           \
  --highlight       \
  --line-numbers    \
  --output Sugar.ps
```

It looked pretty good at first, when looking at the first page of output (not
pictured here).  On the other hand, here's page three:

[![a page of code from enscript](/assets/2024/07/enscript.png)](/assets/2024/07/enscript.pdf)

The line spacing is nice (and maybe nicer when cranked up), and the colors
aren't offensive.  But they're all wrong.  Part of the issue is that this
source is using `=func` as if it was a real Pod directive, which it isn't.  On
the other hand, it's real enough that Perl will ignore the enclosed
documentation.  Syntax highlighting should start at `=func` and end at `=cut`.
The syntax definition for Perl in `enscript` is very strict, and so this is
wrong.  And that means that the documentation's syntax highlighting ends up all
wrong all over the place.  It's unusable.

Syntax highlighting in `enscript` is different than `a2ps`'s style sheets.
Instead, it's programmed with a little "state" language.  You can read the
[Perl state
program](http://git.savannah.gnu.org/gitweb/?p=enscript.git;a=blob;f=states/hl/perl.st;h=161dae131a7850e9a591ec2a1a94ccab35b1e84d;hb=refs/heads/master),
but I'm not sure I recommend it.  It's relatively inscrutable, or at least it
is written in terms of some other functionality that doesn't seem well
documented.  Fixing the Pod thing seemed trivial, but all I could imagine was
an endless stream of further annoyance.  Maybe this isn't fair, but it's where
I ended up.

At this point, settling on `a2ps` might have been a good idea, but instead I
moved on to Vim.

## Vim :hardcopy

Way up at the top of this post, I mentioned that I had used Vim in the past.
So, why not now?  Well, reasons.  The first one is that I didn't remember how,
and I knew that "it didn't work anymore".  But I was in for way more than a
penny by now, so I went further down the rabbit hole.

It turned out that "it didn't work anymore" was trivial.  I was getting this
error:

```
E365: Failed to print PostScript file
```

Right.  Because `lp` doesn't handle PostScript anymore.  I could just write the
PostScript file to a file, then apply `ps2pdf`.  I did so, and it was bad.
The good news was that getting from bad to *okay* wasn't so hard.  I had to set
some `printoptions` in Vim.

```vim
set printoptions=paper:letter,number:y,left:5pc
```

This sets my paper size (which I'd already had in my `.vimrc` actually!), turns
on line numbering, and reduces the left margin to 5%.  The default left margin
was 10%, which was just way too much.  It's nice to have space to write, but I
usually do that in the whitespace on the right side of the code.  To print to a
file in Vim, you can execute `:hardcopy > filename.ps`.  With these settins, I
got this output:

[![a page of code from Vim](/assets/2024/07/vim-1.png)](/assets/2024/07/vim-1.pdf)

The main problem here is that it's one-up.  Only one page of code per sheet of
paper.  It's easy to read, but it takes twice as much paper.  It's a waste, and
also leads to more desk clutter than necessary.  My desk is enough of a mess as
it is.

Fortunately, there's a solution for this!  The slightly obscure `mpage` command
reads a PostScript document in, then spits out another one that's multiple
pages per sheet.  It hasn't quite fallen off the web, but it's not extremely
well published.  Here's [a link to its man
page](https://www.cs.cmu.edu/~mbz/personal/xnix/mpage1.html) hosted at a fairly
random-seeming location at CMU.  Fortunately, it's in Homebrew.  I could take
the PDF above and run this:

```
mpage -2 -bLetter -S Sugar.ps > Sugar2.ps && ps2pdf Sugar2.ps
```

The `-S` option there is fairly critical.  It says "allow non-square scaling".
In theory this might introduce some distortion, but I can't notice it, and it
gets a better use of space on the page.  I also go back to my `printoptions` in
Vim and set *all* the margins to `0pc`.  Since `mpage` will be adding a margin
when it produces the two-up pages, I don't need any margin on the pages it's
combining.  I get four more lines per page, plus more space on the right of
each listing.

Here's what we get:

[![a page of code from Vim, sent through mpage](/assets/2024/07/vim.png)](/assets/2024/07/vim.pdf)

I wasn't sure how to get a better set of colors.  I'm pretty sure it's
possible, but I'll have to think about it and play around.  There is a
**very large benefit** here, though.  The syntax highlighting that I get in the
PDF will be based on the same syntax highlighting that I'm used to seeing every
day in Vim.  I know nothing is critically wrong, and if there *was*, I'd be
very motivated to fix it, because I'd be seeing it every day in my editor!

The real problem, for fixing the colors, is that I use a dark-background color
scheme in Vim.  Printing tries to emulate your color scheme, but has to correct
for the fact that it's going to print on white paper.  The real answer is to
have an alternate color scheme ready for printing.

Still, I'm pretty happy with this.  All that remained was to make it really
easy.  So, I wrote a [stupid little Perl
program](https://github.com/rjbs/rjbs-vim-dots/blob/main/bin/libexec/vim-print-helper)
that finds a PostScript file on disk, runs it through `mpage`, then `ps2pdf`,
then puts it on the Desktop and opens it in Preview.  Then I updated my Vim
configuration to make `:hardcopy` send print jobs to that instead of `lp`.  It
looks like this:

```vim
set printexpr=ByzantinePrintFile()
function ByzantinePrintFile()
  call system("/Users/rjbs/bin/libexec/vim-print-helper "
    \.. v:fname_in
    \.. " "
    \.. shellescape(expand('%:t'))
  \)
  call delete("v:fname_in")
  return v:shell_error
endfunc
```

Vim script is still weird.

This is where I'll stop, feeling content and full of PostScript.  I think for
many people, all this PostScript nonsense would leave a bad aftertaste.  For
them, there's another option…

## Vim 2html.vim

Vim ships with a helper file called `2html.vim`, which exports the current
buffer as HTML, using the settings and colors currently in use.  You can enter
this in your Vim command line:

```vim
runtime! syntax/2html.vim
```

…and you'll get a new Vim buffer full of HTML.  The parity with the Vim display
is impressive.

[![HTML output and Vim side by side](/assets/2024/07/vim-html.png)](/assets/2024/07/vim-html.png)

The problem is that so far, I've found going from HTML to a two-up PDF is too
much of a pain.  Possibly there's some weird route from HTML to PostScript to
piping through `mpage` but I think I'll leave that adventure for another day or
another dreamer.  Me, I've got printing to do.
