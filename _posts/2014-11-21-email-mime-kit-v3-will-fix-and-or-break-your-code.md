---
layout: post
title : "Email::MIME::Kit v3 will fix-and-or-break your code"
date  : "2014-11-21T02:47:38Z"
tags  : ["perl", "programming"]
---
Ever since its early releases, Email::MIME::Kit had a big problem.  It screwed
up encodings.  Specifically, imagine this manifest (I'm kinda skipping some
required junk):

    # manifest.yaml
    renderer: TemplateToolkit
    headers:
      - Subject: "Message for [% name %]"
    alternatives:
      - type: text/plain
        path: body.txt
      - type: text/html
        path: body.html

The manifest turns into a data structure before it's used, and the subject
header is a text string that, later, will get encoded into MIME encoded-words
on the assumption that it's all Unicode text.

The files on disk are read with `:raw`, then filled in as-is, and trusted to
already be UTF-8.

If your customer's name is Распутин, strangely enough, you're okay.  The header
handling encodes it properly, and the wide characters (because Cyrillic
codepoints are all above U+00FF) turn into UTF-8 with a warning.  On the other
hand, for some trouble, consider Ævar Arnfjörð Bjarmason.  All those codepoints
are below U+0100, so the non-ASCII ones are encoded directly, and you end up
with `=C6` (Æ) in your quoted-printable body instead of `=C3=86` (Æ UTF-8
encoded).

Now, you're probably actually okay.  Your email is not correct, but email
clients are good at dealing with your (read: my) stupid mistakes.  If your
email part says it's UTF-8 but it's actually Latin-1, mail clients will usually
do the right thing.

The big problem is when you've got both Ævar Arnfjörð Bjarmason and Распутин
both in your email.  Your body is a mish mash of Latin-1 and UTF-8 data.

In Email::MIME::Kit v3, templates (or non-template bodies) loaded from disk are
— if and only if they're for `text/*` parts — decoded into text and then, when
the email is assembled, it's encoded by Email::MIME's usual `header_str`
handling.

There's a case where this can start making things worse, rather than better.
If you know that templates in files are treated as bytes, you might be passing
in strings pre-encoded into UTF-8.  If that was the case, it will now become
mojibake.

Finally, plugins that read kit contents for uses as text will need upgrading.
The only one I know of like this is my own
Email::MIME::Kit::Assembler::Markdown.  I will fix it.  The trick is: look at
what content-type is being built and consider using `get_decoded_kit_entry`
instead of `get_kit_entry`.

I think this is an important change, and worth the breakage.  Please look at
your use of EMK and test with v3.

