---
layout: post
title : first impressions of ActiveState Stackato
date  : 2011-08-25T23:52:06Z
tags  : ["cloud", "perl", "programming"]
---
When Heroku started to become popular, I thought it was pretty neat, but not
neat enough to get me to change my primary development language.  A year or two
ago, a friend asked if I was interested in helping develop "Heroku for Perl."
I said I didn't see much value in it for myself.  I knew how to deploy
applications "the hard way," so investing in making it easier didn't win me
much.  This year, a few
[PaaS](http://en.wikipedia.org/wiki/Platform_as_a_Service) providers supporting
Perl have shown up, and I didn't pay them any attention until someone told me
that ActiveState's [Stackato](http://www.activestate.com/cloud) cloud system
was having a contest and that I should consider entering it.

To cut a long story short:  I gave it a go, and my opinion has changed.  This
kind of deployment definitely has potential, maybe even for set-in-their-ways
people like me.  Stackato needs more work before its beta period can be over,
but it's way cool, and has a lot of potential.

The following is more of the long story:

I've read almost nothing about Stackato, including the ActiveState site about
it.  I know practically nothing about what it's really intended to be or how
ActiveState imagines it being used or its future.  I only read the pages that
looked like they'd help me get my project up and running, and nothing that
looked like it was designed to convince me to use Stackato.  My mission was to
win the contest, not to decide whether to use Stackato for my business.

The one piece of marketing text that I did read, as I'd seen it a few places,
was this:  **Simply install Stackato, then deploy and run your applications in
the cloud in less than 15 minutes.**  I was shocked by how close to true that
turned out to be.  I had to fumble around a few times when I hit snags that
were sometimes my fault and sometimes Stackato's, but if I had known what I was
doing and if Stackato had been just slightly tweaked to start, I think the
slogan would've been true -- and that's pretty impressive.

The contest was to bring up an open-source web application on Stackato.  At
first, I thought I'd have to write something new, which seemed like a big drag.
I found out that I could use an existing program, whcih was great news.  It
also helped me focus on understanding Stackato instead of writing a web app.
If I had written a new app, the easy deployment wouldn't have made any impact,
because I would've been spending all my time debugging new code.  I decided to
get Rubric up and running.  It's sort of dated in its underlying code, but it
works well and has obvious uses.  I still use it, seven years after writing it,
and am not disgusted by it.  It seemed like a good starting point.

Here's a rough outline of everything I knew I had to do -- and note that some
of these commands might be slightly off:

1. download the VMWare image and start up the machine in VMWare Fusion
2. put an `app.psgi` file in my git repo's root
3. run `stackato target stackato.local`
4. run `stackato push` from my working directory
5. visit my app on the web

This actually went a lot better than I expected it to, but it *did* fail.  Why?
I had nearly no idea.  The Stackato client offers much too little visibility
into what's going on with your deployment.  It tries to offer enough, but here
and there -- especially during initial deployment -- it fails.  For example,
you can tail log files with the Stackato client, but you can only access them
on a per-deployed-application basis.  Once you've finished deploying, this is
fine.  When you're in the middle of deploying, though, you can't get at the
files.  That means you can't tail the results of staging your prereqs during
initial deployment, which is where I hit many of my problems.  Now, it turns
out there was a way to get at those logs:  log into a shell on the VM, look at
the output of `ps auxww`, find the file under `/tmp` to which `cpanm` output is
being piped, and tail that.  Unfortunately, once you have to log into the VM,
something is wrong.  Everything should work without the developer needing to do
that.

The good news is that this seems pretty easy to fix.  The client should make
these logs easier to find and access during deployment or after a failed
deployment.  This doesn't seem like a design problem, just an unfinished
feature.

Incidentally, there was another rough edge that drove me much crazier than it
needed do.  When deploying an app, there is a "staging" phase during which CPAN
prereqs are installed.  Rubric has quite a few prereqs, so this phase takes a
while.  Unfortunately, the indicator that staging has begun is not printed
properly, meaning that while staging is happening, the client would show
"stopping application."  I kept wondering why my application wouldn't shut down
clearly -- well, it turns out it stopped just fine, and then staging began.  I
would've been much more patient with staging.

So, why did I need to keep looking at my staging logs?  There were a few
reasons, each less annoying than the first.  The first problem was probably
most annoying because I hit it first, while I felt like I was on a roll, and it
slowed me down.  Stackato is supposed to determine your prereqs from your
`Makefile.PL`, but mine kept failing to provide any.  Rubric uses
Module::Install for its config tool, and I wasn't pushing up the `inc`
directory that gets built into released distributions.  Stackato doesn't come
with Module::Install pre-installed, so my `Makefile.PL` relied on code that was
neither bundled nor installed.  The lesson here is that **Stackato expects
something more like a dist than like a working tree**.

Rather than convert my install tool, I noticed something telling me that I
could provide a `requirements.txt`.  What's that?  I had no idea, and there
were no links to documentation for it, so I took a wild guess.  I put each
prereq (with no version information) on its own line in the file and pushed
that.  I knew it was working when it took ages.  Like I said, I have a load of
prereqs, and I was just fine with the expense of installing them all.

Pretty soon, Stackato reported success, and I was amazed.  Really?  Everything
*just worked*?  It told me I could find my application at
`http://rubric.stackato.local` -- and this detail delighted me to no end.  See,
when you bring up an application on your virt, it adds a new
[mDNS](http://en.wikipedia.org/wiki/MDNS#Name_resolution) name for that
application, so it just shows up -- no path prefix, no stupid port names, no
nothing.  I hope I can find a way to do this with my local testing of Plack
stuff.  It was a small detail, but a really, really slick one.

Unfortunately, hitting that URL got me an empty page.  Where was the drab,
hacker-produced HTML I expected?  I looked at the logs.  Now that I'd finished
deploying, they were there and easy to access.  The only thing in them, though,
was a warning about doing a `undef > 0` comparison in a template.  This was
driving me nuts!  If my templates were being rendered, why wasn't I seeing
them?

At this point, it was getting late, so I turned in for the night and didn't get
back to things for another day or two.  (I was busy with D&D.)  Once I did get
back, though, the problem was still there.  Fortunately, as is often the case,
IRC had the answer for me:  the Stackato HTTP server was not happy unless it
got a Content-Length header.  I added the
[ContentLength](https://metacpan.org/module/Plack::Middleware::ContentLength)
middleware and there was Rubric, looking right at me.  I had pushed up my
personal Rubric database, and everything worked:  I could log in, post new
entries, and browse existing ones.  The only problem was the lack of any CSS.
I'll come back to that in a bit.

First, though, imagine that I hadn't been using Module::Install -- it's
used by about 15% of CPAN dists -- but instead was using Module::Build or
ExtUtils::ModuleMaker, which are used by nearly all of the remaining 85%.  Then
imagine that I'd already had the ContentLength middleware in place, which I
*should've*, if I was being more careful.  If I had, then I probably would've
actually had the application up and running in about fifteen minutes.  I
realized this immediately, and it was quite impressive.

But what was going on with that CSS?  Why wasn't it showing up?  After all, the
way CSS in Rubric works is simple:  requests under `/style` look for files
under the same directory in the dist's [share
directory](https://metacpan.org/module/File::ShareDir).  Thinking about that
made it clear:  my share files weren't being installed, because **Stackato does
not install your application, it just runs it.**  So, even though it seems like
it expects a dist, even that is not quite right.  What it really wants is much,
much less:  just the `app.psgi` and needed support files.

This was sort of a revelation.  I deleted almost *everything* from my working
tree and pushed a tiny `requirements.txt` requesting only Rubric.  So, my
working tree was now basically this:

    app.psgi          - tiny file, the Rubric PSGI app
    requirements.txt  - one line containing "Rubric"
    rubric.db         - an SQLite file with the data in it
    rubric.yml        - the site configuration

I could've even skipped the database, if I wanted to run the "build a db file"
program after deployment, but it seemed harmless to keep it around.  I pushed
this -- and waited a few minutes while it redeployed -- and pretty soon the
site was up and running, *with CSS*.  I would've started with this from the
beginning, if the docs had made it clear that this was the way to go, and
things would've been *even better* after the 15 minute deployment.  (Maybe the
docs do suggest this, somewhere.  As I said, I barely read them.)

So, I sent off my note to ActiveState.  I didn't think I had much of a chance,
because I'd spent so little time on it.  On the other hand, Rubric is a pretty
nice application, and I thought it was pretty impressive to see that even
something as full-featured as it could be deployed so easily.

The next day, I got a note from ActiveState -- they didn't know how to add
users, and I'd provided only the barest minimum of instructions.  I said they'd
have to run something like this:

    $ stackato run rubric rubric user --new-user \
      --email user@example.com
      --pass  secret
      username

...but this wasn't working.  It turns out that they'd found *a bug in Rubric*!
I hadn't used `--new-user` in years, and in the meantime, I'd added a bug to
it.  And I didn't have a test for it.  How embarassing!  I immediately made a
fix and deployed that to the CPAN.

Now I hit another problem:  `requirements.txt` finds things to install by
looking at ActiveState's PPM repository.  I can't force it to get the latest
from CPAN.  For that, I have to use a `Makefile.PL`, which will use `cpanm`.  I
thought I could sidestep this by using `stackato run rubric cpanm Rubric`, but
it turns out that you can't use the Stackato client to run cpanm in the context
of your app.  This is actually probably a *really good* thing, because it keeps
you from sidestepping the normal deployment procedure.  I bit the bullet and
spent sixty seconds writing a new `Makefile.PL`, using ExtUtils::MakeMaker.  I
re-deployed, it picked up Rubric 0.148, with the bugfix, and now adding users
worked.  Awesome!

If you want to see it, [my deployment
repository](https://github.com/rjbs/rubric/tree/stackato) is on GitHub.  The
head as of this posting was 5227cbb0.

There was one other problem I hit.  At one point, deployment failed halfway
through because of the *loathsome live tests for WWW::Mechanize*.  Sure, they
are optional:  you can supply a `--no-live` switch when configuring it -- but
you have no access to that when deploying with `cpanm`.  I suggested that
Stackato could use CPAN.pm, and ship with ActiveState-managed distroprefs to
deal with just this sort of problem.  I want *most* tests to run, but not tests
that are so fickle.

So, if I wanted to use Stackato, what would my deployment strategy be?
ActiveState doesn't seem to be planning to run their own public cloud.  You'll
have to have your own hardware running Stackato VMs, or maybe you'll be able to
rent them from a cloud provider.  How will this be billed?  What is ActiveState
actually going to *sell* to make money?  **I don't know, and for now, I don't
care.**  I'm in no position to actually move our work applications to this, so
I am content to sit back and relax and see what happens.  Maybe in a year, when
Stackato is a more mature, released product, it will all be clear and I'll even
consider whether we'd like using it for real work.  Until then, what I can say
is that it was a fairly painless experience, and made me see how much utility a
PaaS system can provide.

