---
layout: post
title : "I get points for blogging this!"
date  : "2013-07-25T16:47:05Z"
tags  : ["productivity", "ywar"]
---
I feel like I'm always struggling with productivity.  I don't get the things
done that I want to get done, and I'm never sure where I lost my momentum, or
why, or how I can keep with it.  I've tried a bunch of productivity tools, and
most of them have failed.  For a while, now, I've had an on-again-off-again
relationship with [The Daily Practice](http://tdp.me/), which I think is great.
Even though I think it's great, I don't always manage to keep up with it, which
means it doesn't actually do me much good.

I'm on-again, though, and I'm trying to use it to combine some of my other
recent changes to my routine.  For example, I wrote about [using a big queue to
many all my projects' bug queues]({% post_url 2013-07-04-once-again-trying-to-keep-up-with-the-tickets %})
and [forcing a reading bottleneck]({% post_url 2013-07-06-dealing-with-my-half-read-book-problem %})
to avoid reading too many books at once, and thus getting none read.  I also
want to try to get sustained momentum on keeping my email read and replied-to.
I'm not sure whether TDP will help me stay on target, but I think it will help
me have a single place to see whether I'm on a roll.

The Daily Practice is a calendar for your goals.  You tell it what things you
want to do, and how often.  Then, when you've done the thing, you tell TDP that
you did.  As long as you keep doing things often enough, you rack up points
every time that you extend the chain.  If you fail to keep it going, you lose
*all* your points.  It looks like this:

<a href="http://www.flickr.com/photos/rjbs/9366752922/" title="The Daily
Practice"><img
src="http://farm8.staticflickr.com/7346/9366752922_576cd98707_z.jpg"
width="640" height="275" alt="The Daily Practice"></a>

I started to think about what kind of goals would be useful to demonstrate
momentum.  My list looked something like:

* get some email-reading done
* clear out old mail that's marked for reply
* spend time working on RT tickets and GH issues
* catch up with reading p5p posts
* review commits to perl.git
* keep processing my [long-lived perl issues](https://github.com/rjbs/perlball/) list
* write blog posts
* read books
* read things long-ago marked "to read" in Instapaper
* keep up with RSS reader
* keep losing weight

I started to think about how I'd track these.  It was easy to track my email
catch-up on my last big push.  I was headed to Massachusettes with my family
and while Gloria drove, I read email.  Every state or so, I'd tweet my new
email count.  Doing this from day to day sounded annoying, though.  If I just
finished reading two hundred email messages, I want to reward myself with a
candy.  I don't want to go log into my productivity site and say that I've done
it.

Fortunately, I realized that just about all the goals I had could be measured
for me.  I just needed to write the code and post results to TDP.  I made doe
eyes at TDP support and was given access to the beta API.  Then I didn't do
anything about it for a while… until getting to OSCON.  I've been trying to use
the conference as a time to work through some outstanding tasks.  So far, so
good.

I've written a program, `review-life-stats`, which measures the things I care
about, when possible, and reports progress to TDP.  Some of the measurements
are a little iffy, or ripe for gaming, or don't measure exactly what I pretend
they do.  I think it will be okay.  The program keeps track of the last
measurement for each thing, storing them in a single-table SQLite file.  It
will only do a new measurement every 24 hours.

The way to think of these monitors is that they only report success.  It has to
say "today was a good day" or nothing.  There is no reason (or means) to say
"today was bad," and my monitors don't  consider whether there's a streak going
on (but they could be made to if it would help).

Here are the ones I've written so far:

* the total count of flagged messages must be below the last measurement (or 10, whichever is higher)
* the total count of unread messages must be below the last measurement (or 25, whichever is higher)
* I must have written a new journal entry
* I must have made a new commit to `perlball.git`; any commit will do.  I check this by seeing whether the SHA1 of the master branch has changed, using the GitHub API.
* There must be no unread messages from the `perl.git` commit bot over three days old.
* The count of unread perl5-porters messages over two weeks old must be below the last measurement or zero.

I won't be able to automate "did I spend time reading?" as far as I can
predict.  I'm also probably going to have to do something stupid to track
whether I'm catching up on my bug backlog.  Probably I'll have to make sure
that the SHA1 of `cpan-review.mkdn` has changed.  I'm also not sure about my
taks to keep reviewing smoke reports or to plan my upcoming D&D games.

The other goals that I *can* automate, somehow, are going to be doing semi-regular
exercise, keeping my weight descending, and working through my backlog of
Instapaper stuff.  Those will require talking to the RunKeeper, Withings, and
Instapaper APIs, none of which look trivial.  Hopefully I can get to each one,
in time, though, and hopefully they'll all turn out to be simple enough to be
worth doing.

