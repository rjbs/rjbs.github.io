---
layout: post
title : "rx, json schema, and uri templates"
date  : "2008-09-08T04:04:15Z"
tags  : ["programming", "rx", "web"]
---
I got to feeling like maybe JSON Schema was not yet firm enough to give up on,
and that maybe I could help improve it in the areas where
[Rx](http://rjbs.manxome.org/rx)'s design made more sense.  I made one or two
very minor suggestions that were accepted, but the most important area was not
addressed.  You can read more about it at [the Google Groups
thread](http://groups.google.com/group/json-schema/browse_thread/thread/e6caf10ade7b4b8a).

I moved on to looking at other parts of my project, and realized that I was
going to need a way to templatize a URI.  Maybe it was time to look at [URI
Templates](http://bitworking.org/projects/URI-Templates/) again.  When I'd
first seen them, they didn't seem like they provided much.  You'd say:

    http://gallery.example.com/user/{username}/photo/{photoid}

...and then fill it in with:

    { username => "rjbs", photoid => 1234 }

That was it.  Still, that's more or less everything I'd need.  I thought I'd
have another look and see if there was some reason not to use it.

Well, in the time since I first saw it, there have been a few revisions to the
spec, adding features like list-value variables and operators.  So you can say:

    http://x.com/?valid={-opt|true|valid}&{-join|&|foo,bar}&baz={-list|&baz=|baz}

    { valid => 1, foo => 'x', bar => 'y', baz => [ 1, 3, 5 ] }

...to get:

    http://x.com/?valid=true&foo=x&bar=y&baz=1&baz=3&baz=5

That `-opt` operation says "if the value for 'valid' is not empty, then
evaluate to the string 'true' and otherwise the empty string."  There's also an
inverted form called `-neg`.  The behavior of `-join` should be clear.
Unfortunately you're not allowed to pass list-value items to it, so it's not
very useful for building a query string that would contain multiple entries for
a given name.  That's a shame, since it seems to be intended for use in
building query strings.  Meanwhile, `-list` (once called `-listjoin`) doesn't
act like `-join`.  It doesn't include the name of the variable (or equals sign)
with each entry, so I have to include it in the join string and before the
expansion.

Here's another way to do it:

    http://x.com/?valid={-opt|true|valid}&{-join|&|foo,bar}{-prefix|&baz=|baz}

`-prefix` (along with `-suffix` and `-list`) are actually shown in examples
forming paths, letting you turn our baz value above into `1/2/3/` or `/1/2/3`.

The first thing I wonder is this: why do we need a template system for query
strings, anyway?  They're easy, they've been around since forever, and the
existing tools already handle all the crap like multiple values for one named
parameter.  The more interesting problem is in the path and maybe, sometimes,
the domain.  The most important feature is probably just dropping in a named
value.

Another useful feature mentioned (and according to the archives at least
briefly implemented) but not in the spec is the ability to deal with
substrings.  The system described looked like this:

    http://cpan.org/{-sub|0,1|author}/{-sub|0,2|author}/{author}

I think that stinks.  In most cases that I've seen this kind of thing, you're
just making a simple path, and it looks like one of these:

    R/J/BS
    R/J/RJBS
    R/RJ/RJBS
    S/B/RJBS

I sure don't want to have to give every substring that I need, with those
slashes.  Why not:

    http://cpan.org/{buildup:author,3,cumulative}

...or something more along those lines.

I think I need to look through the APIs that I'd use this on and see what
features I'd want, and whether URI Templates address those well.  If not, I'm
not going to settle on something that gives me features I don't need but none
that I do.  I just don't relish trying to compete with yet another somewhat
successful system.

