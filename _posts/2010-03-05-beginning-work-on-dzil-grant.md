---
layout: post
title : "beginning work on dzil grant!"
date  : "2010-03-05T04:18:09Z"
tags  : ["distzilla", "perl", "programming"]
---
I proposed [a grant for Dist::Zilla
improvements](http://news.perlfoundation.org/2010/02/2010_grant_proposal_improve_di.html) to The Perl Foundation, and a [notice of its approval](http://news.perlfoundation.org/2010/03/2010q1_grant_proposals_results.html) was posted yesterday.  I've gotten to work.

A number of the things I proposed to do have been on my mind for quite a while,
but I haven't been able to commit to working on them.  I had some of them
already sketched out in branches that were unready to merge.  Last night, I
rebased and merged them, resolved a few conflicts, and tried to cut a
development release.  Unfortunately, I foolishly cut a production release.

Fortunately, nothing seems to have been horribly broken.  A few missing
prerequisites were exposed here and there, but those have been fixed.  Some
other, more serious problem were fixed tonight, and I cut an actual dev
release.  You can see most of my "to do" list [in the git
repository](http://git.codesimply.com/?p=Dist-Zilla.git;a=tree;f=todo;h=bfcc53e7b8ddcaf0521a5d0d9d2a2e8d9afa0251;hb=27f4e0ec979dcea4a028902d3d041bb084aab39e),
if you're not content with the summary in the grant proposal.

So far, I've been checking out upstream test coverage, adding a proper logging
facility, and changing the way prerequisites are registered.  The logging
changes are mostly to facilitate better testing so I can start writing tests
for the entirety of Dist::Zilla as it stands now, before I get to any more
refactoring or extension.  The upstream coverage is mostly an issue because
if we test lots of Dist::Zilla, but not the code written to make it go, that's
a big coverage gap.  I'd like to make sure that all the code (that I wrote) to
make Dist::Zilla work is adequately tested.  I want to be able to rely on this
code, after all!

The prereq stuff has just been on my mind and in the margin notes of my recent
CPAN work, especially as it related to fixing some bugs in the excellent
AutoPrereq module.  It may introduce a few bugs in the short term, but those
should clear up.  It will also make it much easier to report prerequisites,
including build-time or configure-time prereqs.  In another release or two, the
AutoPrereq plugin should be able to report libraries found in `./t` as being
test requirements, separate from runtime requirements, for example.

When these tasks are complete, I'll be moving on to testing Dist::Zilla itself.
That means writing some tools to make that easier, and probably a few changes
to how Dist::Zilla works here and there, to improve diagnostics and
configuration.

For now, I'm happy that I'm going to be able to spend some time on this.  It's
sorely needed improvement.

