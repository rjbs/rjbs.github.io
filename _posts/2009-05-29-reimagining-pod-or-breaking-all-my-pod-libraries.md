---
layout: post
title : "reimagining pod (or: breaking all my pod libraries)"
date  : "2009-05-29T03:32:18Z"
tags  : ["perl", "pod", "programming"]
---
After reading `perlpodspec` a few times and trying to reconcile all my hopes
for my Pod-munging tools with the pretty restrictive rules of the spec, I have
come to imagine Pod as a nested set of layers of specification, almost like the
skin on an onion.  Go figure.

The most basic set of Pod that I care about turns out to be very, very basic.
It's all that Pod::Eventual is probably ever going to worry about, and right
now it's four kinds of events.

**Nonpod** events are all the stuff in your document that isn't Pod.  In most
cases, this is your Perl.  Nonpod comes in big hunks; each hunk is everything
from the last `=cut` to the next Pod event.

**Command** events are paragraphs (remember, Pod is paragraph-oriented, not
line-oriented) that start with a command like `=head1` or `=over` or `=method`.

**Blank** events are the blank lines between paragraphs.

**Text** events are everything else: the Pod paragraphs that have
non-whitespace in them but that don't start with a command.

I am currently considering making **cut** paragraphs, which would represent the
`=cut` command, which has slightly different syntax than others.

So, this totally ignores the notion of verbatim paragraphs (text paragraphs
where the content starts with whitespace) or `=begin/=end` regions or anything
else like that.  That is all up to the set of commands and additional semantics
that is supported.  I'm thinking of these, right now, as *dialects*.  I call
the one used by Perl5 "Pod5."

Pod::Elemental represents events as node objects, which can then be reformed,
nested, and sanity checked by libraries that correspond to dialects.  So, given
the following stream of events:

    nonpod
    =head1
    blank
    text
    blank
    text
    blank
    =begin foo
    text
    blank
    text
    blank
    =end foo
    blank
    =cut
    nonpod

...the Pod5 nester or dialect would produce the following document:

    nonpod
    =head1
    text
    text
    region foo
      data
    =cut
    nonpod

Another nester could probably take that input and transform it into:

    nonpod
    =head1
      text
      text
    region foo
      data
    =cut
    nonpod

Part of my earlier frustration with this problem was with questions of how to
nest things.  Pod5 only defines the notion of commands being responsible for
more than their own paragraph in three places: (1) all non-cut commands switch
the parsing mode from non-pod to pod; (2) =begin encloses all pod content until
a matching =end; and (3) =over encloses all pod content until a matching =back.

The original Pod::Elemental::Nester tried to do other clever things as well,
like associate text paragraphs with preceding headers and headers with
preceding higher-ranked headers.  That led to unclear questions like "does an
`=over` list fit inside a `head1`?  what about inside a `head4`?"  Worse, "how
do I know whether to nest a `=begin :Foo` region inside a header?"

Well, I can punt.  Pod5's nester only needs to handle the begin and over
commands.  Other nesters can be clever in their own special way.  I hope to
write a nester-helper (parameterized role, anyone?) that will accept a
description of a hierarchy to enforce.

Right now, I think it won't matter.  In practical terms, applying Pod5's nester
will deal with everything apart from new commands like `method` and `attr` that
I use with Dist::Zilla's PodPurler plugin.  Since those are dealt with by
*en masse* extraction and reinsertion, their place in the hierarchy isn't very
interesting.  I suppose the simplest strategy is to apply Pod5, then apply
"nest all text under immediately preceding command," then extract all things
like methods, then finish nesting, then reinject the Pod created from the
extracted methods and attributes.

I'm still feeling pretty good about the way things are progressing, but I'm
definitely starting to remember the weird design issues I slammed into last
time.  It's fun being forced to work through them, though.  I'm looking forward
to seeing how the end product will work.

