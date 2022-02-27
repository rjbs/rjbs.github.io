---
layout: post
title : "writing your own dispatcher for fun (profit can come later)"
date  : "2009-03-22T17:10:35Z"
tags  : ["perl", "programming"]
---
Almost a year ago, [I wrote to p5p asking about overloading the arrow
operator](http://markmail.org/message/3wwf7pra3whfks5n).  Specifically, I
wanted to be able to change how methods were found and invoked.  My most
pressing motivation was to help me deal with my undying hatred of AUTOLOAD and
UNIVERSAL (and, especially, their interactions), but it had other obvious
benefits.  Without needing to cater to the idea of "classes are packages" you'd
be free to do all kinds of <s>horrible</s> awesome things.

Shortly after that post, to help make clear why it would be totally awesome, [I
posted some example use cases](http://markmail.org/message/omlqbxexvjazndwy) to
the list.  One demonstrated using the system to produce classless
(prototype-based) dispatching, and the other represented classes as blessed
references, with instances blessed into an instance class, meaning that classes
and instances didn't share one namespace for methods.

I was really hungry for this feature, but just shy of hungry enough to learn
how to implement it myself.  [Yuval](http://nothingmuch.woobling.org/) started
work on it, but got busy with other (also very cool) things, and I started to
think I'd have to finally get off my duff and learn what to do.  Fortunately, I
was saved when [Florian](http://perldition.org/) told me he had an idea for
something similar.

Perl 5 version 10 has a system for alternate mro, or method resolution order.
By using the `mro` pragma, the programmer can choose between DFS (depth-first,
the default Perl 5 MRO) or C3, a more beloved MRO, and the default in Perl 6.
Recently, these changes were expanded to make it possible for new method
resolution systems to be plugged in at runtime, and Florian built on that,
writing [MRO::Define](http://github.com/rafl/mro-define), a library for writing
defining a new method resolution order.  Then he used the totally awesome
[Variable::Magic](http://search.cpan.org/dist/Variable-Magic/) (from Vincent
Pit, who once again [deserves your
praise](http://rjbs.manxome.org/rubric/entry/1731)) to apply magic to package
stashes.

If this sounds like mumbo jumbo, don't panic.  I will explain more shortly.

Florian showed me a simple proof of concept and I told Florian how excited I
was and promised to try to write something demonstrative of how this could be
put to use.  Last night, I ported one of my p5p examples to his system, and
ended the night by making a fantastic discovery:  I didn't really need
MRO::Define.  I could accompolish what I wanted on a stock install of perl5
version 10.

    my $class = Class->new({
      class_methods => {
        ping => sub { return 'pong' },
      },
      instance_methods => {
        pong => sub { return 'ping' },
      },
    });

    my $instance = $class->new;

So, now we have a class, which is a perl-style instance (a blessed reference)
of Class.  We also have an instance of that class.

    Class->ping;     # fatal: no such metaclass method

    $class->ping;    # returns 'pong'

    $instance->new;  # fatal: no such instance method

    $instance->ping; # fatal: no such instance method

    $instance->pong; # returns 'ping'

This really works!  There is no AUTOLOAD or auto-creation of packages involved.

Now, Florian's code worked by doing two things:

1. It made a magic class that did something magical instead of looking for
     methods in the package.
2. It made a new MRO that would fall back to the magic class after the default
     class.

That meant that you could write your own class, MyClass, with subroutines
defined in it, and write MagicClass, with its magical method dispatching.
`$my_object->method` would look for MyClass::method first, and would then
invoke the magical bits of MagicClass.

The trick is that while having that new MRO is obviously going to be terribly
convenient in some cases, it isn't necessary in many other cases.  This means
that Florian had developed two distinct tools, each one of which was useful
alone -- and one of which gave me close to exactly what I wanted, easily, in a
pretty stable perl.  (For now, Florian's MRO::Define requires 5.11, but may
work on 5.10.1.)

So, how does the magic class work?  Well, by default a Perl 5 class is just a
package -- a namespace -- into which references are blessed.  A namespace is
just a special kind of hash, called a stash.  When you say:

    my $obj = Class->new;
    $obj->do_something(1);

Then, simplifying only slightly, perl looks for a subroutine called
`Class::new`, which it does by looking for a subroutine stored in the variable
`$Class::{new}`.  There's some other stuff involved, like falling back to other
packages named in `@Class::ISA` and (argh!) the AUTOLOAD method and UNIVERSAL
package and the (hateful) nature of typeglobs, but for the most part, the first
sentence is sufficent to understand this tool.

Variable::Magic lets you do crazy, insane, amazing, powerful stuff to
variables.  Go read its documentation later.  For now, know that one of the
magics you can cast is called "fetch," and fetch magic lets you change what you
find when you look something up in a hash.

Florian's discovery was this particular magic spell:

    cast %Class::, wizard fetch => sub {
      $_[2] = 'invoke_method';
      return;
    };

In other words: when looking for an entry in the Class package, lookup the
entry for `invoke_method` instead.  So, when you say:

    my $obj = Class->new;
    $obj->do_something(1);

It acts as if you did this:

    my $obj = Class->invoke_method;
    $obj->invoke_method(1);

Obviously, this isn't very useful without knowing what method you meant to
invoke, so actually the magic is set up more like this:

    my $method_name;
    cast %{"::$caller\::"}, wizard(
      data  => sub { \$method_name },
      fetch => sub {
          ${ $_[1] } = $_[2];
          $_[2] = 'invoke_method';
          return;
      },
    );

The `data` magic is called every time a wizard casts over a new variable, and
it returns a reference that's available to other magic.  In this case, we're
always returning the same reference, and that's fine, since we're only casting
the wizard once.  (For other uses, you could create a `$wizard` variable and
cast it many times.)

Now, when a method is looked up, we first set `$method_name` to the method name
that should have been looked up, before carrying on with our previous hack of
looking up `invoke_method` instead.  So, we can write something like this:

    # Class->
    my %STATIC = (
      new => sub { ... }, # create a new class when Class->new called
    );

    # $class->
    my %UNIVERSAL = (
      new          => sub { ... }, # create a new instance when $class->new called
      new_subclass => sub { ... }, # create a new class deriving from this one
      base_class   => sub { ... }, # return our base class
    );

    ## PUT THE VARIABLE::MAGIC SNIPPET HERE

    sub invoke_method {
      my ($invocant, @args) = @_;
      my $curr = $invocant;
      my $code;
        
      unless (ref $invocant) {
        die "no metaclass method $method_name on $invocant"
          unless $code = $STATIC{$method_name};
      
        return $code->($invocant, @args);
      }

      while ($curr) {
        my $methods = $curr->{class_methods};
        $code = $methods->{$method_name}, last
          if exists $methods->{$method_name};
        $curr = $curr->{base};
      }

      Carp::confess("no class method $method_name on $invocant->{name}")
        unless $code ||= $UNIVERSAL{$method_name};

      $code->($invocant, @args);
    };

Of course, nobody wants to inline that Variable::Magic block all the time, so I
wrote a simple helper class that lets me write this, instead:

    class Class;

    my %STATIC    = ...;
    my %UNIVERSAL = ...;

    # Make my methods /meta/!
    use mmmm sub {
      my ($invocant, $method_name, $args) = @_;
      my $curr = $invocant;
      my $code;
        
      unless (ref $invocant) {
        die "no metaclass method $method_name on $invocant"
          unless $code = $STATIC{$method_name};
      
        return $code->($invocant, @$args);
      }

      while ($curr) {
        my $methods = $curr->{class_methods};
        $code = $methods->{$method_name}, last
          if exists $methods->{$method_name};
        $curr = $curr->{base};
      }

      Carp::confess("no class method $method_name on $invocant->{name}")
        unless $code ||= $UNIVERSAL{$method_name};

      $code->($invocant, @$args);
    };

The little block of code, above, effectively replaces all Perlish method
dispatch for the class Class.  This is real, ultimate power.

Now, there are catches.  I'm sure we don't even know them all yet, but here are
a few:

It interferes with overloaded operators, but not terminally.  One of the dirty
little secrets of operator overloading is that it works by defining methods
with crazy names like "(+", so they still end up doing method lookup.  The real
magic I used just passes on those and lets them fall back to what you specified
with overload.pm

It breaks (quite intentionally!) the universal methods isa, DOES, VERSION, and
the AUTOLOAD facility.  This is, I promise, a feature.  It also means that
probably the best thing to do would be improve mmmm.pm (or its successors) to
help with those on the fly.  For many OO systems, they'd be easy to generate.

It doesn't work on version 8 perl5, and I don't know why.  I assume that you
couldn't use fetch magic on stashes prior to 5.10, but I haven't gotten
confirmation yet.

Also, it's different from my original proposal in that it affects invoking
methods on packages as well as on blessed references.  While this means a bit
more code is needed to handle things like `Class->new` and `Whatever->VERSION`
I think there is a substantial win over my proposal:  it exists and works,
today.

You can find all my example code, along with some tests, [in my metamethod
GitHub repository](http://github.com/rjbs/metamethod/).

