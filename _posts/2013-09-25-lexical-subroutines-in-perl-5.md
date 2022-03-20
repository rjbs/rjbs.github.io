---
layout: post
title : "lexical subroutines in perl 5"
date  : "2013-09-25T23:50:41Z"
tags  : ["perl", "programming"]
---
One of the big new experimental features in Perl 5.18.0 is lexical subroutines.
In other words, you can write this:

```perl
my sub quickly { ... }
my @sorted = sort quickly @list;

my sub greppy (&@) { ... }
my @grepped = greppy { ... } @input;
```

These two examples highlight cases where lexical *references* to anonymous
subroutines would not have worked.  The first argument to `sort` must be a
block or a subroutine *name*, which leads to awful code like this:

```perl
sort { $subref->($a, $b) } @list
```

With our `greppy`, above, we get to benefit from the parser-affecting behaviors
of subroutine prototypes.  Although you can *write* `sub (&@) { ... }`, it has
no effect unless you install that into a named subroutine, and it needs to be
done early enough.

On the other hand, lexical subroutines aren't just drop-in replacements for
code refs.  You can't pass them around and have them retain their named-sub
behavior, because you'll still just have a *reference* to them.  They won't be
"really named."  So if you can't use them as parameters, what are their
benefits over named subs?

First of all, privacy.  Sometimes, I see code like this:

```perl
package Abulafia;

our $Counter = 0;

...
```

Why isn't `$Counter` lexical?  Is it part of the interface?  Is it useful to
have it shared?  Would my code be safer if that was lexical, and thus hidden
from casual accidents or stupid ideas?  In general, I make all those sorts of
variables lexical, just to make myself think harder before messing around with
their values.  If I need to be able to change them, after all, it's only a one
word diff!

Well, named subroutines are, like `our` variables, global in scope.  If you
think you should be using lexical variables for things that aren't API, maybe
you should be using lexical subroutines, too.  Then again, you may have to be
careful in thinking about what "aren't API" means.  Consider this:

```perl
package Service::Client;
sub _ua { LWP::UserAgent->new(...) }
```

In testing, you've been making a subclass of Service::Client that overrides
`_ua` to use a test UA.  If you make that subroutine lexical, you can't
override it in the subclass.  In fact, if it's lexical, it won't participate in
method dispatch *at all*, which means you're probably breaking your main class,
too!  After all, method dispatch starts in the package on which a method was
invoked, then works its way up the packages in `@INC`.  Well, *package* means
*package variables*, and that excludes lexical subroutines.

So, it may be worth doing, but it means more thinking (about whether or not to
lexicalize each non-public sub), which is something I try to avoid when coding.

So when *is* it useful?  I see two scenarios.

The first is when you want to build a closure that's only used in one
subroutine.  You could make a big stretch, here, and talk about creating a DSL
within your subroutine.  I wouldn't, though.

```perl
# Please forgive this extremely contrived example. -- rjbs, 2013-09-25
sub dothings {
  my ($x, $y, @rest) = @_;

  my sub with_rest (&) { map $_[0]->(), @rest; }

  my @to_x = with_rest { $_ ** $x };
  my @to_y = with_rest { $_ ** $y };

  ...
}
```

I have no doubt that I will end up using this pattern someday.  Why do I know
this?  Because I have written Python, and this is how named functions work
there, and I use them!

There's another form, though, which I find even more interesting.

In my tests, I often make a bunch of little packages or classes in one file.

```perl
package Tester {
  sub do_testing {
    ...
  }
}

package Targeter {
  sub get_targets {
    ...
  }
}

Tester->do_testing($_) for Targeter->get_targets(%param);
```

Sometimes, I want to have some helper that they can all use, which I might
write like this:

```perl
sub logger { diag shift; diag explain(shift) }

package Tester {
  sub do_testing {
    logger(testing => \@_);
    ...
  }
}

package Targeter {
  sub get_targets {
    logger(targeting => \@_);
    ...
  }
}

Tester->do_testing($_) for Targeter->get_targets;
```

Well… I *might* write it like that, but it won't work.  `logger` is defined in
one package (presumably `main::`) and then called from two different packages.
Subroutine lookup is per-package, so you won't find `logger`.  What you need is
a name lookup that isn't package based, but, well, what's the word?
**Lexical!**

So, you could make that a lexical subroutine by sticking `my` in front of the
subroutine declaration (and adding `use feature 'lexical_subs` (and, for now,
`no warnings 'experimental::lexical_subs'`)).  There are problems, though, like
the fact that `caller` doesn't give great answers, yet.  And we can't really
monkeypatch that subroutine, if we wanted, which we might.  (Strangely abusing
stuff is more acceptable in tests than in the production code, in my book.)
What we might want instead is a lexical *name* to a package variable.  We have
that already!  We just write this:

```perl
our sub logger { ... }
```

I'm not using lexical subs much, yet, but I'm pretty sure I will use them a
good bit more in the future!

