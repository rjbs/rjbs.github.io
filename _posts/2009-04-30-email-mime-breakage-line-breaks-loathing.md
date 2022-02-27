---
layout: post
title : email mime breakage, line breaks, loathing
date  : 2009-04-30T02:42:52Z
tags  : ["email", "perl", "programming"]
---
About two weeks ago, Max [reported a bug with
Email::MIME::Encoding](http://rt.cpan.org/Public/Bug/Display.html?id=44709)
related to its handling of QP and line breaks.  QP and line breaks provide a
totally insane problem that I talk about in [my upcoming OSCON
talk](http://en.oreilly.com/oscon2009/public/schedule/detail/8409).  It's a
mess.

I solved the problem Max was reporting, which led to more bug reports.  Now
tests in Email::MIME::Creator and ::Modifier failed tests.  They expected to
see OS-specific newlines, but instead saw CRLF.

Line breaks in Email:: code have been a serious headache since day one, for me.
Some things (like pipemailers) want system newlines.  Other things (like SMTP)
want CRLF.  You can't just change the email content without regard for the
semantics of the content (thanks, RFCs), so this is a real issue.  A very
reasonable way to solve this is to talk about content as a thing that can have
different aspects: for example a Body::Text and Body::Blob.  Text is
line-oriented, and you can abstract out line endings.

Email::Simple is supposed to be simple, though, and [it was intended from the
start](http://simon-cozens.org/draft-articles/email.html#email::simple) to
avoid things like an object for the body.  As things like
Email::Simple::Creator and Email::MIME::Modifier came about, though, I think
this should have been revisited.

I think that a body object is likely to happen in the future of Email::Simple
and friends, and if it doesn't, I will probably end up abandoning Email::Simple
in favor of something else.

In the meantime, newline handling in Email:: is still sub-par, but all of the
current releases should install properly again.

