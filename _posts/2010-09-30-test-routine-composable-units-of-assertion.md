---
layout: post
title : Test::Routine: composable units of assertion
date  : 2010-09-30T19:15:09Z
tags  : ["perl", "programming", "testing"]
---
[Test::Routine](http://search.cpan.org/dist/Test-Routine) is a new system for
building reusable hunks of tests that can be written quickly as one-offs,
broken into modules for reuse, and that can use the large existing set of
`Test::` libraries from the CPAN.  It implements as few features as possible
and instead tries to let you use Moose's extensive and commonly-used object
system to get things done.

I used to use [Exception::Class](http://search.cpan.org/dist/Exception-Class/)
to write exception classes.  It handled setting up class hierarchies, adding
fields, and so on.  It made things pretty simple, but it was a one-off
class-building system with different semantics than every other class builder.
This wasn't a big problem, though, because all the class building systems I
used in 2004 were pretty mediocre.

When I started to really use
[Moose](http://search.cpan.org/dist/Moose) everywhere, though, I started to
chafe at the limitations of the Exception::Class model.  I wanted to build my
exception classes with Moose, so I wrote
[Throwable](http://search.cpan.org/dist/Throwable/), a very small hunk of code
to let you write exceptions easily using the Moose object system.  (I have some
plans to build atop it, but more on that another time.)

Lately, I've been having the same feelings about
[Test::Class](http://search.cpan.org/dist/Test-Class/).  It's a sort of
[xUnit](http://en.wikipedia.org/wiki/xUnit) testing framework for Perl, and it
lets you build your tests into reusable classes.  I've never been a heavy
user, because I've often found that the ways in which Test::Class classes can
be reused to be too limited and restrictive, and that it was always easier to
just write a test file than to write a simple starter Test::Class to build on
later.  That is: I'd always start with something other than Test::Class, and
then converting would be a pain.

On top of that, though, I've now been annoyed that my Test::Class tests (of
which I do have a significant number) are not built with Moose, so they're more
of a pain to refactor, write, extend, and improve.  I looked at the existing
test class frameworks that use Moose, and I didn't think any of them would make
me happy, so I thought about what the minimum set of features I'd need was to
write reusable tests with Moose.  I came to a decision and put together the
simplest thing that could possibly work.  To my delight, after writing a number
of use cases, I didn't feel like I needed much more.  I talked to a number of
other users of Test::Class and some other frameworks and got a little advice,
which I incorporated.  The result is
[Test::Routine](http://search.cpan.org/dist/Test-Routine), as first released
yesterday.

Probably the best demonstration of what Test::Routine is all about is [the
manual's demo
page](http://search.cpan.org/perldoc?Test::Routine::Manual::Demo).  Here's a
very quick overview, though.

      use Test::More;
      use Test::Routine;
      use Test::Routine::Runner;

      has dbh => (
        is   => 'ro',
        lazy => 1,
        default => sub { DBI->connect(...) },
      );

      test ensure_tables_present => sub {
        my ($self) = @_;
        
        my @tables = $self->dbh->...;

        is_deeply(
          [ sort @tables ],
          [ qw(items owners stuff) ],
          "we got all the tables we expect",
        );
      };

      test test_data_populated => sub {
        my ($self) = @_;

        my $data = $self->dbh->selectall_arrayref(...);

        is_deeply($data, [ ... ], "we have the test data we expect");
      };

      run_me;

      done_testing;

If you have a guess as to what happens here, you're probably right.  An object
gets built with the `dbh` attribute available and populated as needed.  Each of
the test methods (because those things after `test` become methods) is called
in the order they were declared, and each one is a subtest.

What isn't obvious is that behind the scenes, `use Test::Routine` has turned
the importing package (`main`, actually!) into a Moose role.  You can't make an
object directly out of a role, so when `run_me` gets called, it knows that it
needs to build a class, which it does by composing the test role with
Moose::Object to get a new, anonymous class.  This works, because we didn't
require any particular methods in the role.

We could, though, using more of the features of Moose roles in our test
routines.  We could tweak the `dbh` attribute to read:

      has dbh => (
        is   => 'ro',
        lazy_build => 1,
      );

      requires '_build_dbh';

Now we can't use this test routine unless we compose it with something else
that provides `_build_dbh`, so the `run_me` call above won't work.  Instead, we
need to take that code and put it in a package -- and probably in a file that
we'll use over and over.  Let's say we put it in `t::DBTest`.  When we want to
use it we might say:

      run_tests(
        "run dbh tests on the dbh_builder",
        [ 't::DBTest', 'Some::Class::Providing::DBH_Builder' ]
      );

Now, suppose we have another thing that can provide a different kind of dbh.
That's easy to test, too:

      run_tests(
        "run dbh tests on the dbh_builder",
        [ 't::DBTest', 'Different::DBH_Builder' ],
        { connect_as => 'tester' },
      );

What's that hashref for?  It's the arguments to be passed to the `new` method.
This is vital for classes or roles that end up with required attributes.

If one of these dbh builders is really expensive to fire up, and we want to run
many of our units of testing against it, we can do that:

      run_tests(
        "prove out the Different::DBH_Builder",
        [ 'Different::DBH_Builder', 't::DBTest', @lots_of_other_roles ],
        { connect_as => 'tester', ... },
      );

We compose all the roles into the new anonymous class and run them all on a
single instance.  (Note that the order of the elements of the arrayref are
irrelevant.  Test::Routine::Runner can determine how to compose them.)

Finally, one thing that you may have noticed is not here, if you're a regular
user of xUnit, is a system for startup or teardown behavior.  There are a lot
of features that we don't need to implement because we've got Moose, and this
is one of them.  Test::Routine roles run each test with the method `run_test`.
If you need extra cleanup on your role, you can just add advice:

      before run_test => sub {
        my ($self, $test) = @_;

        $self->clear_queue;
        $self->clear_eventlog;

        $self->indexer->ensure_connected;

        diag "about to begin test " . $test->name;
      };

Unlike setup and teardown methods, method modifiers like this will compose
nicely when multiple roles or modifiers are used.

I have a very small list of things to add to this system, but I think that it
is largely done.  This is excellent, because the entire system is quite simple
an easy to understand, and under 200 lines of code.  I'm looking forward to
using Test::Routine in a lot of my existing test suites to discover new
strategies to add to the demo suite.

