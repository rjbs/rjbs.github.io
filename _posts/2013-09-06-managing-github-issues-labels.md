---
layout: post
title : "managing GitHub Issues labels"
date  : "2013-09-06T23:14:55Z"
tags  : ["github", "perl", "programming"]
---
I've been slowly switching all my code projects to use GitHub's bug tracking
(GitHub Issues) in addition to their code hosting.  So far I'm pretty happy
with it.  It's not perfect, but it's good enough.  It's got a tagging system so
that you can categorize your issues according to whatever set of tags you want.
The tags are called labels.

Once you figure out what set of labels you want, you realize that you then have
to go set the labels up over and over on all your repos.  Okay, I guess.  How
long could that take, right?

Well, when you have a few hundred repositories, it can take long enough.

And what happens when you decide that blazing red was a stupid color for
"non-critical bugs" and maybe you shouldn't have spelled "tests" with three
t's.

Fortunately, GitHub has a really good API, and
[Pithub](https://metacpan.org/release/Pithub) seems, so far, to be a very nice
library for dealing with the GitHub API!

I wrote [a little program to update labels on all my repos for
me](https://github.com/rjbs/misc/blob/master/github-issue-labels).

