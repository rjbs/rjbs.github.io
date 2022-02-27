---
layout: post
title : "adding some safety to git force-push"
date  : "2021-06-15T16:29:21Z"
tags  : ["git", "programming"]
---
Just the other day, I [wrote about my little git branch manager
tool](https://rjbs.manxome.org/rubric/entry/2122).  I use it to make sure I
know what branches I have lying around, and to delete branches that have
already been merged.  I wrote the post because I had updated the code to work
on more kinds of respository.

I updated the code to more on more kinds of respository because I wanted to
write a *different* program to do something similar.  See, about a week ago, I
did a force-push that I shouldn't have.  The history looked something like
this:

      * [733401c] (github/rewrites) add the EIGHT file
      * [036a97a] SIX: rewrite file number six
      * [5d8e998] FIVE: rewrite file number five
      * [40778dd] FOUR: rewrite file number four
      * [624f233] THREE: rewrite file number three
      * [249af25] TWO: rewrite file number two
      * [2ac9796] ONE: rewrite file number one
      | * [d2e2cfb] (HEAD -> rewrites) add the ZERO file
      | * [2fadf99] SIX: rewrite file number six
      | * [6a2218f] FIVE: rewrite file number five
      | * [bbbe25a] FOUR: rewrite file number four
      | * [adda952] THREE: rewrite file number three
      | * [5d7c662] TWO: rewrite file number two
      | * [f656f0f] ONE: rewrite file number one
      | * [4623ca5] (github/main, main) add a seventh file for good luck
      |/
      * [4c74ba5] add some random content

What you'll see here is that there's a common base, then two versions of the
same branch.  One version (the local one) has been rebased on `main`.  The
other one is up on GitHub.  *Both of them* have had new commits added.  If you
did a force-push of the rewrites branch, you'd clobber the "EIGHT" commit.

To avoid screwing up a force push, the advice includes "use
`--force-with-lease`" which is good advice, it means "don't replace the remote
if it's different than my fetch of it."  That protects you against having it
changed out from under you.  It still means you have to read and compare the
version you see with the version you want to push.

What I wanted was to avoid having to think about that whenever possible, and I
knew there was a way to do it.

I wrote a new program,
[git-publish](https://github.com/rjbs/Git-BranchManager/blob/main/bin/git-publish),
that tries to turn the problem into this one:

* While working on the `foo` branch, I run `git publish`
* If there is no foo branch on my remote, my local branch is published to my
    remote.
* If there *is* a remote branch foo, and my changes are a fast forward, they're
    pushed up.
* If there's a remote branch foo, and my copy has rebased it and then (maybe)
    added commits to the end, a force-with-lease push is made.

Already, this is a pretty good win, covering some of the "is it safe?"
questions in code so that I don't need to.  The last case is "the difference is
more than a rebase", and what I wanted was a means to see that explained.  So,
the last option is:

* If the remote branch exists and my local branch doesn't just
    rebase-and/or-add, then an explanation of the changes (and non-changes) is
    printed, showing me what I'd really be doing if I force-pushed.  I can
    instruct the program to continue (and it will force-with-lease push) or I can
    abort and sort things out by hand.

I'll probably refine this last step a bit more.  I think I can at least add a
step that's "cherry pick commits from the remote that aren't on this branch",
and I'd put them *after* the common commits but *before* the new commits on my
local branch.  Even without that, though, this is a pretty nice little tool.  I
hope to use it more than `git push` from now on.

![screenshot of git-publish](https://rjbs.manxome.org/img/journal/git-publish.png)
