---
layout: post
title : "pod people versus elementalists"
date  : "2008-10-25T18:08:07Z"
tags  : ["perl", "pod", "programming"]
---
A long time ago, I wanted to write [something to let my pod (documentation)
contain its own coverage
hints](http://search.cpan.org/dist/Pod-Coverage-TrustPod/).  I gave up when I
found out that it was not going to be trivial to say something like this:

```perl
my @blocks = PodParser->read_file($my_perl_module)->data_for('coverage');
```

In order to extract "foo\nbar" from:

```perl
sub foo { ... }

=begin coverage

foo
bar

=end coverage
```

I found ways, but they all bugged me.  I gave up on the project for a long
time, because it was a real
[yak](http://www.szabgab.com/blog/2008/10/1224765950.html), but eventually I
came back to it when I realized how much pod manipulation I'd want in
[Dist::Zilla](http://search.cpan.org/dist/Dist-Zilla/).  I really wasn't happy
with how Pod::Simple worked.  Dieter had contributed a bit to Pod::Simple, and
had talked about writing a more TreeBuilder-like interface.  There were a
number of significant blockers, though, and I didn't want to get hung up on
them.  Instead, while walking to McGrady's for ABE.pm, I had an idea and called
Dieter to brainstorm with him.  Basically, the idea can now be summarized as "I
should write [Pod::Eventual](http://search.cpan.org/dist/)."

Pod is really great.  It's so easy to write that I know I write much, much more
documentation that I would if I had to produce, say, a `chm` file.  It's a
very, very simple format, and is complex enough to handle almost everything
I've ever needed from it.  My problems have been that I want to write even less
and have it rewritten for me, so I can avoid boilerplate.

The root problem is that pod has both very simple and very complex parts.
Here are some of the simple things:

* a pod document is made up of paragraphs
* paragraphs are separated by blank lines (but 'cut' commands are special)
* pod can be interwoven with non-pod in a document
* pod paragraphs are either:
    * commands (start with =)
    * verbatim (start with whitespace)
    * text (start with anything else)
* the non-whitespace characters after the = in a command are the command

So, knowing this is about enough to write a tolerable pod paragraph parser for
most uses.  Sure, it misses a lot of encoding stuff, but adding that later (I
believe) is not a big issue.

It omits two very, very big things.  First of all, it ignores the *content* of
text paragraphs.  That means that I've said nothing about what `F<markup>`
means.  This is a big obnoxious problem, and I have absolutely zero interest in
tackling it.  Hooray for punting, right?

The second problem is that it assumes that all pod documents are sequences of
paragraphs.  In fact, this is true.  The problem is that on top of the
syntax of paragraphs, there are paragraph semantics that make this, for
example, an illegal document:

```perl
=pod

=item * Isn't this simple?

=end
```

We have an `=item` outside of an `=over` and an `=end` outside of a `=begin`.
Wait... outside?  If a pod document is just a sequence of paragraphs, how does
containment work?

Well, it doesn't.

It is fairly obvious that the `begin` and `over` commands set up containment.
They have start commands and end commands, and anything between the two is
contained "inside" the block.  Unfortunately, there's a lot of implicit
containment in how many pod formatters relate the document to the reader.  For
example, look at how the [Sub::Exporter
Cookbook](http://search.cpan.org/dist/Sub-Exporter/lib/Sub/Exporter/Cookbook.pod)
is presented.  `head2` items are presented, in table of contents, as being
contained by the `head1` items.  You'd also like to think that the text and
verbatim paragraphs that occur between two `head1` paragraphs are contained by
the first.  Unfortunately, that isn't how it works, and it isn't really clear
how it should work.  What items cause the end of a container?  What items can
contain themselves?

Again, I originally punted.  Pod::Eventual just produces the sequence of
events.  For the things I wanted to do, however, I needed structure.  I wanted
to be able to make a `head1` *thing* and put `head2` or other *things* inside
of it.  (Actually, in Pod::Weaver, the technical term for these is
"[thingers](http://search.cpan.org/dist/Pod-Weaver/lib/Pod/Weaver/Weaver/Thingers.pm)".)

Dieter had long since abandoned his work on pod stuff, so I stole (with his
blessing) the name for my pod event-to-tree transformer:
[Pod::Elemental](http://search.cpan.org/dist/Pod-Elemental/).  It reads in a
document that contains pod and returns a sequence of roots of trees that
represent the document's pod.  The logic by which they're formed into a
structure is contained in the Nester, and anyone can write his own nester to
use whatever nesting logic he thinks makes the most sense.

[Pod::Weaver](http://search.cpan.org/dist/Pod-Weaver/) uses Pod::Elemental to
turn a Perl document (using PPI) into a just-Perl document and a collection
just-Pod elements.  The elements are then reorganized and rewritten, in part by
looking at the Perl and in part by using plugins and provided input.
Dist::Zilla uses Pod::Weaver to add a name-and-abstract section, a license
section, to build methods and attributes sections, and to do other stuff like
that.  It works very well, assuming you don't mind minor explosions while I
rejigger the API every other day.

Right now, I know that I have ignored a *lot* of what is demanded by
[perlpodspec](http://perldoc.perl.org/perlpodspec.html).  Frankly, I intend to
keep ignoring a bunch of it.  My goal is to let people work with pod paragraph
syntax without worrying about the syntax of paragraph content or of the
semantics of paragraph ordering -- until they want to.  The default
Pod::Elemental::Nester, for example, will barf if you try to give it an `=end`
outside matching `=begin`.  Pod::Eventual, however, doesn't care.

Pod::Elemental doesn't care about other things, though, like the magic attached
to `=begin` (data) blocks whose identifiers begin with a colon.  Why?  It's
just about slinging around paragraphs, not around understanding meaning.

I'm definitely planning on adding quite a bit more standards-compliance to
Elemental.  For one thing, I want to get `=encoding` hashed out and improve the
interface for the element tree.  Even Eventual needs some help.  For example, I
think it gets the definition of a blank line (which divides paragraphs) wrong,
and I'd like to change how it understands the lines between `=cut` and a blank.

Still, though, I'm very happy with what I have and how simply I got it.  I
*definitely* would not recomment writing a pod-to-text converter using any of
this code, but for writing a pod preprocessor, I've found it really great.

