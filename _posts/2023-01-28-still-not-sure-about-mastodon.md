---
layout: post
title : "I'm still not so sure about Mastodon"
date  : "2023-01-28T23:59:59Z"
tags  : []
---

I ignored Mastodon for a long time, but eventually I had to stop.  Now that I
stopped ignoring it and started using it, I feel like I'm either going to lose
interest or (ugh) *get involved*.

Mastodon is built on [ActivityPub](https://activitypub.rocks/), a standard for
pub/sub of *stuff*.  I think it's fair to say Mastodon is "what if we used
ActivityPub to build a federated Twitter-alike".  This is okay, but so far I
feel like everything is a big step backwards in the realm of "just making
sense", and there are probably some places where the Twitter metaphor of a
single continuous timeline will just break down in Mastodon and papering over
it won't make sense.  The various servers are not synchronized (that is, you
don't get one server's posts strictly serialized relative to another's), which
means there isn't one timeline.  How will this be resolved?  My guess is "well,
it won't."

In many ways, ActivityPub makes more sense as a much, much richer form of RSS
feeds, but you wouldn't (I think!) want to read RSS feeds in a single-scrolling
timeline.  I think Julia Evans' [Reddit-like
interface](https://social.jvns.ca/@b0rk/109701532005617273) is interesting, but
of course has its own problems.  (Also, let's be clear: she did not post it as
a panacea for all users, it was a very cool own-itch-scratching.)  Still, the
Mastodon clients that are most compelling right now are very Twitter-like,
because that (I think) is what everybody is aiming for.

Meanwhile, I'm not sure I'm crazy about Mastodon as software.  It seems pretty
well optimized to host a community, which is fine, and I like being in
communities, but sometimes I want to have my own totally-just-my voice or
place, and I want to know I own it entirely, and I don't think Mastodon scales
down well, so far.  There is no self-hosted micromastodon optimized for one
person.  The protocol is too interactive to be a static site, but I think a
very very small server could exist.  Or, a service that hosted your microblog
as a standalone thing, rather than as part of a community, might be really
appealing.  As it is, I've now got my own Mastodon instance running, with one
user and signups disabled.  "Do you want to see what other users on your local
server are posting?" it asks me.

I'm not running my own Mastodon, *really*.  I did that for an hour or two, a
while ago, and then realized it was going to be a real drag, so I found a
running server I liked.  I picked "public.garden", which worked great until it
didn't.  Last week, it turned out that the [Ivory](https://tapbots.com/ivory/)
client wouldn't work on it, because it ran [Pleroma](https://pleroma.social/)
rather than Mastodon.  Okay, no big deal!  This week… it just failed.  The
timeline wasn't updating, I couldn't really check my notifications.  What
happened?  I have no idea.  See, it's not a paid service, it's just some random
thing I grabbed.  So, I don't *demand* stability, but I did (foolishly) take it
for granted.  I know I'll get a better end result by paying, so today I set up
a server hosted by [Mastohost](https://masto.host/), which I reckon I'll use
for the foreseeable future.

During [!!Con 2023](https://bangbangcon.com/), I spent a few hours standing up
my own basic ActivityPub server.  From a Mastodon server, I could type in my
personal server's username and subscribe to its posts.  I know I could've taken
it further, but eventually I would've gotten to needing to make it work with a
nice client on my phone, and just thinking about that, I gave up in advance.  I
know this is a problem with me, rather than Mastodon, but nonetheless it's
there.  I don't want to implement OAuth *again*.

Finally, I'm not enthusiastic about the way that Mastodon pushes users to have
a domain just for their Mastodon identity.  I'll elaborate.  I'm a big email
wonk, and like email a lot, and one of the good things about it is that there's
a nice layer of indirection between your domain name and your email service.
You can say "mail for `example.net` goes to `example.mx`" and later change that
relationship without significant service disruption.  With Mastodon, that
relationship isn't in the DNS, but is instead in a service that *perforce* runs
on the host found at the name `example.net`.  You can't delegate activity
services to another host, you can only provide a service *there* that redirects
individual users.  (Yes, you can also issue a generic redirect on the target
domain, but this still means interfering with your web service.)  This could
have been solved with a `SRV` record or, probably, other things.

I guess I should admit that while I know a lot more about how this all works
than the average person on the street, I am not an extremely well-read
ActivityPub and Mastodon expert yet, so possibly my opinions are all junk.  It
all seems promising as a starting point, but needs some nudging.  And that's
what I mean: I'm worried I might want to get involved in showing alternate ways
to do things.  The good news for me is that I'm probably too busy (and maybe
too wrong) to actually do this.

Anyway, until I invent some mostly-not-compatible system that I like and nobody
else can use, you can find me at
[@rjbs@social.semiotic.systems](https://social.semiotic.systems/@rjbs).
