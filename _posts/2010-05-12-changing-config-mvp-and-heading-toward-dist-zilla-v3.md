---
layout: post
title : changing Config::MVP and heading toward Dist::Zilla v3
date  : 2010-05-12T11:48:44Z
tags  : ["distzilla", "perl", "programming"]
---
The following is a message I recently sent to the Dist::Zilla mailing list:

Config::MVP is the mass of moving parts behind the config loader that does most
of the work turning your dist.ini into a set of plugins.  For months, now, I
have had a good idea about how Config::MVP needs to be extended to make a lot
of significant improvements to Dist::Zilla possible.

Today, I've implemented most of those changes, and I will probably implement
more soon.  After that, I can begin making use of the new features in
Dist::Zilla, which will probably get a v3 release in the coming weeks.

Config::MVP has three main parts:  Sections, which are (name, associated
package, hashref payload); Sequences, which are ordered lists of Sections with
unie names; and the Assembler, which is a simple state machine used to build a
Sequence.  The Sequence is the "final product" that represents the loaded
config.

So far, no MVP object required an object above it.  That is, you could have a
Section outside a Sequence and a Sequence with no Assembler.  This has changed
somewhat in my master branch, as of now.  Now, all three objects can be marked
"finalized," and a Section cannot be finalized unless it was placed into a
Sequence.  More importantly, a Section has a reference to the sequence it was
placed in, and a Sequence has a reference to the Assembler constructing it.

This is important because it makes the following possible:

    package DZilSection;
    use Moose;
    extends 'Config::MVP::Section';

    after finalize => sub {
      my ($self) = @_;
      $self->sequence->assembler->zilla->register_plugin($self);
    };

That's just a sketch, but I hope it's clear: plugins will be able to
self-register immediately during loading, and if necessary perform other
operations.

Also, it will make the following vital configuration possible:

    [AwesomePlugin]
    :version = 1.23

...which will cause something like this:

    $seq->section_named('AwesomePlugin')->package->VERSION(1.23);

There is another implication of the above code:  the Dist::Zilla object can
(must!) exist before configuration is done being read.  This means all core
attributes will become, in one way or another, deferrable and settable via
plugin.

Non-phase-plugin sections will also be able to do things.  For example,
sections will exist that represent just hunks of data, possibly validated or
made into objects, but not contributing to the build-like operations.  These
will get their own lookup, with fallbacks to global configuration.  So, you can
say:

    $zilla->config_section('Foo')->...

...and you'll get the Foo section from your dist.ini, and if that's not there,
you'll get the one from global config -- falling back to either nothing or a
master default, like the default :Plugins currently supplied.  This mechanism
will be used for things like PAUSE credentials and default copyright/license
data for minting new dists, making profiles much more reusable by multiple
users.  (It'll also finally mean that `dzil new` can be documented without
looking half-baked.)

Finally, bundles may change.  Rather than immediate transformation into
sections, bundle processing will probably end up processing each Bundle as its
own section, complete with finalization, and a side effect of that finalization
will be the unshifting of synthetic input (the bundle_config) onto a
to-be-created MVP config queue.  The biggest benefit of this change is the
ability to inspect the Dist::Zilla object and report what bundles were actually
loaded and in what order.  This will help the MetaConfig plugin paint a more
complete picture.

That's my whole update for the night, but I'm very excited about these changes,
and I hope you will be, too.


