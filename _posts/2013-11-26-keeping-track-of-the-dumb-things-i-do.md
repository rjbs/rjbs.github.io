---
layout: post
title : keeping track of the (dumb) things I do
date  : 2013-11-26T03:39:31Z
tags  : ["productivity", "programming"]
---
Last week, I was thinking about how sometimes I do something I have to do and
then feel great, and sometimes I do something I have to do and then feel lousy.
I decided I should keep track of what I do and how it makes me feel.  (I have
some dark predictions, but am trying to hold off until I have more recorded.)
To do this, I needed a way to record the facts, and it needed to be really,
really easy to use.  I'd never take the time to say "I did something" if it was
a hassle.

I decided I wanted to run commands something like this:

      rjbs:~$ did some code review on DZ patches :)

So, I did some code review and it made me happy.  Then I thought of some
embellishments:

      rjbs:~$ did some code review on DZ patches :) +code ~45m ++

I spent about 45 minutes doing it, it was code, and this was an improvement to
my mood from when I started.  There's a problem, though: `:)` isn't valid
shell.  I solved this by making `did` with no arguments read from standard
input.  I also renamed `did` to `D`.  I also think I might make it accept
emoji, so I could run:

      rjbs:~$ D haggled with mortgage provider 😠 +money

Later, I'll write something to build a blog post template from a week's work,
maybe.  I'm still not sure whether I'll keep using this.  I need to get into
the habit, and I'm not sure how, although connecting it to Ywar might help.

Anyway, the code is a real mess right now, and it kind of stinks, but [D is on
GitHub](https://github.com/rjbs/rjbs-dots/blob/master/bin/D) in case it's of
interest to anyone.

