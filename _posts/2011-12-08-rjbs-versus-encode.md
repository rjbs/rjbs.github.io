---
layout: post
title : "rjbs versus Encode"
date  : "2011-12-08T05:08:32Z"
tags  : ["email", "perl", "programming"]
---
What a day!  I kept really busy.  I did some good (I think) refactoring of some
libraries for sending transactional mail.  I made a nice little improvement to
our (on-CPAN) mail generator to make our Markdown-based messages look better in
both plaintext and HTML.  I deleted 36 obsolete fields from an annoyingly
large table.  I felt pretty productive.

My productivity streak, though, came to a crashing halt with this really weird
test failure, that looked something like:

    want subject: User rjbs@example.com wants to subscribe
    have subject: User rjbs@example. com wants to subscribe

I didn't have to curse and sputter *too* long, though, because I've seen this
before.  It's because of [Encode](http://metacpan.org/module/Encode).

Before I go much further, I want to say that Encode rocks.  Although I am about
to complain bitterly about it, I love it and am glad it exists and is
maintained by *somebody else*.  (Dan Kogai does a great job, too.)  The problem
is more that dealing with email header encoding is a huge pain.  That said,
Encode gets a number of things pretty wrong.

So, let me set the stage.  As of RFC 2047, if you have an email header field
where a `word` token is expected, you can substitute an `encoded-word` token.
This lets you get non-ASCII text into the header, because words can only be
ASCII.  Encoded words can be Unicode.  As of RFC 822 (meaning roughly forever)
header lines can be folded to fit a narrow terminal by turning
horizontal whitespace into horizontal-and-vertical whitespace.  So, these
should all be equivalent:

    Subject: Eat some "pie!"

    Subject: Eat
      some "pie!"

    Subject: Eat =?utf-8?q?some?= "pie!"

    Subject: Eat
      =?utf-8?q?some?= "pie!"

Encode offers a way to convert any of these into the first form, and to convert
the first form into whatever form is required to transmission.  Great!
Unfortunately, it gets stuff wrong, and that's what I want to write about.
I'm going to write this stuff as tests, and each snippet really starts with:

    use 5.12.0;
    use charnames ':full';
    use Test::More;
    use Encode;

So:

    my $header = "=?utf-8?q?jabber?= =?utf-8?q?wock?=";
    is( decode('MIME-Header', $header), "jabberwock", "two encoded-words join" );

When you have two `encoded-word` tokens next to each other, the space between
them is dropped.  Imagine you have an 80 character string in Tibetan.  Encoded,
it becomes something like 240 octets, and you want to fold that (for some
reason) so you need to break at whitespace, but you can't, because there isn't
any.  You can break the encoded string at character boundaries and fold there,
and this rule promises that the strings will be run together after decoding.
Great!

This works with folding, too, because that's just whitespace.

    my $header = "=?utf-8?q?jabber?=\r\n =?utf-8?q?wock?=";
    is( decode('MIME-Header', $header), "jabberwock", "two encoded-words join" );

Encode passes this test.  Unfortunately, it passes for the wrong reasons.  For
example, it fails this test:

    my $header = "jabber\r\n wock";
    is( decode('MIME-Header', $header), "jabber wock", "two words don't join" );

When we fold, we turn a horizontal space into vertical and horizontal space.
When we unfold, we turn it back into horizontal space.  Unfortunately, Encode
turns it into no space.  This means that it unfolds non-encoded words badly,
running words together.

It has other folding problems, too.  These are especially insidious when you
can't detect them when round tripping:

    my $header = "Randomly eat mussels and maybe you can eat what nobody "
               . "else's stomach can handle without hurling.";

    is(
      decode('MIME-Header', encode('MIME-Header', $header)),
      $header,
      "round trip!",
    );

Great, this works – and why shouldn't it?  It doesn't have any words in need of
encoding, after all.  Unfortunately, there's a bug.

    like(
      encode('MIME-Header', $header),
      qr/else's/,
      "we didn't break on an apos",
    );

This fails, because Encode folds at the apostrophe!  Woah!  You get this:

    Randomly eat mussels and maybe you can eat what nobody else'
      s stomach can handle without hurling.

When someone *receives* this mail, they will probably decode it *properly*, and
there will be a mysterious space in the displayed header.

Really, **Encode should not be dealing with folding**.  Folding is about
formatting messages, not about encoding MIME words.  If Encode stopped folding,
all these bugs would *just go away*!

