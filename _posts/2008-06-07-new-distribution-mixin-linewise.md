---
layout: post
title : "new distribution: mixin-linewise"
date  : "2008-06-07T15:52:07Z"
tags  : ["perl", "programming"]
---
I was almost led astray into the den of releasing a module with a name ending
in `::Tiny`, but then I saved myself.

I found myself implementing these three methods, again:

    sub read_handle { ... }

    sub read_file   { ... }

    sub read_string { ... }

So, the second two translate the input into something the first can understand
and business continues as normal.  How often have I written this, or something
like it?  I'm not sure, but pretty often, anyway.

I wrote a very simple hunk of reusable code, stolen from Config-INI (which in
turn stole from Config-Tiny), to let you get those two methods built for you.
It uses Sub::Exporter, which means you can say what you want the methods to be
called (mostly) and what method you want them to call when they've gotten a
handle.

Of course, using Sub::Exporter also means pulling in a few more prerequisites,
but that doesn't bother me.  Once I'm writing non-trivial code, I'm very likely
using Sub::Exporter anyway.

Mixin::Linewise is on the CPAN, and has both Reader and Writer modules.

