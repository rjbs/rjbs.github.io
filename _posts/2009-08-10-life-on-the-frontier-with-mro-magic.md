---
layout: post
title : "life on the frontier with mro magic"
date  : "2009-08-10T15:02:07Z"
tags  : ["perl", "programming"]
---
`MRO::Magic` is a system for writing your own method dispatcher in Perl.  I have
[written about MRO::Magic](http://rjbs.manxome.org/rubric/entry/1739) before,
but it's rushing toward being useful as 5.10.1 rushes toward release.

Right now, I have two weird issues.  Neither is a real blocker, but both
concern me because they really highlight the hairiness of doing this sort of
thing.

The first is that in *one* case, the following line emits an "Uninitialized
value in subroutine entry" warning:

    $class->UNIVERSAL::isa('Class');

In all cases in the test, `$class` is the string "Class" and in all but one
case, there is no warning.  What?  I don't know if this matters, but it's
confusing, and makes me feel like my own code is voodoo, which is not a feeling
I want.

The other case is more troublesome, as it is likely to drastically affect
performance.

Because we're altering the way that method resolution works, we need to manage
our own method caching, which we can do with the "mro" module.  I tried to use
`mro::method_changed_in` on the classes being magicked, but it failed.  It
looked like I'd need to alter superclasses, so I just called the method on
`UNIVERSAL` and things worked.  Of course, this means that any time you called
a method on an MRO::Magic class, you'd clear you entire method cache.  Oof!

Today I tried injecting a new, empty package into the `@ISA` of magicked
classes and marking it as having changed.  This got me neither the
pre-UNIVERSAL-clearing behavior (of failing tests) nor the UNIVERSAL-clearing
behavior (working).  Instead, I got deep recursion.

Waah?!

If anyone is feeling brave and wants to have a look at
[MRO::Magic](http://github.com/rjbs/mro-magic/tree/master) on 5.10.1
RC1, I would really appreciate it!

