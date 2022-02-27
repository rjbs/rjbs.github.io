---
layout: post
title : "making the switch to git (pt. 2)"
date  : "2007-08-12T13:18:24Z"
tags  : ["git", "subversion"]
---
I used to keep a lot of personal stuff in `~/svn`, like my RPG notes, dotfiles
for various apps, and some of the stupid little things I stick in `~/bin`.  I
converted that to git about a month ago, and it went just fine.  A little
later, John and I decided we'd switch svn.codesimply.com to git, and I ran into
an annoying problem.

When we first created that repository (or converted things to it), we had
everything organized like this:

    /exporter/trunk
    /exporter/branches
    /exporter/tags
    /rubric/trunk
    /rubric/branches
    /rubric/tags

This was mildly annoying, since `git-svnimport` expects one Subversion
repository per project, with the trunk/branches/tags structure at the top
level.  Converting these wasn't hard, though, with commands looking something
like this:

    git svnimport -A authors -i -C git/$project
      -t projects/$project/tags
      -T projects/$project/trunk
      file:///Users/rjbs/vcs/svn/

(I didn't import branches, as I think only one or two projects had ever
branched, and not very interestingly.)  The larger problem was that many
projects had been renamed.  For example, `exporter` had been renamed to
`Sub-Exporter` and `rubric` to `Rubric`.  I was baffled about how to deal with
this problem.  Importing everything from the old name and then from the new
name didn't preserve the history, because somewhere in there a transaction
would delete all the old files and create new ones.

I asked around for help, posting to the git list, asking on #git, and poking at
people I knew who had a clue.  None of this helped very much, although
[mugwump](http://sam.vilain.net/) suggested `git-filter-branch`, and
[rafl](http://perldition.org/) suggested a similar tool in cogito.  Then rafl
gave me a link to [an article about this
problem](http://www.ouaza.com/wp/2007/07/28/assembling-bits-of-history-with-git-take-two/),
which looked quite relevant.  The problem was that it was not a 100% step by
step solution, and I was really not interested in spending much brainpower
thinking about how to apply that solution to my problem.  Switching to git is,
for me, a way to get a better tool, and not something I wanted to spend any
real brain time on.

"Good grief," I thought to myself, "all I really want to do is import the two
sets of changes, skipping the one stupid renaming transaction!  Is that so
hard?"  Of course, as is often the case, yelling my problems out loud made me
realize how easy they would be to resolve.

Almost all of the renaming occurred in a block of transactions spanning, let's
say, 100 to 120.  I just had to run this for each project:

    git svnimport -A authors -i -C git/$new_name
      -t projects/$old_name/tags
      -T projects/$old_name/trunk
      -l 99
      file:///Users/rjbs/vcs/svn/

    git svnimport -A authors -i -C git/$new_name
      -t projects/$new_name/tags
      -T projects/$new_name/trunk
      -s 121
      file:///Users/rjbs/vcs/svn/

It imported all the history up to the rename, from the old names.  Then,
picking up after the rename, it imported all the new history.  For a few
projects, which were renamed later (due to mistakes during The Great Renaming),
I reran the script with alternate values for `-l` and `-s`.  It was really
easy.

I've gotten everything converted now, save for Mixin-ExtraFields-Param and a
few Kwiki plugins.  I think the plugins will be no problem, but MEP has been
givng me grief.  If I can't make it just work today, I'll import it without
history, and then I'll be done!

Starting a read-only git daemon was really easy.  I made a new service for
daemontools to run, and it has a one-line definition.  I'll probably install
gitweb later, but for now I'm ready to start doing all my codesimply coding,
simply, with git.

