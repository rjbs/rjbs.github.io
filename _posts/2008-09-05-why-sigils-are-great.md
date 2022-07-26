---
layout: post
title : "why sigils are great"
date  : "2008-09-05T00:11:26Z"
tags  : ["perl", "programming", "ruby"]
---
Last night at [ABE.pm](http://abe.pm.org/), I was talking a little bit with The
Gang about some of the things I came to believe while doing the same thing in
multiple languages.  In explaining some of the issues I have with Ruby, both
the scope of variables and the resolution of methods, this example came to me:

```ruby
class X
  def x; return 10; end

  def y
    if false
      x = 100
    end

    return x
  end

  def z
    return x
  end
end

obj = X.new

puts "result of obj.y: #{obj.y.inspect}"
puts "result of obj.z: #{obj.z.inspect}"
```

This will print:

```ruby
result of obj.y: nil
result of obj.z: 10
```

When `obj.y` is called, a variable called `x` is *not* assigned to, because the
assignment happens in a conditional branch that is not entered.  Nonetheless,
the assignment to the variable creates the variable, because variables are not
block scoped and because variables need not be explicitly declared.  This means
that when `return x` is reached, `x` is a local variable with no assigned
value.  That variable, which is `nil`, is returned.

When `obj.z` is called, nothing has defined `x` in the method's scope, so Ruby
resolves it as a method call on the current target, `obj`.  In other words, the
`x` in the method `z` is the same as `self.x`.

Of course, good method and variable names goes a long way to making this less
of an issue, but "Can't we just agree to not introduce bugs?" isn't a great
safety net.

In Perl 6, the `y` method would be something like:

```
method y {
  if false { my $x = 100 }
  return $x;
}
```

...but that's a syntax error, because Perl has block scope.  To return the
variable you'd say:

```
method y {
  my $x;
  if $bool { $x = 100 }
  return $x;
}
```

To return the result of a method on self, you'd say:

```
method y {
  if $bool { my $x = 100 }
  $self.x;
}
```

...and if you have a lot of stuff operating on `$self` and want to avoid a
bunch of that typing, you could write:

```
method y {
  if $bool { my $x = 100 }

  given $self {
    # (pretend we have lots of code here that we save typing on)
    return .x;
  }
}
```

It's always clear whether we're dealing with a variable (there's a `$` or other
variable-marking sigil) or a method (there's an invocant or a lone dot, which
acts something like a method-call sigil).

I think that Ruby's use of sigils is great.  Its sigil-for-scope makes much
more sense given Ruby's "everything is an object" variables.  I just wish that
they had a sigil for local scope variables.

This would actually be a huge improvement on a current problem.  See, Ruby 1.9
is going to have block-level scope.  Unfortunately, this will sometimes change
how code worked.

```ruby
value = 10;
array.each { |value| do_something }
```

This code (in Ruby) will clobber `value`, because the `value` in the proc is
not created in a distinct scope from the `value` to which 10 was assigned.
When Ruby 1.9 is adopted, this code will change.  The two value variables will
be distinct, and the first `value` will not be clobbered.

If block scope had been introduced *with a new sigil* this would have been
avoided.  Your old code would be:

```ruby
*value = 10;
array.each { |*value| do_something }
```

Well, of course it's clear that these would be the same!  They both have the
(hypothetical) function-scope sigil.  Ruby 1.9 wouldn't break this, because
instead of changing the way sigil-free local variables worked, it would let you
have a block-local variable if you asked for it:

```ruby
%value = 10;
array.each { |%value| do_something }
```

That first variable could use a star, too.  The important thing is that the
smaller-scoped variable would be marked as only existing in its block-local
scope.  Of course, running out of sigils is a risk, but I'd rather see Ruby 3.0
require twigils than have backcompat issues like this.


