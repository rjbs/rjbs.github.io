---
layout: post
title : "roles, advice, and BUILD in Moose"
date  : "2010-11-05T14:36:18Z"
tags  : ["moose", "perl", "programming"]
---
A very common complaint on `#moose` is, "`BUILD` is broken.  I put `BUILD`
methods in my code and they never got called."  There are a lot of variations
on this.  They tend to come from the fact that `BUILD` is not called like almost
any other method.  Imagine the following class hierarchy:

      ParentClass   <--(does)--<   Role1, Role2
          |
        (isa)
          |
      ChildClass    <--(does)--<   Role3
          |
        (isa)
          |
      GrandChild

Normally if we call a method on an object of GrandChild, we first look for that
method in GrandChild itself.  If we find it, we call it, and we're done.  If
not, we look in ChildClass.  Maybe it's defined there, or maybe it came from
Role3.  If we don't find it there, we look in ParentClass, which again may have
defined its own or gotten it form a role.  If we don't find it there, we give
up and throw an error.  This is all pretty well-understood, even with the
addition of roles.  They're invisible to the method resolver, so you can just
pretend they're not there and that their contents have been stuffed into the
classes.  That's how they work, after all.

The problem is that `BUILD` doesn't work like this, which triggers the "this is
strange magic" response in the programmer's [reptile
brain](http://en.wikipedia.org/wiki/Triune_brain#The_reptilian_complex).
`BUILD` is called before `new` returns, and it's called like this:

1. `BUILD` is called on ParentClass, if ParentClass has a `BUILD` method
2. `BUILD` is called on ChildClass, if ChildClass has a `BUILD` method
3. `BUILD` is called on GrandChild, if GrandChild has a `BUILD` method

Nobody needs to call `super` in `BUILD`, something else makes sure each one is
called.  Now, notice that the three-step process above didn't mention roles.
If Role1 (for example) has a `BUILD` method, then it only gets called because
it's included in ParentClass.  This is where people start to get confused.
It seems like, "everything that is part of the object's composition gets
called."  Heck, if you put `BUILD` in Role1, it gets called!  So, it seems like
roles are "part of the object's composition" and `BUILD` gets called in them.

This is an illusion, though.  For example, if we have a `BUILD` method in both
ParentClass *and* Role1, the one from Role1 isn't called.  This should *not* be
a surprise.  The `BUILD` method is called on every *class* in the hierarchy, so
maybe one of those classes has a `BUILD` method from a role.  It doesn't call
them *in* the role.  Here are some of the things that get interpreted as bugs:

* if Role1 and Role2 both have a `BUILD` method, ParentClass won't compile
* if Role1 and ParentClass both have a `BUILD` method, the method from Role1 is silently ignored

So, to let roles contribute their own independent behavior to `BUILD`, this has
emerged:

    package Role1;
    use Moose::Role;

    after BUILD => sub { ... real behavior goes here... };

So, after the `BUILD` behavior on the class is called, the role's behavior is
called.  This is generally good enough for the kind of thing people want in a
role's `BUILD`, since role application order is not fully defined.  The problem
is that maybe no class has defined a `BUILD` method, so the after advice can't
attach to anything and you get a compile error.  To combat this, the actual
pattern used is this:

    package Role1;
    use Moose::Role;

    sub BUILD {}
    after BUILD => sub { ... real behavior goes here... };

We create a stub BUILD and attach to that.  If the class using Role1 already
has a BUILD, it is not replaced.  If it doesn't, we get that basic stub for the
advice to apply to.  This isn't ideal, though.  The next problem is that Role2
might be using the same trick, and when ParentClass includes both Role1 and
Role2, their `BUILD` methods conflict, so we need to go make sure that neither
does anything so we can resolve the conflict by adding a stub `BUILD` to
ParentClass, too.  Gross.

Wanting to be able to have a role contribute some behavior to an operation
without replacing it is pretty reasonable, and there are plenty of use cases.
The `BUILD` stub and its potential conflicts seem, at first, like an edge case,
caused by the funky nature of how `BUILD` is called on every superclass.
Unfortunately, there are simlar problems with other methods.

Imagine that ParentClass has a `send_message` method, and that Role1 and Role2
both contribute behavior to it by using advice.  Everything works as expected.
Then Role3 adds more advice to the method, and now there are four pieces of
code being called when the method is invoked -- still, just as we expect.  In
GrandChild, however, we *override* `send_message`.  Now, the advice in our
roles was applied to the method defined in ParentClass.  When we override that
method in GrandChild, the advice is also overridden.  This is often a source of
confusion, and rightly so:  the question of what *should* happen isn't
necessarily clear, so one of two mental models is usually formed by the
programmer:

1. Methods and advice are distinct, and both are inherited distinctly from one another, so that altering one leaves the other intact.
2. Advice is applied to the first relevant class method as soon as possible and is then no longer advice.

The second model is correct.  Is it a fundamentally *better* model?  I don't
think it is either necessarily better, but a choice had to be made, and Moose
made one.  [*Update*:  Shawn Moore reminded me that CLOS made the opposite decision!]
If it didn't function this way, we would have had to add a new kind
of method declarator, like "override," that meant "and don't apply any previous
advice, either."  Because it does function this way, we might want ways to say
"call the previous method including its advice," and "call my new method body
only, but do call previous advice."  The former exists, as `override` paired
with `super`.  The latter does not yet exist.  So far, I haven't needed it very
badly, and it seems safe to believe that neither has anybody else, since it has
not yet been coded.

Roles and advice, like most of the rest of Moose, are pretty simple concepts,
but they're also pretty new to many programmers.  What they are *not* is magic.
When you encounter behavior that's contrary to your expectations, finding out
what the actual model in use is can be dramatically helpful, not just with your
current problem, but in future work using the system.

In my next post, I will write about my need for other ways to combine code
blocks spread across class composition structures, different from either plain
old methods, advice, or `BUILD`.

