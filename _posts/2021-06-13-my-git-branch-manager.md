---
layout: post
title : "my git branch manager"
date  : "2021-06-13T14:30:08Z"
tags  : ["git", "perl", "programming"]
image : https://rjbs.cloud/assets/branch-scrubber.png
---
Like a lot of people, I have not been great at cleaning up my old git branches
over time.  Sometimes they get merged but I don't delete them.  (The "delete
branch after merge" option in GitLab and GitHub help, but they're not 100%).
Sometimes I forget I even had a branch, because I never filed a pull request.
Also, with all those already-merged branches lying around, it's easy to
overlook the not-even-requested branches, especially if I haven't touched them
in a while.

The problem is that when you (or I, in this case!) work on a team with other
people, they routinely fetch from your remote, and you're effectively
cluttering up their clone with a bunch of dead branches.  Sure, they can just
ignore it, but it's just a little rude.  Or, at least, it would be nicer to
keep things tidier.

Around a year ago, I wrote a tool to help me clean up (and track) my branches
in the primary Fastmail repository.  It's got two parts:  `git-work-status` and
`git-scrub-branches`.

git-work-status tells me about all my branches, both local and remote, and
whether they're rebased on the primary branch and whether the local and remote
have the same head.  It tells me which of the branches have an open merge
request (the GitLab version of a pull request), whether they're approved, and
also shows some labels of note.

git-scrub-branches tries to detect branches that can be destroyed, by doing
this, more or less:

1. fetch from the primary remote ("origin", for example)
2. fetch from my personal remote
3. detect whether any branches, local or remote, have already been merged
4. rebase all branches
5. detect whether any branches become zero-commit when rebased; they're merged!
6. delete any known-merged branches
7. update remaining remote branches to the rebased version

…and then running git-work-status to show where I ended up.

I have a lot of branches in my work code, so here's the program running on a
repo where I have fewer, the perl5.git repo:

![screenshot of branch scrubber](/assets/branch-scrubber.png)

The existence of this screenshot might alert you to the fact that I've now made
the tool work on perl5.git.  In fact, it should work on any GitHub or GitLab
repository, but if you want to you it, you'll have to set up some configuration
in your `.git/config` something like this:

```ini
[branch-manager]
primary-remote = github
primary-branch = blead
```

Really, though, you should [read the source
code](https://github.com/rjbs/Git-BranchManager) to make it go.  This is
definitely not code I'm looking to maintain as a public utility, but I did put
put the code online, so feel free.  I expect I'll keep messing around with it
over time, without concern for anybody's use case but my own.

Finally, I should note that it's a bit of a double-edged sword, on that whole
rudeness front.  On one hand, it really does help keep your branches nice and
tidy.  I've used this to clean up literally hundreds of dead branches.  On the
*other* hand, GitLab pretty eagerly subscribers people to update notifications,
and those notifications include "Rik just rebased his two-year-old branch for
the 15th time."  This can be annoying, but I'd rather receive those emails and
know that branches were cleaned up.  Also, I don't think GitHub sends them —
let me know if I'm wrong!

