---
layout: post
title : vim and fs case sensitivity: the little things count
date  : 2007-04-10T14:33:15Z
tags  : ["programming", "vim"]
---
For months, I have been getting driven up the wall by some stupid Vim behavior.  When run on Linux, filename completion is case sensitive.  When run on Mac OS, it is not.  This is *despite* the fact that I'm running it on a case-sensitive filesystem.

I never cared much until CPANTS started wanting all dists to have a human-readable license file.  (Apparently, a link to `perlartistic` was not enough -- but that's another rant.)  Now all my dists had `LICENSE` and `lib` and when working on my laptop, where I do most of my work, I couldn't hit `:e l<tab>` and complete `lib`.  I'd get the wildmenu for the two options.

I asked around, poured through help files, and found nothing.  Finally, someone on the mailing list said that it was a compile-time option, but that they didn't see any reason OS X was using it.  I think they didn't have the right file in their build tree, because when I checked out the source, I found it.

This patch has made my life better already:

    Index: src/os_mac.h
    ===================================================================
    --- src/os_mac.h        (revision 242)
    +++ src/os_mac.h        (working copy)
    @@ -83,7 +83,6 @@
     #define FEAT_SOURCE_FF_MAC
     
     #define USE_EXE_NAME               /* to find  $VIM */
    -#define CASE_INSENSITIVE_FILENAME   /* ignore case when comparing file names */
     #define SPACE_IN_FILENAME
     #define BREAKCHECK_SKIP           32       /* call mch_breakcheck() each time, it's


