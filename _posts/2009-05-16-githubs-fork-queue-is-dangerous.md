---
layout: post
title : "github's fork queue is dangerous"
date  : "2009-05-16T03:11:21Z"
tags  : ["git", "programming"]
---
One of the reasons I was keen to use GitHub for hosting controlled files at
work was because of the slick chrome that GitHub puts on a lot of Git
operations.  It meant that some of our less technical users could still benefit
from using a DVCS without having to understand a lot about remotes or merging.
Unfortunately, it turns out that the most important piece of this chrome is
totally unsuitable for use by non-technical users.

The GitHub Fork Queue provides a easy way to see commits that other people have
made on their forks of your project.  You can see that User X has made a bunch
of commits to implement a key feature, or that User Y has fixed an obnoxious
bug.  Then you select the changes you want to pull into your repo and click
"apply" and you get those changes.

The problem is that these changes are not pulled.  If a fast-forward is
possible, it is not performed.  If a simple merge is possible, it is not
performed.  These are what would happen with a pull, and they make it very easy
to benefit from the constant-branching-and-merging workflow optimizations of
Git.

Instead, each change, in turn, is cherry-picked.  That basically means that a
diff of the commit to its parent is computed, then applied to your integration
branch.  That means that each commit you cherry-pick is cloned, has a new sha1
(unique identifier) and that the original author's actual commits do not become
part of your source tree.  This leads to those less technical users ending up
with weird repositories that still end up needing to be merged -- only now the
reason for merging is much harder to explain.

In most cases, the most useful options would be to either list fast-forwardable
paths of development or to list entire branches that the fork queue could
attempt to merge.  Cherry picking, because it is effectively a form of
published rewritten history, should be a strategy of last resort -- or at least
a strategy deployed only by those who really know what they're doing.

In other words, the chrome that should simplify using a DCVS is so dangerous
that it should only be used by those users who are already comfortable with the
underlying tools and concepts.

It's a shame that I can't just disable the Fork Queue as a feature on forks of
all my projects, forcing people to think about what they're doing.  Until then,
I guess all I can do is blog about it.

