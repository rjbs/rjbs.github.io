---
layout: post
title : "a big ol' Catalyst upgrade"
date  : "2015-10-01T03:45:45Z"
tags  : ["perl", "programming"]
---
At [work](https://www.pobox.com), a fair bit of our web stuff is Catalyst.
That's not just the user-facing website, but also internal HTTP services.  For
a long time, we were stuck on v5.7012, from late 2007.  That's pre-Moose (which
was 5.8000) and pre-Plack (which was 5.9000).  It wasn't that we didn't want to
upgrade, but it was a bunch of work and all the benefits we'd see immediately
were little ones.  It was going to free us up for a lot of future gain, but who
has the time to invest in that?

Well, I'd been doing little bits of prep work and re-testing over time, and
once in a while I'd see some plugin I could update or feature I could tweak,
but for the most part, I'd done nothing but repeatedly note that upgrading was
going to take work.  A few weeks ago, I decided to make a big push and see if I
could get us ready to upgrade.  This would mean upgrading over eight years of
Catalyst… but also Moose.  We were running Moose v1.19, from late 2010.

The basic process involved here was simple:

1.  make a local::lib directory for the upgrade
2.  try to install Catalyst::Devel and Catalyst::Runtime into it
3.  sort out complications
4.  eventually, run tests for work code
5.  sort out complications
6.  deploy!

So, obviously the interesting question here is:  what kind of stuff happened in
steps 3 and 5?

Most of this, especially in step 3, was really uninteresting.  Both Catalyst
and Moose will tell you, when you upgrade them, that the upgrade is going to
break old versions of plugins you had installed.  So, you upgrade that stuff
before you move on.  Sometimes, tests would fail because of unstated
dependencies or bugs that only show up when you try using a 2015 modules on top
of a 2007 version of some prereq.  In all of this I found very little that
required that I bug Catalyst devs.   There was one bug where [tests didn't skip
properly](https://rt.cpan.org/Public/Bug/Display.html?id=106373) because of a
silly coding mistake.  Other than that, it was mostly an n-step process of
upgrading my libraries.

The more complicated problems showed up in step 5, when I was sorting out our
own code that was broken by the update.  There wasn't much:

* plugins written really fast and loose with the awful Catalyst "plugins go
    into your `@ISA`" mechanism
* encoding issues
* suddenly missing actions (!)
* deployment issues

In general, we fixed the first by just dropping plugins that we no longer
needed.  The only plugin that really mattered was the one that tied Catalyst's
logging system to our internal subclass of
[Log::Dispatchouli::Global](https://metacpan.org/pod/Log::Dispatchouli::Global),
and that was replaced by roughly one line:

```perl
Pobox::Web->log( Pobox::Web::Logger->new );
```

So, we killed off a grody plugin and replaced it with a tiny wrapper object.
Win!

I also had to make this change to our configuration, which seemed a bit
gratuitous, but the error message was so helpful that I couldn't be too
bothered:

```diff
- view: 'View::Mason'
- default_view: 'View::Mason'
+ view: 'Mason'
+ default_view: 'Mason'
```

Encoding issues ended up being mostly the same.  We dropped the Unicode plugin
and then killed off one or two places where we were fiddling with encodings in
the program.  Honestly, I'm not 100% sure how Catalyst's old and new behavior
are supposed to compare, but the end result was that we made our code more
uniformly deal in text strings, and the encoding happened correctly at the
border.

The missing actions were a bigger concern.  What happened?!

Well, it turned out that we had a bunch of actions like this:

```perl
sub index : Chained('whatever') Args(0) { ... }
```

These were meant to handle `/whatever`, and worked just fine, because in our
ancient Catalyst, the `index` subroutine was still handled specially.  In the
new version, it was just like anything else, so it started handling
`/whatever/index`.  The fix was simple:

```perl
sub index : Chained('whatever') Args(0) PathPart('') { ... }
```

Deployment issues were minor.  We were using the old Catalyst::Helper scripts,
which I always hated, and still do.  Back in the day, and in fact before
Catalyst::Helper existed, Dieter wrote what I considered a much superior system
internally called Catbox… but we never really polished it up enough for general
use.  I regenerated the scripts, but this was a bit of a pain because we'd made
internal changes, and because the helper script generator doesn't act nicely
enough when your repo directory name doesn't quite match your application name.
I got it worked out, but it didn't matter much, because of Plack!

I had been dying to get us moved to Plack for ages, and once everything was
working to test, I replaced the service scripts with wrappers around `plackup`.
I mentioned this to `#plack` and got quoted on
[plackperl.org](http://plackperl.org/):

> "Today, I finished a sizable project to upgrade almost all of our web stuff
> to run on Plack. Having done that, everything is better!"

It was true.  I replaced old Catalyst::Engine::HTTP::Prefork with Starman and
watched the low availability reports become a trickle.  I've moved a few things
to Starlet since.  (I couldn't at the time because of a Solaris-related bug,
since fixed in Server::Starter.)

The Moose upgrades were similarly painless.  The main change required was in
dealing with `enum` types, which now required that anonymous enumerations had
their possible values passed in in a reference, rather than the old, ambiguous
list form.  Since I was the one who, years ago, pushed for that change, I
couldn't get upset by having to deal with it now.

All told, I spent about three work days doing the upgrade and then one doing
the deploy and dealing with little bugs that we hadn't detected in testing.  It
was time well spent, and now we just have one last non-Plack service to
convert… from HTML::Mason.
