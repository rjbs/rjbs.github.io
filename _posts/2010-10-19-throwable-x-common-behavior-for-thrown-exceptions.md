---
layout: post
title : "Throwable::X: common behavior for thrown exceptions"
date  : "2010-10-19T15:05:06Z"
tags  : ["perl", "programming"]
---
When I first wrote about
[Test::Routine]({% post_url 2010-09-30-test-routine-composable-units-of-assertion %}), I said it was a way
of building a replacement for Test::Class that relied on Moose for all of its
class composition.  I compared it to replacing
[Exception::Class](http://search.cpan.org/dist/Exception-Class/) with
[Throwable](http://search.cpan.org/dist/Throwable/), which let me get rid of a
lot of features that were oriented toward building classes, and which were
different from and inferior to those provided by Moose.

The thing you find out when you strip Exception::Class of all its sugar for
building classes is that there isn't much else there.  Throwable does nearly
nothing; it mostly just gives you a `throw` method that calls new and passes
the result to `die`.  Throwable also ships with StackTrace::Auto, which
captures a stack trace reflecting that stack at the point where your object was
created, which is also useful.  Still, there are a number of things I wanted to
get out of an exception that were specifically features for exceptions, not
just general purpose class construction things like adding attributes.

We sat down one day to talk about the things we needed from our exceptions,
both looking back at shortcomings in our existing exceptions and at features we
knew we would want based on planned future work.  We hashed out a basic design,
and now I've put together a basic implementation, available on the CPAN, for
review and improvement.
[Throwable::X](http://search.cpan.org/dist/Throwable-X/) is a combination of
roles providing solutions for common problems in handling exceptions.

## Identifying

We wanted to be able to know what exception we'd encountered, when our `catch`
block fired.  This seems pretty simple, right?  Well, it's really not.  There
are basically two tactics for this that I see often.  One is to check the
string form of the exception against a regex.  This is awful: if the error
message is changed, the error handling fails.  It's problematic to respond by
never changing error messages, because they may contain typos or grammatical
errors that are confusing to users reading the message.  Inspecting the
stringified form of the exception forces the value to be equally useful to both
computers and humans, which is nearly always a mistake.

Another tactic is to check the exception's class.  This is *much* better, but
it means that to make any given case identifiable, you need one class per
exception, which is not maintainable in practice.  Even if you were to write
sugar for auto-generating classes for each possible throw, it would become
difficult to track and read.

Throwable::X provides a few solutions to exception identification which work
together to make it possible to identify ranges of exceptional conditions on
several scales.  First, all exceptions still are members of classes, which
means that for very low-resolution checks, `isa` still works.  Further,
Throwable::X is a role, and it's easy to write additional behavior for groups
of exceptions as roles, so `does` can also be used.  On smaller scales, though,
these are still something of a pain.  Throwable::X adds unique identifiers and
tags to exceptions.

The unique identifier is just a string.  There's no real effort made to make
sure you can't throw the same identifier in more than one place, but by setting
aside an attribute of the exception as "for computers to know exactly what
happened," it's much easier for the programmer to provide a useful value.  What
should the value be?  There are a lot of potentially good answers to this, and
I'd rather not say.  It could be a URL following an in-house convention to help
prevent accidental collisions.  It could be a GUID entered in a global table --
or just useful for grepping.  I think I'll probably end up just using a short
string, or maybe a URL.

The ident is the only part of the exception you absolutely must provide, and
since that's true, you can provide it as a single argument:

```perl
Some::Exception->throw($ident); # same as...
Some::Exception->throw({ ident => $ident });
```

The exception is tagged with a list of simple strings.  These can be provided
as arguments to `throw`, but the list also includes tags provided by any of the
classes or roles contributing to the exception being thrown.  This lets you
refactor your exceptions later without breaking a lot of `does` checks.  You
just ensure that the new roles add up to the same tags.

We can define several units of behavior:

```perl
package OurException::Role::Network;
use Moose::Role;
sub x_tags { qw(network) }

package OurException::ServerDown;
use Moose;
with 'OurException::Role::Common', 'OurException::Role::Network';
sub x_tags { qw(unavailable) }

has service_name => (...);
```

...and then easily see what's what:

```
OurException::ServerDown->throw({
  ident => ...,
  tags  => [ 'memcached' ],
  service_name => 'cache',
});

# the exception has tags: memcached network unavailable
```

Tags are easy to check with the `has_tag` method.

So, we have a bunch of ways for our code to identify what kind of exception has
been encountered.  Now we need to make it easy for humans.  To do this, we
added a [simple string formatting
system](http://search.cpan.org/dist/String-Errf/), something like `sprintf`
with a pared down set of conversions and named parameters.  It makes it easy to
write an error message that will have access to a lot of the exception's data,
even computed or implicit attributes.

We mark attributes that we want to be available in formats with the Payload
trait:

```perl
package OurException::OnThisHost;
use Moose;
use Throwable::X -all;
with 'Throwable::X';

has hostname => (
  is => 'ro',
  default  => sub { Sys::Hostname::hostname },
  traits   => [ Payload ],
  init_arg => undef,
);
```

Then, when an exception is thrown:

```perl
OurException::OnThisHost->throw({
  ident   => ...,
  message => "can't connect to gopher server from %{hostname}s",
});

# $err->message will be "can't connect to gopher server from real-hostname"
```

## Serializing and Presenting

Like a lot of services with web interfaces, we're adding more and more Ajax to
our web site.  We have some conventions for how we communicate successes or
errors, but they're not great, and they're not universally applicable.  The
identification features of a Throwable::X exception actually make it much
easier for us to communicate exceptions.  Imagine that the web application runs
its actions in a `try` (which of course it has to, anyway) and, in some
circumstances, just communicates the exception directly to the client.  The
first question is, how do we know it's safe to do so?  We don't want to send
back "no space left on device" and look like a bunch of idiots.  It's easy: we
just assume all exceptions are private unless marked otherwise.  Throwable::X
has a `public` attribute.  If an exception `does` Throwable::X, and if it
`is_public`, you can show the exception to the user.

So, how do we communiate it to the web client?  This is easy, too.  Everything
we've done so far works nicely to make our exceptions easy to represent with a
simple data structure:

```perl
{
  ident       => $err->ident,
  tags        => [ $err->tags ],
  message_fmt => $err->message_fmt,
  payload     => $err->payload,  # the attr values available in message_fmt
}
```

Since we rely on tags and ident for identification, we don't need to worry
about indicating any sort of class hierarchy or role inclusion.  Anything that
needs to be communicated will have been communicated by the tags and ident.

If our user experience team decide that they dislike the `message_fmt` that
we've sent, they can fix it.  They just tell the client-side code that when
encountering errors with ident X, they should use a new format instead of the
format given in the exception.  There's no need to alter the code, although it
can be altered later to improve the error message in places that haven't been
tweaked by UX.  If no message was given during exception construction, it
defaults to the ident.  Of course you usually want to provide a message, but if
you've got a unique ident and the user complains about getting "General Error:
-1203182012" you can grep for that (awful) ident and add a message everywhere
without breaking anything.

## Refactoring

Finally, all of these features are implemented individually as roles, so you
can pick and choose which ones to offer in your own exceptions, in the event
that you don't care for them all.

One thing that has still not been reconstructed, which was present in
Exception::Class, is an exception factory that builds all the classes desired
from a structure describing the exception class hierarchy.  For now, I'm not
sure I need something like that, but it should quite simple to build something
like that without altering Throwable::X, and to discard it later if it is
determined to be a mistake.

I think it's likely that we'll find a few more common patterns worth coding up,
but for now I think these can help to solve a lot of problems.

