---
layout: post
title : "fixing rubric's cli"
date  : "2006-01-27T04:30:56Z"
tags  : ["perl", "programming", "rubric"]
---
Rubric has had a CLI since forever.  It has basically been a bunch of crappy little scripts that did one or two things each, badly, with lousy command line processing.  I really want to fix this, since one of the biggest complaints I get is that it's too hard for muggles to install Rubric.  I'd like to eliminate any need for people who have no clue to ask for help installing things.

Beyond that, I'd like to have a command useful enough to install in the path to take care of any Rubric needs, from installing a new Rubric to managing users, to exporting datasets to a flatfile, to performing database management.

I'm not using all my favorite tools, because some of them aren't on the CPAN yet.  We have a little CLI toolkit at work that I'd really like to make into its own distribution and rely on.  It does a little bit of this and a little bit of that, and just makes script-writing easier.  I am using Dieter's killer Getopt::Long::Descriptive, which is nice.  I'd like to make rubric(1) act something like svk(1), which is what I had in mind when I started writing Rubric::CLI.  A bit later that evening, I saw that SVK uses App::CLI, which looks like it was split off from SVK.  Unfortunately it's underdocumented, and I'd rather not lose momentum to figure it out.  I'll either get Rubric::CLI up to its level, or refactor later.

I fixed a bug or two, and I'm starting to feel like I'm getting somewhere.

So far, though, no real progress on the official Rubric Gallery setup.  I need to JFDI. 
