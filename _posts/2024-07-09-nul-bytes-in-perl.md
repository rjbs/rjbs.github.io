---
layout: post
title : "apparently NUL is mostly whitespace in Perl?"
date  : "2024-07-09T12:00:00Z"
tags  : ["perl","programming"]
---

This post will be short but baffling.

In the following snippet, the `^@` sequences indicate literal NUL bytes in the
source document.

```
use v5.36.0;
my $i = ^@ 1;
sub foo () {
 say q^@Hell0, w0rld.^@;
 $i^@++;
}

foo(^@);

say ^@$i;
```

This program will run and print:

```
Hell0, w0rld.
2
```

The NUL bytes are all ignored… except for the two that act as the string
delimiters for the q-operator.  As near as I can tell without reading any of
the source for the perl tokenizer (or related code), NUL is treated like
whitespace.  I am gobsmacked.  I know all kinds of weird stuff about Perl, but
this one surprised me.

It came up when I tried to run a bunch of small programs through `perltidy`,
and it refused to process just one file, because it was "binary".  There was a
NUL after a subroutine's opening brace.  I removed it out, but not because it
was a syntax error.  Just because it was not in good taste to leave it there.
