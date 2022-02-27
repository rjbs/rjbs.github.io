---
layout: post
title : "Dist::Zilla and line numbering"
date  : "2014-01-14T16:22:29Z"
tags  : ["perl", "programming"]
---
brian d foy wrote a few times lately about potential annoyances distributed
across various parties through the use of Dist::Zilla.  I agree that
Dist::Zilla can shuffle around the usual distribution of annoyances, and am
happy with the trade offs that I think I'm making, and other people want
different trade offs.  What I don't like, though, is adding annoyance for no
gain, or when it can be easily eliminated.  Most of the time, if I write
software that does something annoying and leave it that way for a long time,
it's actually a sign that it doesn't annoy *me*.  That's been the case,
basically forever, with the fact that my Dist::Zilla configuration builds
distributions where the `.pm` files' line numbers don't match the line numbers
in my git repo.  That means that when someone says "I get a warning from line
10," I have to compare the released version to the version in git.  Sometimes,
that someone is me.  Either way, it's a cost I decided was worth the
convenience.

Last week, just before heading out for dinner with
[ABE.pm](http://abe.pm.org/), I had the sudden realization that I could
probably avoid the line number differences in my shipped dists.  The
realization was sparked by a little coincidence: I was reminded of the problem
*just* after having to make some unrelated changes to an unsung bit of code
responsible for creating most of the problem.

### Pod::Elemental::PerlMunger

Pod::Weaver is the tool I use to rewrite my sort-of-Pod into actual-Pod and to
add boilerplate.  I really don't like working with Pod::Simple or Pod::Parser,
nor did I like a few of the other tools I looked at, so when building
Pod::Weaver, I decided to also write my own lower-level Pod-munging tool.  It's
something like HTML::Tree, although much lousier, and it stops at the paragraph
level.  Formatting codes (aka "interior sequences") are not handled.  Still,
I've found it very useful in helping me build other Pod tools quickly, and I
don't regret building it.  (I sure would like to give it a better DAG-like
abstraction, though!)

The library is Pod::Elemental, and there's a tool called
[Pod::Elemental::PerlMunger](https://metacpan.org/pod/Pod::Elemental::PerlMunger)
that bridges the gap between Dist::Zilla::Plugin::PodWeaver and Pod::Weaver.
Given some Perl source code, it does this:

1. make a PPI::Document from the source code
2. extract the Pod elements from the PPI::Document
3. build a Pod::Elemental::Document from the Pod
4. pass the Pod and (Pod-free) PPI document to an arbitrary piece of code,
     which is expected to alter the documents
5. recombine the two documents, generally by putting the Pod at the end of the
     Perl

The issue was that step two, extracting Pod, was deleting all the Pod from the
source code.  Given this document:

    package X;

    =head1 OVERVIEW

    X is the best!

    =cut

    sub do_things { ... }

...we would rewrite it to look like this:

    package X;

    sub do_things { ... }
    __END__
    =head1 OVERVIEW

    X is the best!

    =cut

...we'd see `do_things` as being line 9 in the pre-munging Perl, but line 3 in
the post-munging Perl.  Given a more realistic piece of code with interleaved
Pod, you'd expect to see the difference in line numbers to increase as you got
later into the munged copy.

I heard the suggestion, many times, to insert `# line` directives to keep the
reported line numbers matching.  I *loathed* this idea.  Not only would it be
an accounting nightmare in case anything else wanted to rewrite the file, but
it meant that the line numbers in errors wouldn't match the file that the user
would have installed!  It would make it harder to debug problems in an
emergency, which is *never* okay with me.

There was a much simpler solution, which occurred to me out of the blue and
made me feel foolish for not having thought of it when writing the original
code.  I'd rewrite the document to look like this:

    package X;

    # =head1 OVERVIEW
    #
    # X is the best!
    #
    # =cut

    sub do_things { ... }
    __END__
    =head1 OVERVIEW

    X is the best!

    =cut

Actually, my initial idea was to insert stretches of blank lines.  David Golden
suggested just commenting out the Pod.  I implemented both and started off
using blank lines myself.  After a little while, it became clear that all that
whitespace was going to drive me nuts.  I switched my code to producing
comments, instead.  It's not the default, though.  The default is to keep doing
what it has been doing.

It works like this:  PerlMunger now has an attribute called C<replacer>, which
refers to a subroutine or method name.  It's passed the Pod token that's about
to be removed, and it returns a list of tokens to put in its place.  The
default replacer returns nothing.  Other replacers are built in to return blank
lines or commented-out Pod.  It's easy to write your own, if you can think of
something you'd like better.

Karen Etheridge suggested another little twist, which I also implemented.  It
may be the case that you've got Pod interleaved with your code, and that some
of it ends up after the last bits of code.  Or, maybe in some documents, you've
got *all* your Pod after the code, but in others, you don't.  If your concern
is just keeping the line numbers of code the same, who cares about the Pod that
won't affect those line numbers?  You can specify a C<post_code_replacer> for
replacing the Pod tokens after any relevant code.  I decided not to use that,
though.  I just comment it all out.

### PkgVersion

Pod rewriting wasn't the only thing affecting my line numbers.  The other thing
was the insertion of a `$VERSION` assignment, carried out by the core plugin
PkgVersion.  Its rules are simple:

1. look for each `package` statement in each Perl file
2. skip it if it's private (i.e., there's a line break between `package` and
     the package name)
