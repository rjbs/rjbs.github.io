---
layout: post
title : "new minicpan trial release"
date  : "2011-04-26T13:06:34Z"
tags  : ["cpan", "perl", "programming"]
---
Part of [my work at the QA Hackathon]({% post_url 2011-04-21-the-2011-perl-qa-hackathon-in-amsterdam %}) led to making it quite a lot easier to test [minicpan](http://search.cpan.org/dist/CPAN-Mini).  I'm pretty happy with that, and got to work writing tests.  Once I had the basic "mirroring works" tests written, I wanted to have a quick look at testing logging.  Unfortunately, it turned out that logging was a big mess.

The log level was determined by three pseudo-boolean flags: errors, trace, and quiet.  Their interaction was not well-explained, and I say *pseudo*-boolean because trace, at least, had three different behaviors: set to true, set to false, or unset.  It was a big mess, and to emulate CPAN::Mini's behavior, subclasses would have to look at the object guts.  Ugh.

I rewrote the logging methods and tried to keep them very simple, but it may be that somebody who was copying code from CPAN::Mini in a subclass has now got broken code.  The basic changes are:

* the `trace` method is now deprecated in favor of `log` and `log_debug` and `log_warn`
* the `trace` config file option is now `log_level`, which can be debug, info, warn, or fatal
* the object's internal hashref entries (always off limits) for the old settings are gone

I also wrote my first batch of tests for processing config files and command line options.  This exposed a few minor bugs, and I look forward to writing more, and then updating the documentation to finally explain how it all works. I also wouldn't mind refactoring the goofy current initialization implementation.  It's not pretty.

Anyway, I expect that the new trial release of CPAN::Mini, v1.111004, will not cause anybody any serious problems, but I'll give it a few days before I promote it to a stable release.
