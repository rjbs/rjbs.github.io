---
layout: post
title : "version control"
date  : "2006-08-18T12:26:57Z"
tags  : ["programming"]
---
I moved from CVS to Subversion a few years ago, and to SVK about a year ago. Moving to Subversion was an unqualified success.  Everything is either as good or, usually, better.  It has some quirks, and some things that I'd like to see changed, but it has never caused me to scream or waste much time.

Moving to SVK was a much more qualified success.  What I really wanted was offline commits, so that I could work on the bus.  SVK gives me those, but its nature of operation has, on occasion, made it very easy to do stupid things like reverse other people's commits without noticing.  For example, I recently decided I'd check out an entire mirrored repo, rather than the few bits I'd had checked out.  I did this, got back to work, committed, and pushed. Unfortunately, I had only checked out my local copy of the mirror; I hadn't merged my up-to-date mirror's updates into it.  When I went to push the changes I'd just made, I started to get all kinds of conflicts: it was trying to commit my out of date local version as if it was my work.  Of course, the first conflict didn't come until after it had managed to revert a lot of changes, so I had to cancel the commit, create a backwards patch, and undo the damage.

I know that the problem here is probably "you didn't push with -l" or, more generally, "the sofware did what you told it do."  The problem, from my perspective, though, is that the software doesn't make the same assumptions I do about what it should dy by default.

I've played with darcs a bit, and it looked very promising.  I'm not sure if I would get sick of its (unknown to me) warts very quickly, though.  I also poked at git a little, following mugwumpjism's endorsement.  I'm on the bus, right now, and after I got it to compile I started looking through the git crash course for Subversion users.  It irritates me, though.  It starts with this disclaimer:  "Warning! This tutorial has been just converted from the CVS tutorial by someone not really knowing that much about Subversion usage."

Here are some manifestations of that: it says that tagging and branching are done with "svn copy somethingscaryinvolvingname" and that to list tags you do "svn whoknowswhat".  Meanwhile, "Git supports merging between branches much better than Subversion."  Maybe that's true, but when you've led in by showing that you don't even know how to branch or merge, it damages your credibility!

I'd like to try out using darcs or git some more, but I'm afraid it might end up like my desire to write more Ruby:  the returns just aren't high enough to displace my current tools.  This is especially true where I imagine I'd see the most benefit: darcs and git are so cool because of their ability to support branches, distributed repositories, and cherry-picking commits from multiple developers.  Unfortuantely, most of my collaborators use Subversion or SVK; making it harder for them to use my SCCS by using unfamiliar tools will reduce the chances that they will actually submit patches.  I'd rather have committers than sharp tools.  I could use git for my personal repositories, but I feel like I'd be getting a very small win, there.

I think I need to get back to doing work on CGI::Application.  It lives in darcs, which gives me a chance to play with it. 
