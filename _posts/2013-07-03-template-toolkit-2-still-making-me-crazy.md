---
layout: post
title : "Template Toolkit 2: still making me crazy"
date  : "2013-07-03T16:19:36Z"
tags  : ["perl", "programming"]
---
Template Toolkit 2, *aka* TT2, has long been a thorn in my side.  Once upon a
time, I really liked it, but the more I used it, the more it frustrated me.  In
almost every case, my real frustrations stem from the following set of facts:

* TT2 is a templating system for Perl.
* TT2 provides a language for use when adding logic to the templates.
* The language is inferior to Perl.  It may be useful to be inferior in some
    ways, to encourage programmers to move complex logic out of templates, but…
* The language has significant conceptual mismatches with Perl.

I'll start with this object:

```perl
package Thing {
  sub new      { bless { state => 0 } }
  sub name     { my $self = shift; $self->{name} // 'Default' }
  sub set_name { my $self = shift; $self->{name} = shift }

  sub next  { my $self = shift; return $self->{state}++ }
  sub error { my $self = shift; $self->{error} }
}
```

…and I'll write this code…

```perl
my $tt2   = Template->new;
my $thing = Thing->new;

my $template = <<'END';
Got  : [% thing.next  %]
Error: [% thing.error %]
State: [% thing.state %]
END

$tt2->process(\$template, { thing => Thing->new })
  or die $tt2->error;
```

The output I get is:

```
Got  : 0
Error:
State: 1
```

We've got one problem, already:  I was able to look at the object's guts, and
not because I obviously dereferenced the reference as a hash, but because I
forgot that `state` was not a method.  There is, as far as I can tell, no way
to prohibit fallback from methods to dereference by configuring TT2.

There's another problem:  we stringified an undef, where we might have wanted
some kind of default to display.  In Perl we'd get a warning, but we don't
here.  We probably wanted to write:

```
Error: [% thing.error.defined ? thing.error : "(none)" %]
```

That works.  That also calls `error` twice, so maybe:

```
Error: [% SET error = thing.error; error.defined ? error : "(none)" %]
```

…but that won't work, because it sets `error` to an empty string, which is
defined.  Why?  Because TT2 doesn't really have a concept of an undefined
value.  This can really screw you up if you need to pass undef to an object API
that was designed for use by Perl code.

This should be obvious:

```
Name : [% thing.name %]
```

You get "Default" as the name.

```
Name : [% CALL thing.set_name("Bob"); thing.name %]
```

…and we get Bob.  If we ever needed to clear it again, though,

```
Name : [% CALL thing.set_name("Bob"); CALL thing.set_name(UNDEF); thing.name %]
```

Well, this won't work, because `UNDEF` isn't really a thing.  It isn't
declared, so it defaults to meaning an empty string.  I thought you could, once
upon a time, do something like this:

```
[% CALL thing.set_name( thing.error ) %]
```

…and that the undef returned by `error` would be passed as an argument.  I may
be mistaken.  It doesn't work now, anyway.

We need to detect these errors, anyway, right?  In Perl, we'd have `use
warnings 'uninitialized'` to tell us that we did `print $undef`.  In TT2,
there's `STRICT`.  We update our `$tt2` to look like:

```perl
my $tt2   = Template->new(STRICT => 1);
```

Now, `undef`s in our templates are fatal.  It's important to note that the
error isn't *stringifying* undef, but *evaluating* something that results in
undef.  Our original template:

```perl
my $template = <<'END';
Got  : [% thing.next  %]
Error: [% thing.error %]
State: [% thing.state %]
END
```

…now fails to process.  The error is: `var.undef error - undefined variable:
thing.error`.  In other words, `thing.error` is undefined, so we can't use it.
If we try to use our earlier solution:

```perl
my $template = <<'END';
Got  : [% thing.next  %]
Error: [% thing.error.defined ? thing.error : "(none)" %]
State: [% thing.state %]
END
```

We still get an error:

```
var.undef error - undefined variable: thing.error.defined
```

So, we can't check whether anything is defined, because if it isn't, it
would've been illegal to evaluate it that far.  You can always pass in a
helper:

```perl
my $undef_or = sub {
  my ($obj, $method, $default) = @_;
  $obj->$method // $default;
};

my $template = <<'END';
Got  : [% thing.next  %]
Error: [% undef_or(thing, "error", "(none)") %]
State: [% thing.state %]
END

$tt2->process(\$template, { thing => Thing->new, undef_or => $undef_or })
  or die $tt2->error;
```

This, of course, still doesn't solve the inability to pass an undefined value
to a Perl interface.  In fact, it doesn't deal with any kind of variable
passing.

I like the idea of discouraging templates from including too much program
logic.  On the other hand, I loathe the idea of providing a large and complex
language in the templates that can still be used to put too much logic in
there, but without making as much sense as Perl or working well with existing
Perl interfaces.

I'll take Text::Template or HTML::Mason any day of the week, instead.

