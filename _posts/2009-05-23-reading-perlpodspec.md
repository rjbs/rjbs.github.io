---
layout: post
title : reading perlpodspec
date  : 2009-05-23T18:59:38Z
tags  : ["perl", "pod", "programming"]
---
I've begun work on my Pod-munging grant.  My first real task has been reviewing
[perlpodspec](http://perldoc.perl.org/perlpodspec.html), which is the most
useful document one can read about writing a Pod parser.  It's a bit
unstructured, but for the most part it's clear, unambiguous, and useful.

One of the things I'm doing to make my life easy is to avoid considering
*formatting codes* at all.  Formatting codes are those things in angle brackets
in pod, like `I<<use the C<force> method>>`.  Since I'm only concerned about
producing event streams and trees of Pod paragraphs, I can ignore formatting
codes entirely without losing much.  It would be possible, later, to build
something atop this code to handle formatting codes, but I sure don't plan on
doing it!

The only tiny edge case I've wondered about is:

    This is a B<

    very

    > big idea!

The spec does not address this edge directly, but I'm pretty sure I can ignore
it as garbage.  (I'm working on a list of feedback on the spec, and this point
will be in it.)

So, to see how much of a difference it makes to exclude formatting codes from
my plans, let's look at the spec.  I printed out a copy this morning, and it
was 24 pages.  They break down roughly like this:

    overview of paragraph syntax    |   2 pages
    overview of defined =commands   |   2 pages
    overview of formatting codes    |   3 pages
    misc. notes on implementing     |   5 pages (about 2 on formatting codes)
    specific quirks of the L<> code |   4 pages
    notes on =over, =back, =item    |   3 pages
    notes on =begin, =end, =for     |   5 pages

So, by totally ignoring formatting codes, I can ignore about nine pages of the
spec.  That's more than a third of it.  What's better, those pages contain some
of the most complicated parts of the spec.  Dealing with things like `L<>` and
`S<>` is not fun, and for the most part it's only important to formatters.  I'm
not looking to implement formatting tools, so I can punt and let existing
formatters do the job they've been designed to do.

The place where Pod::Elemental had previously gotten tied up was in the
interaction of the Nester and Document classes.  I believe that my closer
reading of `perlpodspec` today has really helped me form a good plan on how to
deal with this.

The things I'd been thinking of as "subdocuments" in Pod are better imagined as
"regions," which is a term that the spec itself uses.  Regions can be isolated
immediately after event production and then dealt with as atomic (or not) units
within the pre-nested element collection -- the Document.  I'll need to put
this into practice, but I think it will work well.

So far, the only case that I'm finding somewhat annoying in my plans is this
one:

    =begin data

    =head1 Not a header.

    =end data

Since `data` doesn't start with a colon, the contents of the region are not
Pod.  Because of that, `=head1` can't represent a header.  Instead of being a
data paragraph beginning with `=head1`, however, the paragraph is invalid Pod.
This means that you can't have Pod-like content inside a non-Pod region.  I
suppose this is an attempt to prevent errors like:

    =begin y

    =begin x

    =end y

    =end x

    =end y

...but I can't say I'm a big fan.  Still, it's a pretty unlikely use, so I
think I can live with it.

My next step is probably going to be the creation of a "blank line" event for
Pod::Eventual.  I'm hoping to to handle region checking in Eventual, if I can
help it, so I'll need to be able to have blank lines on hand to reconstitute
data paragraphs that were broken during a first-pass parse.  If that works,
Pod::Eventual can remain entirely event-based, with no concept of nesting.

