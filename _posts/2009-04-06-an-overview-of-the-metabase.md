---
layout: post
title : an overview of the metabase
date  : 2009-04-06T03:05:04Z
tags  : ["metabase", "perl", "programming"]
---
At both the Oslo and Birmingham QA Hackathons, my big project was the CPAN
Metabase.  I'm hoping that in 2010, I'll be working on something new, but only
because I like variety -- I really like the product we've got and I believe it
can be a great tool for a lot of problems.  Here's a simple overview of what it
is and how we plan to use it.

Metabase is a system for storing and searching structured annotations about
resources that you don't (necessarily) control.  Its first job is to store the
next generation of CPAN Testers reports.

Whenever you upload a distribution to the CPAN, a bunch of other servers
download it and try to install its prereqs and run its test suite.  When
they're done, these servers (or sometimes end users) submit reports that say
things like "all tests successful" or "tests failed."  They also include some
other information that humans can look at to decide what really happened.  This
has been an extremely useful system for me, as it makes it very easy to see, in
effect, well-filed bug reports that required no human effort to generate.
(There is a constant debate about whether these reports are useful.  To me,
they are.  YMMV.)

Rather than just send in a dump of what happened when installation was
attemped, though, we wanted to get a bunch of structured data like:

* details of perl's compilation options
* other installed modules
* decisions made by installer about how to install
* structured Test Anything Protocol data
* other stuff

All these facts about a test run are distinct items that can be submitted
together as a report about an installation attempt.  We break down this sort of
submission into a few parts:

1. the content -- a list of these facts
2. the resource -- the distribution file from the CPAN that was being tested
3. the metadata -- data we can summarize for indexing and searching

As more and more reports in this format are submitted, we can easily say "show
me all new reports for my dist `RJBS/URI-cpan-1.003.tar.gz` with the metadata
`test-result` set to `FAIL`."

There's more to it, though.  The searchable metadata is drawn from the content,
the resource, and from the submitting user.  This means we can say "show me all
reports for any dist file where I was the uploader, where result was FAIL,
where the OS was VMS, and where the perl version was at least 5.008."

Then we can extract just the TAP from the report and load it into our sweet GUI
visualizer, or we could just look at a summary of users submitting those
reports, or do lots of other things with the data.

Now, imagine that one of the facts reported by testers is "What prerequisites
did I think your module had?"  This is a really interesting question when your
distribution dynamically determines prereqs based on the installer.  It's also
useful if you find out that different install tools are computing things
differently.  We might give this fact a name of CPAN-Metabase-Dist-Prereqs.

A great consequence of the structuring of our test reports is that the units of
contained data can be re-used.  That means that if
[CPANTS](http://cpants.perl.org/) also wants to submit these facts, it can.  So
could other pieces of software that look at CPAN distributions and guess what
they will require for installation -- Debian's packaging tools, for example.
If these facts were submitted, it would be easy to notice that all tools but
one agree on the prereqs for a given distribution, exposing a likely bug
somewhere.

So, the use of structured reports is clearly a big win, and indexed metadata
largely follows from that.  If we know how to provide some indexable data for a
fact, it's easier to find facts.

The next likely win is in the way that we associate test reports with
distribution files.  Every fact is associated with one resource.  We use an
identifier for our resources that is universal.  We call it a URI.  For
example, if you wanted to submit a report about Config::INI's latest release,
you would submit a fact about `cpan:///distfile/RJBS/Config-INI-0.014.tar.gz`

By using URIs for resources, the metabase is wide open for expansion.  You
could use it as an address book by submitting vCard facts about mailto URIs.
You could submit ratings by submitting a fact about a distribution.  There is
nothing CPAN-specific in the metabase, even though it was designed first and
foremost to be a repository for CPAN testers data.  It just worked out that by
keeping it simple, we'd made it very generic.

Resources also provide some metadata, so you can easily get a list of all facts
about `distfile` resources where the uploader was `DAGOLDEN`.

Finally, the Metabase code is free and easy to install.  If you want, you can
run your own metabase for anything you like.  One obvious use is to run your
own test report collector.  You could have your company's internal deployment
system use all the standard CPAN tools -- from CPAN.pm to [the same web
interface](http://search.cpan.org/dist/CPAN-WWW-Testers) -- for testing its
internal code.  You'd just submit test reports to your internal server.  You
could even easily relay reports for non-private code to the public repository.
I'm really hoping to eventually do some work to make
[Smolder](http://search.cpan.org/dist/Smolder/) cooperate with Metabase, so
test reports will contain TAP archives and you can tell Smolder to get its data
from a Metabase server.

There's lots more I could say, but I've probably rambled a lot, already.  I'm
really tired.

There aren't too many major hurdles between the current state of code and
getting real data into the system.  I'm hoping that we'll have a "stock"
testing client submitting data to a test installation within the week -- David
suggested he might have it working tonight.  After that, it will all be about
testing, polish, and scaling.

Well, and a bunch of other problems... but that's okay.  It's really coming
along nicely.

