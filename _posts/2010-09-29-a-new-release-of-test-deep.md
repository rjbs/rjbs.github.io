---
layout: post
title : "a new release of Test::Deep"
date  : "2010-09-29T12:33:37Z"
tags  : ["perl", "programming"]
---
Fergal Daly wrote one of the most fantastically useful testing modules on the  CPAN, [Test::Deep](http://search.cpan.org/dist/Test-Deep/).  If you don't use it, you really should.  It's very powerful and very easy to use.  Fergal  has decided that he can no longer promise enough time to Test::Deep  maintenance, and I'm pleased to report that I have accepted responsibility.

I will work slowly through the RT queue, applying a few patches, making a  release, and waiting for feedback.  Test::Deep is quite heavily used, and I  don't want to cause a catastrophe.

I do not yet have any serious plans to change anything about Test::Deep,  although I am considering making it use Sub::Exporter, which could address a  number of the bugs related to its large set of default exports.

I uploaded version 0.107 this morning, which includes some small fixes.  The  most important of these is a fix to pass tests under the latest blead builds of perl 5.13.
