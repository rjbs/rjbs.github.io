---
layout: post
title : "Moose, laziness, and weak refrences"
date  : "2010-05-06T12:19:46Z"
tags  : ["perl", "programming"]
---
Last night, I was making some improvements to some work code, and trying to
make it easier to use in places where I wasn't using it yet.  Part of this
involved allowing an important attibute to be a weak reference.  I really
wanted to do something like this:

    my $child  = $parent->child;
    my $parent = $child->parent;

In this code, `$parent` and `$child` may be expensive to create, so I want both
to have a reference to each other, without worrying about cyclical references,
which will prevent either variable from ever being garbage collected.  That
means one of the references has to be weak.  I picked the reference from
`$child` to `$parent`.  Unfortunately, this means that `$parent` can be garbage
collected before `$child`, which can lead to this problem:

    my $parent = Parent->new(...);
    my $child  = $parent->child;

    $child->parent; # returns $parent

    undef $parent;

    $child->parent; # returns undef, which may violate the attribute's type

Alternately, here's a runnable example that demonstrates just the problematic
behavior.

    use 5.12.0;
    our $parent;

    package Child;
    use Moose;

    has parent => (
      is   => 'ro',
      isa  => 'Ref',
      lazy => 1,
      default => sub {
        $parent = {};
        return $parent;
      },
      weak_ref => 1,
    );

    package main;
    my $child = Child->new;

    use Test::More;
    is($parent, undef, '$parent begins undef');
    is_deeply($child->parent, {}, '$child->parent returns {}');
    is_deeply($parent, {}, 'now $parent is set');

    undef $parent;

    is($parent, undef, '$parent has been undefined');
    is_deeply($child->parent, {}, '$child->parent returns {}');

    done_testing;

I ended up hiding the reader method for the `parent` variable and replacing it
with one that checks the definedness of the attribute.  If it's not defined, it
clears the attribute and re-accesses it, which causes the lazy constructor to
fire again.

    has parent => (
      is        => 'bare',
      reader    => '_parent',
      isa       => 'Parent',
      lazy      => 1,
      weak_ref  => 1,
      clearer   => '_clear_parent',
      default   => sub {
        my ($self) = @_;
        Parent->get_parent_of($self);
      },
    );

    sub parent {
      my ($self) = @_;
      my $value = $self->_parent
      return $value if defined $value;
      $self->_clear_parent;
      return $self->_parent;
    }

This is already pretty complicated, but it's still not enough.  When the value
in `$parent` gets garbage collected, the next time we try to read it, our
method notices that it's undef and gets a new value.  Unfortunately, because
nothing else refers to the new value *it is immediately garbage collected*.  We
need to only weaken references that were set during construction.

    has parent => (
      is        => 'bare',
      reader    => '_parent',
      isa       => 'Parent',
      lazy      => 1,
      predicate => '_has_parent',
      clearer   => '_clear_parent',
      default   => sub {
        my ($self) = @_;
        Parent->get_parent_for($self);
      },
    );

    sub parent {
      my ($self) = @_;
      my $value = $self->_parent
      return $value if defined $value;
      $self->_clear_parent;
      return $self->_parent;
    }

    sub BUILD {
      my ($self) = @_;
      Scalar::Util::weaken $self->{parent} if $self->_has_parent;
    }

Weak references are often a lot more complicated than they might seem.  It can
be attractive to try and solve a problem by "just weakening" one half of a
relationship.  Very often, it doesn't solve a problem, it just replaces it with
a much weirder or more subtle one.

