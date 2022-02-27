---
layout: post
title : "I still hate email"
date  : "2014-04-19T03:15:35Z"
tags  : ["email"]
---
Last week, Yahoo! changed their DMARC policy.  Since that event, I have grown
to loathe email even more.

You can find a domain's DMARC policy, if any, by checking DNS:

    ~$ dig -t txt _dmarc.yahoo.com | grep TXT
    ;_dmarc.yahoo.com.    IN  TXT
    _dmarc.yahoo.com. 1793  IN  TXT "v=DMARC1\; p=reject\; sp=none\; pct=100\;
    rua=mailto:dmarc-yahoo-rua@yahoo-inc.com, mailto:dmarc_y_rua@yahoo.com\;"

DMARC gives instructions on how to check whether a message is really from a
domain, and how to deal with messages that aren't.  First you check a message's
DKIM signature and SPF results, then you use the DMARC policy to decide what to
do.

DKIM is a kind of digital signature.  For example, here's one from a message I
sent myself recently:

    DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:from
      :to:date:mime-version:content-type:content-transfer-encoding
      :message-id;
      s=sasl; bh=Thy1S1zI40m42mTl74YTuMseXt4=; b=W/XF275Z
      Es+/l8eC+TeiRiBerAmSbYV7zFTTQfxP4dPtws7xVo3bPxb+E1mZ4dQXbzv6b92N
      QREJ9lOSeET42toRjh37uDN8OhPZRqK37TfSSy2yplDC/1cpswW1Girg3FoUZ03q
      FVRtfzsJNABmAhg8tP5ajrCVaAFvUpHuig8=

The `h=...` stuff says which headers are part of the message.  To verify the
signature, look look up the public key (found with `dig -t txt
sasl._domainkey.pobox.com`) and verify the signature against the content of the
body and selected headers.

Without DMARC, DKIM can tell you that there's a valid signature, but not why or
what to do about it.  DMARC lets you say "if there's no valid signature,
consider the message suspect, and please tell me about such messages." DMARC is
designed to be used on "transactional email,"  like receipts and order status
updates, on newsletters, or on other kinds of mail from an organization to a
recipient.  It's a reasonable way to attack phishing, because phishers won't be
able to produce a valid DKIM signature without your private key.  Even if they
had it, it will be much more expensive to send out mail that requires a digital
signature.

DMARC also lets you give the instruction to reject mail that doesn't
authenticate.  This is useful if you're a bank and you're really sure that
you're getting DKIM right.

Last week, Yahoo! changed their DMARC policy to "reject when DKIM doesn't
match."  This is a big problem, because they made this change on `yahoo.com`
addresses.  DMARC is applied only and always to whatever address is in the From
header of an email message.  Addresses at `yahoo.com` are used not just by
Yahoo!'s internal services, but also by end users, who can get such addresses
by signing up for Yahoo! Mail.  Then they can do things like join discussion
mailing lists.

Mailing lists will almost always change the headers of the message, and
changing the body is quite common, too.  Either of these will break the DKIM
signature.  That means that if someone with a Yahoo! Mail account sends a
message to your mailing list, quite a lot of the subscribers will immediately
bounce the message.  (Specifically, those subscribers whose mail servers
respect DMARC will bounce.)

You can't just strip the DKIM signature to prevent there from being an invalid
one.  The policy requires a valid signature — or a valid SPF record.  SPF
records are designed to say which IP addresses may send mail for a domain.
Since a mailing list will be sending from the list server's IP and not the
original sender's IP, that fails too.  One email expert described the situation
as "Yahoo! has declared war on mailing lists."  It's pretty accurate.

The most common solution that's being put into play is From header rewriting.
Mailing lists are changing their From headers, so that when you used to see:

    From: "Xavier Ample" <xample@example.com>

You'll now see:

    From: "Xavier Ample via Fun List" <funlist@heaven.af.mil>

Of course, this screws with replies, so Reply-To needs munging, too.  It screws
with lots of stuff, though, and it makes everyone angry — and rightfully so, I
think.  Certainly, I've had to spend quite a lot of time trying to deal with
the fallout of this decision.  DMARC just isn't good for individual mail
accounts.  I worry that some of the mechanisms that are being introduced to
deal with this are going to create a much less open system for email exchange.
This isn't a good thing!  Email has a lot of problems, but being a network that
one can join without permission is a *good* thing.

DMARC does a fair job at the thing for which it was intended, but it makes
everything else much trickier.  This is the nature of many email
"improvements," which were added without careful consideration.  Or, often,
with careful consideration but not much concern.  It's understandable.  Email
seems impossible to replace and impossible to *really* fix, so we bodge it over
and over.

I mentioned SPF, above.  SPF also broke parts of the pre-existing email system.
Specifically, forwarding.  SPF lets you say "only the machines that are MXes
for example.com may send mail with an SMTP sender at 'example.com'".  This
broke forwarding servers.  That is, imagine that you've got `mydomain.com` and
its MX sends mail on to your private host `myhost.mydomain.com`.  On that last
hop, `mx.mydomain.com` might be sending you mail `FROM` an address
`someone@example.com`, while the SPF records for `example.com` only allow
`mx.example.com` to send such mail.

A second standard was introduced to fix this problem: SRS.  With SRS,
`mx.mydomain.com` would be required to rewrite the address to something like
`SRS0=xyz=abc=example.com=someone@srs.mydomain.com`.  There are just a holy ton
of problems with this setup, but I'll stick to the one that I had to fight with
today.

This is a valid email address for use in SMTP interchange:

    "your \"best\" friend"@example.com

It's not often used, and it's basically totally awful, but it exists, it's
legal, and you should generally try to cope with it if you're doing something
as wide-ranging in effect as SRS.  Sadly, the reference implementation of SRS
totally drops the ball, rewriting to:

    SRS0=xyz=abc=example.com="your \"best\" friend"@srs.example.com

This is not a legal address, to say the least.

If anybody needs to reach me, just send a fax.

