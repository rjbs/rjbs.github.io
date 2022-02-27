---
layout: post
title : "adding the perl-support section to my CPAN modules"
date  : "2021-07-02T23:39:49Z"
tags  : ["cpan", "perl", "programming"]
---
I have quite a few Perl software libraries available on the CPAN.  I've written these at different points over the last twenty years, but almost all of them, until pretty recently, were written to support perl v5.8, which was released about 18 years ago.  Perl v5.10 took almost four years to come out after v5.8. It had some teething problems, and then v5.12 took another three years.

During all this, with a lot of people pretty firmly entrenched in v5.8, it became pretty normal to assume that your users might very well be stuck on v5.8.  That meant it was a courtesy to support that version of perl.  Over the years, though, this didn't seem to move forward too much.  Perl v5.8 seems to remain a pretty standard default version to target.  I find this annoying, and I am going to be mostly ignoring this convention.

I don't think I really need a lot of justification for this, but I'll provide just a little.  When I write code, I want to write it in one way.  To me, the reason that Perl's "more than one way to do it" is great is that I can pick the one I like best, then always do that.  Over time, better ways become possible, and I pick those.  I don't write in every possible way, I write in one.  The more versions of perl I support, the more I need to think about how to write something beyond "the way I most like to write things."

Being stuck on an old version of perl is a pain.  I have had production systems stuck on old perls, and it's not fun.  Sometimes, though, that's just how it is.  It's part of dealing with the realities of operating software systems. When I get stuck in that situation, I don't expect all the new releases of code that I use to still work on my old perl.  It's nice if they do, but if they don't, it's just more of the debt I'm incurring by virtue of being stuck.  It's my problem, and not the problem of people who write new versions of things.

In the Perl Toolchain world, where things like "that program that runs your tests and installs your code", our rule is that we must support very old perls. This is reasonable, because this code is the thing that everybody wants to rely on.  Possibly there are a small number of distributions I maintain that are sufficiently relied-upon that it would be important for new releases to keep working on old perls.  Mostly, though, I think this is a problem best foisted downstream to operating systems still supporting and shipping ancient perls.

A while ago, I bumped up the minimum version on a few of my libraries to v5.20. (That version came out in 2014, so this is something like saying you support MSIE 11 but not older, to make a somewhat sloppy comparison.)  Some of the pushback I got was, "The normal thing is to support 5.8, and you gave no notice you might not!"  That's fair.  It's especially fair if there are some libraries where I think I'd obviously keep 5.8 working, some where I'd be happy to require the latest monthly release, and some where I think there's some reasonable medium!

So, I have made a plan and written a little code, and it goes like this:

I added a new configuration option to [my Dist::Zilla bundle](https://metacpan.org/pod/Pod::Weaver::PluginBundle::RJBS), to let me declare how far in the past I'm prepared to live.  I called this setting `perl-support`, but I think I'll end up changing that.  It's not really related to me _supporting_ anything.  It's just about my intentions toward changing prerequisites.

I started with these options:

* **standard** - If code won't work on every version of perl still in its
     perl5-porters maintenance period, I won't ship it.  That means that once a
     perl is about three years old, I won't worry about.  I don't actually expect
     to use this one very often, so possibly I'll rename it.
* **long-term** - I won't require a perl less than five years old.
* **extreme** - Extreme as in "extremely long term".  I won't require a perl
     less than ten years old.
* **toolchain** - I will abide by the [Lancaster Consensus](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lancaster-consensus.md), meaning I'll stick to whatever the toolchain promises to support.  Right now, that's v5.8.1.
* **no-mercy** - I do what I want.

Over the past few weeks, I've been adding this setting to my bundle.  It does a couple things, but by far the most important is add some text to my documentation that says something like this:

> This module has a long-term perl support period. That means it will not
> require a version of perl released fewer than five years ago.
> 
> Although it may work on older versions of perl, no guarantee is made that the
> minimum required version will not be increased. The version may be increased
> for any reason, and there is no promise that patches will be accepted to
> lower the minimum required perl.

I don't actually plan to start cranking up the required versions of things just because, but when I do work on my code, I do want to modernize it.  Now I'm just setting a guideline to myself about how modern I'll go.

At time I'm writing this, here's what level means what perl:

* **standard**  - v5.32.0 (or v5.30.0 if I go by security support)
* **long-term** - v5.24.0
* **extreme**   - v5.14.0
* **toolchain** - v5.8.1
* **no-mercy**  - v5.35.1?  Blead?  Only my own private build?  I do what I want!

So far, I've been marking most of my code long-term.  I'm pretty happy with that.  v5.24.0 is the last version that I helped produce as pumpking, so it's a bit like I'm saying "I really want to use all the features I was helping to get out the door."  And I do really want to!
