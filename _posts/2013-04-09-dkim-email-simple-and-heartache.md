---
layout: post
title : "DKIM, Email::Simple, and heartache"
date  : "2013-04-09T18:06:43Z"
tags  : ["email", "perl", "programming"]
---
## Header folding

These email headers are all supposed to be equivalent:

    1 Foo: bar baz

    2 Foo:  bar baz

    3 Foo: bar
       baz

    4 Foo: bar
         baz

It's part of the "folding white space" thing that is just one of the reasons
that email is such an irritating format.  In any of these cases, when your
program has received the message and you as, "What's in the Foo header?" the
answer should generally be "bar baz" and not anything else.

## Representing headers in memory

Email::Simple uses a pretty simple mechanism for representing headers: a list
of pairs.  When a message is built in memory, its header object stores a list
of name/value pairs.  Since the above forms are all equivalent, they are
reduced to the first form when parsed.  If you read in form 4, above, your
header will store:

    @pair = (Foo => 'bar baz')

## DKIM

DKIM is a mechanism for digitally signing parts of an email message to provide
reliable evidence that some sender has taken responsibility for the post.
Parts of the message are digested and signed by a private key.  The public key
can be found in DNS, and the message's recipient can verify the signature.

Here's a DKIM signature from a message I got from Twitter recently:

    1 DKIM-Signature: v=1; a=rsa-sha1; c=simple/simple; d=twitter.com; s=dkim;
    2     t=1365174665; i=@twitter.com; bh=LmB+XG63ICs3ubpceGdSzYEPG4o=;
    3     h=Date:From:Reply-To:To:Subject:Mime-Version:Content-Type;
    4     b=BRBSHqSmznpsZOEC1tbOtGdZu+YX20jL9NiEIAsepmOaazRCpzTYVfUMC9oEoomok
    5      /X0HVHkBgrkYfp9sWTGcCrDHr+7zntfykKwDWNrgTx9+t64wTrASvcBlUD4lGxTw1T
    6      +JPJtdI17YtTg7pvpsHYYOMmbNZCLNSFTpClo0RQ=

Sometimes messages change in flight.  For example, "Received" headers are
just about always added.  For that reason, only some of the headers are signed.
If the whole header was signed, it would be guaranteed to fail once somebody
added Received (or did lots of other things).  The "h" attribute in the
signature says which headers were signed.

There are other ways to break a header.  For example, the DKIM-Signature above
references the Reply-To header.  Twitter might set the header to:

    To: "Twitter Customer Support"
      <support+F33D3AAE-A13D-11E2-85CF-F379509576E5@some.site.twitter.com>

...and then later someone emits the header as:

    To: "Twitter Customer Support"
        <support+F33D3AAE-A13D-11E2-85CF-F379509576E5@some.site.twitter.com>

There's a change in the *representation* of the header, even if not the
effective value.  Does it matter?  *Maybe.*

The "c" attribute in the signature says how values were "canonicalized" before
signing.  In relaxed canonicalization, changes to things like whitespace won't
affect the signature.  In simple canonicalization, they will.  If the header is
re-wrapped, the signature will be broken.

Simple canonicalization is the default canonicalization.

Finally, the [DMARC](http://en.wikipedia.org/wiki/DMARC) standard is providing senders with a way to assert that DKIM signatures are a reliable test of a message's legitimacy.  If a DKIM signature is broken, the message is not trusted.  Breaking DKIM matters now more than it did before, because DKIM is taken more seriously.

## Email::Simple and DKIM

Email::Simple stores the normalized form.  When round-tripping a message,
unless the header is folded *exactly* how Email::Simple would fold it,
Email::Simple will re-fold the header.  In other words, Email::Simple breaks
DKIM signatures pretty often, even in simplest pass-through program that
doesn't try to affect the message's content at all.

It amused and frustrated me, in fact, that with the Twitter message I posted
above, the only change affected in the message was to the DKIM-Signature
itself.  The signature was rewritten to:

    1 DKIM-Signature: v=1; a=rsa-sha1; c=simple/simple; d=twitter.com; s=dkim;
    2  t=1365174665; i=@twitter.com; bh=LmB+XG63ICs3ubpceGdSzYEPG4o=;
    3  h=Date:From:Reply-To:To:Subject:Mime-Version:Content-Type;
    4  b=BRBSHqSmznpsZOEC1tbOtGdZu+YX20jL9NiEIAsepmOaazRCpzTYVfUMC9oEoomok
    5  /X0HVHkBgrkYfp9sWTGcCrDHr+7zntfykKwDWNrgTx9+t64wTrASvcBlUD4lGxTw1T
    6  +JPJtdI17YtTg7pvpsHYYOMmbNZCLNSFTpClo0RQ=

The only difference?  Five tabs replaced with spaces and the omission of two
extra spaces.  This broke the signature.

## Fixing Email::Simple

Email::Simple 2.200_01 is now on the CPAN, and it fixes this problem.  When it
reads a message in from a string, it keeps track of the exact lines that were
used, and it will emit them again, unless the header is deleted or changed.  If
a header it set from within the program, it will be folded however
Email::Simple likes.  If you need to set a header field within your program and
specify how it will be folded, you'll need to use another library.

If you're using Email::Simple (or Email::MIME) for forwarding or delivering
mail (and that includes using Email::Filter), you should test with this new
trial release *right now*.  It will become a stable release soon.  Probably as
soon as I'm back from the QA Hackathon next week.
