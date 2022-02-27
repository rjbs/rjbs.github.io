---
layout: post
title : "finally started using dzil new"
date  : "2010-10-20T12:43:39Z"
tags  : ["perl", "programming"]
---
Ages ago, I got a lot of requests for a way to let Dist::Zilla create new
dists.  Creating a useful command for doing that became part of the TPF grant
work that I did, and `dzil new` started to work in May.  By June, it reached
the state it's been in for months now, which seemed pretty good -- but I didn't
really know, because I wasn't using it.

This week, I released a few new distributions, and the same things bit me each
time:  I didn't have a `.gitignore` and I didn't have a `Changes` file.  The
latter was much more annoying, because it would make the NextRelease plugin die
after release, and I'd have to do a bunch of the post-release actions myself.
I thought about writing a "don't do the actual release unless the Changes file
exists" plugin, but then I decided it would be pretty easy to just start using
`dzil new`.  So far, I'm happy!  Here's my setup:

**profile.ini**:

```ini
[DistINI]
append_file = plugins.ini

[Git::Init]

[GenerateFile / Generate-gitignore ]
filename    = .gitignore
is_template = 1
content = {{$dist->name}}-*
content = .build

[GenerateFile / Generate-Changes ]
filename    = Changes
is_template = 0
content = Revision history for {{$dist->name}}
content =
content = {{$NEXT}}
```

**plugins.ini**:

```ini
[@RJBS]
```
