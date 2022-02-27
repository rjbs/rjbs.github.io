---
layout: post
title : "email::mime::* make me crazy"
date  : "2009-01-20T20:33:23Z"
tags  : ["email", "perl", "programming"]
---
I've been doing a lot of work on our internal library for building multipart
email messages from templates.  Email::MIME has been stabbing me in the face
much of the time.

Here's just a little sample:

    use strict;
    use Email::MIME::Creator;

    my $email = Email::MIME->create(
      attributes => { content_type => 'image/jpeg' },
    );

    print $email->as_string;

The above code prints:

    Date: Tue, 20 Jan 2009 15:32:52 -0500
    MIME-Version: 1.0
    Content-Type: image/jpeg; charset="us-ascii"

Good to know that our jpeg is in the us-ascii charset.

