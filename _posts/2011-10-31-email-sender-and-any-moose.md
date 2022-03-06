---
layout: post
title : "Email::Sender and Any::Moose"
date  : "2011-10-31T15:07:08Z"
tags  : ["email", "perl", "programming"]
---
At YAPC::Asia, I gave my talk [Email Hates the
Living!](http://www.youtube.com/watch?v=JENdgiAPD6c), and at the end there was
just one question:  "When will you make
[Email::Sender](https://metacpan.org/release/Email-Sender) use
[Any::Moose](https://metacpan.org/module/Any::Moose)?"

It's a reasonable question.  Email::Sender uses Moose, right now, which gives
it a startup (compile-time) cost that's something like a quarter second higher
than it would be with Mouse.  I've replied to these requests before with a very
stone-faced "never!"  I just didn't want to deal with the inevitable bug
reports related to it.  All my friends at YAPC::Asia were so hospitable,
though, and so polite in their questions about this change, that I decided to
give it a go.  While we sat around having beer and shabu-shabu, I pulled out my
laptop and powered through an attempt to make it happen.  As it turned out, it
was not easy to do, and I have put it back on my list of things that I am
unlikely to do myself.

Finding the problems was fun, though, as was [explaining the problem with as
little English as possible]({% post_url 2011-10-19-yapc-asia-awesome %}).  I
promised to publish the explanation, but before I got a chance to, someone
submitted [some patches](https://github.com/rjbs/throwable/pull/1) to do the
conversion.  Awesome!  Unfortunately, it was someone who hadn't been there, and
didn't get to hear the explanation of the problem.

Lest it happen again, here goes:

Email::Sender is meant to replace Email::Send.  Email::Send has a goofy API.
When you tell it to send a message, it returns a Return::Value object, which
might be false in boolean context.  If it's false, you can inspect the object
to find out why things failed.  There's a lot more wrong with the API, but this
one is pretty bad.  Probably you realized that as soon as I said there's an
object that might be false.  ("[P]urveyors of exception object classes
should have the good taste to make exception objects behave as true and
stringify to something non-empty." --
[Zefram](http://markmail.org/message/gsliygn32j7cb4up)))

Email::Sender addresses this problem by always returning an
Email::Sender::Success object or throwing an Email::Sender::Failure exception.
Its exceptions use my simple role for Moose exceptions:
[Throwable](https://metacpan.org/module/Throwable).  With that said, I can
start explaining the problem.

I converted Email::Sender to use Any::Moose within fifteen minutes or so.  It
was mostly a job for `s///` and a little poking around here and there.  All the
tests passed that didn't throw errors.  The errors failed because
Email::Sender::Failure said this:

    package Email::Sender::Failure;
    use Any::Moose;
    extends 'Throwable::Error';

When the Failure class was being loaded, other Email::Sender had already
loaded, setting Any::Moose to use Mouse, and now a Mouse class
(Email::Sender::Failure) was trying to extend a Moose class.  This is fatal.

So, now you'd think you could go and make Throwable an Any::Moose role.  This
is not really a good idea, and here is the code I used to explain it:

    # Abc.pm
    package Abc;
    use lib 'lib';
    use Moose;
    with('Role::AnyThing');
    1;

    # Xyz.pm
    package Xyx;
    use lib 'lib';
    use Any::Moose;
    with( 'Role::AnyThing' );
    no Any::Moose;
    1;

    # Role/AnyThing.pm
    package Role::AnyThing;
    use lib 'lib';
    use Any::Moose 'Role';
    sub foo { ... }
    no Any::Moose;
    1;

Here I have two classes, one Moose and one Any::Moose.  They both consume an
Any::Moose role.  So, what's the problem?  Well:

    $ perl -I lib -MAbc -MXyz -e0
    $ echo $?
    0

Great!  I can use these in the same program!  Or can I?

    $ perl -I lib -MXyz -MAbc -e0
    You can only consume roles, Role::AnyThing is not a Moose role at … line 137

What happened?  Well, in the *first* example, Abc is compiled first.  It loads
Moose.  When Xyz is compiled, it loads Any::Moose, which sees that Moose is
loaded, and uses Moose as its backend.  Everything is Moose.  In the *second*
example, Xyz is compiled first.  It sees that Moose is *not* loaded and that
Mouse *is* available.  It uses Mouse as its backend.  This means that
Role::AnyThing – an Any::Moose role – is now a Mouse role.  When Abc is
compiled and tries to compose it, it fails:  Abc is Moose but the role is
Mouse.

Throwable exists to be used all over the place by all kinds of things.
Sometimes it will be very, very simple and its behavior would be easy to
produce in Mouse.  Other times, though, it is getting composed with Moose-only
roles.  I throw exceptions that use Throwable together with MooseX modules.
These can't be converted to Any::Moose, and I don't want to convert them.

The real solution is to have some sort of Any::Throwable, so that if you're
using Any::Moose, you can use Any::Throwable and get a Throwable built against
Any::Moose's backend, but can otherwise be sure that Throwable itself is always
Moose-based.  *This* isn't trivial, because Throwable::Error uses
StackTrace::Auto, which would then need to be made to work properly under both
Moose and Mouse.

So, we get back to what I think the solution is:  make Moose faster.  Of
course, I'm even less likely to personally do much work on speeding up Moose
compile time.  I just don't have a lot of code that needs to run very quickly
and repeatedly from a standing start.  I write daemons, and I don't mind an
extra quarter second startup time on those.

It would be nice if everyone could use Email::Sender safely without Moose, but
I think it's a bunch more work than I am interested in doing.  I'll definitely
review patches, though, so let me know if you want to take a swing at making it
all work.

