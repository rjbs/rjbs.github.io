---
layout: post
title : "the PAUSE micro-hackathon"
date  : "2011-08-14T02:06:12Z"
tags  : ["cpan", "perl", "programming"]
---
When a generous Perl programmer decides to share his fantastic new library with
the world, he probably uploads it to CPAN -- that's where most of the shared
Perl libraries are found.  In fact, though, he's not uploading it to CPAN, but
to PAUSE, the Perl Authors Upload Server.  (The "E" is acronymically silent.)

PAUSE is one of the most important pieces of the CPAN ecosystem.  It decides
which uploaded files will become indexed and therefore findable by CPAN
clients, and it also decides which files are going to be skipped as bogus,
broken, or unauthorized.  Without PAUSE, there'd be no CPAN index (the
`02packages.details.txt` file that makes commands like `cpanm Some::Library`
work) and the CPAN would be really, really annoying to use.

The code that powers PAUSE is not well-understood, though.  For years now, it's
been maintained almost entirely by Andreas Koenig, who runs PAUSE -- and runs
it so well that nobody else has really had to get involved.  Still, nobody
wants Andreas to feel shackled to running PAUSE, and if he should win the
lottery and retire to the Black Forest, it would be a real pain if he took the
world's only PAUSE expertise with him.  Beyond the whole "only one guy" issue,
there's lots of important logic in PAUSE!  Did you know that `-TRIAL-` in your
dist's filename will prevent indexing?  Did you know that a newline between
`package` and the package name will prevent that package from being indexed?

There are quite a few secret behaviors like these, some better known than
others.  Because the code is only in PAUSE, and not in a shared library, many
of these behaviors have been copied into other libraries over the years,
sometimes correctly and sometimes with subtle differences.  It would be great
if they could be factored out into reusable components.  Some of us in the
"CPAN workers" community have looked at doing this in the past, but there's a
huge hurdle:  PAUSE has very, very few tests.  It also isn't trivial to build
tests for it, as it expects you to have a properly configured mod_perl (v1) and
MySQL database.

I really wanted to work on PAUSE tests at the QA Hackathon in April, but poor
planning on my part made that impossible, so I worked on
[FakeCPAN](http://fakecpan.org/) instead.  After the QA Hack, though, David
Golden and I got to talking about getting together for a one day hackathon of
our own.  We only live about two hours apart, after all.

Today was the day!  I got to Brooklyn around 9:15.  We talked a little bit
about our Dungeons and Dragons games, and I admired David's son's awesome tank
top, but it wasn't too long before we got to work.  The plan was something like
this:

1. get a single manual run of the indexer working against a MySQL database
2. turn that into a repeatable program
3. turn that into automated tests
4. start refactoring the indexer to test its pieces individually

We figured that if we got that far, we'd have made great progress for the day.
Just after we got to work, David suggested we shoot for testing against SQLite
instead of MySQL, so our procedure for achieving #1 was pretty simple:  run the
darn program over and over, addressing each error message as we hit it.  First,
we hit a bunch of SQLite errors, which I worked to correct before we finally
gave up and moved to MySQL.  Then we found more and more bits of configuration
that we needed to override.  Then we found more and more bits of code that
needed to be made configurable.  Every run got us just a little further until,
just before lunch, we got the excellent message:

> Finished rewrite03 and everything

When we got *back* from lunch, I suggested that while we were fixing other
problems, I'd also sorted out the last of the SQLite issues.  We re-ran the
tests and it was so!  The whole thing worked against SQLite, too.  That would
be a huge benefit when writing automated tests.

Our test, at this point, were pretty simple:  we wrote a `PrivatePAUSE.pm`
file, analagous to CPAN's `MyCPAN::Config` library, providing overrides to the
default PAUSE configuration.  Then we took a bunch of dists from the "minicpan"
[FakeCPAN](http://fakecpan.org/) and tried to index them.  Success meant two
things:  the program ran to the end, and the dists showed up in the database.

With this bare minimum of work done, we moved to step two.  We split up to work
on two tasks:  building an automated form of the test that could easily
interrogate the database after indexing; and cleaning up the absolute mess of
log lines produced by the program, which made it hard to follow the work being
done.

This was a lot of fun.  We ended up with a library that build a whole CPAN, by
indexing a CPAN-like `./authors/id/...` tree.  Once the indexing is done, tests
can be run against the PAUSE database, the CPAN packages file, and the rest of
the filesystem containing the test.  When the test is over, the whole thing is
deleted and thrown away, so it's cheap to run it over and over... and we did!
We renamed badly-named methods, broke apart the massive `mldistwatch.pm` file,
which originally contained around a half dozen different package definitions,
replaced all the global filehandles with lexical ones, improved error messages,
and did some other simple refactoring.  Each time we did this, we could run the
simple automated tests and see that we hadn't broken anything major.

I even got to meet one of my long-standing goals:  I replaced PAUSE's use of
Mail::Send with Email::MIME and Email::Sender, meaning that pretty soon I can
make it use Email::MIME::Kit, sending even better-looking, easy-to-update email
messages.

Today felt really, really productive, much like a good day at the QA Hackathon.
I'm hoping that we can see these changes land on the real PAUSE sometime soon
-- and without incident.  From there, it will just get easier and easier to add
more tests, spin out more reusable code, and clean up more confusing bits of
the program.

