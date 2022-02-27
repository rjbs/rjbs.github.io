---
layout: post
title : "another unproductive complaint about subversion"
date  : "2008-10-15T02:18:37Z"
tags  : ["git", "stupid", "subversion"]
---
I remember in 2005 or so when I first started using Subversion, I liked it so
much.  It was much easier to use than CVS.  Everyone said it would be make
tagging and branching easier than CVS.  In CVS, tagging was fine, but branching
was such a pain that I never bothered.

Eventually, I found out that branching and merging were much easier, but still
a real pain.  Tagging, though, was completely insane.  Tags were implemented as
copies (just like branches).  This sort of made sense as a cheap way for
branches to work, but none for tags.  Tags are labels for points in time in a
repository.  They shouldn't be mutable, unless maybe to let you remove a label
from rev 1 and put it on rev 2.

Because they're implemented as copies, you can actually go in and alter the
state of a tag, meaning that tags are useless as ... tags.  It also means that
if you have a standard Subversion repository with trunk, branches, and tags
directories, and you check out the whole thing, you check out absolutely every
file in every revision.  "Copies are cheap" was a big Subversion mantra back in
the day, because in the repository, only files that changed were new files on
disk -- but that only goes for what's in the repository, not your checkout.  In
your checkout, every copy of `readme.txt` is its own file -- and it has to be,
because even the tags are mutable.  You can't say that
`./tags/1.000/readme.txt` is the same file as `./tags/2.000/readme.txt` just
because there was no change between the two releases, because you could go
change either of them, and if you do, you'd change both.  Oops!

This came up today because of a piece of automated deployment code that did
something like this:

    $ mkdir TEMP
    $ chdir TEMP
    $ svn co $REPO/project
    $ cd project/trunk
    $ bump-perl-version
    $ cd ..
    $ svn cp trunk tags/$NEW_VERSION
    $ svn ci -m "bump and tag $NEW_VERSION"

Checking out requires a whole lot of space, because it has to check out every
single tag's copy of every file.  Tagging the new release is also fairly space
hungry.  How hungry?  Well... the project I'm working on right now is a web
application.  Let's call it New-Webapp.

If I export a copy of trunk from Subversion, getting just the files that make
up the latest version of the application, it's 1.9 megabytes.

If I check a copy of the trunk out, so now there's all the extra working copy
files, and it's 5.2 megabytes.

If I check out the whole repo, getting every tag and branch (for your
information, there is exactly one branch), it's 207 megabytes.

Now, keep in mind that this gives me every file from every tagged release
(there are 40 releases).  This does *not* give me the entire revision history.
There are many, many revisions missing.  After all, what I have is basically 42
revisions: 40 releases, trunk, and one branch.  That's it.

If I use `git-svn` to build a git repository of the project, meaning that I
have absolutely every revision, every tag, and every branch, it's 249
megabytes.  That's all 1149 revisions.

I am so ready to be done with Subversion.