3. insert a version assignment on the line after the `package` statement

...and a version assignment looked like this:

    {
      $My::Package::VERSION = '1.234';
    }

Another version-assignment-inserter exists,
[OurPkgVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::OurPkgVersion).
It works like this:

1. look for each comment like `# VERSION`
2. put, on the same line:  `our $VERSION = '1.234';`

I had two objections to just switching to OurPkgVersion.  First, the idea of
adding a magic comment that conveyed no information, and served only as a
marker, bugged me.  This is not entirely rational, but it bugged me, and I knew
myself well enough to know that it would keep bugging me forever.

The other objection is more practical.  Because the version assignment uses
`our` and does not wrap itself in a bare block, it means that the lexical
environment of the rest of the code differs between production and test.  This
is not likely to cause big problems, but when it does cause problems, I think
they'll be bizarre.  Best to avoid that.

Of course, I could have written a patch to OurPkgVersion to insert braces
around the assignment, but I didn't, because of that comment thing.  Instead, I
changed PkgVersion.  First off, I changed its assignment to look like this:

    $My::Package::VERSION = '1.234';

Note:  no enclosing braces.  They were an artifact of an earlier time, and
served no purpose.

Then, I updated its rules of operation:

1. look for each `package` statement in each Perl file
2. skip it if it's private (i.e., there's a line break between `package` and
     the package name)
3. skip forward past any full-line comments following the `package` statement
4. if you ended up at a blank line, put the version assignment there
5. otherwise, insert a new line

This means that as long as you leave a blank line after your package statement,
your code's line numbers won't change.  I'm now leaving this code after the
`# ABSTRACT` comment after my package statements.  (Why do the VERSION comments
bug me, but not the ABSTRACT comments?  The ABSTRACT comments contain more data
— the abstract — that can't be computed from elsewhere.)  Now, this can still
fall back to inserting lines, but that's okay, because what I didn't include in
the rules above is this:  if configured with `die_on_line_insertion = 1`,
PkgVersion will throw an exception rather than insert lines.  This means that
as I release the next version of all my dists, I'll hit cases once in a while
where I can't build because I haven't made room for a version assignment.
That's okay with me!

I'm very happy to have made these changes.  I might never notice the way in
which I benefit from them, because they're mostly going to prevent me from
having occasional annoyances in the future, but I feel good about that.  I'm so
sure that they're going to reduce my annoyance, that I'll just enjoy the idea
of it now, and then forget, later, that I ever did this work.


