---
layout: post
title : "email::mime's horrible design problem"
date  : "2008-08-28T18:30:07Z"
tags  : ["email", "perl", "programming"]
---
...or at least the problem that came to light recently.

In a MIME message, you can use an "encoded-word" in the header to represent
text that isn't 7-bit ASCII.  For example:

    From: =?utf-8?q?Ricardo_Juli=C3=ADn_Besteiro_Signes?= <rjbs@example.com>

Email::MIME's `header` method helpfully decodes these into character strings,
so that when you say:

    $email->header('from');

...you get Julián in there, not some MIME crap.

The header method is used to stringify the message.  This means that when you
load in a safe, 7-bit MIME message and then stringify it, you get an 8-bit
(wide-character-having) string that can't be safely sent over plain old SMTP.

Maybe this wasn't a problem back when Email:: modules were more brazen about
assuming that each others' internals would never change, and only became a
problem when I started making them rely on methods rather than guts.

Either way, this is a pretty big problem.  It means you can't reliably do:

    Email::Send->send($email_mime->as_string);

Oops.

