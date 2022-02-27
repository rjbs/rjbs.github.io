---
layout: post
title : pod::elemental approaches first major resting point
date  : 2009-10-19T03:58:48Z
tags  : ["perl", "pod", "programing"]
---
After numerous jerks and stops,
[Pod-Elemental](http://search.cpan.org/dist/Pod-Elemental) is about as useful
as it has to be for work on Pod::Weaver to really build up some steam.

It's well past my bed time, here, but I wanted to do a quick run through of
what it can now do.

First, I have it read in the very basic Pod events from a document and convert
them into elements.  This is exercising only the [most basic dialect of
Pod](http://rjbs.manxome.org/rubric/entry/1763).  If I load in this document
and then dump out its structure (using Pod::Elemental's `as_debug_string` code)
I get this:

    Document
      =pod
      |
      (Generic Text)
      |
      =begin
      |
      (Generic Text)
      |
      =image
      |
      =end
      |
      =head1
      |
      =head2
      |
      =method
      |
      (Generic Text)
      |
      =over
      |
      =item
      |
      =back
      |
      =head2
      |
      (Generic Text)
      |
      =head3
      |
      =over
      |
      =item
      |
      =back
      |
      =head1
      |
      (Generic Text)
      |
      =begin
      |
      (Generic Text)
      |
      (Generic Text)
      |
      =end
      |
      =method
      |
      (Generic Text)
      |
      =cut

All those pipes are "Blank" events.  Everything else is either a text paragraph
or a command.  There's nothing else structural.  We feed that document to the
Pod5 translator, which eliminates the need for blanks, understands the context
of various text types, and deals with `=begin/=end` regions.  It takes runs of
several text elements separated by blanks and turns them into single text
elements.

    Document
      (Pod5 Ordinary)
      =begin :dialect
        (Pod5 Ordinary)
        =image
      =head1
      =head2
      =method
      (Pod5 Ordinary)
      =over
      =item
      =back
      =head2
      (Pod5 Ordinary)
      =head3
      =over
      =item
      =back
      =head1
      (Pod5 Ordinary)
      =begin comments
        (Pod5 Data)
      =method
      (Pod5 Ordinary)

So, already this is more readable.  That goes for dealing with the structure,
too, because we've eliminated all the boring Blank elements.  Now we'll feed
this to a Nester transformer, which can be set up to nest the document into
subsections however we like.  This is useful because Pod has no really clearly
defined notion of hierarchy apart from regions (and lists, which I have not
handled and probably don't need to).

    Document
      (Pod5 Ordinary)
      =begin :dialect
        (Pod5 Ordinary)
        =image
      =head1
        =head2
      =method
        (Pod5 Ordinary)
        =over
        =item
        =back
        =head2
        (Pod5 Ordinary)
        =head3
        =over
        =item
        =back
      =head1
        (Pod5 Ordinary)
      =begin comments
        (Pod5 Data)
      =method
        (Pod5 Ordinary)

Now we've got a document with clear sections, but we've got these `=method`
events scattered around at the top level, so we feed the whole document to a
Gatherer transformer, which will find all the `=method` elements and gather
them under a container that we specify.  (Here we used a `=head1 METHODS`
command.)

    Document
      (Pod5 Ordinary)
      =begin :dialect
        (Pod5 Ordinary)
        =image
      =head1
        =head2
      =head1
        =method
          (Pod5 Ordinary)
          =over
          =item
          =back
          =head2
          (Pod5 Ordinary)
          =head3
          =over
          =item
          =back
        =method
          (Pod5 Ordinary)
      =head1
        (Pod5 Ordinary)
      =begin comments
        (Pod5 Data)

That still leaves us with `=method` elements, so we update the command on all
the immediate descendants of the newly-Gathered node and end up with a pretty
reasonable looking Pod5-compliant document tree:

    Document
      (Pod5 Ordinary)
      =begin :dialect
        (Pod5 Ordinary)
        =image
      =head1
        =head2
      =head1
        =head2
          (Pod5 Ordinary)
          =over
          =item
          =back
          =head2
          (Pod5 Ordinary)
          =head3
          =over
          =item
          =back
        =head2
          (Pod5 Ordinary)
      =head1
        (Pod5 Ordinary)
      =begin comments
        (Pod5 Data)

It doesn't round-trip, but that's the point.  We've taken a simple
not-quite-Pod5 document and turned it into a Pod5 document.  We've also got it
into a state where further manipulation is quite simple, because we've created
a tree structured nested just the way we want for our uses.

I think the next steps will be further tests for a while.  I need to deal with
parsing `=for` events a bit more, then I'll consider making `=over` groups
easier to handle.

At this point, I believe I could replace PodPurler's code with a Pod::Elemental
recipe.  I might even do that.  The real goal, now, is to start implementing
Pod::Weaver itself.  I think the way forward is clear!

