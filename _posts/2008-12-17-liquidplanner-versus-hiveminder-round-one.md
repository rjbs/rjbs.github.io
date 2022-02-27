---
layout: post
title : liquidplanner versus hiveminder: round one
date  : 2008-12-17T00:39:52Z
tags  : ["hiveminder", "liquidplanner", "productivity", "software"]
---
I've written a few times about how much I like
[Hiveminder](http://rjbs.manxome.org/rubric/entries/tags/hiveminder), Best
Practical's to do list manager.  (As an aside, I really need to decide on
whether I write "to do" or "todo" or "to-do."  I keep switching between them in
single documents.  It's silly.)  I've also mentioned LiquidPlanner a few times.
I like it quite a lot, also.  Unfortunately, neither one is perfect and, worse,
they do such similar things that using both can be a real drag.  I keep wishing
I could drop one.  My mom likes to call my dad the "Gadget Man" because he's
always buying new gadgets.  I try to make it clear that I am not Gadget Man II:
I try to have as few gadgets as possible to get the job done.  This goes for
software tools, too.

LiquidPlanner is a project management tool, like OmniPlan or Microsoft Project.
I'd made noises at work for quite a while about how good these tools are for,
uh, project management, but there was a big problem:  we were not a target
market for any of the products we could find.  OmniPlan was great, but requires
that there is a single project manager adding details to the project.  Workers
are responsible for keeping track of their work in some other system, like
Trac.  MS Project isn't bad, either, and has a tolerable server side component
to let users update their own tasks.  Unfortunately, Project Server is one of
those obnoxious products that you have to buy through Microsoft with an
irritating license, and you need a Windows server, and it's expensive.  Also,
and I'm guessing here, it probably requires ActiveX support in the client's
browser.

Anyway, what we needed was a project management tool that allowed users to
manage their own work, that had as little hosting hassle as possible, and that
didn't cost a fortune.  One day, somehow, I stumbled on LiquidPlanner, and
poked around.  Pretty soon, we'd loaded our work into it, and we've been happy
ever since.  It has a few shortcomings, but in general it's very, very good at
helping us stay on track and to keep an eye on what is going on.

The places it fails are all about quick interactions and lightweight
interoperation.  I really feel like LiquidPlanner is its own application, and
it has one interface: the web.  It does have an email gateway, but email is
really low on my list of ways to interact with something like this.  Its
latency is so high, it's so inexact, and ... well, I'm pretty sure I'd hate
however it would end up working with mutt, over time.

Hiveminder completely and entirely blows LiquidPlanner out of the water, here.
In my mind, Hiveminder is a datastore that provides many interfaces.  It's not
a web application, because the web app is just one interface.  In fact, in my
opinion, it's the *least useful* interface.  (That's why I use it the least.)
The absoute killer feature with Hiveminder is its IM interface.  I can send it
a message from Adium asking it to make a new task, send a request for work to
someone, or search my tasks.  This is worlds better than an email interface,
because I get immediate response: I say "create buy a loaf of bread" and it
says "Okay, I created that task, here's its identifier." I can also easily say,
"did this," and it marks the task complete.

That's nearly as structured as Hiveminder gets, though: done and not done.
There is a system for prerequisites, but it has always struck me as bolted-on
and clumsy.  I think this is largely because the IM interface for it is poor,
and, well, I'm not a fan of the web interface either.  In contrast,
LiquidPlanner has a rich set of structuring tools.  Each task belongs to a
category inside a hierarchy of categories.  Each task also belongs to one task
list, which is a set of work items that are going to be done in one go.  These
make a great stand in for "one Scrum sprint or agile iteration," or "one gaming
session" or "one trip to the mall."  Task lists automatically produce an
ordering that, in conjunction with time estimates, produces a schedule.  If
this isn't enough (and it usually is) you can pin events onto the calendar or
set up forced prerequisites.  The interface for doing all of this is insanely
polished and behaves much, much more like a native application than a web
application.  I visit LiquidPlanner in a Fluid.app instance, which makes this
seem even more true.  It's like I have a program on my computer for real
project planning that synchronizes to all the other instances of it that my
team uses.

