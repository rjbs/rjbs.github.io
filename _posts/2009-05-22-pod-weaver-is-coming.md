---
layout: post
title : pod::weaver is coming
date  : 2009-05-22T23:19:30Z
tags  : ["perl", "pod", "programming"]
---
Oh.  Actually, [Pod::Weaver](http://search.cpan.org/dist/Pod-Weaver/) is
already on the CPAN.  It's just not all that useful yet.  I had been using it
as part of [Dist::Zilla](http://search.cpan.org/dist/Dist-Zilla/) for a while,
but it needed more work to be useful for my applications.  Some of it was
design work and some of it was implementation work, and rather than sort it all
out, I took my early, crappy proof of concept work and released it as its own
thing, [PodPurler](http://search.cpan.org/dist/Dist-Zilla-Plugin-PodPurler/).
It wasn't extensible, tested, or... well, it wasn't very good.  It just
happened to do what I needed.

Thankfully, it's time for me to get back to work on Pod::Weaver.  [The Perl
Foundation](http://news.perlfoundation.org/) has funded a grant for the
completion of a good bit of work related to Pod::Weaver and related tools, and
I'm hoping to get lots of improvements done.  Before the end of summer, I'm
hoping to have most or all of my original vision for Pod::Weaver completed.

I figured this might be a good time to play around some more with [GitHub
Pages](http://pages.github.com/) so I've made a `gh-pages` branch in my project
and thrown up the original proposal as well as the [planned
deliverables](http://rjbs.github.com/pod-weaver/) on it.  I'll try to keep them
updated as I go.

The first step is going to be pretty boring: although I've been using
[Pod::Eventual](http://search.cpan.org/dist/Pod-Eventual/) plenty since putting
Weaver on the back burner, Weaver and its underlying POD-handling code,
[Pod::Elemental](http://search.cpan.org/dist/Pod-Elemental/) haven't seen me
around much.  I'm going to need to refresh my memory on exactly how they work,
how they should work, and the order in which I'll need to tackle problems.

Wish me luck!

