---
layout: post
title : "all hail chocolateboy (and autobox)"
date  : "2008-05-13T02:09:04Z"
tags  : ["perl", "programming"]
---
The `autobox` pragma first showed up a few years ago.  It lets you do something
like this:

    use autobox;

    [ qw(wonderful is very autobox) ]
      ->sort->map(sub { ucfirst })->join(q{ })->print;

...to print: Autobox Is Very Wonderful

At first, it was pretty neat, but it required patches to perl.  By 2005, it had
been rewritten to require no patch, but was still pretty scary and
experimental, at least to me.  Over the last few years, I've looked over toward
autobox a few times, itching to use it all over the place, but never quite
willing to do so because of a few significant limitations.

First of all, this didn't work:  `$array_ref->$method_name`

Method names needed to be literals, meaning that it was more difficult to pick
a method at runtime with autoboxed values than with standard objects.

More importantly, this didn't work: `@array->method`

This was important because this wouldn't work either: `\@array->method`

The precedence of `->` is higher than `\`, so it took a reference to the result
of `@array->method`, which was equivalent (as I recall) to:

    (my $x = @array)->method

...so, not very useful.

Over the last few weeks, these two bugs have been addressed.  The only thing
that I'm still not entirely sold on is that this does not do the right thing:

    my @new = grep { ... } @old->sort;

Sure, I could write `@old->sort->flatten`, but that's not the point.  I
want the result of `sort` to be usable as a flat list, the same was `@old` was.
Coding that would require knowing that the invocant of the autoboxing class's
method was not a reference to begin with, and that information isn't available.

Still, it's not bad at all.  This morning I released a new Moose::Autobox,
adding a `flatten` method to both Array and Hash.  I think I see a lot of
autoboxing in my future!

    


