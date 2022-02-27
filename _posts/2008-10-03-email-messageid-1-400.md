---
layout: post
title : "email::messageid 1.400"
date  : "2008-10-03T11:48:56Z"
tags  : ["email", "perl", "programming"]
---
I've uploaded a new Email::MessageID, version 1.400.  It has two major
improvements.  First, the result of its `new` method is now an Email::MessageID
object, where it was previously an Email::Address object(!).  This means that
it can now have its own message-id-specific methods.  It has one:
`in_brackets`.  This is a very common mistake:

    my $email = Email::Simple->create(
      body   => ...,
      header => [
        ...
        'Message-Id' => Email::MessageID->new->as_string,
      ],
    );

This would produce a bogus message.  Message-Ids must be in angle brackets.
Rather than fix `as_string` and break the code of everyone who was already
dealing with this, I've added `in_brackets`.  Use it!

