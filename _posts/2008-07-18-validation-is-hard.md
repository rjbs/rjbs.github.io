---
layout: post
title : "validation is hard"
date  : "2008-07-18T03:26:38Z"
tags  : ["programming"]
---
More and more, I'm dealing with lots of mostly-JSON web service APIs.  I enjoy
this.  It's simple, and tends to work well.  I think JSON is a really nice
format to work with.  I had a discussion with Ingy and a bit of the `#yaml`
gang about things I don't like about YAML (largely it's implicit types) and I
ended up thinking that YAML wasn't quite as insane as I'd thought.  Still, from
the perspective of clarity, JSON blows it out of the water.

I want to add more formalized validation to our JSON APIs, so I was looking at
ways to quickly write validation for data structures.  I'd seen
[Kwalify](http://www.kuwata-lab.com/kwalify/) and [its Perl
implementation](http://search.cpan.org/dist/Kwalify) out of the corner of my
eye a number of times, and I looked into it more today.  It started out looking
quite reasonable, but then I started to find things that made me unhappy.

The first thing that should've made me wary was the fact that you can declare a
`pattern` for a node, saying that the string must match a regex.  That's not so
crazy if you're writing a library for one language, but Kwalify seems like it's
multilanguage.  What regex library does it use?  You can't specify it.
Presumably it's the "native" library, but that means that your schemata are
already not cross-language.  That didn't jump out at me until later.

There's an `assert`, too, which is basically a string of code that gets
templated and evaluated.  This made me grumpy, but it's marked as
"experimental," so I pretended that it would be ditched or replaced.

The mechanism for reusable schema parts is the YAML reference/anchor schema,
which is equivalent to Perl references.  In order to say that both "masters"
and "servants" are the same kind of data, you might write a schema like this:

    ---
    type: map
    mapping:
      masters:
        type: seq
        sequence:
          - &person
            type: map
            mapping:
              name: { type: str }
              age:  { type: int }
      servants:
        type: seq
        sequence:
          - *person

...or something like that.  I'd rather write something like:

    ---
    schema: map/person
    type: map
    mapping:
      name: { type: str }
      age:  { type: int }
    ...
    ---
    type: map
    mapping:
      masters:
        type: seq
        sequence:
          - type: map/person
      servants:
        type: seq
        sequence:
          - type: map/person

Then I could have some better registry of types than just "references to other
parts of one document."  For example, the first document in the above section
could actually be resolved by Some Unspecified Mechanism like "look up in
filesystem."  Without that, each schema is an island.

Kwalify also has a "data-binding" feature, which really means that it can
generate a class from a schema and transform input into objects.  That's okay,
but I don't see how the fact that you might want to do that belongs in the
schema.  Doesn't it belong in some loader layer?  Every time more features are
added that do runtime things, the schema system becomes less cross-platform.

The two container types allowed in Kwalify are `seq` and `map`, which
correspond to YAML's sequence and mapping.  Unfortuantely, the sequence type
can only define sequences of zero or more elements each matching the same
constraint.  In other words, you can say "this is an array of zero or more
integers" but not "this is an array of between 2 and 8 integers" or "this is an
array of an integer, then a string, then a map."

Validation systems always disappoint.  So far my experience has been that
everybody has his own particular fetishes for what he wants from a validator,
and the more validation he has done, the more perverse his desires become.  If
you're really satisfied with your data validator (and you only use the one
library for it) you're probably not validating enough.

Some time ago, I looked at BDFOY's [Brick](http://search.cpan.org/dist/Brick)
library.  It looks great, but it has no non-developer releases, and the
impression I got is that while it's really, really cool, no one actually uses
it.  I'm wary of being the first one to try to use it in production.

Beyond that, it's pretty clearly Perl.  Of course, it would be possible to
write something to compile simpler schema definitions into Bricks, so you could
hand your compiler something like a Kwalify YAML file and get a Brick.

I've spent the last two hours or so trying to decide how I'd want to write
this, with an eye toward being able to say things like, "and then you should
have an array with one or more things matching the Pobox/Spam/Item schema."
I'm also keen on being able to have things defined in terms of semantics that
can be implemented in multiple languages, rather than being specified in regex.
Maybe that just means you have to say "to be a valid Email/Address, you meet
these criteria" and people are responsible for their own testing.

Of course, with a schema in a format like JSON, and a cross-platform testing
system like FIT, this could be practicable.  Further, it's not the worst thing
in the world if parts of the schema can't be validated everywhere by everyone.
It lets the client say "well, I tried to validate before sending, but I do not
have all of the schema to be sure I am okay."  This might not be acceptable
for two-way transmission, but it's okay as long as the receiving end can
validate enough to be happy.

I'm going to keep thinking about it while I clean the guinea pig cage.

