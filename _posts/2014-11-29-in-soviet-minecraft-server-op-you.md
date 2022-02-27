---
layout: post
title : "In Soviet Minecraft, server op you!"
date  : "2014-11-29T14:50:40Z"
tags  : ["minecraft", "perl", "programming"]
---
## Prelude

A couple weeks ago, my daughter became interested in Minecraft.  She'd tried it
before and thought it was interesting enough, but this time she seemed to have
a more abiding interest.  She did a bit more flipping through the [Minecraft
Essential
Handbook](http://www.amazon.com/Minecraft-Essential-Handbook-Official-Mojang/dp/0545669936)
and made a few things from it, and had fun, but was finding it just a bit
tedious to have to gather all the resources she needed.  Still, she built a
simple house in the trees, explored some nearby caves and villages, and kept
looking through the book… and then she found reference to [creative
mode](http://minecraft.gamepedia.com/Creative).  I showed her how to play in
creative mode, and she was elated.  She was even more excited when she found
out she could *fly*.

We played some LAN games, which was fun, but I knew I'd want a server.  I
wanted to be able to muck about when she was not playing, and I knew she'd want
to play when I wasn't home.  To do both those things in one shared world, we'd
need a server.  I asked some friends, who said it was easy, but all of the
instructions I found online had a bunch of steps, wanted me to add apt
repositories, create system users, and so on.  It just looked like a big drag,
and I started to consider just using [Minecraft
Realms](https://minecraft.net/realms), Mojang's "we host your Minecraft world
for you" service, but at $13 per month, it was enough to make me want to put a
real effort into getting the service running on my Linode.

I read through the instructions carefully, and realized that the whole thing
was a big complicated way of saying:

* make sure you have Java 1.7
* download the Minecraft server jar file
* run `java -Xms1024M -Xmx1024M -jar minecraft_server.1.8.jar nogui` and keep
    it running

Well, I could do that!  Once I realized that, I had a running server in a
minute or two.  Wow!  I spent just a little time updating the server
configuration, then rsynced the kid's Minecraft world files to my Linode, and
it all worked!

## The Teleport Network

I knew that sharing a Minecraft server with a seven year old might lead to
angry times later, when one of us wrecked the other one's work product.  I
declared that we'd each have a big hunk of land where we'd be in charge.  We
could visit, but not build or destroy stuff without permission.

This led to an obvious logistical problem: how would we get from one place to
another?  Minecraft has a `teleport` command, and I could've left it available,
but teleporting works by map coordinates rather than named locations.  If I
wanted Martha to be able to teleport home, she'd need to know the coordinates
for her home.  I could put them on a sticky note, but that would surely get
lost immediately.

I decided to solve the problem by building a point-to-point teleport network!

You can build loads of amazing stuff in Minecraft by using "redstone" devices.
This is sort of code for "electrical stuff," but it has its own physics, and
you don't want to think of it too much like electricity or you'll end up deeply
confused.  You can't build a teleportation booth out of things you can mine in
Minecraft, but there's something you can use as a bit of a cheat: the [command
block](http://minecraft.gamepedia.com/Command_block).  It's a block that, when
powered, executes a console command… like `/teleport`.

I build a pair of booths, each with a button.  Push the button in booth A, and
you'd end up in booth B.  It worked the other way, too.

This was a good start.  We had our own places, we stuck to the rules, and we
had a good time.  Martha started to ask about inviting some friends to our
server, which led me to realize that booth-to-booth teleporters would not
scale.  I could build a targeting system, but that would become very
complicated quickly.  Instead, I built a hub.

<center>
<a href="https://www.flickr.com/photos/rjbs/15900530961" title="Minecraft
Teleport Network v2.0 by Ricardo SIGNES, on Flickr"><img
src="https://farm8.staticflickr.com/7493/15900530961_97fa5f45e4_z.jpg"
width="640" height="400" alt="Minecraft Teleport Network v2.0"></a>
</center>

I left the two booths in place, but now instead of linking to each other,
they'd drop you at a floating platform at (0,0) on the map.  This place, "the
hub," was meant to have eight sub-platforms, each with a teleporter leading to
a new place.  I scouted out some locations and set up a few machines ahead of
time, but not all of them, just enough to show how it would work.  It worked
great!  Mostly!

Martha kept having weird problems.  Parts of the network would work for me, but
not for her.  Then, it would all work.  Meanwhile, I was struggling with [spawn
protection](http://minecraft.gamepedia.com/Spawn/Multiplayer_details#Derivation).
This feature prevents users from editing the world near the spawn point.
Without this, some jerk could fill the spawn point with lava, or solid stone,
and when a new player joined, they'd be stuffed.  I wanted to set the hub as
the spawn point, and then keep it from being edited.  It just didn't work.

Eventually, I realized that the problems were related.  Spawn protection
disables redstone inside the protected area, which meant that the teleport
machine buttons didn't work.  So, why did it only affect Martha?  Because I was
an operator, and could still use the button inside of protection.  Why only
sometimes?  I really didn't want to have ops on myself, so I kept disabling it.
When there are no operators configured for a server, spawn protection is
disabled.  Yow!

I didn't really want to make everyone operators, and I *did* want a protected
hub area.  I'd have to figure something else out.

## The Stupidest Thing That Could Possibly Work

I did a lot of searching for solutions, and I found them.  They were almost
always in the form of "mods."  Those are plugins to change how the Minecraft
server behaves.  As far as I could tell, they always worked by having you first
run a modded server.  That's a replacement Minecraft server which is, itself, a
Java subclass of the base server.  The most popular of these, Bukkit, was
recently removed from distribution because of alleged GPL violations.  Its
whole situation is, to me, an unclear mess.

The new thing people seem to be using is CanaryMod.  It's entirely unencumbered
by any sort of GPL issues, but it (like Bukkit, actually) only supports
Minecraft Server 1.7.  We've been running 1.8, which is a big difference.  Of
course, there are some bleading edge nightly builds that are 1.8, but… I felt
like this was going to lead to me spending time writing Java or hanging out on
a phpBB, and this thought killed all my motivation.  Surely, I thought, there
is some stupider, easier way.

Well, here's what I did:

When you run that `java` command up above, the Minecraft server starts on your
console.  It prints out some status messages, then as the game goes on prints
out logins, logouts, the results of various messages, and all of the global
chat.  Importantly, it's also an operator console.  You can key in commands
that get run with superuser privileges.  Obviously, if I wrote a program that
owned pipes into and out of the server, I could monitor what was going on and
execute operator commands.  It would be a grody hack, but it would work!

I thought about using [Expect](http://en.wikipedia.org/wiki/Expect), but
decided that I'd be miserable.  I tried to remember how to write this kind of
thing in Perl, but couldn't remember a few key bits about non-blocking I/O.  I
asked Dominus for a reminder and he said "Expect!"  I didn't take the bait.

By the evening, I had a crude prototype working in pure core Perl, but getting
there involved some annoying things.  For example, I had to keep calling
`waitpid` inside my read/write loop, and I knew that if I wanted to add more
non-blocking behavior, it would just get worse.  I needed an event loop.  I had
a look at using [IO::Async](https://metacpan.org/pod/IO::Async), which I keep
meaning to use in anger, but it wasn't immediately obvious how to proceed, and
my goal was to deliver something (to my seven year-old) rather than to do
something elegant and modern.  I was already using Perl, right?  Anyway, when I
want to get something really cool done and I don't care what people think of
me, I use POE.  I use it badly.  It worked, as usually, really well.

Basically, the setup is this:  my POE program runs the Minecraft server with
non-blocking a linewise event machine.  When it gets lines from the server, it
decides whether it cares about them.  Mostly, it cares about chat.
Occasionally, it cares about other status updates, but it mostly ignores those.
As for chat, it looks for players saying commands, just like an IRC bot.
Players can say `!home` to be teleported to their home, or `!set home` to
decide where that is.  They also have a "porch," and can `!set porch` to set
that location.  The porch is where another player goes if they try to `!visit
player`.  They can switch between creative and survival modes.

Setting home was a tiny bit interesting to implement.  There's no command to
get a player's location, so how could I save it?  Well, if a player is
teleported, their location is logged.  Teleportation can be to a location
relative to a player's current location.  So, to set home, you register a
callback for "do this when the player next teleports" and then immediately
teleport them to their current location, plus a 3-D delta of (0,0,0).  Ha!

Something I knew was important to Martha was the ability to skip night time.  I
could have disabled the day/night cycle, but I knew that it would also be nice
to have it enabled sometimes, for adventuring.  I added `!sunrise` and
`!sunset` commands.  This wasn't going to be good enough, though.  When she
invites friends, they will surely argue about whether to change the time, so I
made it a voting system.  As soon as one player casts a vote for a time change,
the other players have thirty seconds to also vote.  Whatever change is
requested wins.  In the event of a tie, nothing happens.  Critically, once
everybody online votes, the change happens immediately.  This is most critical
because if you're playing alone, waiting thirty seconds for opposition stinks.

Actually, I lied a bit.  The voting doesn't end when everyone online votes.  It
ends when there are at least as many votes cast as there are players online.
This can be a bit weird.  Imagine:

* currently online: players A, B, C, D
* players A, B vote
* player B logs off
* player C votes

Now there are three votes (A, B, C), and three players (A, C, D), so the
election is complete.  Oops.

Getting the list of currently online players is easy, but not trivial.  The
`list` command prints out the current count of logged-in players, then their
names.  To gather that properly, I need to get the first line, then intercept
the next *n* lines, then fire off a "updated roster" event.  I haven't bothered
yet, because I'm guessing it's just a bit more pain than it's worth.

A simpler solution, which I may implement if the server becomes popular with
her friends, would be to notice logout events and immediately cancel the votes
of disconnected users.  I could also add some facility for speaking to the
server over [RCON](https://metacpan.org/pod/Minecraft::RCON), but… again, I'm
guessing it's not worth the bother.

If I had any next steps actually planned, they'd probably be:

* add an SMS interface to allow remote whitelisting ("Oh, your kid wants on?
    What's their user name?" // send SMS to whitelist)
* an "alone time" mode where a player disables the ability of others to
    teleport to their location
* refusal to let a player set their home/porch within some distance of another
    player's home
* a way to say "if you want to join me or come to my realm, you have to enter
    the mode I'm in"

For now, though, I think it's good enough.  I'll wait for its overwhelming
success with the kids before putting more time into it.

Meanwhile, I have published the code.  As I said, it's a hot mess. I barely
know how to use POE, and I did not aim *at all* for maintainability.  I just
wanted it to work.  I also have a bunch of code that's copied from POE
documentation, and could really be rewritten to be better.  The whole thing
should be turned into a MooseX::POE class for my own sanity.

Whatever, it works, right?

[Soviet Minecraft](https://github.com/rjbs/Soviet-Minecraft) is on GitHub.

