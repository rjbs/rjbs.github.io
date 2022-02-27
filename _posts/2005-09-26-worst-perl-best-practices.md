---
layout: post
title : "worst perl best practices"
date  : "2005-09-26T17:25:55Z"
tags  : ["cpan", "perl", "programming"]
---
There are a few things I disagree with in PBP, but I'm just going to name the one that is current causing me the most inconvenience because I can't just ignore the rule.

Damian says, "use three-part version numbers."

No.  Do not do this, at least not if you're going to use version.pm.

Because Damian is using "qv(0.99.2)" and the like, the CPAN indexer considers the version number in IO/Prompt.pm to be undef, so it is not newer than the one that had "$VERSION = '0.02'" and so the new version isn't installed when I run "cpanp install IO::Prompt"

Maybe the indexer should be fixed, but in the meantime, do not do what Damian does. 
