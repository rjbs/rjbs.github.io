---
layout: post
title : "dzil new - using Dist::Zilla to start new dists"
date  : "2010-05-04T03:51:02Z"
tags  : ["distzilla", "perl", "programming"]
---
I'm very pleased to report that the last to-do item from my 2010Q1 Perl Foundation grant to improve Dist::Zilla is complete.  That item was an improved `dzil new` command, described like this:

> event structure for distribution creation
> 
> In other words, plugins will be able to attach more behavior to distribution
> creation, to create new source code repositories, start files, and so on.

If you already use Dist::Zilla, you know how this should work:  more roles for plugins to consume!  The "make a new dist" method looks something like this:

    $_->before_mint  for $self->plugins_with(-BeforeMint)->flatten;
    $_->gather_files for $self->plugins_with(-FileGatherer)->flatten;

    for my $module (@modules) {
      $module->{minter_name} ||= ':DefaultModuleMaker';
      my $minter = $self->plugin_named($module->{minter_name});
      $minter->make_module({ name => $module->{name} })
    }

    $_->prune_files  for $self->plugins_with(-FilePruner)->flatten;
    $_->munge_files  for $self->plugins_with(-FileMunger)->flatten;

    # ... code to write files to disk, etc ...

    $_->after_mint({ mint_root => $dir })
      for $self->plugins_with(-AfterMint)->flatten;

You can configure as many different sets of plugins as you like and drop them in `~/.dzil/profiles` so that you can create dists with different build types. Later, we'll make it possible to add new content to an existing dist.  For now, we have enough new behavior to reasonable use `dzil new` for new work, and we have enough plugin roles to implement VCS integration.  Here's what it looks like in action:

<center><a href="http://www.flickr.com/photos/rjbs/4576716361/" title="first run of the new, complete-ish `dzil new` by rjbs, on Flickr"><img src="http://farm4.static.flickr.com/3319/4576716361_3dd5a5f9ab.jpg" width="447" height="500" alt="first run of the new, complete-ish `dzil new`" /></a></center>

All of this is available in Dist-Zilla 2.101230, which I've just uploaded to the CPAN.
