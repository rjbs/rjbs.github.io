---
layout: post
title : merging both ways in subversion
date  : 2006-10-19T15:21:52Z
tags  : ["subversion"]
---
We have had no end of trouble managing branches, lately, and for no clear reason.  This is how we generally introduce a big change:

1. svn cp trunk branches/branch 2. work in the branch and in the trunk 3. occasionaly svn merge trunk-to-branch, merging from last merge to head 4. when done with branch, merge trunk into it one last time 5. try to merge branch into trunk 6. curse loudly

Step 5 always gives me grief.  I try to use the suggested command:

    svn merge --dry-run URL-TO-TRUNK@HEAD URL-TO-BRANCH@HEAD

This does crazy things, like show that it's going to a huge mess of files.  If I drop the `--dry-run`, I get weird errors about what URL things claim to be using.  I asked #svn, where I got one response suggesting that my URLs were wrong.  They were not -- I checked them a dozen times.

Finally, I resorted to rsyncing, which made me feel ashamed.  Has anyone else had this sort of difficulty?

More and more, I think I'll be moving my personal svn to darcs. 
