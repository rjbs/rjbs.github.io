---
layout: post
title : mail audit deconstruction
date  : 2007-03-06T16:39:04Z
tags  : ["email", "perl", "programming"]
---
Despite the fact that it is mostly superseded by Email::Filter, Mail::Audit is still used by a bunch of people, included $WORK.  To aid my sanity in maintaining it, I've begun splitting off some of its plugins, especially those with extra prerequisites.  The latest Mail-Audit removes Mail::Audit::List and Mail::Audit::PGP and Mail::Audit::Razor to their own dists.

In the future, I may poke at them, but I think it's more likely that I will give them to interested parties.  The only agenda I'd have with them woudl involve writing a better plugin mechanism than "define subs into Mail::Audit," but I think I'll save that work for Email::Filter, or my own still-vaporware email filtering framework. 
