---
layout: post
title : "The Slack IRC gateway drops your messages."
date  : "2017-01-24T01:42:40Z"
tags  : ["perl", "programming", "slack"]
---
So, imagine the following exchange in private message with one of your team
members:

```
<alice> So, how have I been doing?
<bob> Frankly, I don't think it's working out.
* bob is joking!  You're doing great.
```

Maybe Bob shouldn't be such a joker here, but sometimes Bob can't help himself.
Unfortunately, Bob has just caused Alice an incredible amount of stress.  Or,
more to the point, Slack has gotten in the way of team communication, leading
to a terrible misunderstanding.

The problem is that when you use `/me` on the IRC gateway while in private chat
with someone, **Slack just drops the message on the floor and doesn't deliver
it!**  Alice never got that final message.

Read that again, then ask yourself how often you may have miscommunicated with
your team because of this.  Remember that it goes both ways: maybe you never
used `/me` in privmsg, but did your coworkers?  Who knows!  I reported this bug
to Slack feedback in August 2016 and again in September.  When I reported it
the second time, I went back in my IRC logs to compare them to Slack logs.
If I found a time when an emote showed up in both, I'd know when the problem
started.

The answer is that it started around January or February 2016.  In other words,
this silent data loss bug has been in place for a year and known about for, at
the very least, five months.  It hasn't been fixed.  More than a few times in
this period, I've realized that I missed an invitation to a meeting or other
important communication because it was `/me`-ed at me in privmsg.  **This is
garbage.**

I can't fix Slack from my desk, but I can fix my IRC client to prevent *me*
from making this error.  I wrote this `irssi` plugin:

```perl
use warnings;
use strict;

use Irssi ();

our $VERSION = '0.001';
our %IRSSI = (
  authors => 'rjbs',
  name    => 'slack-privmsg-me',
);

Irssi::signal_add('message irc own_action'  => sub {
  my ($server, $message, $target) = @_;

  # only stop /me on Slack
  return unless $server->{address} =~ /\.slack\.com\z/i;

  return if $target =~ /^#/; # allow /me in channels

  Irssi::print("Sorry, Slack drops /me silently in private chat.");
  Irssi::signal_stop();
});
```

This intercepts every "about to send an action" event and, if it's to a Slack
chatnet and in a private message, reports an error to the user and aborts.  I
could've made it turn the message into a normal text message, but I thought I'd
keep it inconvenient to keep me angry.

Please use this plugin.  If you port it to WeeChat, I'll add a link here.

When people tell you, "Of course your free software project should use Slack.
There's even an IRC gateway!" remember that Slack doesn't seem to give a darn
about the IRC gateway losing messages.  It's saying that gateway users are
second-class users.

*Garbage.*

**Update**:

* Matthew Horsfall provided [a WeeChat plugin](https://github.com/wolfsage/playground/blob/master/weechat-scripts/privmsg-emote-on-slack.pl)
