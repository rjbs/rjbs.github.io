---
layout: post
title : "fixing/breaking email::simple::creator"
date  : "2007-02-26T16:04:46Z"
tags  : ["email", "perl", "programming"]
---
Email::Simple::Creator crams a `create` method into Email::Simple.  It lets you
provide an array of headers and a body, and it returns a new Email::Simple
object.

I thought I'd have a quick run through Email::Simple::Creator to clean up some
of its foibles.  Here is another one that makes me wonder...

`_add_to_header` is called by the create method.  A reference to a string is
passed in, along with each name/value pair for the headers.  `_add_to_header`
appends a line to the string.

    sub _add_to_header {
        my ($class, $header, $key, $value) = @_;
        return unless $value;
        ${$header} .= join(": ", $key, $value) . $CRLF;
    }

That `return unless $value` is nuts!  It means that you can't create a message
with "0" or "" as a header value.  This is clearly a bug.

The problem is that unless a Date header is specified, one is generated and
added.  Currently if one specifies a false Date header, nothing is added,
either the given (false) value or a generated value.

The code below creates a message with one header, Subject:

    my $email = Email::Simple->create(
      header => [ Date => undef, Subject => 'foo' ],
      body   => "Hello sailor.",
    );

If the bug is fixed in the way that seem obvious to me -- use '' for empty and
undefined headers and 0 for literal zero headers -- then people using
constructs like the above will now have Date fields again -- they'll just be
blank.

I don't really like the idea of "`undef` is skipped but '' is not."

I am sort of leaning toward special-casing Date.  It sucks, but it's already a
special case to begin with.

