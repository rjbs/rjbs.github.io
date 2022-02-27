---
layout: post
title : "astounding optimization! thanks nytprof!"
date  : "2008-11-12T02:34:01Z"
tags  : ["perl", "programming"]
---
We've been unhappy with the performance of some code, recently.  I was pretty
sure I knew where the problem was, but I thought I'd run NYTProf just to see
how things looked.  I'm running an older NYTprof, so it's not 100% clear that
my SQL-level optimization is what I need to do -- but it's the right thing to
do anyway.  Anyway, I figured I might see something sort of interesting, but I
never expected this:

    Calls     InclTime   ExclTime     Subroutine
     27,908        406        406     DBI::st::execute
    543,412         79         31     Carp::caller_info

...and let's not go any further.  The program took almost exactly 600s to run.
Of that, nearly five percent was because the program called *Carp*, and it
called it *a half million times*!  **What?!**

I won't be coy, because I'm writing this while waiting for a test suite to run
and while watching House.  It turns out that it was related to this line:

    Calls     InclTime   ExclTime     Subroutine
    139,340        222          6     SUPER::get_all_parents

That subroutine looks like this:

    sub get_all_parents {
      my ($invocant, $class) = @_;

      my @parents = eval { $invocant->__get_parents() };

      unless ( @parents ) {
        no strict 'refs';
        @parents = @{ $class . '::ISA' };
      }

      return 'UNIVERSAL' unless @parents;
      return @parents, map { get_all_parents( $_, $_ ) } @parents;
    }

See how it calls `$invocant->__get_parents`?  Well, that's great, except that
our internal ORM has an AUTOLOAD subroutine that looks like this:

    sub AUTOLOAD {
      my $self = $_[0];
      my $class = (ref $self) || $self;
      (my $method = $AUTOLOAD) =~ s/.*:://;
      return if $method eq "DESTROY";
      unless (blessed($self)) {
        confess qq(AUTOLOAD: \$self for ->$method is not a blessed reference: )
          . Dumper($self);
      }

      ...
    }

Now, to avoid hitting the database too much, we have a mixin that makes it talk
to a memcached.  That mixin (like many such modules) uses SUPER.pm.
SUPER then calls `__get_parents` on our ORM, but hits the `AUTOLOAD` instead,
and since that's only supposed to work on objects, it confesses.  It does this
every time we check consider using a cached copy of an object, causing us to
invoke `Carp::confess` a half million times.

The solution?  I added this line to our ORM:

    sub __get_parents { return; }

Shaved two minutes off the test case.  That's about 20%.

