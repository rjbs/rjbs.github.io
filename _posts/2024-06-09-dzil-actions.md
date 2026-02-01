---
layout: post
title : "more GitHub Actions: rjbs/dzil-actions"
date  : "2024-06-09T12:00:00Z"
tags  : ["perl","programming","testing"]
---

I'll be quick, this is just an update to my [last post]({% post_url
2024-06-08-github-actions-for-dzil %})!

I had complained that I'd had to leave the matrixing of perl versions in my
per-repo workflow, so the structure of any given repository's workflow was
something like this:

{% raw %}
```yaml
jobs:
  build-tarball:
    steps:
    - uses: rjbs/dzil-build@v0
  multiperl-test:
    strategy:
      matrix:
        perl-version: ${{ fromJson(needs.build-tarball.outputs.perl-versions) }}
    container:
      image: perldocker/perl-tester:${{ matrix.perl-version }}
    steps:
    - name: Test distribution
      uses: rjbs/test-perl-dist@v0
```
{% endraw %}

I've eliminated a lot of content from the above, to keep it short.  My
complaint was that I wanted to put the matrix stuff out in some abstracted
action, but I couldn't.  Actions can't matrix, jobs can matrix.  (It's
something like this.  The documentation answers a lot of questions, but it's
not laid out in a way that I find easy to dig through or refer back to.)

While looking at things in the
[perl-actions/perl-versions](https://github.com/perl-actions/perl-versions)
repo, I came to realize that there's a way around this.  Instead of using an
action, you use a reusable workflow.  I started to put one together as
`rjbs/dzil-test` but hit some snags.  I no longer remember the details, but it
felt like "you can't call things in such-and-such away outside one repository".
I'm no longer sure that's what it really was, though.  The errors you get are
often very bare statements of fact without much context or hinting at what you
might have meant.  That, along with the docs, have made this project involve a
lot more thinking and experimenting than I feel should have been necessary.
But that's life as a programmer, right?

What I ended up doing was creating *yet another* repository,
[rjbs/dzil-actions](https://github.com/rjbs/dzil-actions), which contains a
bunch of the actions I'd been using, plus two workflows.  One workflow tests a
tarball against a bunch of perls.  The other workflow builds a tarball from a
Dist::Zilla-based repository and then calls the first one.  It feels pretty
reasonable.  It's just the path that got me here that feels a bit unreasonable.

At this point, I think the complete workflow file I'm installing is now about
the length I want.  Behold, the whole thing:

```yaml
name: "dzil matrix"
on:
  workflow_dispatch: ~
  push:
    branches: "*"
    tags-ignore: "*"
  pull_request: ~

jobs:
  build-and-test:
    name: dzil-matrix
    uses: rjbs/dzil-actions/.github/workflows/dzil-matrix.yaml@v0
```
