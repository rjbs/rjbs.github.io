---
layout: post
title : further avoiding global configuration with per-object classes
date  : 2006-06-06T12:14:00Z
tags  : ["perl", "programming"]
---
Every time I see a package variable used for configuration, I wince and shake my fist. Despite this, I have a number of modules that use globally-defined plugins. Some of these are usually not a big deal, because the modules are almost always going to be used in programs with one object of the class. Module::Starter and Mail::Audit fall into this group. (I don't really think this is a good excuse, but it's a reasonable explanation.)

Other classes really do suffer from it, like HTML::Widget::Factory and Number::Tolerant. It limits the way that they can be used in conjunction with other modules. To be fair, I don't know of a large group of people clamoring to make their Number::Tolerant-based code pieces interoperate, but the widget factory is something we use a good bit at work, and we have some interesting ideas about how to use it to make our lives even easier. This becomes a problem if every widget factory has to use the same global set of plugins.

The objects produced by the factory work using existing plugins that affect the modules mixed in to the object's class. Class::Prototype or Class::Classless make it easy to have objects with differing but similar behavior, but they'd make the code more idiosyncratic and would require re-engineering the plugins, or writing an annoying (for me, at least) adapter.

Instead, I'm stealing from Ruby (which, for all I know, already stole the idea). HTML::Widget::Factory's new method now returns objects in a unique class, derived from HWF and with a set of plugins mixed into it. Every factory, and all its created objects, also get one more datum: a Package::Reaper. Package::Reaper is a new part of the Package-Generate distribution, and it makes me happy. Reapers use the "exists to be destroyed" pattern; when the reaper is destroyed, so is the package it's made to reap. This means that by using Package::Generate and Package::Reaper together, you can approximate the production of lexical, garbage-collected classes.

I'd like to factor this behavior out and mix it in to other modules, but I'm not sure exactly how abstract to make it, yet. If I decide to tie myself to a few rules, especially regarding how plugins or mixins are added and whether they can be removed, it should be simple. My current goal is to implement my specific needs in a few modules, then see how I can abstract it out of all of them into a common solution. That has worked well in the past, so I'm hoping it will again.  
