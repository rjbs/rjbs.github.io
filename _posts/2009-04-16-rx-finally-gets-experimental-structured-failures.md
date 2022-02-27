---
layout: post
title : rx finally gets (experimental) structured failures
date  : 2009-04-16T04:08:40Z
tags  : ["javascript", "perl", "php", "programming", "python", "ruby", "rx"]
---
[Rx](http://rjbs.manxome.org/rx) is my schema system for validating data in a
highly extensible and portable way.  It is in the same problem space as JSON
Schema and Kwalify (both of which, I think, Rx exceeds), and close to RELAX NG.
I wrote it last summer, and I've used it quite a bit since then, and I have not
been unhappy with it... except for its error reporting.

As initially implemented, all it would tell me was "yeah, something wasn't
valid."  This was obviously a real pain, especially when validating complex
structures or writing new, complex schemata.

Finally, as Rx and
[Email::MIME::Kit](http://search.cpan.org/dist/Email-MIME-Kit) got intertwined
and have started to sink deep down into the guts of
[Listbox](http://listbox.com/), I knew I'd need to improve what Rx could tell
me -- or, more importantly, what it could tell the other folks who'd work on
the project.

I'm still working on the implementation, but now, given this schema:

    type: //seq
    contents:
    - //int
    - //nil
    - type: //rec
      required:
        foo: //int
        bar: //int
      optional:
        baz:
          type    : //arr
          contents: //int

...and this input...

    - 1
    - ~
    - foo: 1
      bar: 2
      baz: [ 3, 4, 5, 6.2, 7 ]

...you can get this structured failure (read from bottom to top):

    - type   : tag:codesimply.com,2008:rx/core/int
      error  : [ type ]
      message: found value is not an integer
    - type: tag:codesimply.com,2008:rx/core/arr
      entry: 3
    - type: tag:codesimply.com,2008:rx/core/rec
      entry: baz
    - type: tag:codesimply.com,2008:rx/core/seq
      entry: 2


