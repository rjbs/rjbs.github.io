---
layout: post
title : "JSON::Typist"
date  : "2016-08-06T17:17:12Z"
tags  : ["perl", "programming"]
---
I've been meaning, for a while, to make a little post about a library I wrote a
while ago.

Perl 5's type system is a mixed bag.  Sometimes it's great, because you don't
need to worry about types, and sometimes it's a pain, because you wish you
could worry about types.  There have been a number of proposals or attempts to
sort this out over time, but basically nothing has happened.  My guess is that
not much is ever really going to happen, and that's okay.  I still like Perl 5.

Sometimes, though, the lack of typing really does get in the way.  In my
experience, it's mostly when you need to deal with something outside of Perl
that *does* have a strong distinction between numbers and strings.  This can
often be in the interchange of serialized data structures.  JSON, for example,
has three fundamental types that are more or less all muddled together:
numbers, strings, and booleans.

When using JSON.pm, booleans can be produced by using `\0` and `\1`, which is a
bit weird, but ends up working really nicely.  When read in, booleans become
objects.  Okay!

Strings and numbers can be produced by serializing `"$x"` or `0+$x` directly,
or by starting with string or number literals, which is *maybe* okay, but
inspecting the data before it gets serialized can ruin this effect:

```
~$ perl -MJSON -E '$x = 0; say $x; say JSON->new->encode([$x])'
0
[0]

~$ perl -MJSON -E '$x = 0; say "$x"; say JSON->new->encode([$x])'
0
["0"]
```

That `say "$x"` could always be buried deep in some subroutine, and you end up
with spooky action at a distance.

Similarly, if you read in JSON and wanted to check what types the data had,
you'd end up using `B::svref_2object` or other much-too-low-level tools.  I
wanted to be able to get objects back, just like I did with a boolean.  I
don't want this *all* the time, only *sometimes*, but when I want it, I want
it!

I wrote JSON::Typist, which walks a structure produced by a JSON decode and
returns a new structure, replacing string and number leafs with objects:

```perl
my $content = q<{ "number": 5, "string": "5" }>;

my $json = JSON->new->convert_blessed->canonical;

my $payload = $json->decode( $content );
my $typed   = JSON::Typist->new->apply_types( $payload );

$typed->{string}->isa('JSON::Typist::String'); # true
$typed->{number}->isa('JSON::Typist::Number'); # true
```

I'm using it for testing a web service that must provide data in the right
types.  It isn't enough to make sure that `$data->{id} eq $expected`, I also
need to know that it was provided as a string.  With JSON::Typist, I can.

I know this library needs some more work, and I need to build some test tools
(maybe adding on to Test2::Compare?) to work with the structures I get back,
but this has allowed me to test for (and then fix) a bunch of bugs, so I'm
pretty happy with having gotten started.

