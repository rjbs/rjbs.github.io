---
layout: post
title : logging changes in Dist::Zilla are maybe complete
date  : 2010-03-10T04:52:13Z
tags  : ["distzilla", "perl", "programming"]
---
The last 24 hours or so have been really busy.  Today was Martha's third
birthday (wow, can you believe it?) and I've had a number of incredibly
annoying bugs at work.  I won't get into the details right now but one of them
was an MSIE bug that I solved by `\uXXXX`-only double-JSON-encoding a
structure.  The other was fixed by disabling Etag headers.  Blaaaagh!

Despite this, I found some time for working on Dist::Zilla improvements.  I did
a pretty significant amount of work, actually, but if I paste the results, it
will not look very impressive:

    [DZ] beginning to build Dist-Zilla
    [DZ] guessing dist's main_module is lib/Dist/Zilla.pm
    [DZ] extracting distribution abstract from lib/Dist/Zilla.pm
    [@RJBS/Classic/ExtraTests] rewriting release test xt/release/pod-coverage.t
    [@RJBS/Classic/ExtraTests] rewriting release test xt/release/pod-syntax.t
    [@RJBS/PodWeaver] [@Default/Name] couldn't find abstract in lib/Dist/Zilla/Tester.pm
    [@RJBS/PodWeaver] [@Default/Name] couldn't find abstract in lib/Dist/Zilla/App/Tester.pm
    [DZ] writing Dist-Zilla in Dist-Zilla-1.100680
    [DZ] writing archive to Dist-Zilla-1.100680.tar.gz

The change, here, is that Pod::Weaver's plugins can now log as a "second order"
set of plugin data.  This sort of worked, in theory, with previous
implementations of logging, but it's much simpler now.  I've ripped out a lot
of the logging code from Dist::Zilla, eliminating the illusion that you could
use something other than Log::Dispatchouli to replace its logging.  At the same
time, I refactored some of Log::Dispatchouli's methods to make it more
flexible, but not (I hope!) more complex.  I don't think much will come of it,
beyond what I've just shown above, but it's still useful.  It will also let me
easily do something like this:

    $self->log_debug(
      { prefix => $self->prefix_wrap },
      $multi_line_log,
    );

...to produce...

    [PluginName] <<< This is a multi-line
    [PluginName] ||| log entry that will be
    [PluginName] ||| marked with some sort
    [PluginName] >>> of log-item grouper.

The real win here is "less code."  I had to copy and paste a five or six line
hunk of code around a few times, and I think that will get refactored later.
Still, things are very simple, now, and it will make testing the logging of
plugins very easy.

Next up: actual testing.

I hit one stumbling block with my previous attempt to make it possible to build
a dist found in another directory.  Because of the way things worked, I ended
up getting dist tarballs with contents like
~/User/rjbs/code/cs/Whatever/lib/...` instead of `Whatever-1.234/lib/...`.  I
fixed this by reverting the directory absolutizing.  I'll either have to do a
more comprehensive survey and fix of the code or I'll just more aggressively
add localized chdirs.  That's fine, too.

So, next up: I start to really test things.  First up, I'll make the existing
`dz1.t` and `dz2.t` tests actually test things.  After that, it will be time to
start testing each plugin.  That should be... well, awful.  It will be nice to
have the tests, though!

