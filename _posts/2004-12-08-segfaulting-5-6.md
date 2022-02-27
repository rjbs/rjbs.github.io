---
layout: post
title : "segfaulting 5.6"
date  : "2004-12-08T19:21:00Z"
---
Well, I knew I'd forgotten to tell Number::Tolerant to require 5.6, which it
wants.  (I like warnings and our, and I'm willing to require 5.6 for them. It's
old!)  Now I realize it needs 5.8, too, due to this weird bug:

```perl
use strict;
use warnings;

package Noval;
use overload fallback => 1, '0+'=> sub { undef };

package main;

my $noval = bless {} => 'Noval';

my $plus0 = 0 + $noval;
```

It segfaults 5.6, and I just don't care enough to investigate deeply.  We use
5.8 at work, after all.

