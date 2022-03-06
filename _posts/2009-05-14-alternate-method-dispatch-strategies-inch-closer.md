---
layout: post
title : "alternate method dispatch strategies inch closer"
date  : "2009-05-14T21:04:31Z"
tags  : ["perl", "programming"]
---
It's been nearly two months since [my last update on writing new method
resolvers in Perl]({% post_url 2009-03-22-writing-your-own-dispatcher-for-fun-profit-can-come-later %}), and not much has
happened.  I was very disheartened to learn that while it was easy (for some
value of "easy") to make this work:

    $object->magic_method(...);

This was not as simple:

    my $method = 'magic_method';
    $object->$method(...);

It's not all that exciting to explain, so I'll be brief.  In Perl, you can
attach "magic" to variables that makes them behave in new ways.  This is how
the [tie](http://perldoc.perl.org/perltie.html) built-in works, and it's very,
very powerful and useful.  (It's also very dangerous, if you use it without
thinking long and hard, first, so don't just go crazy with variable magic!)

Method dispatcher replacement worked by attaching magic to the stash, where a
class's symbols are stored.  Unfortunately, not all the things that accessed
the stash respected magic.  Respecting magic can be slower than ignoring magic,
so there's constantly a tension between performance and enchantability in perl5
development.

[Florian Ragwitz](http://perldition.org/), who discovered this strategy for
method dispatch to begin with, suggested that I stop trying to avoid using his
excellent [MRO::Define](http://github.com/rafl/mro-define/) and just use it.
It means we'll need 5.10.1 instead of 5.8.z, but it also means that things
*work*.

Last night I finally got back to my code and pulled MRO::Define back in.  All
tests pass... except for one.  It's a really cool one, too, demonstrating one
of my biggest goals: anonymous, almost-first-class classes and instances.

As you can imagine, there's a fair bit of magic (or voodoo, in some cases)
swirling around this code, and debugging this problem is pretty taxing.  Want
to give it a go?  My code is, for now, in the [rjbs/metamethod GitHub
repo](http://github.com/rjbs/metamethod).  It will probably be renamed in the
near-ish future.

I look forward for using these new powers for good (and maybe some evil).

