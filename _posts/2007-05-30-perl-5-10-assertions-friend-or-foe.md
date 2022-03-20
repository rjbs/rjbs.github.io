---
layout: post
title : "perl 5.10 assertions: friend or foe?"
date  : "2007-05-30T22:19:40Z"
tags  : ["perl", "programming"]
---
I've been writing mini-articles about some of 5.10's new features for ABE.pm, this past week.  It's been fun, and I've learned a few things that I didn't know in the process.  The feature that I knew the least before covering it, so far, has been assertions.  Assertions let you have code that only runs if some set of assertions are enabled.  It's something like this:

```perl
sub everything_is_ok : assertion { print "Everything is okay!\n"; }

everything_is_ok;

{
  use assertions 'foo';
  everything_is_ok;
}

{
  use assertions 'foo && bar';
  everything_is_ok;
}
```

If I were to run this program with `perl`, it would print one line.  If I were
to run it under `perl -A=foo`, it would print two.  If I were to run it with
`perl -A=foo,bar`, it would print three.

Because assertions must be specified before compilation, it's possible to
optimize away the sub calls at compile time, so it's more efficient than just
checking, say, `$ENV{PERL_ASSERT_FOO}`.

I think it's a swell idea, but so far a few things have left me underwhelmed.

First of all, assertions don't prevent method calls.  I'm sure that this would
lead me to some profound grief in the future, when I find that a subclass
really needs a subclassed assertion and I have to do more than just subclass
it.  It's been mentioned that maybe this (and related woes) will be fixed
before 5.10.

The whole interface seems a bit clumsy, though.  I had expected it would work
like this:

```perl
sub everything_is_okay : assertion(wtf) { ... }
```

...and then this code would only run when "wtf" exceptions were enabled.  I
guess the problem with this might be that sometimes you'd want it to run and
sometimes not -- that's why the assertion's power was moved to the calling
block.  The thing is, why isn't the whole block compiled in or not?  It would
solve the problem of method calls, and it would prevent this problem:

```perl
sub check_stuff : assertion { ... }

my $code = \&check_stuff;

{
  use assertions 0; # should prevent all assertions
  $code->();        # ... but this will run anyway
}
```

Further, how weird is this:

```perl
{
  use assertions 'debugging';
  my $value = some_assertion;
}
```

If the `debugging` assertion isn't on, $value is set to zero.  I'd expect a
compile-time death, or at least a runtime death, or at *least* a result of
`undef`.

The docs for assertions aren't great, yet, but I hope I can help. What I hope
even more is that I can find a simple way to use the existing assertions hooks
to write mine like this:

```perl
sub does_something_fantastic {
  ...

  assuming 'foo && bar' {
    my $object = get_object;
    $object->some_method;
    say "foo and bar must be enabled!";
  };

  ...
}
```

...but then again, maybe someone will just be able to point out why the
implemented way is the One True Way To Do It.
