---
layout: post
title : "experiments with claude, part ⅰ: signatures"
date  : "2026-03-10T12:00:00"
tags  : ["programming","agents","perl"]
---

I've been slowly ramping up my use of Claude for coding issues.  I've been
meaning to write a bit more about how I use it, and had been putting that off
until I finished a few things.  With some of those done, I thought I'd write up
some notes on how it's gone, finally.  Over the next little while, I'll post
some actual work I've done.  Later, I'll try to write some more sort of general
thoughts: other things I might try, what general tactics have felt useful,
places where I think things are particularly problematic, and so on.

I started out fairly negative on "agentic coding", and I still have a lot of
opinions, but they now include that (a) coding agents are not going anywhere
and (b) the resulting code can be of sufficient quality to be worth using in
real work.

## Project One:  Cassandane Signatures

I work on [Cyrus IMAP](https://cyrusimap.org/dev), an open-source JMAP, IMAP,
CalDAV and CardDAV server.  Cassandane is the Cyrus test suite's largest
component.  It's a big pile of Perl, around 200k LOC.  In general, each test is
a separate subroutine stored in its own file.  The whole thing has upsides and
downsides.  One of the smaller, but noticeable, downsides: basically none of
that code used subroutine signatures.  I try to always use subroutine
signatures in new Perl code.  I'd begun using them in some new Cassandane code,
but it was just a drop in the ocean.  I wanted them everywhere, and to be the
clear default.  My existing "convert subs to use signatures" code munging
program I had lying didn't cut it, for a variety of boring reasons, including
that it didn't cope with Perl subroutine attributes, which Cassandane uses
extensively.

I wanted to, in one swoop, convert all of Cassandane's tests to use subroutine
signatures.  I considered futzing with my old code for this, but then I
thought, "This seems like a nice simple job to test out Claude".  I gave
Anthropic $20, installed Claude Code, and fired it up.

Claude strategy was a lot like mine:  rather than go edit every file, it wrote
a program that would edit all the files.  It was sort of terrible, around 300
lines of code.  Later I tried to write my own version.  It never quite worked
(after five to ten minutes of work, anyway), but it was close, and under 50
lines.  But the good news is that *Claude's worked, and then I could delete
it*.  If I was building a program to use and maintain, I would never have
accepted that thing.  But I didn't need to.  I could run the program and look
at the git diff.  There wasn't even a security concern.  It all lived in a
container.

Claude needed help.  Its first go was so-so.  Claude couldn't check its own
work because it didn't know how to use the Docker-driven build-and-test system
I use for Cyrus, and so Claude couldn't run the tests.  It could compile-test
the tests, though, which went a long way.  It iterated for an hour or so.
Sometimes I'd hop in and tell it what it was doing wrong, or that it could stop
worrying about some issue.

When it was done, I had a diff that was thousands of lines long and touched
1,500+ files.  I spent a long time (several shifts of 15 minutes each)
reviewing the diff.  The diff was so close to perfectly uniform as to be
mind-numbing.  But it was my job to make sure I wasn't sending bogus changes
for review to a colleague without vetting it first.  (After all, had I written
my own code-transforming program entirely by hand and run that, I wouldn't have
sent *its* output along for code review without a careful reading!)

I found some minor bugs and fixed them in separate commits.  You can read the
[whole changeset](https://github.com/cyrusimap/cyrus-imapd/pull/5695/commits)
if you want.  You'll see it's six commits by me, one by Claude.

If this was the only value I got out of the $20, it would've been well worth
it, but I went on to get a lot more done on those $20.  I'll write more about
some other, more interesting work, over the next few days.
