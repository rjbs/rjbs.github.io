---
layout: post
title : "bizarre email headers, part 23412"
date  : "2008-07-10T20:07:46Z"
tags  : ["email", "wtf"]
---
I see a lot of crazy email content and headers.  I should post more of them,
just for giggles.  Here's one I found sitting in `wtf.msg` in my home directory
at work:

    Content-type: multipart/related;
        type="multipart/alternative";
        boundary="----=_NextPart_000_003D_04D3ADB7.0E7B0925"

So, it's a multipart/related message with a ... type ... of
multipart/alternative.  What?

Maybe it was a heads-up: the only part inside the multipart/related was a
single multipart/alternative.

I don't think this is the only cause of the problem, but:

    X-Mailer: Microsoft Outlook Express 6.00.2800.1158
    X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441

Thanks, Microsoft MimeOLE!

