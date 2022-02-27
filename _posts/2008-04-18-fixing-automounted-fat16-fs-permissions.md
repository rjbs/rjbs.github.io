---
layout: post
title : fixing automounted fat16 fs permissions
date  : 2008-04-18T15:26:03Z
tags  : ["macosx"]
---
The old FAT filesystem, still used by many USB mass storage devices like my new USB key drive, does not have a good concept of permissions.  That is: not even as good a concept as UNIX.  It's common that the default behavior when mounting a FAT filesystem on unix is to set everything a+rwx.  I'd rather not have files mounted a+x, so normally I could set a mask in my fstab options.  On OS X, though an automounter is used that doesn't seem to be configurable on a per-filesystem-type level.

Is there no good way to reduce the maximum mode of a FAT filesystem's files? 
