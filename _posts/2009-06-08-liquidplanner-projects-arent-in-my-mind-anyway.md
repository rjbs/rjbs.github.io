---
layout: post
title : liquidplanner projects aren't (in my mind, anyway)
date  : 2009-06-08T22:40:58Z
tags  : ["liquidplanner", "productivity"]
---
If you don't use [LiquidPlanner](http://liquidplanner.com/), this post might be
incomprehensible and/or boring.  I'm writing it in part just to help form my
own ideas.

Recently, I gave Chris a task with a description like, "remove spurious 'use
base' from Catalyst applications."  It was a poorly-described task, and really
meant, "perform one step in preparing for an upgrade to Catalyst 5.8."  This
got me thinking about how I should've laid out the entire upgrade path.  In my
mind, that would be a whole project.  That is, it's a bunch of tasks that we
have to carry out to achieve an end goal.  There is an implied ordering, and
we'd like to do them all without switching to another project, but it's not
quite one task list.  (A task list is the other fundamental unit of organizing
tasks in LiquidPlanner.  Task lists are primarily ordering structures and
projects are primarily nesting structures.)

The "prepare to upgrade" endeavor isn't just one task list because it might be
(and, in this case, is) too much work to fit in one sprint.  It needs to be
broken down into smaller units (task lists).  So, imagine that there are two
sprints' worth of work for this endeavor.  I can make one task list, "Prepare
to Upgrade Catalyst" and then two others inside it.  When it's time to schedule
the work, though, there will be a task list "Sprint 2009-07-01" for everyone's
work for the sprint.  I'll move the first sprint-worth of work into that task
list, and now it will no longer be in "Prepare to Upgrade Catalyst."  Now I
can't, for example, see how much of the predicted work for that endeavor is
complete.

My reluctance to use projects for this is that they seem much more intended to
represent products.  That is, we have a "Website" project and a "Spam Browser"
project under that.  They are parts of our service against which we can file
bugs or on which we can do more work.  They never get closed.  They go on and
on until we all retire.

Projects also have no concept of ordering.  I started a [forum
post](http://www.liquidplanner.com/forums/forums/3/topics/340) about allowing
project view to display tasks in local order -- that is, ordered as they are on
the schedule, limited to being relative to other tasks within the same exact
folder.

Were that the case, the workflow for planning a new project would be:

* create new project folder; default task list is the "Future Work" nebula
* bulk-add tasks to the project folder

Now you have the tasks, in order, and they're all in the right project folder.

When scheduling the work out into the first sprint:

* view the now-ordered project
* select enough tasks to fill up X days
* bulk-assign to upcoming sprint task list

Later, when it's time to schedule the next sprint, you can go back to the
organize view and filter on active items.  Since the project view is (in this
hypothetical world) shown in relative order, you can safely pick from the top
to assign to the next sprint.

You can then safely look at the project folder to see overall progress.

The "projects are forever" problem may be solved by updating our use of the
organizer to use some of the new node types.  Right now, all our work is
organized in "yellow" folders, which used to be called project folders.  There
now exist two kinds of folders: yellow folders ("folders") and blue folders
("projects.")  If we use one style for products that we offer idefinitely and
one for fleeting endeavors that we eventually complete, it will be very obvious
which items you can safely mark "done."  (I like policies that I can put on the
wiki as "mark yellow folders done when the project is complete; if you mark
blue folders done, rjbs will be very angry.")

This will all work without being able to view folders sorted, but it seems a
fair bit more annoying.  Even so, I think it will be better than the current
organization.  I guess it's time to start making yellow things blue.

