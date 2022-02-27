---
layout: post
title : "Test::Fatal, for simpler exception testing"
date  : "2010-10-25T14:30:45Z"
tags  : ["perl", "programming", "testing"]
---
Right now, the most popular Perl library for testing code that throws
exceptions is probably
[Test::Exception](http://search.cpan.org/dist/Test-Exception/).  It works like
this:

    dies_ok   { ...code that might die... } 'description';

    throws_ok { ...code that might die... } 'Class::Name', 'description';

    throws_ok { ...code that might die... } qr{regex}, 'description';

    lives_ok  { ...code that might die... } 'description';

There are some things about this interface that bother me, like the lack of
commas after the closing brace, or the use of one test for both `isa` and `=~`
testing.  Those minor annoyances got to me every time I tried to use
Test::Exception, but they weren't the thing that really bugged me.  That was
the use of [Sub-Uplevel](http://search.cpan.org/dist/Sub-Uplevel/).

Sub::Uplevel is a library that lets you call a subroutine, but hide parts of
the call stack visible to it.  In other words, if the subroutine checks the
result of `caller`, it won't see the real answer, but will instead see what it
would have seen, had it been called from a higher place in the stack.  This
effect is accomplished by replacing `CORE::GLOBAL::caller` -- scary stuff
indeed.  It's even a bit worse, because it has to replace it globally and then
only behave differently if `uplevel` is in effect.

Sub::Uplevel interacts strangely with other tricky code, and the development
branch of perl5 seems to break Sub::Uplevel more often than many other
libraries.  What makes this frustrating is that in almost every case, there is
no reason for anyone to use Sub::Uplevel.  It should only be used when it is
absolutely necessary that the callee not see a few stack frames.  That's only
necessary when the callee has distinct behavior based on different callers, and
that behavior can't be overridden with explicit parameters.  Writing code that
behaves that way is a *really bad idea*.  Test::Exception's use of Sub::Uplevel
caters to this very small minority of awful code, at the expense of making
better distributions unstable because of their unneeded dependency on
Sub::Uplevel.

This week, I released [Test::Fatal](http://search.cpan.org/dist/Test-Fatal/),
which is a replacement for Test::Exception.  It is not a drop-in replacement,
because I didn't really care for the API of Test::Exception.  Instead, it
provides only one important routine:  `exception`.

`exception` is passed a code block and executes it.  If the code throws an
exception, the exception is returned.  Otherwise, `exception` returns undef.
In the event that an exception was thrown, but it is undefined or otherwise
false, Test::Fatal will *die*, telling you in effect, "This code can produce
the really awful case of 'died but `$@` is false,' and you should either fix it
or use a more sophisticated testing mechanism for it."

This means that the sample of Test::Exception code, above, could be rewritten
as follows:

    dies_ok   { ...code that might die... } 'description';
    # becomes...
    ok(exception { ...code that might die... }, 'description');

    throws_ok { ...code that might die... } 'Class::Name', 'description';
    # becomes...
    isa_ok(exception { ...code that might die... }, 'Class::Name', 'description');

    throws_ok { ...code that might die... } qr{regex}, 'description';
    # becomes...
    like(exception { ...code that might die... }, qr{regex}, 'description');

    lives_ok  { ...code that might die... } 'description';
    # becomes...
    ok(! exception { ...code that might die... }, 'description');

The only external library used by Test::Fatal is
[Try::Tiny](http://search.cpan.org/dist/Try-Tiny/), which is a fantastic
library, and is what I use to test any exceptional flow control too weird to
test with Test::Fatal.

Finally, one great upshot of the birth of Test::Fatal is that Moose has been
converted to use it, so Moose will no longer be broken on bleadperl when
Sub::Uplevel is broken!

