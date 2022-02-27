---
layout: post
title : git: you're explaining it wrong
date  : 2008-01-25T15:37:04Z
tags  : ["git", "vcs"]
---
I switched from Subversion to Git entirely, shortly after YAPC last year.  Now
I only use `svn` for work and other people's projects, and even that is because
I'm just way too lazy to bother witching to `git-svn` just yet.

Git is a really great tool, and I have enjoyed using it much more than
Subversion.  By this, what I really mean is that it's generally gotten in my
way a lot less while still providing even more tools for getting real work
done.  I know that it's all sorts of different under the hood, and I even
understand some of them.  [This article about
Git](http://eagain.net/articles/git-for-computer-scientists/) was interesting
as lazy reading to get a bit more information about what's going on under the
hood.

It's not an introduction to using `git`, though.  I have seen quite a few
introductions to it that look something like [this
explanation](http://random-state.net/log/3410155710.html) that Git is all about
content and not metadata.  I'm not sure who the intended audience is for this
post, but I hope it isn't "people considering switching to Git."

I see a lot of people saying, "I tried to move to Git, but it was too
confusing."  I think the confusion must be coming from the hype, and not so
much the product.  Sure, Git can be really confusing, when you get into its
weird features that come from its magical moon code, but it makes a very simple
replacement for a lot of CVS or Subversion use cases.  The problem is that once
you've become part of the Git Mob, you become so excited by true
decentralization, content-addressability, and other forms of advanced mtfnpy
technologies that you can no longer be bothered to explain how to just check in
a damned file change.

Fortunately, I have not yet tried to deal with any of the `git` commands that
are rated GURPS Tech Level 8 or above, so I still bellyfeel Subversionthink.

Sam Vilain, who is way cool, wrote [an introduction to git-svn for
Subversion/SVK users](http://utsl.gen.nz/talks/git-svn/intro.html), and it's
very good, especially at explaining why Git is a good tool.  There's also Git's
own [Git - SVN Crash Course](http://git.or.cz/course/svn.html), which isn't
bad, but it does some weird things like put tagging and branching under one
header (even though in Git they are, as is proper, two distinct things).

My point is this:  if you have your own code or documents under source control,
git is a very good tool to consider.  It's very, very fast.  It's very easy to
use.  It comes with a lot of nice tools (like, say, `gitk`).  If that sounds
nice, don't get distracted listening to how it will revolutionize your
conception of source code control by eliminating metadata-based delta-logarithm
concatenation sets.  Just run `git init` and start committing.  The two
documents above are decent minimal introductions.  Maybe I'll do a lightning
talk on Git For Morons this year.

