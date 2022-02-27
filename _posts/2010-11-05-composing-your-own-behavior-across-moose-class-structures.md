---
layout: post
title : "composing your own behavior across Moose class structures"
date  : "2010-11-05T15:50:10Z"
tags  : ["moose", "perl", "programming"]
---
In my last entry, I wrote about [how role composition and advice and `BUILD`
interact](http://rjbs.manxome.org/rubric/entry/1864).  A number of times, I've
wanted to get behavior that was *like* `BUILD`, but without needing the stub
method hacks that are needed to get roles to participate in the method call.  A
very simple example came when I was [writing
Throwable::X](http://rjbs.manxome.org/rubric/entry/1860), which had a mechanism
for all of its contituent parts to contribute tags.  The idea was that any
class or role that was part of your class hierarchy could implement an `x_tags`
method that would return a list of tag strings.  These methods would all get
called and the resulting set of tags would be uniqued and returned.

The only problem was that it totally didn't work.  I tried to implement it by
copying from `BUILDALL`, the mechanism by which `BUILD` methods are called.
This had all the problems that `BUILD` has (like needing stubs and advice to
make things in roles all get called), but I didn't notice because (a) I was not
thinking very hard about it and (b) I was not testing very thoroughly.  (Of
these, I fault myself more for (b).)

This is what `BUILDALL` looks like, boiled down:

    sub BUILDALL {
        my ($self, $params) = @_;
        foreach my $method (
            reverse( class_of($self)->find_all_methods_by_name('BUILD'))
        ) {
            $method->{code}->execute($self, $params);
        }
    }

So, find the `BUILD` method in every class that has it (started with the least
derived class) and then call it.  For tags, I also had to gather up return
values, but this was simple:  I just pushed the results of each method call
onto an array and returned it.

My first thought for fixing my implementation was, "I can walk up my class
hierarchy (like `BUILDALL`) but at each class, also look at all of the roles it
composed for the method."  Not only was this a bad idea because it violated the
notion that roles should not be considered as entities external to a class,
after composition, but it was a *terrible* idea, because it didn't even solve
the problem of including two roles that provide an `x_tags` method!

What I wanted was a way for a role *or a class* to add a hunk of code that
would be called, no matter what, and then I wanted a way to decide how to
interpret the results.  In other words, something like this:

### TagProvider.pm

      package TagProvider;

      use MooseX::ComposedBehavior {
        sugar_name   => 'add_tags',
        compositor   => sub {
          my ($self, $results) = @_;
          return uniq( map { @$_ } @$results );
        },
        method_name  => 'tags',
      };

### Foo.pm

      package Foo;
      use Moose::Role;
      use TagProvider;

      add_tags { qw(foo bar) };

### Bar.pm

      package Bar;
      use Moose::Role;
      use TagProvider;

      add_tags { qw(bar quux) };

### ParentClass.pm

      package ParentClass;
      use Moose;
      use TagProvider;
      with qw(Foo Bar);

      add_tags { qw(parent) };

### ChildClass.pm

      package ChildClass;
      use Moose;
      extends 'ParentClass';
      use TagProvider;

      add_tags { qw(child) };

Phew!  So, the TagProvider library is generated mostly by this
"MooseX::ComposedBehavior" thing, which I was going to have to write.  We told
it that we wanted `add_tags` sugar in anything using `TagProvider`.  Later,
we'll call that sugar with a block that we want called on every piece of a
class.  We'd get all those blocks to be called by calling a method named
`tags`, and it would compose all the results of the `add_tags` blocks by
flattening them and picking the unique values.

Then we get this behavior:

      my $obj = ChildClass->new;

      $obj->tags;  # set of: foo bar quux parent child

This is just one use for this kind of "call everything everywhere!" behavior.
We could, for example, have each sub-block return a deep hashref and then have
the compositor perform a deep merge, possibly dying on any conflict.  We could
have merged our list of arrayrefs-of-tags into a hash telling us how many time
each tag occurred.  *Further*, the sub-blocks are all passed the object on
which `tags` was called, along with any arguments passed.  Each block could
perform analysis on the arguments, for example, and the compositor could reduce
the analyses to a single report.  

One of my other use cases is similar to that final example.  We don't want to
use the compositor for reducing reports -- there are other facilities better
for this, already, like delegation.  We don't want the sub-block calls to even
do the analysis.  Delegation handles that better, too.  Instead, I have code
where each sugar block returns a hash of delegates to be used for performing
analysis.  The hashes are merged, and conflicts on keys (the delegate's
identifier) are fatal.  When instances are constructed, they can replace
delegates by name.  The "composed behavior" here is a distribued system to
allow class components to contribute to a composite default value.

I will note, for now, just one of things to be wary of when using like
[MooseX::ComposedBehavior](http://search.cpan.org/dist/MooseX-ComposedBehavior/)
-- which I did implement and release.  Because every part of the class can
contribute behavior unconditionally, there is no easy way to say that you want
to "reset" the behavior at a certain point in the class hierarchy.  You either
get all the behavior or none of it.

Moose provides a lot of good tools for reusing code, and many of them focus on
ways to compose units of code together:  roles and traits, advice, the
behavior-building facilities of attributes, and so on.  Being able to decompose
your code down into simple, easy to understand pieces is one of the most
important skills for a programmer to have, and that means both being able to
make the most out of the existing, well-known patterns of reuse and also being
able to design new patterns of reuse as a last resort when the existing ones
don't quite solve your problem.

