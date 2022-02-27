---
layout: post
title : money into code: Perl 5 code bounties
date  : 2013-02-25T03:44:58Z
tags  : ["perl"]
---
If there's money earmarked to be spent improving Perl 5, one seemingly obvious
thing to do is to try to use it to *directly* to improve `perl`.  In other
words, the mission is to "turn money into code."  The most successful
expression of this strategy, I think, has been in Nick and Dave's grants.  On
the other hand, it's an expression that succeeded because of very specific and
felicitous circumstances.  Dave and Nick were both well-established, trusted
participants in perl's development, known as experts and conscientious workers.
They were given, by and large, free rein to pick the topics on which they would
work.  The foundation trusted them to pick things of value, though with a means
for TPF to call shenanigans if needed. That trust has been well-placed, in
my opinion.

For whom else, though, would the foundation be willing to do this?  I began to
write "precious few" before deciding that it's probably more likely to say
"nobody."  Or, rather, nobody who has any chance of applying.  What we need is
a confirmed expert at working on the core, with a broad knowledge of many of
its pieces, including its build options, portability concerns, and so on.
Then there would be the question of picking topics for work: they'd have to be
things on which the candidate *could* work, since no one seems quite
comfortable with every single piece of the codebase.  They'd also have to be
things with value, since they'd have to get approval from grant managers, and
possibly code reviewers.

I think I speak for most, if not all, of the regular contributors when I say
that we'd *love* to see such a person apply for and receive a grant to work on
core improvements.  It just doesn't seem likely, in part because it hasn't
already happened.

If we can't fund the work of a highly skilled, self-starting factotum, what's
next?  One common refrain goes something like, "Now that TPF has such-and-such
quantity of money, they should use it to get such-and-such feature added." This
is something that we haven't really tried doing in recent memory, in part
because it's very unclear how we'd do it.

