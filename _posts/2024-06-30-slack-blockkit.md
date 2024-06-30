---
layout: post
title : "trying to cope with Slack's BlockKit"
date  : "2024-06-30T12:00:00Z"
tags  : ["perl","programming"]
---

The other day, a concatenation of circumstances led me to thinking about the
lousy state of sending formatted text to Slack.  We have [a bot called
Synergy](https://www.youtube.com/watch?v=3YlJHX1QO0Y) at work, and the bot
posts lots of content.  Mostly it's plain text, but sometimes we have it send
text with bold or links.  This is for a couple reasons.  Our bot supports
channels other than Slack (like SMS and Discord and the console), so we can't
express everything in Slack-oriented terms.  But even doing so would be hard,
because of the APIs involved.

Slack's APIs are dreadful, and not in the usual ways.  At first glance, they
look fairly modern and straightforward.  Maybe they seem a bit over-engineered,
but Slack is a large-scale system, and some of that is to be expected.  But
when you really start using them, they're surprisingly painful.  Common
patterns turn out to have weird exceptions.  Things don't compose because of
seemingly-arbitrary restrictions.  The documentation seems auto-generated, with
all that entails:  missing context, lack of an overview of any given
abstraction, no helpful hints.  Auto-generated documentation is, at least,
usually accurate and comprehensive in the methods and types provided, because
it comes from the source code.  Unhappily, the Slack documentation is
frequently inaccurate.

## sending text isn't good enough

So, as I said, the state of the Slack APIs and developer ecosystem is such that
I've avoided trying to get more out of it.  Then again, the kind of formatting
we can use easily in Synergy's messages is not great.  It usually uses roughly
this:

```perl
await $slack->api_call('chat.postMessage', {
  text    => $text,
  channel => $channel,
  as_user => jtrue(),
});
```

Nice and simple!  So, how does this get us rich text?  Well, the `$text` content
just gets formatted with Markdown!  No, sorry, wait… with *mrkdwn*.  The Slack
"mrkdwn" format is like Markdown, but worse.  It differs in how bold, italic,
and link work, at least.  Maybe other things, too.  You can disable this, but
then you just get plain text, which has its own problems.

This is an actual, practical problem.  When we display search results from our
work tracker, Linear, imagine we find an issue called "problems with
Secure::Key::HSM".  This will get displayed as "problems with Secure:🔑:HSM"
because mrkdwn is always on the lookout for emoji colon codes.

mrkdwn is intended for human writers, just like Markdown is intended for human
writers.  (That said, I don't actually know whether a human can avoid that
problem above.)  If you want your software to write rich text output, you
should use a less ambiguous, tricky format.  For example, HTML.  In Slack, the
format provided is BlockKit and especially its "rich text" blocks.  BlockKit
is a (mediocre) object model for describing content that Slack can display in
many different contexts (called "surfaces"), like:  modal dialogs, messages,
canvases, and more.  Instead of supplying a hunk of mrkdwn, you can supply an
array of "blocks", and Slack will display them.  Blocks are not ambiguous.
Take the problematic Linear issue from the last paragraph.  The form we want
would be expressed in BlockKit like this:

```json
[ {
  "type": "section",
  "text": { "type": "plain_text", "text": "problems with Secure::Key::HSM" }
} ]
```

Great!  (The bad form is actually exactly the same, but replace `plain_text`
with `mrkdwn`.)

## sending rich text is a big pain

But let's say that in the message above, you wanted to call them "*serious*
problems", with the italics.  You can't use plain text, because you want
italics.  You can't use mrkdwn, because you'd get that emoji.  You need a rich
text block.  Like so:

```json
[
  {
    "type": "rich_text",
    "elements": [
      {
        "type": "rich_text_section",
        "elements": [
          {
            "type": "text",
            "text": "serious",
            "style": { "italics": true }
          },
          {
            "type": "text",
            "text": " problems with Secure::Key::HSM"
          }
        ]
      }
    ]
  }
]
```

Kinda great, but tedious.  Unambiguous, but awful to write.

Also, there's a bug.  I put "italics" when I should've put "italic".  No
problem, because you can easily expect an error like this:

```
Unknown property "italics" at /0/elements/0/elements/style
```

Not great, but gets the job done, right?  Well, the problem is that while you
can easily *expect* that, you won't *get* it.  What you get is this:

```
invalid_blocks
```

No matter how serious or trivial the error, and no matter where it is, that's
what you get.  That is the *entire body* of the response to sending any invalid
message.  Then you try to go re-read the documentation about how it should
work, and you pour over each and every element in the structure and the
corresponding documentation.  Worse, that documentation, as I said, is *bad*.
I found at least a handful of errors (now reported).  The combination of (bad
docs) and (bad error messages) and (wordy structure) made it easy to sigh and
go on using using (sigh) mrkdwn.

## making it hard to screw up

Well, now I didn't want to do that anymore, so I wrote a bunch of classes,
representing each of the kinds of blocks.  (More on "kinds of blocks" below.)

Here's a piece of rich text I generated for testing:

> Here is a *safe* link: **[click me](https://rjbs.cloud/)**
> * it will be fun
> * it will be cool 🙂
> * it will be enough

This is easy to type, and simple, and I wanted it to be easy to program.

Here's the code for that four line Slack rich text:

```perl
my $blocks = Slack::BlockKit::BlockCollection->new({
  blocks => [
    Slack::BlockKit::Block::RichText->new({
      elements => [
        Slack::BlockKit::Block::RichText::Section->new({
          elements => [
            Slack::BlockKit::Block::RichText::Text->new({
              text => "Here is a ",
            }),
            Slack::BlockKit::Block::RichText::Text->new({
              text  => "safe",
              style => { italic => 1 },
            }),
            Slack::BlockKit::Block::RichText::Text->new({
              text => " link: ",
            }),
            Slack::BlockKit::Block::RichText::Link->new({
              text  => "click me",
              unsafe => 1,
              url   => "https://fastmail.com/",
              style => { bold => 1 },
            }),
          ],
        }),
        Slack::BlockKit::Block::RichText::List->new({
          style => 'bullet',
          elements => [
            Slack::BlockKit::Block::RichText::Section->new({
              elements => [
                Slack::BlockKit::Block::RichText::Text->new({
                  text => "it will be fun",
                }),
              ]
            }),
            Slack::BlockKit::Block::RichText::Section->new({
              elements => [
                Slack::BlockKit::Block::RichText::Text->new({
                  text => "it will be cool",
                }),
                Slack::BlockKit::Block::RichText::Emoji->new({
                  name => 'smile',
                }),
              ]
            }),
            Slack::BlockKit::Block::RichText::Section->new({
              elements => [
                Slack::BlockKit::Block::RichText::Text->new({
                  text => "it will be enough",
                }),
              ],
            }),
          ],
        }),
      ],
    })
  ]
});
```

Okay, the *good* news is that if I screw up on any property or type, this code
will give me an error message that tells me a lot more about what happened, and
it happens before we try to send the reply.  The error message isn't *great*,
but it will be something roughly like "Slack::BlockKit::Block::RichText::Text
object found where ExpansiveBlockArray expected in Section constructor".  Maybe
a little worse.  But it's descriptive, it has a stack trace, and it happens
client-side.

The bad news is that it took 57 lines of Perl, mostly fluff, to generate four
lines of text.  This made me sour, so I needed some sugar:

```perl
use Slack::BlockKit::Sugar -all => { -prefix => 'bk_' };
bk_blocks(
  bk_richblock(
    bk_richsection(
      "Here is a ", bk_italic("safe"), " link: ",
      bk_link("https://fastmail.com/", "click me", { style => { bold => 1 } }),
    ),
    bk_ulist(
      "it will be fun",
      bk_richsection("it will be cool", bk_emoji('smile')),
      "it will be enough",
    ),
  )
);
```

This is 13 lines.  Maybe it could be shorter, but not much.  All the same type
checking applies.  Also, each function in there has a reusable return value, so
you could do things like:

```perl
# provide either an ordered List of 2+ Sections or just one Section
my @reasons = gather_reasons();
return bk_blocks(@reasons > 1 ? bk_olist(@reasons) : @reasons);
```

## how does it work?

It's practically not worth explaining how it works.  It is almost the
definition of "a simple matter of programming".  You can read [the source for
Slack::BlockKit on GitHub](https://github.com/rjbs/Slack-BlockKit).  It's a
bunch of Moose classes with type constraints and a few post-construction
validation routines.  I think it's a pretty decent example of how Moose can be
useful.  Moose made it easy to make the whole thing work by letting me
decompose the problem into a few distinct parts:  a role for elements with
"style", a set of types (like for "which kinds of elements can be children of
this block"), and `BUILD` submethods for validating one-off quirks that can't
be expressed in type constraints.

The thing worth nothing, maybe, is how it *doesn't* work.  It isn't
auto-generated code.  It'd be pretty nice if Slack was publishing some data
description that could automatically generate an API, maybe with some sugar.  I
don't normally enjoy that sort of thing, but it'd probably be better than doing
this by hand and then digging for exceptions, right?  Anyway, they don't do
that, so I wrote this by hand.  It felt silly, but it was only a few hours of
work, much of it done while on a road trip.

## some of the problems I encountered

I feel a bit childish calling out the problems with the BlockKit API (or its
documentation), but I'm going to do it anyway.

First, I'll say that my biggest problem is the lack of a clear object model.
The term "block" and "object" and "element" are used without much clear
distinction.  It might be safe to say "anything with a `block_id` propety is a
block".  Beyond that, I wouldn't bet much.  Many Block types have an `elements`
property.  Some say they contain "objects" and some say "elements".  A
`rich_text_list` thing might be an object, or maybe an element?  Or maybe an
element is a kind of object?  There's also a kind of object called a
"composition object", which just seems to be another name for "types we will
reuse".  I can't tell if a composition object is substantially different from
an "element".  They have their own page in the docs, anyway.

This isn't a huge deal, but a hierarchy of types makes it easier to build a
system that has to represent… well, a hierarchy of types!

### non-isolated type definition

Next, the types that do exist are not clearly separated.  The most jarring
example of this might be:

1.  some of the rich text blocks can contain, in their `elements`, "link" objects
2.  "link" objects have a set of styles, chosen from { bold, code, italic,
    strike }
3.  …but the "link" objects contained in a "preformatted" rich text block can
    only have bold or italic styles

So, the type definition for a link object isn't a complete definition, it's
contingent on the context.  To verify the object, you have to put the
verification into the parent:  when constructed, a RichText::Preformatted
object must scan its children for Link objects and raise an error based on
their styling.  (The alternative would be to have a distinct PrefomattedLink
type, which sounds worse.)

But *actually* the alternative is to do nothing.  This restriction isn't
enforced, and in fact using the `strike` style works!  (I can't say whether the
`code` style works, since by definition a link in a preformatted section will
be in code style.)

### missing or bogus properties

The text object (not to be confused with the text *composition* object) exists
almost entirely to pass along its `text` and `style` properties for rending.
But the `text` property isn't documented.  It appears in nearly every example,
though, so you can figure that one out.

Quite a few blocks are documented as having pixel-count properties, like the
`border` property on the list block.  When used at all, these trigger
an `invalid_blocks` error.  Possibly their validity is related to the surface
onto which they're rendered, but I can't find any documentation of this.

Other properties have incorrect type definitions.  The preformatted block says
its elements can contain channel, emoji, user, and usergroup objects.  Trying
to use any of those, though, will get an error.  Only link and text objects
actually work.

## what's next?

I filed an pull request against
[Slack::Notify](https://metacpan.org/pod/Slack::Notify), which Rob N★ quickly
applied and shipped (thanks!), which makes this code easy to use.  So, the iron
is hot and I want to strike it.  I'll probably put this in place to replace a
couple gross bits in Synergy.

But also, I should write some tests first.

But also, and much less likely, it'd be great to have some form of Markdown
Esperanto, where I could write Markdown (or the like) in my code, and then have
it formatted into the right output based on the output channel.  Given a
Markdown DOM, it would be fairly simple to spit out BlockKit rich text.  I
think.  That would be cool, but I'm pretty sure I won't ever do it.  We'll see,
though.
