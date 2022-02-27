---
layout: post
title : "reasons to avoid zsh auto-correction"
date  : "2007-12-29T22:11:03Z"
tags  : ["stupid", "zsh"]
---
    root@backup:/var/backup/mail# tar jcvf 200701.tar.bz2 200701   zsh: correct '200701.tar.bz2' to '200601.tar.bz2' [nyae]? 

No.  I do not want to back up this year's mail into last year's backup.

I imagine this could be fixed by updating the `tar` completion to not want an existing files when creating an archive.  Heck, you might be able to tell it to suggest correcting `c` to `A`... but I'll stick to my current procedure, which is to grumble and swear when encountering this behavior. 