First, we'd need to make a list of things we want done.  That part is pretty
easy, especially if we don't scruple to list even the very difficult things
like "untangle PerlIO" or "replace string exceptions with objects without
breaking things."  In a sense, we have had this for some time in the
[perltodo](http://perl5.git.perl.org/perl.git/blob_plain/HEAD:/Porting/todo.pod)
document, but its placement does have a bit of "beware of the leopard" to it.

With a list of tasks that we'd like to see done, the next step would be to
post bounties or request bids.  That is, either we'd attach a prize to seeing
the task completed or we'd let each applicant name his or her price.  Either
way, we'd end up (assuming *any* interest) with a list matching up people,
tasks, and dollar amounts.  Through some selection criteria, applications for
grants would be approved and work would begin.

In fact, we already have a mechanism for some of this in the [grants
committee](http://www.perlfoundation.org/grants_committee) of the Perl
Foundation.  Four times a year, they post a public call for grant applications.
Lately, there have been precious few applications, though.  It's not clear why
this is, but one reason that's been cited in the past is that the amount paid
for the grants is not sufficient to warrant the time required, at least for
many.  The maximum value paid for a grant from the committee is $3,000 by their
rules (although the most recent call for proposals set a $2,000 cap).  This is
about a week and a half at $50 per hour, the rate used for Dave Mitchell and
Nicholas Clark's grants.

Being able to accept a $3,000 grant and work on it steadily probably means that
an applicant must already be unemployed, working as a contractor, or willing
and able to take off the stretch of time from one's day job.  With those
conditions met, the next question is whether any of the problems we'd really
like to see sorted out *can* be done in ten days of work.  It seems quite
unlikely, from here.

What we see, instead, from most grants is that the work gets performed in off
hours: evenings and weekends, while the grantee continues on his or her day
job.  The grant money isn't necessary income, but a bonus, and is now at odds
with the grantee's enjoyment of leisure time — hardly a great motivator.

I think that in order to achieve results on any task that can't already be done
in someone's leisure time, any bounty or grant is probably going to have to be
for a much greater amount, sufficient to become the grantee's livelihood or
chief income for the duration.  Too many grants have lingered on for too long,
often fizzling out, because they were hobby projects with an optional prize at
the end.  For the grantee to abandon the grant cost nothing but face.

The next problem is keeping the work moving.  This isn't necessarily a question
of keeping the grantee on task.  After all, we've tried to make it possible
for this work to be the primary employment of the grantee, so there should be
some built-in incentive.  The problem here is removing roadblocks to the work
getting done and getting accepted.  That means that the programmer needs access
to code review to answer the questions, "why doesn't this work?" and "does this
changeset look good?"

That last one is particularly important because at some point any work being
done will have to land on perl5.git's `blead` branch, and if it's problematic,
it could be *very* problematic.  Several years ago, for example, a grant was
paid for to have perl produce an AST.  The work was done and the grant paid,
but the code was rejected for inclusion in the core for numerous reasons that
would not have occurred had there been regular code review.

Code review and expert advice are insufficently available on the perl5-porters
mailing list.  The reasons for this include, but are not limited to, the
strictly low number of experts on the core and the low availability of those
experts who exist.  Some potential reviewers have gone so far as to say that
providing code review can be depressing, because they have sometimes spent a
lot of time trying to transfer knowledge to would-be contributors, only to have
the contributors later go away, never to contribute again.  (This, after both
successful and failed attempts to get changes into the core.  Difficulty in
retaining contributors is problem for another day.)

If availability of code review is critical to making the money-to-code machine
work, how do we improve that availability?  One option is to pay reviewers, but
I think this is no good.  It means that potential aid might be withheld because
the potential reviewer knows that someone else could be getting paid to do what
he or she would be doing for free.  In other words: if *somebody* is supposed
to be getting paid to do this, why should *I* do it for free?  Further:  if I'm
getting *paid* to perform review for *this* set of changes, why should I do it
for *free* for *that* set of changes?

This concern applies, really, to the grant itself.  Why should anyone
contribute to the core "for fun" when others are doing it "for profit."  I
don't quite think that this argument is a reason to avoid cash-for-code
altogether, but I do think it's a reason to limit grant-funded work to problems
that are clearly understood to be very difficult and long-languishing.  Dave's
work on `(??{})` is probably the paragon of this sort of problem.

Of course, fixing `(??{})` is a big task, plausibly on the order of "untangle
PerlIO" or "replace string exceptions with objects without breaking things."
It took time, code review, design review, and time.  It was possible, in part,
because Dave was on a fairly open-ended grant, and could work on it until it
was finished.  If coding grants are given based on bids or bounties, and if the
grant is meant to be the primary work of the grantee, the time in which they
must be concluded is much more strictly bounded.

For me, on the topic of turning money into code, I'm left with a few thoughts:

1. Grants like Dave's and Nick's amount in many practical ways to simple
employment contracts, and work well because of the freedom afforded by that
arrangement.  Finding more suitable people willing to take on such a commission
would be a boon.  Of course, this might mean minting (read: mentoring) new
experts in the perl internals, and so far, this seems to be the real mystery of
the age.

2. Grants for thankless, short tasks likely to take two weeks or less might be
suitable for bounties.  One example from the top of my head would be "convert
Pod::Usage to Pod::Simple."  These would (presumably) require less code review
than longer-scale tasks.  If the best way to try to turn money into code is to
pay for short, awful, thankless tasks that will benefit future development, I
think the best thing that can be done is for such tasks to be clearly listed
and described somewhere, possibly `rt.perl.org`, and to point at them from any
future call for grant proposals.  I think the foundation should probably try to
offer $3000 (or more) grants again, to try its best to make grants "real
income" rather than a bonus for work in spare time.

3. Code review needs to become more universally available — whether it's wanted
or not, in some cases.  It probably can't be brought about with the direct
application of money, and I don't see how money can indirectly help just yet.


