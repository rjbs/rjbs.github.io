---
layout: post
title : the 2012Q3 call for grants: some ideas
date  : 2012-07-13T23:30:06Z
tags  : ["perl", "programming"]
---
It's that time again!  The Perl Foundation has issued the [Q3 2012 call for
grant
proposals](http://news.perlfoundation.org/2012/07/2012q3-call-for-grant-proposal.html),
and you've got a few weeks to apply for one.  Here are some things I'd like to
see people do.  Obviously, when you apply for a grant, you need to convince the
grants committee that you've got a great chance of getting the work done, and
done on time.  "On time" probably means "pretty quickly" for these tasks.

These are pretty small, and I think that's good.  Small tasks are more likely
to be doable, and even a small grant amount might be a nice bounty for them, as
opposed to the lousier ratio one tends to get when doing a whole lot of work
for a higher end (around $2000) grant.

These are the first few tasks that popped into my head.  I'd love to see what
other people think needs doing.

## readpipe(LIST)

From the Perl todo:

> system() accepts a LIST syntax (and a PROGRAM LIST syntax) to avoid
> running a shell. readpipe() (the function behind qx//) could be similarly
> extended.

## unused lexicals

From the Perl todo:

> This warns:
>
>     $ perl -we '$pie = 42'
>     Name "main::pie" used only once: possible typo at -e line 1.
>
> This does not:
>
>     $ perl -we 'my $pie = 42'
>
> Logically all lexicals used only once should warn, if the user asks for
> warnings.  An unworked RT ticket (#5087) has been open for eleven
> years for this discrepancy.

There's [an RT ticket](https://rt.perl.org/rt3/Ticket/Display.html?id=5087)
for this one.  Probably the warning should be suppressed if you assign to 
the variable, as above, because you may be doing so in order to get an effect
when the object is destroyed.  "my $x;" alone, though, is pointless... right??

## make App::Nopaste's Gist plugin with with GitHub's v3 API

When I wrote App::Nopaste::Service::Gist, it was very easy to post a gist under
my own username.  Now it seems to be a nightmare of OAuth.  I'd sure love if
this worked again, though.  I bet somebody out there knows OAuth.

## update PPI for more recent constructs

Last I looked, PPI couldn't handle much newer than Perl v5.10 or v5.12.  I
don't have a comprehensive list of the stuff it can't do, but it wouldn't be
tiny.  Make it all work.


