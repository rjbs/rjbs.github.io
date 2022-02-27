---
layout: post
title : "finally released: less piggish email code"
date  : "2007-02-21T02:25:58Z"
tags  : ["email", "perl", "programming"]
---
Last week, I finally released the long-ago-announced new versions of
Email::Send and Email::MIME, which together greatly reduce the memory used to
store an email (and, in effect, to do many other things with PEP).  There was
one glitch that required a small tweak to Email::MIME's part-inflating code,
but for the most part it went quite well.  The only other non-bogus error
reports I got were from people who relied on private Email::Simple code, or
used code that did so.

For example, Email::LocalDelivery::Mbox needs to escape lines in the body that
begin with "From ".  To do this, it parsed the message into a header and body,
and then returned the header followed by the escaped body.  That sounds fine,
except it did it like this:

    # breaking encapsulation is evil, but this routine is tricky
    my ($head, $body) = Email::Simple::_split_head_from_body($$mail_r);
    $body =~ s/^(From\s)/>$1/gm;

It couldn't just create an Email::Simple to do that, because there was no
Email::Simple method to stringify just the headers -- except for
`_headers_as_string`, which was private.  (Of course, that didn't stop older
versions of Email::MIME from using it.)  Instead, it relied on a different
method (well, subroutine) for doing something similar.

The clincher here is the comment!  I don't really know what it means: the
routine is tricky?  If it does something that is tricky, and that is useful
enough to use elsewhere, why isn't it just made public so nobody needs to break
encapsulation?  After all, both modules had the same author!

PEP has a lot of interface problems. Sometimes, fixing them is an enjoyable
challenge.  Other times, it's just annoying tedium.

Still, I think that a lot of the core ideas, and certainly the central goal of
being as simple as possible, are good ones.  What I'm most afraid of (and
slightly exhilarated by) is the likelihood that I'll need to write new modules
that replace the interface of a number of modules.  Email::Send has some
problems that, I fear, cannot be easily fixed without significant backcompat
problems.  Email::LocalDelivery, Email::Folder, and Email::Delete have
interfaces so minimal (and in the case of Email::Delete, so unusual) that they
seem difficult to reconcile into a set of tools that really seem designed to
work together.  Still, more modules will mean that even under Email:: there
will be multiple choices for any single task, which hurts the value of the
presently (mostly) one-module-per-task namespace.

I'll probably mumble about some of these plans on the PEP mailing list.

