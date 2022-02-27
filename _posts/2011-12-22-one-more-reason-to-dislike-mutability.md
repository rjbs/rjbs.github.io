---
layout: post
title : one more reason to dislike mutability
date  : 2011-12-22T04:43:59Z
tags  : ["perl", "programming"]
---
Here is a sample from work IRC today, as I pounded on a weird test failure I'd
just introduced:

    <rjbs> I think I see it.
    ...time passes...
    <rjbs> or not.
    <rjbs> this is really ibzarre.
    <rjbs> zibarre
    ...time passes...
    <rjbs> hoyl cow
    <rjbs> WOW
    <rjbs> WOW WOW WOW
    <rjbs> p.s.
    <rjbs> WOW
    <rjbs> astounding. okay, committing, pushing
    <rjbs> mjd: check my df4ae63 and be amazed
    <mjd> OMG

Then I went off and, unable to think about anything else, spent dinner
explaining mutability, references, and action at a distance to my daughter.
She was very interested in it, it seemed.  Action at a distance lends itself
to really good examples, as a general concept.

Anyway, what was the bug?  Well, I'm going to simplify it, but you won't miss
out on the non-baffling parts.

Our application has an Environment object that mediates access to the outside
world, like the object store, the mail queue, and the clock.  If you want to
know what time it is, you say:

    my $now = Environment->now;

This is *tremendously* useful in testing, because our test environment's clock
is not just a call to `time`, but has a simulated clock that we can pause,
speed up, turn back, or whatever we want.  Since everything has to go through
that Environment call, we can test all our code pretty easily.  This is vital,
since a lot of this code has to test things happening over the course of days,
months, or years.

There used to be an object in the system that started its life like this:

    has last_event => (
      ...,
      default => sub {
        my ($self) = @_;
        Environment->now - $self->event_frequency;
      },
    );

In other words, it would pretend that it acted just long enough ago that it was
now ripe to act again.  This was, as my colleague put it, a lie.  We wanted to
remove it, because other parts of the program needed the truth.  So removed it
and rewrote the code that relied on it in terms of the object's `created_at`
attribute:

    has created_at => (
      ...,
      default => sub {
        my ($self) = @_;
        Environment->now;
      },
    );

Every single test still passed except one.  In that test, the event never
fired.  It just kept waiting.  "What the heck is going on?!" I cried, shaking
my fist at the sky.  I added print statement after print statement.  Finally, I
added the right one.

Every time the thing said, "When was I created, again?" its answer was a day
later than the previous time.  Its **read-only** `created_at` attribute was
**changing**!  What?!

Well, it turned out to be quite simple.

The test Environment's time-travel facility has an `elapse_time` method for
turning the clock forward.  It looks something like this:

    sub elapse_time {
      my ($self, $duration) = @_;

      X->throw("can't elapse time when clock is not stopped")
        if $self->_clock_state ne 'stopped';

      X->throw("tried to elapse negative time")
        if $duration->is_negative;

      $self->_clock_stopped_time( $self->now->add_duration( $duration ) );
    }

We make sure we're only moving the clock forward, then we make a DateTime equal
to the old one plus the duration, then we replace the Environment's time
attribute with the new one.  What's the problem?

The problem is that `add_duration` *affects the time piece on which it is
called*.  When the objects with `created_at` attributes called
`Environment->now`, they were getting the same object as subsequent calls, when
the clock was stopped.  When the clock was moved forward, the `add_duration`
affected not just the pretend wallclock, but also the `created_at` of any
object created during that time period.  **Madness!**

The fix was incredibly simple:  we added a `->clone` just before
`->add_duration` and another one inside the test Environment's `->now` method.  We're also going
to see whether we can't just make our application's internal subclass of
DateTime entirely immutable.  Still, what a bug!  If the system had been much
larger, I think I could have easily spent a day on it.

Remember, friends:  **mutable state is the enemy**

(For fun you can also read [the commit mentioned in the chat log at the beginning](https://github.com/pobox/Moonpig/commit/df4ae63).)
