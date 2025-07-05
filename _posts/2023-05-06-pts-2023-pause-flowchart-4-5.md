---
layout: post
title : "PTS 2023: refactoring the PAUSE indexer flowchart (4/5)"
date  : "2023-05-06T16:07:01Z"
tags  : ["perl", "programming"]
---

## Email, indexing, and error reporting

Yesterday I said that in addition to a bunch of little work, I worked on one
big change.  That was true!  It was still one thing all around email, indexing,
and error reporting.  These three were closely related, because the code is so
intertwined.  Here's an example:

In newer perls, you write a package statement in one of these two ways:

```perl
package Code::Reusable 1.234;

sub something_in_package { ... }

##
## …or…
##

package Reusable::Code 1.234 {
  sub something_in_package { ... }
}
```

Here, the versions must be "strict", meaning you can either write a simple
rational decimal number or a v-string like `v1.2.3`.  There are a few more
rules in practice, but those are the rules.  In very old perls (below the
toolchain minimum version), you had to assign to the package variable
`$VERSION` by hand, like this:

```perl
package Code::Retired;
our $VERSION = '1.234';
```

Notice that the rvalue above is a string literal?  You're meant to set the
version to a string, although really the whole thing is a muddle.  The muddle
has consequences, though, because a simple Perl assignment means you could
write this:

```perl
package Code::Rebuffed;
our $VERSION = 1.234;
```

Why should this matter?  Well, it shouldn't, and it doesn't, except what if you
use a much smaller number, like `0.000001`?  *That* matters.  See, in
processing version strings, PAUSE will `eval` them (safely) to convert them
into strings.  The numeric literal `1.234`, evaluated, will later stringify to
1.234.  Perfect!

The numeric literal `0.000001` will, on the other hand, stringify to `1e-06`,
which is not a valid version.  The indexer chokes and basically reports
nothing.

So, how do we fix this?  We could try to notice that the value was a numeric
literal and enquote it, but this is no good, some version assignment
expressions are too complicated.  (Would I like to stop indexing anything
using old-style version assignment?  Yes, but I know it's a total nonstarter.)

Instead, we could make this a clear indexer error.  If we see that the version
assignment's rvalue won't be a valid version, we could decline to index the
package and report it to the user.  In fact, we *already do that*… for certain
other kinds of bad version.  In the place we could detect this, though, it
wasn't trivial to say "this package failed, report this reason, and now proceed
to the next package."

<a href="https://www.flickr.com/photos/rjbs/52869038908/in/dateposted/" title="how the PAUSE indexer works"><img src="https://live.staticflickr.com/65535/52869038908_a2106ab1dd_z.jpg" alt="how the PAUSE indexer works"/></a>

I've encountered this problem a bunch of times when working on the indexer.
Generally, my approach has been to figure out how to best cram something in
place.  This time, I decided to finally enact my longstanding plan of making it
easier to do exactly what I said: at any point during indexing, to be able to
say:

* mark the current part of the operation as failed
* either proceed to the next part of the operation, or stop entirely

I did this by introducing a new object, the context object, to the indexer.
One is created whenever we index a new distribution (file), and it's passed
down the call stack to each part of indexing.  Really, the distribution object
could've performed this job, but I was trying to tease things apart, and making
a new object seemed like it would help keep the old and new code separate.

The context object keeps track of what warnings or errors have occurred, and
has methods to add new warnings or raise new errors.  As you might guess from
the word "raise", errors are generally treated like exceptions.  Indexing works
something like this:

```
given a file:
    if it doesn't look like a distribution: quietly give up

    extract archive
    check for acceptability of archive (extracts cleanly, no blib dir)
    look for a META.json or META.yml file
    check for acceptability of META file (not a dev release, etc.)

    for each .pm file:
        figure out its $VERSION
        find all the packages in the file
        check permissions
        plan to index the package

    send an email report
```

Only a few of these steps could effectively abort indexing, and only a few
parts of the "for each .pm file" loop could skip the file early.  I wrapped the
overall code in try/catch block, and the body of the foreach block in another.
They catch exceptions of the type `Abort::Dist` and `Abort::Package`.  Then,
all the code that indicated "skip when you can" or "this error might be useful
to show later" got converted into exceptions.  In no case does this seem to
have led to a reduction of quality of error messages, but I think it has made
the code a lot cleaner.  I also think it means that adding new kinds of errors
should now be much simpler.  Any piece of code can now throw the right kind of
exception and it'll end up usefully in the email.

To keep providing helpful error messages, I named all the errors we throw.
Previously, some (but not all) errors worked by setting a property on the
distribution object to a named constant.  That constant was then associated
with a header string, so `EBADVERSION` would lead to "The package version was
malformed or invalid."  I didn't lead to further text, though, so at some
places throughout PAUSE, a long-form description was inline with the error
handling code.  For example, this error exists:

```perl
dist_error multiroot => {
  header  => 'archive has multiple roots',
  body    => sub {
    my ($dist) = @_;
    return <<"EOF"
The distribution does not unpack into a single directory and is therefore not
being indexed. Hint: try 'make dist' or 'Build dist'. (The directory entries
found were: @{$dist->{HAS_MULTIPLE_ROOT}})
EOF
  },
};
```

To throw that error, a bit of code calls this:

```perl
$ctx->abort_indexing_dist(DISTERROR('multiroot'));
```

No further error handling is needed there, because it throws an exception that
gets caught upstream.

This work is all [ready and waiting to be reviewed and
merged](https://github.com/andk/pause/pull/405)!

Unsurprisingly, doing this refactoring exposed a few bugs in PAUSE.  It has
probably introduced some new ones, but hopefully they'll be easy to fix when
found!

I look forward to getting this finished and merged.  I have one last thing I'd
like to do before I stop thinking about PAUSE for a while, and I would like to
keep up a head of steam.
