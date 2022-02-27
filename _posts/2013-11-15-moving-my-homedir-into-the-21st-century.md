---
layout: post
title : moving my homedir into the 21st century
date  : 2013-11-15T04:26:11Z

---
Over the last few weeks, I've done a bit of pair programming across the
Internet, which I haven't done in years.  It was great!  Most of this was with
Ingy döt Net and Frew Schmidt.

As is often the case, the value wasn't only in the work we did, but in the
exchange of ideas while doing it.  I got to see both Ingy and Frew using their
tools, and it made me want to steal from them.  It also helped me get a handle
on what things I *didn't* want to change in my own setup, and why.  It's
definitely something I'd like to do more often.

Both Ingy and Frew were using [`tmux`](http://tmux.sourceforge.net/), the
terminal multiplexer.  `tmux` is a lot like GNU `screen`, which I've been using
for at least fifteen years.  If you're not using either one, and you use a
unix, you really ought to start!  They help me get a lot of my work
parallelized and simplified.  I first learned of `tmux` a few years ago when
I learned that several members of the Moose core dev team has started using it
instead of `screen`.  I tried to switch at the time, but it didn't work out.
It crashed too much, its Solaris support seemed spotty, and basically it got in
my way.  Now, inspired by looking at what Ingy and Frew were doing, I felt like
trying again.  I sat down and read most of [the `tmux`
book](http://pragprog.com/book/bhtmux/tmux) and was convinced in theory.
Although I don't like every difference between `screen` and `tmux`, there were
clear benefits.

Then I got to work actually switching, which meant producing a tolerable
[`.tmux.conf`](https://github.com/rjbs/rjbs-dots/blob/master/.tmux.conf).  I
started with the one I'd made years before and slowly added to it as I read
more about `tmux`'s features.  It's clear that I've got more improvements to
make, but they're going to require a few months of using my current config to
figure things out.

When I paired with Ingy, we used
[PairUp](https://github.com/ingydotnet/pairup), his instant pairing
environment.  Basically, you provision a Debian-like VM using whatever system
you want (we were using RackSpace, but I tried it with EC2, also) and, with one
command, create a useful environment for pairing in a shared `tmux` session.
We didn't actually work *on* anything.  Intead, he showed me PairUp and we
encountered enough foibles along the way that we got to pair on fixing up the
pairing environment.  It was fun.

I saw a lot of the tools he was using, as we went, and one of them was his
dotfile manager.  I've seen a lot of dotfile managers, although I've never
really switched to using one.  Instead, I was using a fairly gross hack of my
own, using GNU `make` to install my dotfiles.  The tool that Ingy was using,
[`...`](https://github.com/ingydotnet/...) was interesting enough to get me to
switch.  I've converted almost all of my config repositories to using it, and I
feel good about this.

`...` isn't a huge magic change in how to look at config files, and that's why
I like it.  It's also not just "your dotfiles in a repo."  It's got two bits
that make it very cool.

First, it is configured with a *list* of repositories containing your
configuration:

    dots:
    - repo: git@github.com:sharpsaw/loop-dots.git
    - repo: git@github.com:rjbs/rjbs-dots.git
    - repo: git@github.com:rjbs/rjbs-osx-dots.git
    - repo: git@github.com:rjbs/vim-dots.git
    - repo: rjbs@....:git/rjbs-private-dots.git

Each one of these repositories is kept in sync in `~/.../src`, and the files in
them are symlinked into your home directory.  Any file in the first repo takes
precedence over files in later repositories, so you can establish canonical
behaviors early and add specialized ones later.

The second interesting bit is provided by the `loop-dots` repository above.  It
sets up a number of config files (like `.zshrc` and `.vimrc` to name just two)
that loop over the rest of the dots repositories, sourcing subsidiary files.
So there's a global `.zshrc`, but almost the only thing it does is load the
`.zshrc` files of other repositories.  This makes it very simple to divide up
your config files into roles.  I can have a `rjbs-private-dots` that just adds
on my "secret data" to my normal dot files.  At work, I'll have an
`rjbs-work-dots` that sets up variables needed there.

Finally, there's another key benefit:  each repository is basically just a
bunch of dot files in a repo, even though `...` is more than that.  If I ever
decide that `...` is nuts, bailing out of using it is very simple.  I don't
need to convert lots of things out of it, I just need to replace the `...`
program with, say, `cp.`

I'm only about a week into this big set of updates, but so far I think it's
going well.  Of course, time will tell.  I haven't yet updated my Linode box,
where I do quite a lot of my work, to use my `...` config.  Tomorrow…

