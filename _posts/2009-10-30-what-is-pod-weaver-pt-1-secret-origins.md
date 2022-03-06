---
layout: post
title : "what is pod weaver? (pt. 1: secret origins)"
date  : "2009-10-30T04:54:10Z"
tags  : ["perl", "pod", "programming"]
---
One or two people who write Pod regularly said, "Yeah, I saw you blogging about
that Pod thing.  I had no idea what you were talking about."  A few other
people said, "neat, but how do I use it?"  Its documentation is getting better,
but here's a crash course in its history.  Tomorrow I'll write about its
application (and maybe later I can turn this into some real docs).

Pod is Perl's in-source documentation system.  It has a very simple syntax,
muddy simple-but-weird semantics, and a lot of conventions as to how Perl
module documentation is written for distribution through the CPAN.  Its syntax
is usually tolerable, but some constructs are way too verbose.  Its conventions
can be tiresome because they involve lots of extra typing all over the place.

I wrote [Dist::Zilla](http://search.cpan.org/dist/Dist-Zilla) as a way to
greatly reduce the amount of typing and boilerplate needed to build CPAN
distributions, and part of what I wanted to do was eliminate boilerplate
documentation.  My first passes through this was mostly regex-based.  It pulled
all the Pod out of the Perl source with
[PPI](http://search.cpan.org/dist/PPI) and then played around with them as
strings.  It did a pretty reasonable job on a lot of things, but adding more
stuff to it was nightmare because it really just was a pile of code.

I knew I needed a real Pod parser, so I looked at Pod::Simple and Pod::Parser
but both were way more than I needed.  They were hard (for me) to understand
and they seemed to really focus on the semantics rather than the syntax.  For
example, I needed to think about how to do things like add the notion of
`=method` to the parser rather than just get a "some kinda command."  So I
decided that it would be really easy to make an event-driven parser for Pod,
especially if I stuck to the linewise layer (rather than the inline layer where
things like `B<bold>` live).  I pitched my idea to Dieter, who told me I was
not crazy, and that led to Pod::Eventual.  It only understood two kinds of
events: command and everything else.  Now there are four: command, text,
non-Pod, and blank line.  The only command it actually understands beyond "it's
a command" is `=cut`, which is effectively the only Pod command that has to be
understood differently no matter what.

The first thing I built was something to just give me a reified event stream.
With that, I could muck with the document more easily than strings, but I knew
I'd want structure.  That is, when I moved the thing containing `=head1
METHODS`, a top-level header, I wanted to move all the plain text it included
as well as all the lower-level headers.

The problem is that Pod doesn't really have much in the way of native
structure.  I agonized over exactly what nested when, delaying progress for a
long time.  Finally, I decided I wanted something like a document tree that I
could put together based on whatever fancy struck me, rather than something
where the nesting of elements was dictated by the parser.  

This led me to the kind of design Pod::Elemental has now:

* Pod::Eventual::Simple hands me the events as hashrefs
* Pod::Elemental::Objectifier turns each event into an object

...and now you have an array of paragraphs, probably collected in a Document
object.  You can already turn them back into a Pod string, but probably you
want to apply just a little amount of standard meaning: you want `=begin`
regions marked off and you want verbatim paragraphs marked as such, so:

* Pod::Elemental::Transformer::Pod5 applies the "normal" Pod semantics

The Pod5-transformed document tree is much easier to play around with because
it eliminates the need to track blank lines and estabishes structure by marking
off begin/end regions.  With that done, other transformations are really easy
to apply, like:

* nest anything other than regions and head1 under preceding head1s
* replace weird commands with Pod5-safe commands (like =method with =head2)
* decide how to handle regions; leave them in place or translate them to Pod5

Once you've done all your transformation, you can just turn things into a Pod
string again.

The next step in the toolchain is Pod::Weaver.  It's a system that lets you
describe all the transformations you want to perform on an input document as
well as what kind of output you want to guarantee in an output document.  For
example you can say "the input document will have its `=method` commands
gathered up and put under a `=head1 METHODS` command."  Then you can say "at
this point in the output document, we will put a `=head1 METHODS` section, if
we found it in the input."

What I was really pleased to discover was that once Pod::Elemental was all
working, Pod::Weaver was almost trivial.  It helped that I had a lot of code I
could re-use from other places to build its plugin and configuration system.
It helped that I'd spent a lot of time thinking about the way sections would
work.  Even so, there's just so little to it.  All most section generating
plugins have to do is create a Pod::Elemental::Element and push it onto the
output document's contents.

Now that it's so easy to write new section generators and add them to my
templates, the future of Pod::Weaver is probably all in writing plugins.  I
really want to write one to generate a "thanks" section for sponsors and
contributors.  I'm hoping to get code that will generate documentation by
inspecting the Class::MOP and Moose meta-object systems.  I want to write a few
more special commands like `=list` and I want to write a few more dialects so I
can `=begin Markdown` and maybe `=begin KindaPod6`.

So, [tomorrow I'll show how you can use and configure Pod::Weaver either using
Dist::Zilla or by writing your own document-munging tool]({% post_url 2009-10-30-what-is-pod-weaver-pt-2-pod-weaver-and-you %}).  For now, it is way,
way past my bedtime.
