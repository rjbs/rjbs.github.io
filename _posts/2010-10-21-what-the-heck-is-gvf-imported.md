---
layout: post
title : what the heck is GVf_IMPORTED?
date  : 2010-10-21T13:40:25Z
tags  : ["perl", "programming", "wtf"]
---
I was happy to learn about this bizarre flag in Perl, even though it took a lot
of aggravation to learn it.

All code snippets below should be assumed to include strictures.

    BEGIN {
      package Source;
      use Exporter 'import';
      our @EXPORT = qw(*var);
      our $var = 10;
    }

    package Destination;
    BEGIN { Source->import; }

    print $var;

The program above prints 10.  This is probably not surprising to anyone.  We
have some package, `Source`, which exports its `var` symbol, which has 10 in
its scalar value.  `Destination` imports that symbol and prints it.  Because
the symbol was imported, we don't have to fully-qualify the name or declare it
with `our`.

What `Exporter` does is a simple glob assignment, like this:

    *Destination::var = *Source::var;

...so it should be easy to take Exporter out of the equation:

    BEGIN {
      package Source;
      our $var = 10;
    }

    package Destination;
    BEGIN {
      *Destination::var = *Source::var;
    }

    print $var;

This blows up!

    Variable "$var" is not imported at - line 10.
    Global symbol "$var" requires explicit package name at - line 10.
    Execution of - aborted due to compilation errors.

Well, we never had to declare when it *was* imported, and why is it bringing up
importing anyway?  We did exactly the same thing!

Well, it turns out there's a tiny difference...

    BEGIN {
      package Source;
      our $var = 10;
    }

    package Destination;
    BEGIN {
      package Source;   # <----- that is really, really important
      *Destination::var = *Source::var;
    }

    print $var;

If a glob in your package has a value because it was assigned from outside the
package, the variable is marked with the flag GVf_IMPORTED and you can use it
without a declaration even under strict.  If it was assigned *within* your
package, you need to declare.  I used `Source` for the assigning package in the
sample above, but it can be anything other than the destination package.  For
example, when you use Exporter, the assignment happens in Exporter::Heavy.

Amusingly enough, this is how `use vars` works.  When you say:

    package X;
    use vars qw($foo @bar);

...it is equivalent to:

    BEGIN {
      package vars;
      *X::foo = \$X::foo;
      *X::bar = \@X::bar;
    }

Really!  Go read the source.

This seems like a weird way for this to work, and like it was a hack added for
one purpose and abused for another.  I'd hoped to find an explanation of the
reasoning for it, but the flag entered perl's source code in a massive commit
apparently reconstructed from four months of changes in 1994.  (It's commit
[a0d0e21ea6ea90a22318550944fe6cb09ae10cda](http://perl5.git.perl.org/perl.git/commitdiff/a0d0e21ea6ea90a22318550944fe6cb09ae10cda)).

