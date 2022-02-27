---
layout: post
title : "playing with ppi and perl critic"
date  : "2006-11-10T15:36:43Z"
tags  : ["perl", "programming"]
---
I've heard a lot about Perl::Critic, and it has always sounded neat.  Chris
Dolan gave a talk about it at YAPC, and I decided I should give it a go.  I
didn't get around to it until this week.  I went through and installed a
perl-critic.t in all my distributions, then started testing them.  Nearly all
the violations it found were in a few groups.

"Don't use stringy eval!"  Ok, but I'm trying to load a module by name, and I
don't want to use UNIVERSAL::require.  I need to use stringy eval!

"Don't put any code before `use strict`!"  Ok, that's reasonable.  I'll just
move `use strict` to the very top of every file.  "Now don't put any code
before the package declaration!"  What?  No, it doesn't matter!  It's lexical
to the file!

The other things it caught were pretty reasonable, and I fixed them.  I just
didn't like the idea of putting `no critic` comments at places where I wanted
to keep my code the same.  When I looked at the code for policies, I was
surprised at how simple it was.  PPI exposes a really reasonable DOM, and I was
able to code lots of fiddly little policy tweaks for my own use.

I have a few more policies I want to write, but so far I'm pretty happy with
Perl::Critic and my own attempts to train its taste.