Sometimes, though, that structure is just too much.  I'm using LiquidPlanner
for my new D&D campaign, and so far I'm very happy with it.  One thing that I'm
sure is going to annoy me, though, is the presence of time estimates and
scheduling everywhere.  I want to use it as a rich, structured to do list.
There's not much schedule to be had, because its progress is based largely on
my free time.  This would clearly be worse with an unfunded open source
project, where a user's availability is random.  Already, after just a few
days, I'm starting to get "this item needs an update" warnings.  I want to
tick the "never bother me about scheduling again" and "do not display time
estimates" boxes, but they don't exist.

Over and over, Hiveminder trumps LiquidPlanner when it comes to an interface
for letting you JFDI.  For example, probably the most common conversation at
the office is something like this:

    <puck> I'm having trouble connecting to the gene resequencer.
    <rjbs> Oh, I need to re-align the chromo-inverters.  Make a task for that.

In Hiveminder, the next step would be:

    <puck> hmtasks: create re-align chromo-inverters [owner: rjbs@sea.lab]
    [generesequencing] [due: today]

...and there's an HTTP API for writing your own ways to do this sort of thing
-- like, for example, writing an IRC bot.

In LiquidPlanner, the next step would be:

    * puck goes to LiquidPlanner
    * puck leaves the dashboard for the Plan tab
    * puck clicks Add -> New Task
    * puck selects "assign to rjbs"
    * puck selects "folder: gene resequencing"
    * puck selects "task list: urgent tasks"
    * puck enters description
    * puck clicks "Add"

Now, what if puck were to use the email gateway?

    * puck sends mail to "Urgent Tasks" <123456-67890@lp-gateway.example.com>
    * subject: re-align gene sequencers, rjbs

That's much better, but the big problem is that now the user needs to have a
unique email address for each task list and it won't set the project folder
correctly.  Since LP doesn't have tags, project folders are the best way to
find "all bugs relating to X," and now our bug isn't related to the Gene
Resequencer but to whatever the default project is for urgent bugs.  That's
probably the root project.

Meanwhile, Hiveminder's email integration (for Pro accounts) requires that you
know only the email address of the user you want to assign a task to:

    * puck sends mail to <rjbs@work.example.com.with.hm>
    * subject: re-align gene sequencers, rjbs

This doesn't assign tags, due dates, or lots of other things, but it makes it a
new *request* for the target user, meaning that he sees it's got to be
classified and triaged.  It would, of course, be better if the requester could
do that work for him, but marking new tasks as needing acceptance means it's
clear what isn't categorized yet.

Unfortunately, once you're into the realm of categorizing, Hiveminder isn't
doing so well.  To elaborate a bit on what it has beyond "done" and "not done,"
there is a due date, a delay-until date, and tags.  There's also tracking for
time spent and time remaining, which has been in beta since June, but isn't
useful for scheduling because tasks have no inherent order and, beyond that...
well, it just doesn't compute a schedule.  This makes the delay-until date and
due date much less useful, too.  You can easily put off tasks to such an extend
that you'll never be able to complete them, because there's no over-arching
schedule where you can see that you've just planned the impossible plan.

So, to sum up...

Hiveminder presents a very, very low barrier to creating new tasks or marking
existing ones done.  This means that more work is likely to get tracked.  Its
system for accepting requests means that there is a built-in workflow phase for
performing triage on work requests.  It doesn't have a lot of features for
organizing a schedule, and is much better at dealing with individual tasks or
search-based batches of tasks.

LiquidPlanner makes it very easy to manage a complete project schedule with
multiple sub-projects, planning for future work, resource availability, and
predictive scheduling.  It has a single, gorgeous user interface that makes it
easy to work with the schedule, but makes it difficult enough to fire off quick
requests or work logs that some requests or time sinks go unlogged.

My educated guess it that LiquidPlanner has less work to do to become just what
I want, but that it's unlikely they're going to head in that direction.  I
don't think they have much interest in becoming good at managing my to do list.
Still, they might add enough quick-entry features to help improve the odds of
all work getting logged.

Hiveminder is a fantastic to do list manager, but most of the work I track in
it would probably be better as projects in an LP space: my CPAN modules, home
improvement.  Hiveminder is strongest, in my experience, for things you need to
do today, or this week.  Longer term work tends to get hidden by using the
delay-until feature, precisely because there is no longer-term schedule.

As a side node, neither LP nor HM has any good way to expose the contents of a
group or workspace to the public, meaning that neither is a suitable work
planner for open source projects.

I don't know just how my use of these two products will evolve in the future,
but I'm really hoping that the products themselves keep evolving.

