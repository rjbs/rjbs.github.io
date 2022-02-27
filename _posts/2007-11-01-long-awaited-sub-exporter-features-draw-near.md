---
layout: post
title : long-awaited sub::exporter features draw near
date  : 2007-11-01T13:40:05Z
tags  : ["perl", "programming"]
---
Since the very, very early days of Sub::Exporter, it was clear that it would be
really useful to be able to replace the way that exporting itself occurs.  That
is: the way that routines are generated and installed, based on configuration,
gathered collections, and other user arguments to the generated `import`
method.

In the past, it was possible to replace this, but only by relying on an
(intentionally) awful and undocumented interface.  The routine worked something
like this:

1. build an arrayref of (thing, import-as) pairs
2. call `_do_import` on each one
3. `_do_import` cleans up the pair and some associated configuration
4. `_do_import` calls the "exporter"
5. the default exporter calls `_generate` to build the installable routine
6. the default exporter calls `_install` to install the routine
7. next pair

The "exporter" is the thing that was supposed to be pluggable.  In fact,
Sub::Exporter::Util contains an alternate exporter.  The problem was that the
interface stank, and I didn't want to publish an interface until I had one I
liked... but the possible uses are huge.  I use it in the Sub::Exporter test
suite to test what would have been done, basically letting me instrument the
system.  Dieter and I were talking about making a way to gather information
about what has exported where for a kind of cheap metadata about what roles
have been built where, and how.  (This would be needed as part of my
long-standing mixin factory idea, and as part of the roles stuff Dieter wants
to work on.)

Finally, spurred on by outside demand (that is, Dieter), I made a first pass at
implementation last night.  I think it's pretty good!

Now:

1. build an arrayref of (thing, import-as) pairs
2. call `_do_import` on arrayref
3. `_do_import` calls the *generator* for each pair, generating a new arrayref
4. `_do_import` the exporter, passing the new arrayref and some other info
5. the default exporter installs the routine
6. next pair

Now there are two publicly defined callbacks that can be provided, either for
your whole exporting package (passed as part of the `-setup` for Sub::Exporter)
or per call to `import`, as part of the optional initial hashref.

I'm hoping to see and create some fun new behaviors.

This code is on the CPAN as [Sub::Exporter
0.977_01](http://search.cpan.org/dist/Sub-Exporter).  It's a big step toward
1.000.