Unfortunately, it's not the only problem.

For example, you can't use an encoded word inside a `quoted-string` token, but:

    {
      my $header = qq[I like "Queensr\N{LATIN SMALL LETTER Y WITH DIAERESIS}che"];
      unlike(
        encode('MIME-Header', $header),
        qr/like "/,
        "the double quotes are encoded into the encoded-word",
      );

      is(
        decode('MIME-Header', encode('MIME-Header', $header)),
        $header,
        "round trip!",
      );
    }

Encode will see that y-umlaut and encode it… but it won't encode the quotes
around it!  You end up with the wildly illegal: `I like
"=?UTF-8?B?UXVlZW5zcsO/Y2hl?="`

The round trip works, which seems good until you realize that this means that
Encode is *also decoding improperly* because that illegal encoded form should
not be decoded!

This last one is really nasty.  Here's some text that appears in the Encode
test suite:

    From:=?UTF-8?B?IOWwj+mjvCDlvL4g?=<dankogai@dan.co.jp>
    To: dankogai@dan.co.jp (=?UTF-8?B?5bCP6aO8?==Kogai,=?UTF-8?B?IOW8vg==?==
      Dan)

Should this be decoded?  What a mess…

I'm really not sure about that From header.  I think the `encoded-word` and
`route-addr` tokens should almost certainly be separated by spaces, but is it
strictly required?  Probably not.  The problem is, more or less, that we can
only know this by knowing that From is a structured field with the structure
`phrase route-addr`.  It comes down to RFC 822's insane off-handed remark that

> Rather than obscuring the syntax specifications for these
> structured fields with explicit syntax for this linear-white-
> space, the existence of another "lexical" analyzer is assumed.

That is, there's supposed to be some kind of preprocessor lexing this stuff
before you can apply the rules that might otherwise seem simple.  But Encode
isn't that lexer.  It neither *is* that lexer nor *assumes* that lexer nor *has
access to* such a lexer.

Look at that To header, up there, too.  Should that work?  No, but not for the
reason you might think.

This should be legal, with two encoded words:

    To: dankogai@dan.co.jp (=?UTF-8?B?5bCP6aO8?= =?UTF-8?B?IOW8vg==?=)

You can use encoded words in comments, even without a space between the
parenthesis and the encoded word.  This is *explicitly* spelled out in 2047.
On the other hand, we had this:

    To: dankogai@dan.co.jp (=?UTF-8?B?5bCP6aO8?==Kogai,=?UTF-8?B?IOW8vg==?==
      Dan)

Those aren't valid `encoded-word` tokens, because they're not set off from the
interior tokens by space.  It would be *one* big encoded word, but the encoded
text can't contain question marks, so that's illegal.  Aarrrrggh!

Actually, it's worse than this!  This is only legal because we can see that
this is a **To** field!  Let's muddy this up:

    dankogai@dan.co.jp (=?UTF-8?B?5bCP6aO8?= =?UTF-8?B?IOW8vg==?=)

Okay, given this string as something you pulled out of a header, can it be
decoded to Unicode?  Well, maybe.  If the field is structured, then yes, those
could be two encoded words in a comment.  If the field is just a `*text` field,
though – like Subject – then you can't have comments, so the parenthesis is
literal, and there are no valid encoded words.  Strip the parens and you have
encoded words again, though, because a `*text` field can be composed of words
and encoded words.

In other words, you can't *really* decode MIME headers without having a real
grammar and lexer for the email.  Yup.

So, what *should* a MIME header encoding routine do?

* It should not deal with folding.  (At the very least, it should not get it wrong.)
* It should assume it's dealing with `*text` fields only

That means that it should not decode comments like the ones above.  That's
fine, because if you really need to deal with comments, you should *actually*
be tokenizing the header according to its field definition and decoding encoded
words only where appropriate.  In reality, though, you're probably safe just
*throwing away* comments in these fields.  The only fields that tend to have
*useful* comments are Received headers, and those are *prohibited* from having
encoded words.  In almost every case, these two rules would mean that you could
pass a string with words and encoded words, *always divided by whitespace* to a
routine and get a character string back.  The reverse would also work.

Of course, this solves the problem by saying that we should ignore most of the
complexity.  It's not fair.  On the other hand, that's how we deal with a lot
of email problems, and it seems like one of the only winning strategies.

