---
layout: post
title : notes on how pod::weaver works
date  : 2009-08-21T03:29:26Z
tags  : ["perl", "pod", "programming"]
---
Originally, I conceived of Pod::Weaver as a system that took two Pod streams
and wove them together.  One was the Pod that the user wrote.  The other was
Pod generated based on some stuff.  (That's about as concrete as the idea was.)
This got rewritten a bit and interleaved, and poof, you had better Pod.

Pod::Weaver was about a weaving-together of multiple threads, hence the name.
That's still basically how PodPurler works, and it's fine, but it doesn't have
much of a future.

The new design, which I've been working on, is much more output-centered.  The
program is given an output template, which it attempts to render using a number
of inputs.  Here's an example output template (still very much a notion and not
an implemented thing):

    [Abstract]
    [Version]
    [Synopsis]
    [Description]
    [Accordion / fronter]
    [Attributes]
    [Methods]
    [Authors]
    [Maintainers]
    [Copyright]

So, Pod::Weaver's goal is to build a document with those sections.  Each of
those sections is produced by a plugin (a "weaver") that knows how to produce
content given inputs.  There are a few kinds of inputs.  For example, some
weavers need a "module info" input.  The "Abstract" weaver wants to produce
this Pod:

    =head1 NAME

    Some::Module - what it does

To do that, it needs a module name and abstract.  The "Version" weaver needs
similar input.  "Attributes," on the other hand, could get inputs from a other
places.  It could look at an existing Pod document to find `=head2` commands
under `=head1 ATTRIBUTES` or it could look for `=attr` commands.  It could also
look at a compiled version of the package to inspect for metaobject
information.  (This will get us Moose autodoc, for example.)

Accordion sections are tricky (and were called out as such in the original
grant proposal) because they require a cursor in the input Pod, and probably
also a per-node marking of "already consumed."  The accordion section lets you
say, "anything that isn't interesting to another weaver that occurs at the
corresponding point to this place in the source document."  That lets your
source document put a `=head1 BY THE WAY...` after its synopsis and have it
show up in your output.

In the event that accordion sections grow to complex to implement, I have an
alternate plan, which is to say something like:

    [Subsection / postsynopsis]

This would weave in the contents found inside a `=begin postsynopsis` block, so
that you could add arbitrary content there by wrapping it in begin/end markers.
This avoids a lot of confusion with a pretty low cost.  Still, I'd like to
avoid even that low cost for authors by spending some time up front now.

So, next steps:  rewrite the Pod::Weaver framework to load configuration
something like that above (using Config::MVP) and emit Pod::Elemental or
Pod::Eventual data.  For now, I can start by only consuming the configuration
and a Dist::Zilla object as input, and maybe a Module object of some sort.
This can actually produce a lot of good test cases.

After that, I can implement something to find and "consume" bits of an input
Pod document to get the synopsis, methods, and so on.  Then I can tack on
remaining on somewhere.  Dealing with proper placement will be the tricky part,
but it can be done.

All this should make it possible to also put of dealing with Pod nesting, which
has been the most annoying thing I've had to deal with in all this code.  I
have ideas on how to sort it out, but I'd rather make progress than just noodle
around.

