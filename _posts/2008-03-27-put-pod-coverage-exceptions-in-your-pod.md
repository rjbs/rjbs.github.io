---
layout: post
title : "put pod coverage exceptions in your pod"
date  : "2008-03-27T03:57:24Z"
tags  : ["perl", "programming", "testing"]
---
After having this task languish in my todo for years, at least, I have finally
reduced my goal to the important 90% and applied some JFDI.

Pod::Coverage::TrustPod acts like Pod::Coverage::CountParents, but accepts
non-whitespace lines inside "Pod::Coverage" POD targets as "trustme"
instructions.

In otherwords, given this module:

```perl
package Foo;

=begin Pod::Coverage

  bar

=end Pod::Coverage

=head2 baz

This routine does stuff.

=cut

sub foo { ... }
sub bar { ... }
sub baz { ... }
sub _xyzzy { ... }
```

Pod::Coverage::TrustPod will return 2/3 coverage.  `_xyzzy` is private, so
uncounted.  There are docs for baz, bar is trusted (because it's in the
Pod::Coverage =begin block) and there are no docs for foo.

The basic use case is that now my xt/pod-coverage can now read:

```perl
all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
```

and the information on what code is written but undocumented can be put where
it belongs -- near the code that is written but undocumented.  This will help
eliminate both (A) marking a symbol `trustme/also_private` in all of a dist's
packages so that I can use `all_pod_coverage_ok` and (B) having to write a
bunch of `pod_coverage_ok` lines to avoid problem A.
