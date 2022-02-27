---
layout: post
title : splitting up a \"big\" git repo, take two
date  : 2007-09-11T01:37:17Z
tags  : ["git"]
---
Converting to git has been fun, educational, and annoying, at various times.
Here are some notes (mostly to myself) on the fun, educational, and annoying
bits that I solved today.

When I converted my personal Subversion repository (notes on my RPG, talks,
letters, config files) to Git, I just turned one big Subversion repo into one
big Git repo.  It was about 400 megabytes, in Git.

I decided, a little later, that there was no reason that all my huge Keynote
slides needed to be in the same place as my letters to my grandmother or my
notes on my RPGs.  A little digging made it seem like this would work just
fine:

    $ git filter-branch --subdirectory-filter letters HEAD

With that, my history would be rewritten to only include changes in the letters
directory, which would become root.  When I did it, I found that everything was
still there -- but listed as a new or modified file.  That was easy to deal
with, too:

    $ git reset --hard

Great!  Now I had only my fifteen letters with twenty total revisions.  Only
one small problem:

    $ du -sh ../letters
    381M letters

    $ git-gc && git-prune
    $ du -sh ../letters
    381M letters

I couldn't figure out what the hell was going on, mostly because I didn't know
much about how git stored things.  More importantly, I didn't realize that when
cloning a git repository from one directory to another on the same filesystem,
`git-clone` will make hardlinks.  Then, when cleaning up, it will see that
files are in use and not purge them.  They're not actually taking up any more
space, and after I had removed the original, big repository that I'd cloned, a
cleanup would have worked.

I realized this later, when reading the docs because of another problem.  I had
long since removed the trimmed-down repositories, because I thought they were
taking up too much space.  To deal with the problem from the get-go, I did
something like this:

    for dir in talks/exporter rpg/deliverance letters;
      do (
        cd $dir
        git filter-branch --subdirectory-filter talks/$dir HEAD
        git reset --hard
        cd ..
        git clone --no-hardlinks $dir _$dir
        cd _$dir
        git gc --aggressive
        git prune
      )
    done

The important thing here is the `--no-hardlinks` option to `git clone`.
Obviously, it prevents hardlinking, instead making copies of everything.  With
that done, the `gc` and `prune` commands can work as I had expected, removing
all the objects not used in this particular repo.

More and more, I find that git is a really well-designed system.  I wish I had
a reason to learn much more about it!

