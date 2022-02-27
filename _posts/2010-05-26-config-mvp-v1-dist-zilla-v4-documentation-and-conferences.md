---
layout: post
title : "Config::MVP v1, Dist::Zilla v4, documentation, and conferences"
date  : "2010-05-26T03:34:08Z"
tags  : ["distzilla", "perl", "programming"]
---
[YAPC](http://yapc2010.com/) is only about three weeks away, and I have a lot
of work to do on my presentation material.  I'm giving three presentations: one
on Perl 5.12, one on Git, and one on Dist::Zilla.  The Dist::Zilla talk will
also be presented at [OSCON](http://www.oscon.com/).  I've been working
feverishly to get prepared for those talks, but not by writing presentation
material.

Instead, I've been working on Dist::Zilla itself.  I want to make a lot of
improvements to `dzil new` before I give the presentation, and that means
finishing a lot of long-standing work on the internal configuration system.
Once that refactoring is done, I can add a proper interface to "global
configuration" for config shared between projects.  Then there will still be
lots more room to improve the config system, but more importantly I can make
`dzil new` really easy to use.

Getting these changes into Dist::Zilla (which will be Dist::Zilla v4 when this
set of changes is landed) has been a significant amount of work, not just to
Dist::Zilla but also to Config::MVP, its external configuration loading system.
I'm very happy with the last few changesets, which introduced finalization,
temporary references back up from sections to sequences to assemblers, and an
overhauled API for writing configuration readers.

Because of these changes, the `global-config` branch of Dist::Zilla has
replaced a bunch of ugly code with much saner and simpler code.  It also can
register each plugin as its configuration section is read, rather than loading
all config, then registering all plugins.  The next step is to have non-Plugin
configuration entries, primarily for storing data only.  A section, for
example, could store your PAUSE credentials.  You might store them in a global
(to your user) file in `~/.dzil`, but override that section on a per-project
basis in `dist.ini` in your dist.

Unfortunately, all these changes have made documentation wrong.  When I have
noticed the incorrect documentation (and I think I've noticed just about all of
it as I worked), I deleted it.  So, now there's less documentation of
Config::MVP again.  Fortunately, I'll have plenty of time to redocument it when
I'm preparing a presentation on Dist::Zilla!  My current plan, though it may
change, is to use most of my "free time" at YAPC and OSCON writing docs rather
than code.  We'll see how that goes.

At any rate, I'm very happy with the progress toward an improved global
configuration system, especially because I know the milestones that will appear
next.

