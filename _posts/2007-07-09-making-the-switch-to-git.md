---
layout: post
title : "making the switch to git"
date  : "2007-07-09T16:12:55Z"
tags  : ["git", "subversion"]
---
A few months ago, Dieter and I played around a bit with git.  He used it more
than I did, but we both agreed that it was way cool.  It came up again at YAPC,
and I gave it another look.  It's come a long way in those few months!  The
need for a friendlier user-oriented command apart from `git` is basically gone,
and the tools for interoperation with other VCS finally exist and seem to work
well.

On the way home from YAPC, I converted my personal Subversion repository into a
few git repositories.  Now I'm looking at the way forward for converting
(code (simply))'s repository.  (We haven't decided to do this, but I'm very
tempted, at present.)  We have a fairly common setup, from what I've seen of
the Subversion-using world:

    ./project/{branches,trunk,tags}/content

The `git-svnimport` command is meant for dealing with projects in repositories
that start at the second level, with the trunk (et cetera) forming the root.
That's not a big deal, because you can tell `git-svnimport` to use
`project/trunk` as the trunk directory, and so on.  The problem is that for
quite a few projects, the name changed once during the course of history.  So,
what is now `Sub-Exporter` was once just `exporter`.  I'm not sure how to get a
full history import while switching from one large Subversion repo to many
small git repositories.  I think that perhaps I can import the entire
repository and then somehow slice it up from there, then drop the "massive" git
repository in favor of the sliced up pieces.  I'm not sure how to go about
doing that, yet.

At any rate, I'll have to figure out how to do it before we make any decisions.
It sure would be nice, though.

