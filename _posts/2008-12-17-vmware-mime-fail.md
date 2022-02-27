---
layout: post
title : vmware mime fail
date  : 2008-12-17T17:48:03Z
tags  : ["email"]
---
VMware keeps sending me newsletters.  Too bad they're horribly broken MIME.
It's just more proof that all email software sucks and email hates the living.

Let's have a look at this, for example:

    From: "=?iso-8859-1?Q?The VMware Team?=" <vmwareteam@connect.vmware.com>

So, they want to indicate that they are "The VMware Team."  This would have
sufficied:

    From: "The VMware Team" <vmwareteam@connect.vmware.com>

They decided to encode the string in Latin-1, though.  That's fine, it means
they're probably trying to always encode output, even if it's 7-bit-safe, and
that's a good strategy.  Unfortunately, their encoder is broken.  An
encoded-word must be one atom, which means it may not have whitespace in it.
RFC 2047, where encoded words are defined, goes out of its way to make this
clear.

They meant:

    From: "=?iso-8859-1?Q?The_VMware_Team?=" <vmwareteam@connect.vmware.com>

...but that's wrong, too.  You can't have something that is both a quoted
string and an encoded word.  RFC 2047 also goes out of its way to make that
clear.  They really meant:

    From: =?iso-8859-1?Q?The_VMware_Team?= <vmwareteam@connect.vmware.com>

It gets worse, though.  The message is multipart/alternative, and the text part
is content-transfer-encoded with quoted-printable.  Here's a snippet:

    more about VMware and how virtualization solutions can make a positive=
    impact on your business. =0D=0A=0D=0AYou are receiving this email because=

They've ended their lines with equals signs to indicate that they're soft line
breaks, and should not be used for wrapping.  That's fine.  Unfortunately,
they've encoded their "real" line breaks, to go between paragraphs, as
`=0D=0A`, which means "CRLF."  This is not fine.  Hard line breaks must be
transmitted as unencoded octets (that is, the literal bytes `\x0D\x0A`) rather
than encoded octets.  Otherwise, the mail agent is expected to believe that the
bytes are literal data, and not to be interpreted as newlines.  This means that
compliant user agents display things like `^M` in your message.  RFC 2045 is pretty clear about this.

If you're going to send text alternatives, people, look at what you see in text
agents.  I guess if you're already hosing the headers, though, you don't care
much.

