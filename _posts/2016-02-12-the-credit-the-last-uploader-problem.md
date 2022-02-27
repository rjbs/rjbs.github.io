---
layout: post
title : "the \"credit the last uploader\" problem"
date  : "2016-02-12T14:16:24Z"
tags  : ["cpan", "perl"]
---
## First, a refresher…

At its simplest, the CPAN is a bunch of files and an index.  The index directs
you from package names to the files that contain the latest authorized release
of that package.  Everything else builds on top of that.

If you want to publish Foo::Bar to the CPAN, you need to use PAUSE.  PAUSE
manages users and permissions, authenticates users, accepts uploads, and
then decides how and whether to index them.  To make those indexing decisions,
first PAUSE analyzes an uploaded file to see what packages it contains.  Then
it compares those packages to the permissions of the uploading user.  If the
user has permission, and if the uploaded package is later-versioned than the
existing indexed package, the package is indexed.

I have skipped some details, but I believe that for the purpose of everything
else I'm going to write about, this is a sufficient explanation.

To get permissions on a package that isn't indexed at all, you upload it.  Then
you have permissions.  If you want to work with a package that already exists,
the person who uploaded it needs to give you permission.  There are two kinds
of permission:

* first-come; you're the person who first uploaded it, or the person to whom
    that person has handed over the keys;  **there is only one first-come user
    per package**;  you can upload new versions and you can assign and revoke
    co-maint permissions
* co-maint: you are permitted to upload new versions, but you may not alter
    the permissions of the package

## The Complaint

When you view code on [MetaCPAN](https://metacpan.org/) or
[search.cpan.org](http://search.cpan.org/), one of the most visible details is
the name (and avatar) of the last user to have uploaded that package.  This
creates a strong impression that this is the contact point for the package.
Sometimes, this is true, or true enough.  On the other hand, sometimes it's
not, and that's a problem.  It may be that the last person to upload the
library only did so as a one-off act, or that they were a member of the
team working on a project years ago when it was last released.  Now, though,
they will be boldly listed as the contact person.

Here's a scenario:

* in 2002, a library, Pie::Packer is uploaded by Alice and is popular for a
    while
* in 2008, Bob finds a bug and finds that Alice isn't really working on Perl
    anymore;  Bob offers to do a release for just this bug fix
* Alice gives Bob co-maint on Pie::Packer
* Bob uploads Pie::Packer v1.234, the only release he ever plans to make
* from 2008 through 2016, Bob is sent requests for help with Pie::Packer

Bob can't just pass on permissions to stop it.  He can *give up* permissions,
but he'll still be the last uploader.

You might object:  "Alice should have given Bob *first-come*!  Then he could
pass along permissions!"

This is true.  Maybe in 2010, Bob gives permissions to Charlotte... but now
Charlotte is stuck in the same position.  If nobody ever comes along to take it
over, Charlotte can't usefully get out from under the distribution.

## Half a Solution

In 2013, the QA Hackathon led to [a consensus about a mechanism for permission
transitions](http://neilb.org/2013/08/07/adoptme.html).  It goes something like
this:

* give user "ADOPTME" co-maint to indicate that first-come permissions can be
    given to someone who wants them, and you don't need to be consulted
* give user "HANDOFF" co-maint to indicate that you're looking to pass along
    first-come to someone else, but they should go through *you*

(The third magic user, "NEEDHELP," is not relevant to the topic at hand.)

Marking a library with ADOPTME or HANDOFF is useful in theory, but not in
practice, because it's almost impossible to know that it has happened.
Yesterday, I filed [a bug about making ADOPTME/HANDOFF visible on
MetaCPAN](https://github.com/CPAN-API/metacpan-web/issues/1643), and I think
it's critically important to making the ADOPTME/HANDOFF worth having.

So, why is this section headed "half a solution"?

Because this solution helps you if you have first-come, but not if you have
co-maint.  Imagine poor Bob, above, in 2016.  By this point, Alice has moved off
the grid and can't be contacted.  Bob can't mark the dist as ADOPTME.  He can
ask the PAUSE admins to do so, but that's it.  It's also a bit a burden to put
onto the PAUSE admins, who may not know whether Bob has really made a good
faith effort to contact Alice.

The final remaining problem is this:  There is no escape hatch for someone who
has co-maint permissions and wants to get out from under the shadow of an
unwanted upload.

## The Simplest Thing That Could Possibly Work

This problem *could* be solved by adding a "GitHub Organizations"-like layer to
PAUSE… but I think there's a much, much simpler mechanism.

We should always treat the first-come owner as the authoritative source,
including when displaying a distribution on the web.  **MetaCPAN Web should
stop showing the name and image of the latest uploder as prominently, and
should show the first-come user instead.**  The same goes for search.cpan.org
and other such sites.  MetaCPAN already has a place for listing other
contributors, which should contain the last uploader.  Adding note like "last
upload by BOB" seems okay, too, but the emphasis should be on connecting the
distribution with the one person who can actually make decisions about its
future.

