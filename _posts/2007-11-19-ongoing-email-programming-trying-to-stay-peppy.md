---
layout: post
title : ongoing email programming: trying to stay peppy
date  : 2007-11-19T02:10:55Z
tags  : ["email", "perl", "programming"]
---
Email is tough.  It's very, very complicated, which is a big problem, because
from the outside it seems so simple: it's like some headers and then a body or
two, right?  I try to advise people that Mail::Message is not as crazy as
everyone implies, but people really like to use something really, really
simple, and it leads to problems -- one of which is trying to figure out where
the ideal distinction between "just enough" and "too much" is.

Fortunately, I've been able to ignore some of the "core"
[PEP](http://emailproject.perl.org/) modules for a while, as they've been
keeping stable.  Instead, I've been doing some work on some of the second-order
modules, and I'm hoping to start making some real progress toward some bigger
goals.  (Part of this has involved resetting the due dates for them in my
OmniFocus, as they were so ridiculously past due that anything due soon was
pushed off my view of things to do.  Ugh!)

After a long string of slowly-improving dev releases, Email::Abstract has seen
a new stable release.  It adds quite a few tests, many of which failed on
previous releases, but which now pass.  Basically, it seems clear that the
original code was not ever really used, but just written as a lark, because
quite a lot of it could never have been used for much of anything.  I believe
that is no longer the case.

This is important, because it sets the stage for using Email::Abstract instead
of Email::Simple as the standard for email objects in Email::Sender, which
should replace Email::Send in 2008.  I'm hoping we can add some methods for
things like streaming, soon, but for now it's good enough to get started.

I'm also hoping to get a bit more work done on Email::Filter, largely focused
on improving its plugin system.  I'm using Email::Filter for all my mail, now,
and there are a few places where it's obvious that the triggers it provides are
not useful enough.  Its author wrote, of it, "This is another module I don't
use, because my Mail::Audit setup works and I'm terrified of breaking it and
losing all my mail. But I'm told that Email::Filter works just fine too."

Reading this sort of thing makes me want to review my modules and make sure
that I'm using them, to keep track of whether or not they're any good.  I know
that a number of the ones I don't really use are sort of lousy.  I should stick
a big LOUSY tag on them.

As always, the [Big Todo List](http://emailproject.perl.org/wiki/Big_Todo_List)
is full of stuff for anyone to help with.  I'm hoping to start getting
[ABE.pm](http://abe.pm.org) involved in doing some of the tasks, which should
be a lot of fun.

