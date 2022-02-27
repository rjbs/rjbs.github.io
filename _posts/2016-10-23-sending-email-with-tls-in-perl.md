---
layout: post
title : "sending email with TLS (in Perl)"
date  : "2016-10-23T02:55:36Z"
tags  : ["email", "perl", "programming"]
---
Every once in a while I hear or see somebody using one of the two obsolete
secure SMTP transports for Email::Sender, and I wanted to make one more attempt
to get people to switch, or to get them to tell me why switching won't work.

When you send mail via SMTP, and need to use SMTP AUTH to authenticate, you
want to use a secure channel.  There are two ways you're likely to do that.
You might connect with TLS, conducting the entire SMTP transaction over a
secure connection.  Alternatively, you might connect in the clear and then
issue a `STARTTLS` command to begin secure communication.  For a long time,
Perl's default SMTP library, Net::SMTP, did not support either of these, and it
was sort of a pain to use them.

[Email::Sender](https://metacpan.org/release/Email-Sender) is probably the best
library for sending mail in Perl, and it's shipped with an SMTP transport that
uses Net::SMTP.  That meant that if you wanted to use TLS or STARTTLS, you
needed to use another transport.  These were around as
[Email::Sender::Transport::SMTPS](https://metacpan.org/pod/Email::Sender::Transport::SMTPS)
and
[Email::Sender::Transport::SMTP::TLS](https://metacpan.org/pod/Email::Sender::Transport::SMTP::TLS).
These worked, but you needed to know that they existed, and might rely on
libraries (like Net::SMTPS) not quite as widely tested as Net::SMTP.

About two years ago, Net::SMTP got native support for TLS and STARTTLS.  About
six months ago, the stock Email::Sender SMTP transport was upgraded to use it.
Now you can just write:

```perl
my $xport = Email::Sender::Transport::SMTP->new({
  host => 'smtp.pobox.com',
  ssl  => 'starttls', # or 'ssl'
  sasl_username => 'devnull@example.com',
  sasl_password => 'aij2$j3!aa(',
);
```

...and not think about installing anything else.  This is what I suggest you
do.

