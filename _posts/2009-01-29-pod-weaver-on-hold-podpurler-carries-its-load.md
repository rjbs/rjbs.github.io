---
layout: post
title : pod::weaver on hold, podpurler carries its load
date  : 2009-01-29T04:39:47Z
tags  : ["distzilla", "perl", "programming"]
---
As I recently explained in an [email to the Dist::Zilla
list](http://www.listbox.com/member/archive/139292/2009/01/sort/time_rev/page/1/entry/0:1/20090111130839:BCEF116E-E00A-11DD-A36D-AC73AB975BFC/),
Pod::Weaver is on hold while I'm too busy with other priorities.  This has been
a holdup for Dist::Zilla, as its Pod::Weaver integration is my big need.

Since I can't magically make time, right now, to work on Pod::Weaver, I've gone
back to the original PodWeaver plugin that predates a well-designed Pod::Weaver
module and released it as a standalone Dist::Zilla plugin.  The [PodPurler
plugin](http://github.com/rjbs/dist-zilla-plugin-podpurler/) is on GitHub now
and waiting to be indexed on the CPAN.  It will behave just like PodWeaver did,
originally.  If you avoid looking directly at the source, it's quite nice and
you can get back to releasing code without writing any boring boilerplate.

I think this will help me get a bunch more dists out the door next week.

