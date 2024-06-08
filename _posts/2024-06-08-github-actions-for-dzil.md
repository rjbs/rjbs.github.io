---
layout: post
title : "GitHub Actions for testing Dist::Zilla dists"
date  : "2024-06-08T12:00:00Z"
tags  : ["perl","programming","testing"]
---

In my [last post]({% post_url 2024-06-02-dzil-workflower %}), I wrote about how
I made [dzil
workflower](https://metacpan.org/pod/Dist::Zilla::App::Command::workflower) to
install GitHub Actions into my Dist::Zilla-based dists' repositories for
automated testing.  I also said I'd been reading O'Reilly's [Learning GitHub
Actions](https://learning.oreilly.com/library/view/learning-github-actions/9781098131067/).
This week, I applied some more of what I learned from the book, and it was
good.

I created reusable actions for parts of my common workflow.  It was easy, and
now I'll explain.

Here's a really commonly-seen bit of GitHub Actions workflow code:

```yaml
steps:
  - name: Check out repo
    uses: actions/checkout@v4
```

This clones the repository being tested onto the "runner" where your action is
running.  Since very often actions are going to compile and run the code, this
is a really useful step to be able to call easily.  It's got a bunch of
parameters, too, but the defaults are probably what you want.  You get a
shallow clone, without Git-LFS files, without submodules, and lots of other
reasonable defaults.  I hadn't really thought about how this worked, but as
with many things in GitHub Actions, it turns out to be pretty straightforward,
even if the amount of YAML makes me a little exasperated.

The `uses` line points at a commit in a GitHub repo.  Here, it's `v4` (a tag)
in the `checkout` repository owned by `actions`.  That owner is a user owned by
GitHub where they put their "official" actions, but anybody can write their own
actions, and generally speaking, anybody can use anybody else's actions.  An
action definition looks a lot like a "job" definition, but with inputs
(parameters) and outputs (return values) and branding (weird).

The `actions/checkout` action is written in JavaScript.  The actual program
that gets run is nearly 40,000 lines of code.  I guess this is because it has
all of its prereqs packed into it, but it means it's a bit daunting to approach
if you don't understand the webpack system.  Fortunately, I didn't need to
understand how to write a JavaScript action.  You can write them in anything,
but even better, you can just write them in YAML.  (I can't believe I just
wrote that.)  I mean that instead of writing an executable program to run, you
can provide a list of standard GitHub Actions steps that will be run to execute
your action.

I decided I would be happier by breaking down my big 93 lines of YAML workflow
into smaller reusable actions.  Even if I didn't use them in any context other
than the `workflower`-generated workflow, it would mean that I could update the
action definition in one place, and all my workflows would get the new version
on their next run.  Right now, I have to rebuild the workflow for each repo
individually.

I won't embed the whole hundred lines of workflow, but you can read an
[old-style workflower
workflow](https://github.com/rjbs/Email-MIME/blob/f8d4fb1f8df1b7fcad8af3d6ff47d7747358ffcb/.github/workflows/multiperl-test.yml)
on GitHub in my repos' history.  It's fine, and easy enough to understand, if
you know how to read a workflow definition.  Basically, it says this:

* in the `build-tarball` job:
    * check out the repo
    * install prereqs for dzil
    * install prereqs for building the dist
    * build the dist
    * upload it as a build artifact so that the next job can use it
* in the `multiperl-tests` job:
    * on every major perl release supported by the dist, in a container:
        * download the build artifact
        * extract it
        * install its prereqs
        * configure and build the dist
        * run the tests
        * publish a report

It's not complicated, but writing this stuff in YAML is a bit fiddly, so it's
not great to read, and it's too long.

My initial plan was to make the whole thing into an action called
`rjbs/dzil-multitest` or something.  Two things prevented that.  First, I
realized that a standalone action for "just build the tarball" might prove
useful to somebody else some day.  The second thing was more complicated.

The "on every major perl release" step uses something called the [matrix
strategy](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs).
In your workflow, you provide permutations of testing, and then the runner runs
them all.  Here's the example from GitHub's docs:

```yaml
jobs:
  example_matrix:
    strategy:
      matrix:
        version: [10, 12, 14]
        os: [ubuntu-latest, windows-latest]
```

This will run on every combination of version and OS.  My workflow only had one
parameter: which version of perl.  (This is the only thing currently computed
by the `dzil workflower` program, actually.  Everything else in the workflow is
static.)  The problem is that you can't put a matrix strategy in a reusable
action, you can only put it in a workflow definition.  At least, I'm pretty
sure that's right!

So, my goal was to make my workflow definition look like this:

* in the `build-tarball` job:
    * build and upload the tarball
* in the `multiperl-tests` job:
    * on every major perl release supported by the dist, in a container:
        * test the tarball

That seemed like the least complexity I could produce, for now.  And I achieved
it!

```yaml
jobs:
  build-tarball:
    runs-on: ubuntu-latest
    steps:
      - name: Build archive
        uses: rjbs/dzil-build@v0

  multiperl-test:
    needs: build-tarball
    runs-on: ubuntu-latest

    strategy:
      fail-fast: false
      matrix:
        perl-version: [ "devel", "5.38", "5.36", ... ]

    container:
      image: perldocker/perl-tester:${{ matrix.perl-version }}

    steps:
      - name: Test distribution
        uses: rjbs/test-perl-dist@v0
```

The actions themselves are pretty straightforward, too.

The [dzil-build](https://github.com/rjbs/dzil-build) action is a good fifty
lines, but it does more or less exactly one thing, and I bet it could be used
by other people for other purposes.  I think it could also be a good place to
put some little improvements like the caching of the installed prereqs.  I only
gave it one parameter, `dist-name`, which is used to create the tarball.
Generally, you don't need to supply this, because the action will use your
repository name.  This is a little improvement on the previous workflow, which
always created `Dist-To-Test.tar.gz`.

The [test-perl-dist](https://github.com/rjbs/test-perl-dist/) action is the
other fifty lines.  I'm less certain that this action would be useful in other
contexts, but it still might be!  Even if not, it means that upgrades to the
action will upgrade all my workflows that use it by name, which is a big deal.

Maybe I'll never make many changes to these actions, and so there won't be a
lot of benefit in that sense, but going through the process was pretty helpful
for my ongoing learning of how to use GitHub Actions.  I'm glad I did it.
