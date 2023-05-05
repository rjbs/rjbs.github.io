---
layout: post
title : "PTS 2023: more PAUSE work (3/5)"
date  : "2023-05-05T12:07:01Z"
tags  : ["perl", "programming"]
---

In past years, one of my big areas of work at PTS has been PAUSE.  If you're
not a CPAN wonk, here's a tiny explainer:  PAUSE is the Perl Author Upload
SErver.  It's where you go to upload new software to the CPAN, and to manage
the permissions on packages for which you're the administrator.  It's got a
number of interrelated pieces, but the two easiest units to describe are the
web interface and the indexer.

The web interface lets you log in, update your profile, manage permissions, and
some other things like that.  For the most part, the business logic and model
code is directly written into the web app, which has been a Mojolicious app
since 2017.  I barely know anything about the web app, although I did get a
test instance of it running with Docker, thanks to Kenichi Ishigaki's work this
year.

The indexer is the part I know well.  It looks at newly-uploaded archives and
decides whether they may be written to the index.  I can upload a new
version of ExtUtils::MakeMaker, but it won't show up in the index, which means
nobody will get it unless they specifically ask to get the file I uploaded.

The indexer works by inspecting the contents of the uploaded archive, looking
at the META.json file (or META.yml), examining the Perl source code files, and
looking at the CPAN module permissions database.  Conceptually, it's simple.
In practice, it's pretty complicated.  Part of this is because it wants to
statically analyze Perl source (good luck!) and part of this is that the
implementation is not very componentized.  Now, maybe what I should say is that
this means it's complicated *for me*.  I like breaking things into small
reusable pieces that I can test in isolation.  This is especially valuable for
me as somebody who came to this project when it was already at least ten years
old.

So, lots of my work on PAUSE goes in a cycle.  First, I see what I want to
improve or change, then I figure out what existing code I need to refactor to
make those changes easy enough for me to succeed at making them.

When I arrived this year, I thought the big changes I made would be related to
installing new instances, but as I wrote in my last entry, that work was mostly
already done when I got there!  I had some other things in mind that would be
worth working on, but I started by categorizing the [PAUSE issue
tracker](https://github.com/andk/pause/issues/).  I started with about 115 open
issues and went through the list, getting a sense for which were already done,
which ones were easy wins, and which ones formed big chunks of work to
consider.  Every once in a while, I leaned over to Matthew Horsfall and said,
"Hey, look at this one with me," but mostly he was sorting out a really nasty
deadlock and I tried to leave him be.

By the end of the process, I'd closed thirty issues or more as already fixed,
duplicates, or things we agreed to do.  The rest, I categorized like this:

* **Issues needing a decision from Andreas on how we would proceed**:  There
  were about a dozen, and the next day Andreas sat down with me and we made
  decisions.  Some we rejected, some we documented what we'd do.  Some of those
  got done, too!  As we made decisions, I removed the label, so sadly I can't
  link to the list.  Most of these were in the form, "I don't like the behavior
  of the indexer and think it should change."  About half the time Andreas
  agreed, and about half the time he didn't.
* **[Issues with permissions](https://github.com/andk/pause/issues?q=is%3Aissue+label%3Apermissions)**:  These were things like "sometimes when I upload
  a distribution, the permissions seem to get broken."  Some were like "it
  should be easier to do some common but tedious action."  Some were "it should
  be harder to do some easy but dangerous action."  I didn't end up touching
  many of these.  Kenichi Ishigaki dealt with a few.  I believe that a number
  of the weird bugs were related to an interaction of the database deadlock
  Matthew Horsfall was working on with a bit of code that ran outside of a
  database transaction instead of inside.
* **Issue with emails, indexing, and error reporting**:  I ended up spending my
  time on these, so I'll write more below!  (If you want to go look at these,
  they're labeled with
  *[indexer](https://github.com/andk/pause/issues?q=is%3Aissue+label%3Aindexer+)*
  and
  *[metadata](https://github.com/andk/pause/issues?q=is%3Aissue+label%3Ametadata)*
  and
  *[email](https://github.com/andk/pause/issues?q=is%3Aissue+label%3Aemail)*.)

## Email, indexing, and error reporting

First, I'll say that there were two bits of work in this bucket: a bunch of
little bug fixes and enhancements, and also one big pile of work related to
making fixing these kinds of things easier.  I'll write about the big pile in
another post.  For now, the little stuff.

I updated all the email code to [use Email::Sender to send
mail](https://github.com/andk/pause/pull/389).  Sometimes it used Mail::Send,
which is what it all used ten years ago.  This makes it just a little easier to
write automated tests that can see all the mail that would've been sent by
PAUSE.  I also tweaked some of Matthew Horsfall's work from a couple years ago,
making it easier to say "run tests and let them see all the mail they'd send,
but *also* save a copy to disk."  This is useful when I want to compare the
exact emails sent before and after patching PAUSE.  I can write a test that the
things I expect are there, but it's nice to check the exact emails, to avoid
surprise content (or blank space)!

There was an 18 year old hack to support some weird packaging in mod\_perl 1.
[I removed this without regret](https://github.com/andk/pause/pull/402).

I learned that there was a short list of files that you *can* replace after
uploading on PAUSE.  If you upload `Perfect-Project-1.234.tar.gz`, you can't
upload it again, even if you realize that you screwed up and included your
GitHub API token in the release.  You have to upload a new file and delete the
old one.  You can replace things like `README` or `documentation.pdf`, though.
I [made that code a little easier to
read](https://github.com/andk/pause/pull/393), in furtherance of allowing
Markdown files.  I mostly did this because I stumbled across the code when
talking about the "CPAN index for ancient version of Perl" idea.

I nudged Andreas to upgrade the SSL bindings on PAUSE, meaning we *should* stop
seeing PAUSE fail to retrieve files from URLs at stricter hosts.

I finally flipped the switch on a years-old decision: [all distributions must
have a META file](https://github.com/andk/pause/pull/401) (JSON or YAML) to be
indexed.  It isn't carefully validated yet, but that will come next.  Last
year, only about a half of a percent of all uploads were missing a META file.
Looking into the thirteen distributions, most of them appeared to have made a
mistake in their MANIFEST.  (Once again, MANIFEST causes hassle!)

## Module::Faker changes

That last change to PAUSE, requiring a META file, broke a bunch of tests.  That
didn't mean the code was broken.  It exposed that some of the early tests
were written such that they indexed tarballs stored in the repository, built by
hand, with the minimum set of files to make the test go.  They needed
rebuilding.

I converted those to use Module::Faker directly.  I [wrote about Module::Faker
after last PTS]({% post_url 2019-04-30-pts-2019-module-faker-3-5 %}), when I
added the ability to specify what the faked-up distribution should look like.
I was easy to handle removing the META file, but some of the distributions
needed weirder changes, like bogus version declarations.

I made a new 0.025 release of Module::Faker that includes more options for how
to build a fake distribution with weird properties.  Some aren't so weird.
You can now build a `perlclass`-style package for testing, like this:

```perl
class iSnack 2.0 {
  ...
}
```

All this is still a bit underdocumented.  I should fix that, but I'm a bit
nervous about committing to the interface I've provided.  Still, it's very
useful to have it coded, and I used it to simplify a lot of the code!
