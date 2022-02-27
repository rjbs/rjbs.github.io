---
layout: post
title : cpan testers who shouldn't
date  : 2005-12-17T17:15:13Z
tags  : ["cpan", "testing"]
---
The CPAN testers are, in general, a crew of kind-hearted people who perform a valuable service for module authors.  They run tests for all kinds of modules -- even ones that the tester just doesn't care about.  How else would we ever know that XML::Fudge::WithPeanuts doesn't work on OpenVMS/3.2-cray?

Really, though, they are a good bunch and should be applauded and given beer.

That said, every time somebody decides to submit automated test results from a system that doesn't give up if it can't meet a distribution's clearly declared prerequisites, God kills a kitten.

It is not that hard: if you don't meet the prereqs, either instal them or (more likely) give up.  Don't waste my time loading your report, just so I can see that all of Log::Dispatch::LogTable's tests failed because you don't have Log::Dispatch. 
