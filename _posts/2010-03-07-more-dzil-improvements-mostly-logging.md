---
layout: post
title : more dzil improvements; mostly logging
date  : 2010-03-07T14:22:12Z
tags  : ["distzilla", "perl", "programming"]
---
I've been continuing to work on adding improved logging capabilities to
Dist::Zilla.  They're not going to be terribly complex, but I'm trying to make
sure that they're easy to use, and that they lend themselves to sane default
output and useful debugging output.  Yesterday, I realized that these lines
were really annoying:

    [DZ] Dist::Zilla::PluginBundle::RJBS/Dist::Zilla::PluginBundle::Git/Dist::Zilla::Plugin::Git::Push initialized

I went through and fixed all the bundles I could to produce simpler (but still
useful) names and then used each plugin's logger for logging initialization.
The result is now more like this:

    [@RJBS/@Git/Push] online, Dist::Zilla::Plugin::Git::Push v1.234567

That's also been demoted to debug output, so there's much less noise by
default.  Releasing Dist::Zilla this morning looked like this:

    ~/code/cs/Dist-Zilla$ dzil release
    reading configuration using Dist::Zilla::Config::Finder
    [DZ] beginning to build Dist-Zilla
    [DZ] guessing dist's main_module is lib/Dist/Zilla.pm
    [DZ] extracting distribution abstract from lib/Dist/Zilla.pm
    [@RJBS/Classic/ExtraTests] rewriting release test xt/release/pod-coverage.t
    [@RJBS/Classic/ExtraTests] rewriting release test xt/release/pod-syntax.t
    [DZ] writing Dist-Zilla in Dist-Zilla-1.100660
    [DZ] writing archive to Dist-Zilla-1.100660.tar.gz
    [@RJBS/@Git/Check] branch master is in a clean state
    [@RJBS/Classic/UploadToCPAN] registering upload with PAUSE web server
    [@RJBS/Classic/UploadToCPAN] POSTing upload for Dist-Zilla-1.100660.tar.gz
    [@RJBS/Classic/UploadToCPAN] PAUSE add message sent ok [200]

Not bad!

I also made some improvements to Pod::Weaver and the PodWeaver plugin so that
it can log its work as it goes.  This will produce output like:

    [@RJBS/PodWeaver] [Name] added name/abstract section to lib/Dist/Zilla.pm

I'm starting to wonder if Dist::Zilla isn't the project where I'll end up
wanting more fine-grained control than "normal logging" or "debugging logging,"
but I think things will go as this issue always has:  I'll put it off until
everything else is done and then realize I don't care about it.

