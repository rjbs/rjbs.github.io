---
layout: post
title : "workflower, for my dzil testing workflows"
date  : "2024-05-25T12:00:00Z"
tags  : ["perl","programming","security"]
---

Starting ages ago, once in a while somebody would show up and offer me a commit
that would add some automated testing system to my open source repositories.  I
liked the idea, but it always felt like a free puppy.  I didn't know how it
worked, I didn't know how the YAML file (always YAML!) was put together, and I
didn't know what I was supposed to do when something went wrong.

Usually, I politely declined.  Sometimes, I'd add it and ignore whatever
happened.  This is one of those places where I knew I could do better by
learning the thing, but I also knew that it was going to require a lot more
effort from me than I'd end up saving.  I try not to get worked up about what I
"should" do when it comes to the software I write for myself and give away.

Over time, I've gotten a better handle on how these systems work.  We use one
at work, which helped.  Also, GitHub Actions is so integrated with GitHub that
it's been easy to sort of peek into that world while doing my "normal" GitHub
things.

Eventually, I realized the huge value I'd get out of an automated testing
system: testing on multiple perls!

It was never interesting, to me, to have some server run my test suite.  I was
going to run it anyway, and I try to make sure my test suites are fast.  So,
sure, I could push up changes and see them pass on the server, but I wasn't
going to push until I knew they did pass!  (Usually.)  The thing is: I run my
tests on perl v5.38 or v5.39 these days.  For years, I've been running a very
recent perl for day-to-day use, but I release that code to be run on older
perls.  There are ways to do that multi-perl testing locally, but they're
mostly a drag.

When I found out about the
[perldocker/perl-tester](https://hub.docker.com/r/perldocker/perl-tester)
Docker images, I realized I could use those to have GitHub Actions test my
code against many perls in one go, and I'd only have to think about it one
time.  *This* was going to be useful!

As with most things, I started by looking for people already doing this, and
then I stripped out all the variables and shoved it into a Dist::Zilla plugin.
I'm afraid I no longer remember what my sources were, but the outcome was
pretty simple.  I wrote a `dzil workflower` command that installs a GitHub
Action workflow file into your checkout.  The workflow does this:

* install Dist::Zilla and the plugins needed by the repo's dist.ini
* builds a new tarball of the dist and stores it as a build artifact
* tests that tarball under every perl supported by the dist

"Every perl supported" is basically every (major) version of perl from v5.8 to
v5.38 plus blead, but then pruned down based on the dist's minimum perl.  It
won't bother testing on v5.22 if the minimum perl is v5.24.  For each perl, it
uses the `perl-tester` Docker image, retrieves the build artifact, extracts it,
and does the normal "install prereqs and run tests" you'd expect.

For fun, I use [yath](https://metacpan.org/dist/Test2-Harness) and
[Test2::Harness::Renderer::JUnit](https://metacpan.org/pod/Test2::Harness::Renderer::JUnit)
so I can feed them to
[mikepenz/action-junit-report](https://github.com/mikepenz/action-junit-report)
and get nice little summaries of test failures.  In the future, I might upload
the test event archive for failing tests.  For now, it hasn't come up.

It's been a big help in avoiding stupid mistakes, mostly related to things like
adding postfix deref to code meant to run on older perl.  Everybody knows that
my preferred solution is to bump my minimum required perl to v5.20 or later,
but I don't always do what I prefer.

This week, I've been reading O'Reilly's [Learning GitHub
Actions](https://learning.oreilly.com/library/view/learning-github-actions/9781098131067/),
which has been helpful.  Today, after reading a few chapters, I got to
puttering about with `workflower` and wondering whether I could speed things
up.  It turns out that there wasn't much GitHub-related for me to do, but I did
notice that even though I was installing Dist::Zilla from apt, it was later
being reinstalled!  This cost valuable time!

There were two things at play.  One is that I'm installing things with `cpanm`,
and when you run `cpanm Some::Module`, it will interpret it as a request to
install-or-upgrade, rather than only install.  There's no switch to say "do not
upgrade if already installed", as far as I know.  That wouldn't have been a
problem, I think, but *also*, running `dzil authordeps --missing` was spitting
out Dist::Zilla::Plugin::CPANFile even though it was installed.  It *had to* be
installed, because it comes with Dist::Zilla itself!

I banged on this mystery for a little while, but finally decided to try a
tactic that didn't solve the mystery, but did render it irrelevant.  I switched
to [cpm](https://metacpan.org/pod/cpm).  `cpm` is an alternative to `cpanm`,
and it's focused on speed.  I happened to be at the YAPC::Asia where it got its
first big announcement, and its speed was no joke.  I'm not usually in a rush,
so I mostly still use `cpanm`.  I'm a creature of habit.  Here, though, it
looked like it would be a double win:  not only was it fast, but it won't
reinstall things already present.  Some testing showed off that this was going
to be a nice little win.

I just uploaded the new version of `workflower`.  It's part of the `@RJBS`
bundle, and really I don't make any promises about its continued functioning,
or any promises that I won't radically change how it works.  It's for me, part
of my tools.  But it might work for you.  I'd be happy to hear sounds of
delight, but I'm not super into hearing complaints about it.

Anyway, rebuilding Dist::Zilla's own workflow takes its full test run down from
about 3.5 minutes to about 2.5.  Email::MIME's went down from around 2.5
minutes to around 1.5.  They're going from fast to slightly faster, but it's
still satisfying.  Depending on when you read this, you may be able to see
[workflow results on GitHub](https://github.com/rjbs/Dist-Zilla/actions).

I do expect that in the future I'll make the whole thing better, but not until
I have some code I'm working on a lot more.  We'll see when that happens…
