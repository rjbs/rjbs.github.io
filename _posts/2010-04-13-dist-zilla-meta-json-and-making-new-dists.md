---
layout: post
title : Dist::Zilla, META.json, and making new dists
date  : 2010-04-13T02:40:11Z
tags  : ["distzilla", "perl", "programming"]
---
This weekend, David Golden and I holed up in the Pobox offices and worked on
the final draft for v2 of the CPAN Meta specification.  It's the document that
describes what goes in META.yml -- or, now, META.json.  This was not very
exciting to many people, but we were both really excited to get it done, and
hopefully the final v2 spec and support libraries will be out in a few days.

There's a big benefit for Dist::Zilla here.  One of the things we produced is a
class that handles organized sets of prerequisites.  For example, it can track
the modules needed to configure before installation, the modules recommended to
improve your testing, and the modules required to use the code.  These sets can
be merged, inspected, and marked as "closed for new changes."

Dist::Zilla::Prereq already does some of this, but not very well, apart from
the central bit built atop Version::Requirements.  The new library is very
similar in purpose, but much more useful.  It will replace the guts of
Dist::Zilla::Prereq, greatly improving the usability of the prereq system.

In other good news for Dist::Zilla, I've made some good conceptual progress on
a few things after some talk with David.  For one, `dzil new` should be getting
some real improvements soon.  David wrote yet another "new distribution
starter" tool some time ago, and I thought it had a number of really nice
features.  I talked over my problems with writing a new engine for `dzil new`
and we ended up with a plan that I think I like.

We also talked about how to improve MakeMaker and ModuleBuild by allowing
arbitrary hunks of code to be added to the output.  This is something I've
wanted to do for a while, and I think it will really improve those plugins
without requiring users to write custom templates.  We talked about a few
strategies for doing this, and I'm going to ask for some more input from the
mailing list tomorrow or so.

For now, though, I'm really tired.  Tomorrow, I'm back at the office, but this
time to start churning out some more code for work.  I need to be bright-eyed,
bushy-tailed, and sharp-witted, so I think that right now I'll go crash.

