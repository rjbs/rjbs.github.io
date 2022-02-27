---
layout: post
title : "getting re-rolling on pod work"
date  : "2009-08-09T02:01:37Z"
tags  : ["perl", "pod", "programming"]
---
This has been a good week for me to take things that look to big and break them
into smaller, attainable goals.  I did it for some work projects, and I think
it's helping me feel like I can start making more progress.  It also led to a
huge update to [Path::Resolver](http://search.cpan.org/dist/Path-Resolver/),
including much-needed documentation.

Now I'm doing the same the same thing with some personal projects, both code
and otherwise.  I'm tired of feeling boxed in by huge projects that really just
need a lot of small steps taken.

My initial list of goals was:

* a clear distinction laid out for ::Nester v. ::Document
* extensive tests for Pod::Elemental, and Document implemented
* Pod::Weaver operating on Document objects
* the "Allow" Weaver, which leaves specific stuff in place, if found
* the "Accordion" Weaver, which leaves generic stuff in place, if found
* Pod::Weaver::Config, for loading Pod::Weaver config from files

...with some optional stuff I'd like to get done.

The first one I did already, pretty early on.  I also realize that I did the
final one during OSCON by producing
[Config::MVP](http://search.cpan.org/dist/Config-MVP), which makes the
Dist::Zilla configuration generic enough for anyone to use.  (Maybe I should
add more documentation, though.)

So, what's left?  Tests, "operating," and two specific weavers.  Tests are sort
of uninteresting.  They'll happen.  The specific weavers are also sort of
obvious.  Those two, especially, are very hand-wavey.  Everything interesting
comes down to "Pod::Weaver should work."

What a stupid goal!  What was I thinking?

Tomorrow, I will start sketching out the specifics of what that means, how
Pod::Weaver will be used, and how I will get it into an operational state.

