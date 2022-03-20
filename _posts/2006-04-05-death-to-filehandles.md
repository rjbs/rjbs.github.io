---
layout: post
title : "death to filehandles"
date  : "2006-04-05T23:09:31Z"
tags  : ["perl", "programming", "stupid"]
---
Adam has a module called Params::Util.  It provides a bunch of routines that
let you say something like "is this value an X value?"  X might be "array" or
"valid identifier" or so on.  In general, I don't put that module to a lot of
use.  Maybe I should, but I don't.

The one routine that I do often use from it is one that I donated: `_CALLABLE`:

```perl
sub _CALLABLE {
  (Scalar::Util::reftype($_[0])||'') eq 'CODE'
  or
  Scalar::Util::blessed($_[0]) and overload::Method($_[0],'&{}')

  ? $_[0]
  : undef;
}
```

I've reformatted it for slightly better readability.  Basically, it tells you
whether this will work:

```
$value->();
```

It's nice to be able to pass a bit of code into another bit of code.  If you've
never done it, give it a try.  It's also nice that you can pass in things that
act like a bit of code.  As with many things in Perl, though, the problem that
can arise is that people are lax in checking that they can call the thing in
question.

If someone is checking whether you've passed in `$data` that is actually
callable, you might see one of these:

```perl
if (ref $data eq 'CODE') { act_on $data->() }

if (UNIVERSAL::isa($data, 'CODE')) { act_on $data->() }

if (my $result = eval { $data->() }) { act_on $result }
```

These all suck.

In the first case, all you can pass in is a plain old CODE ref -- or something
blessed into the class CODE.  This prevents someone from taking advantage of
the fact that objects, in Perl, can be called like coderefs.  Callable objects
are quite useful, especially because they can be passed in where a coderef is
expected -- but only if the coderef is being detected properly.  Once you're
blessing your object into CODE just to satisfy that test, you've got problems.
Either you can only do this with one class, putting the object's methods in
the CODE package, or you can do really weird things with method dispatch to
allow multiple classes to share space in CODE.  Either way, you lose.

The second option is just the tiniest bit better.  With that option, if you've
built an object from a blessed coderef, the test will pass and `$data` will be
called.  If your object isn't built atop a codref, however, it won't work.
Now, you could try to override the `isa` method so that it would lie about
whether your object was a code, but because the programmer us calling
`UNIVERSAL::isa` as a function, it won't help.  To fix this, you can use
chromatic's UNIVERSAL::isa module, which makes the `isa` in UNIVERSAL respect
your override.  Of course, now you're mucking with UNIVERSAL.  Those who know
me know that I think, at this point, that you have lost.

Why is it that the programmer called `UNIVERSAL::isa` as a function, you ask?
Well, it's because in Perl, you can't call a method on anything but a blessed
reference.  Why not?  Maybe if I looked back into the pits of history there
would be a better answer, but I suspect it comes down to bad design choices.

I think life would be better overall if any scalar could respond to methods,
even if it was usually to throw an exception.  It would mean that they could
all answer to `isa` and can as methods, which could let us replace that second
choice, above, with:

```perl
if ($data->isa('CODE')) { act_on $data->() }
```

This would be a little weird, but it would be entirely acceptable.  Perl
doesn't have a big history of duck typing, so we can forgive that we're not
checking, I don't know... `can('&{}')` or something wretched like that.

The last remaining option was

```
if (my $result = eval { $data->() }) { act_on $result }
```

This sucks the most.  It work as long as `$data` is callable and returns
something true.  (It could be tweaked to work as long as it's callable, but
would get even uglier and no better.)  Unfortunately, it has to call it to find
out whether it's callable.  This severely limits the usefulness of the
callback, since you must either: (a) have just one context in which the routine
is called and one set of params to pass or (b) have a lot of convoluted code
that puts off the "is it callable?" check until the last possible statement.

That is why I like `_CALLABLE`.  It will actually tell you whether something
can be called.  There are really only two possibilities: the underlying
reference is to code, or the variable is an object that provides deref-as-sub
overloading.

Maybe by now you're really wondering why the subject of this entry is a call to
arms against filehandles, since I seem mostly to be rambling on about coderefs.

The coderef problem ("is this thing callable?") in under ten lines of code.
Sure, not everyone uses `_CALLABLE`, but they can (and should).  There is
another problem, though: "is this thing a filehandle?"  This problem is much
more obnoxious, and I'm just not sure there's a reasonable way to deal with it.

Part of the issue is that being a filehandle implies a much larger interface
than being a coderef.  There are a lot of builtins that you need to respond to,
and if IO::File is in play, you'll be expected to answer to a lot of methods,
too.  There's just no clear way to determine whether something wants you to
think that it's a filehandle.  It really makes me want more people to use
Roles.

My most recent run-in with this problem was this week, as I tried to make some
resources remotely available.  They're files associated with persistent
objects, and traditionally only the servers with the files on a mounted share
could access the data.  I wanted to use a network protocol to make the content
available without mounting; I'd get the document and put it in a IO::String
object and hand that back from the `get_fh` method.

This failed horribly.

Eventually, the IO::String was passed to Mail::Internet, which will accept a
filehandle of data to turn into a piece of mail.  It checks whether that's what
it's gotten like this:

```
if (defined fileno($data)) { ... }
```

`fileno` throws an exception if the value passed to it can't be coerced into a
glob reference.  That means that if you built an object on top of a non-glob
reference and didn't overload `*{}`, this will fail.  Later, it will use the
diamond operator to get the data out of your faux-file, so you'd better have
overloaded that, too.  (That means that merely providing the methods `getline`
and `getlines`, provided to real filehandles by IO::Handle, is not enough.)

Well, IO::String is built on a glob reference, and tied as one.  It provides
the `getline` and `getlines` methods and responds to the diamond operator.
What was going wrong?

It was returning `undef` to `fileno`.  A comment in the code explained that
perlfunc said that an undefined fileno indicated a closed file.  So, is
Mail::Internet to blame for checking it?  Probably not; a closed file isn't
likely to provide any data on read, and it couldn't rely on IO::Handle's
interface, because Mail::Internet supports 5.002, which predates IO::Handle.
(Well, it could, but I'm assuming that this is why it doesn't.)  Maybe it could
rely on FileHandle...

I think, in the end, this problem is less solvable than the coderef one.
Writing _ITERABLE is pretty simple:

```
sub _ITERABLE {
  (Scalar::Util::reftype($_[0])||'') eq 'GLOB'
  or
  Scalar::Util::blessed($_[0])
    and
    (overload::Method($_[0],'*{}') or overload::Method($_[0],'<>'))

  ? $_[0]
  : undef;
}
```

This mostly gets the job done, although it assumes that any glob can be
meaningfully iterated, which isn't really true.  The bigger problem, for me, is
that I want at least a little more interface.  I want `tell` and `seek`.  I'd
even settle for some sort of `reset` or a way to determine whether the iterator
was pristine.

I'm going to send a patch for Mail::Internet, I suppose, to get around the
ugliness I've put into my IO::String subclass to make this work.  I'm not
really happy with it, but it will be an improvement.

In my own code, I know how I will avoid this problem: I won't accept
filehandles.  They are dead to me.  Instead, I will accept coderefs which
stream the data.  After all, I already know how to tell whether something is
callable.
