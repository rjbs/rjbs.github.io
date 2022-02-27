---
layout: post
title : "HTML::MasonX::Free"
date  : "2016-05-25T01:45:18Z"
---
Who's ready to live in the past?  Me!

Every time I try to like some other templating system in Perl, I fail.  The
only one I sort of like is Mason.  No, no, not Mason 2.  I don't like that.  I
like *HTML::Mason*.  You know, *Mason 1*.

It has about a zillion problems, but the biggest problem, I think, is just its
reputation.  People think it's guaranteed to lead to some kind of awful "whole
app written inside your templates," just because its original use case was "you
can write our whole app inside your templates."  But we believe in second
chances, right?

For years now, I've wanted to write a Mason-inspired Mason replacement.  I just
haven't.  I did, though, write a bunch of plugins to Mason to change how it
behaved.  They've made it a lot nicer to work with, and I thought I'd give a
bit of a quick run-through on what they do.  Maybe someone else will find them
useful, although… well, I guess it could happen!

## Stricter Component Interfaces

So, a typical Mason component might look like:

```mason
<%args>
$name
</%arg>

<%method greeting>
<%args>$name</$args>
Hey, <% $name %>
</%method>

<html>
  <head><title>Your face</title></head>
  <& SELF:body, name => $name &>
</html>

<%method body>
<%args>$name</$args>
  <body>
  <div><& SELF:greeting, name => $name &><div>
  </body>
</%method>

<!-- good night! -->
```

Even in this dumb contrived example, it can be hard to figure out the entry
point.  Basically, anything that isn't part of some other special block like
`<%method>` or `<%args>` or `<%def>` is "the main thing that gets run."  You
could write your Perl programs like this, too, switching between the main code
and subroutine definitions as you go, mixing them together, but you wouldn't.
Right?  No, you wouldn't.

Sometimes, we even encapsulate the main part of a program in `sub main`, like
some other languages do.  Then you run the program by calling `main()` at the
end.

HTML::MasonX::Free::Compiler lets you do this with your Mason components.
First, it forbids stray content.  Everything must be inside a method or doc
block (or similar structures), or the compiler barfs.

Then, when you render a component, there's a default method to call.  So, if
you call `<& /some/component &>` — which is what happens when you find and
render a path — then it actually ends up calling `/some/component:main`.  This
forces a non-nesting structure where you're not interleaving a bunch of blocks
inside of your main content.

## Component Roots as Subclass Overlays

The Mason resolver maps component paths (which look like file paths) to
components.  In general it does that by looking through a file tree, but it can
be more abstract, like in
[MasonX::Resolver::WidgetFactory](https://metacpan.org/pod/MasonX::Resolver::WidgetFactory).  By default, though, it works like this:

Say you have three roots, `/X` and `/Y` and `/Z`.  Then these two things exist:

    /X/vehicle/car
    /Z/vehicle/car

…and then you call `/vehicle/car`.

Traditionally, Mason will look through the component and find the one in the
first root.  In this case, that's in `/X`.  The component at `/X/vehicle/car`
is then called.  Calling (`exec`-ing) that component actually means walking up
its ancestry to its inheritance root and calling *that*, which will then call
`$m->next` until it gets back down to the actually-requested component.

This is *nuts*.

It made a bit of sense once upon a time when the default parent, `autohandler`
was used for things like permissions checks.  I'm only using Mason for
templates, though, so forget that!  I want to use inheritance in a more
traditional way, for a more specialized version of a general thing.  For this,
I wrote HTML::MasonX::Free::Resolver.  It gets a list of roots, but they're
treated like overlays.

I'll elaborate.  In the standard configuration, `/X/vehicle/car` can never have
a parent under `/Z`.  The default tree is:

    /X/vehicle/car
      -> /X/vehicle/autohandler
        -> /X/autohandler

With HTML::MasonX::Free::Resolver, we'd get:

    /X/vehicle/car
      -> /Z/vehicle/car

And while traditional Mason would call its tree from the bottom up, ours calls
from the top down.  Since all our components have a `main` method, then a
pretty simple thing to do is to have this in the "base" template
`/Z/vehicle/car`:

```mason
<%method main>
This is a <% SELF:color %> <% SELF:type %> car.
</%method>

<%method color>grey</%method>
<%method type>motorized</%method>
```

…and in your "derived" template, `/X/vehicle/car` just:

```mason
<%method type>hybrid</%method>
```

This makes it easy to have a generic pack of templates that you customized on a
per-install basis by adding a new root at the derived end of the list.

One fun fact:  the component roots in Mason aren't stored in the resolver, but
in the interpreter, even though the resolver is the thing that does the
resolving.  In order to have HTML::MasonX::Free::Resolver be in charge of its
roots, you have to put a special value into `comp_roots` to indicate, "yes, I
realize this won't ever get used."

## HTML Entity Encoding with Fewer Screw-ups

Say your template has this:

```mason
<input value='<% $value %>' />
```

Well, you'd never do that, right, because you'd use a widget generator?  But
let's pretend you would.  The other bug is that you probably didn't escape the
entites in `$value`, so maybe there's an HTML injection attack there.  You
might have wanted:

```mason
<input value='<% $value |html %>' />
```

That weird-o pipe thing is Mason's filtering syntax.  You probably *almost
always* want to entity encode things, so you might set the
`default_escape_flags` on your compiler to `html`.  Then, when you *don't*
wan't to encode, you do this:

```mason
<div><% $known_html |n %></div>
```

This means, "*no* escaping for this, please."  The problem is that you might
want to write a method that accepts a parameter that could be of either type.
There's no default way to know, and if you get it wrong, you're screwed up.
You can find yourself in that situation in a number of ways.

HTML::MasonX::Free::Escape provides a replacement for the default `html` filter
that can be given an argument that is *known* to be HTML.  You generate it by
using the `html_hunk` routine, like this:

```mason
% my $text = "D&D";
% my $html = html_hunk("D&amp;D");
I like playing <% $text %> and more <% $html %>.
```

The rendered text will encode `$text` without double-encoding `$html`.  You
also can't accidentally do this:

```mason
% my $html = html_hunk("D&amp;D");
% my $string = "My favorite game is $html."
```

Or, rather, you *can*, but it will be a runtime error instead of a weird-o
double encoding showing up somewhere.

## That's it!

So, these don't really make Mason an amazingly modern thing, but help sand down
a few of its most obvious warts, and that's been good enough for me!

