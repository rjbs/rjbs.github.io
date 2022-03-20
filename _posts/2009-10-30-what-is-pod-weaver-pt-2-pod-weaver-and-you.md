---
layout: post
title : "what is pod weaver? (pt. 2: pod weaver and you)"
date  : "2009-10-30T21:47:09Z"
tags  : ["perl", "pod", "programming"]
---
So, yesterday I [wrote about Pod::Weaver's history]({% post_url
2009-10-30-what-is-pod-weaver-pt-1-secret-origins %}).  Today, the much more
useful topic of "how to use it now that it exists."

I try to write classes that define objects in terms that you can think about as
actual objects: machines that perform a given task.  A Pod::Weaver object is a
machine that expects to be given some source material from which to build a
Pod::Elemental::Document.  That's really all it does.  It has a method called
`weave_document` that performs that function, and everything else is a kind of
constructor or support method.

There are a few kinds of common input to Pod::Weaver: preexisting Pod
documents, PPI (Perl source) documents, Software::License objects, and a few
other kinds of data.  The exact data required are determined by the plugins
loaded into the Weaver object itself.  The Weaver object doesn't actually
produce any output itself.  Instead, it delegates all of that work to its
plugins.

If you're familiar with Dist::Zilla's plugin system, then you'll understand
Pod::Weaver's.  It's the same basic idea:  there are several phases in the
process of weaving a document, and plugins can perform roles (by composing
`Moose::Role`s into their definition).  Here is most of the code in the
Weaver's `weave_document` method:

```perl
$self->plugins_with(-Preparer)->each_value(sub {
  $_->prepare_input($input);
});

$self->plugins_with(-Dialect)->each_value(sub {
  $_->translate_dialect($input->{pod_document});
});

$self->plugins_with(-Transformer)->each_value(sub {
  $_->transform_document($input->{pod_document});
});

$self->plugins_with(-Section)->each_value(sub {
  $_->weave_section($document, $input);
});

$self->plugins_with(-Finalizer)->each_value(sub {
  $_->finalize_document($document, $input);
});
```

A single plugin can perform as many of these roles as it wants.  The most common role to perform (so far) is Section.  A section is expected to look at the input and, based on the input, tack content on to the end of the output document.  One plugin that performs multiple roles is Collect, which will turn:

```perl
=method whatever

This is the whatever method.

=method other_one

This is the other_one method.
```

...into...

```
=head1 METHODS

=head2 whatever

This is the whatever method.

=head2 other_one

This is the other_one method.
```

It does this by first acting as a Transformer, altering the input Document to
look like plain old Pod5 where the `=method` commands are seen, and then acting
like a Section to find and include the METHODS section.

Configuring a Pod::Weaver object requires that you decide what plugins you need
to get from your input to your desired output.  Right now, most users are using
Pod::Weaver to more or less emulate the original Pod-munging tasks of
Dist::Zilla.  They're using the default configuration of Pod::Weaver, and you
can get a Weaver with the default configuration by calling the
`new_with_default_config` constructor on Pod::Weaver.  Otherwise, you can
configure by hand or write a config file that can be loaded by Config::MVP. The
most common format for that is INI.  Here's a sample:

```ini
[@CorePrep]

[Name]
[Version]

[Region  / prelude]

[Generic / SYNOPSIS]
[Generic / DESCRIPTION]
[Generic / OVERVIEW]

[Collect / ATTRIBUTES]
command = attr

[Collect / METHODS]
command = method

[Leftovers]

[Region  / postlude]

[Authors]
[Legal]
```

In general, you can read this as a description of what the output document will
look like.  Everything is a section to produce, many of them "generic," which
means they're just all the stuff after a `=head1` command with the right name.
The only non-section is `@CorePrep`, which is a bundle containing two simple
transformations: conversion of raw, generic Pod elements into Pod5 elements;
and nesting of content under nearby `=head1` commands.  (Neither of these
plugins does the Section role.)

You can write your own configuration file easily, and you can write your own
plugins just about as easily.  Look at the source of the existing plugins to
see how simple they are.

So, now you know what Pod::Weaver does and how you configure it.  The next
question is how to put it to use.  If you use Dist::Zilla, this is really easy!
All you have to do is add this line to your `dist.ini` or other config file:

```ini
[PodWeaver]
```

That's it.  You'll get the stock configuration.  If you'd rather write your
own, you can drop a `weaver.ini` file in your distribution's directory.  If
you've written your own plugin bundle to configure Pod::Weaver the way you
like, you can say:

```ini
[PodWeaver]
config_plugin = @RJBS
```

That would set up Pod::Weaver with Pod::Weaver::PluginBundle::RJBS -- the
configuration I'm using.

That's about as easy as it's going to get.  If you don't want to use
Dist::Zilla, though, you can build your own Pod-weaving tool by using the
[Pod::Elemental::PerlMunger](http://search.cpan.org/perldoc?Pod::Elemental::PerlMunger)
role.  It helps build a class that expects to be handed the contents of a Perl
module and other inputs, and then hands back a new string containing the
rewritten Perl source.  It uses Pod::Elemental and PPI to pull the Pod out of
the Perl (if possible), transform them as needed, and then recombine them into
one string that does not change the behavior of the module's code.  To write a
tool built on PerlMunger, you just need a class that includes the PerlMunger
role and provides a `munge_perl_string` method with the following semantics:

```perl
my $output_doc = $obj->munge_perl_string(\%input_doc, \%other_input);
```

The input documents hash has entries for `ppi` and `pod`, which will contain
the PPI::Document and Pod::Elemental::Document built from the input string. The
output is a hashref with the same keys, which will be reconstituted into a new
string of Perl.

The PerlMunger role alters the semantics of that method for outside callers,
who will write:

```perl
my $new_perl_string = $obj->munge_perl_string($input_string, \%other_input);
```

This makes it easy to write something like this:

```perl
package MyMunger;
use Moose;
use autodie;

sub munge_file {
  my ($self, $filename) = @_;

  open my $input_fh, '<', $filename;
  my $string = do { local $/; <$input_fh> };

  my $new_string = $self->munge_perl_string($filename, { ... });

  open my $output_fh, '>', $filename;
  print {$output_fh} $new_string;
}

my $weaver = Pod::Weaver->new_from_config; # supply your config here

sub munge_perl_string {
  my ($self, $input_doc, $input) = @_;

  my $doc = $weaver->weave_document({
    %$input,
    ppi_document => $input_doc->{ ppi },
    pod_document => $input_doc->{ pod },
  });

  return {
    ppi => $input_doc->{ppi},
    pod => $doc,
  };
}

with 'Pod::Elemental::PerlMunger';
1;
```

Then you can write a little program:

```perl
use MyMunger;

MyMunger->munge_file($_) for @ARGV;
```

It might not be the safest thing in the world, but the simplicity of writing
the program should be pretty apparent.  Now imagine bundling that into your
build procedure, or just a plain old pod-munging program.  After all, a Pod
document with no Perl content is still a valid Perl program, so you can use
PerlMunger to munge pure-Pod strings, too -- it will only barf if the nonpod
sections are not valid Perl.

I'm hoping to see people outside the Dist::Zilla user base get decent use out
of Pod::Weaver.  Even if that doesn't materialize, though, I think it was
absolutely worth the time and effort.  It greatly reduces the amount of time I
waste writing the boring, boilerplate Pod in my distributions, which makes it a
lot easier for me to get basic documentation written, which helps keep my
contributions to CPAN fun to write and usably by other people.
