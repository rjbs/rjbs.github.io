---
layout: post
title : "common per-host colors"
date  : "2023-09-02T16:12:00Z"
tags  : ["programming"]
---

I found a note to myself that I should post about my per-host colors.  I don't
know whether it's of general interest to whoever reads this thing, but I guess
I thought that once, so here we go.

I work on a bunch of different hosts, from my laptop to my Raspberry Pis to
work systems, and others.  At work, hosts have different color prompts by
datacenter, and I thought this was a good way to remind myself where I was
running my commands.

First, I made a little shell program called `.sh/host-color`:

```sh
HOSTNAME=`hostname -s`
if [ -z "$HOSTNAME" ]; then
  RJBS_HOST_COLOR=247 # no hostname! dim unto death
elif [ "$HOSTNAME" = "dinah" ]; then
  RJBS_HOST_COLOR=141 # lovely lavendar
elif [ "$HOSTNAME" = "snowdrop" ]; then
  RJBS_HOST_COLOR=81  # an icey blue
elif [ "$HOSTNAME" = "snark" ]; then
  RJBS_HOST_COLOR=202 # orange you glad I picked this color?
elif [ "$HOSTNAME" = "wabe" ]; then
  RJBS_HOST_COLOR=66  # the color of moss on your sundial

# ... lots of options elided

elif [ -e "/etc/listbox-version" ]; then
  RJBS_HOST_COLOR=46  # any Listbox host, Listbox green
else
  RJBS_HOST_COLOR=201 # bright pink; where ARE we??
fi
```

Then it's easy to use that variable in a bunch of places to remind yourself of
context.  The most important for me are tmux config and shell prompt.  That
way, I can see when I've ssh'd into host A from a tmux on host B, like this:

![shell on wabe, and tmux on snowdrop](/assets/2023/09/tmux-and-shell-colors.png)

In my `.zshrc`:

```sh
export PS1="%{^[[1m%}%F{$RJBS_HOST_COLOR}%m%f:%~%(!.%F{red}#.%F{46}$)%f%{^[[0m%} "
```

In my `.tmux.conf`:

```
set -g status-right \
  " #[fg=colour238]#[bg=colour0]▛#[fg=colour$RJBS_HOST_COLOR] #h "
```

…and that's that!
