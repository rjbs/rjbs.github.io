---
layout: post
title : "omnifocus versus hiveminder: the prelude"
date  : "2008-02-15T03:38:50Z"
tags  : ["hiveminder", "omnifocus", "productivity", "software"]
---
A million (alternately, five) years ago, when I was working at IQE, I got sick
of trying to use any of our existing project tracking software to track my todo
list.  Instead, I started [using index
cards](http://www.flickr.com/photos/rjbs/328834262/).  I put the big chunks of
todo into Project or Press Your Luck (the project-managing add-on to our
internal helpdesk software), but all the task-level stuff became index cards
instead of helpdesk tickets.

This worked really, really well.  I could stick blanks in my pocket to catch
random ideas.  I could (as pictured) organize my cards on a pinboard in a lot
of ways.  Sometimes I made dependency trees, which was great when working with
someone or making clear progress in a project.  Sometimes I put them into a
grid using the [Eisenhower
method](http://en.wikipedia.org/wiki/Time_management#The_Eisenhower_Method).
Sometimes I just put them in a rough todo order and made a stack on my desk to
plow through them.  It was pretty fantastic.

I felt pretty silly, carrying around these neon index cards everywhere, and my
co-workers seemed to find them sort of bemusing.  I think my boss thought I was
nuts for not using, say, Exchange.  I felt pretty silly, but not silly enough
to stop using them.  After all, they were so darn useful!

I took my index carding ways with me to Pobox, and at least briefly infected a
coworker with the idea.  Through the years, from IQE to Pobox, I kept trying to
find a useful software alternative.  I used Kwiki, OmniOutliner, a few bug
tracking systems, Vim (with various plugins, including
[Viki](http://www.vim.org/scripts/script.php?script_id=861) and
[TVO](http://bike-nomad.com/vim/vimoutliner.html)), and probably a bunch of
other things I can't remember.  When [Getting Things
Done](http://en.wikipedia.org/wiki/Getting_Things_Done) became the hot new
thing, I immediately tried the software that was made for GTD.  Well, not
immediately.  First, I spent some time rolling my eyes at people who seemed
amazed at what had been obvious, to me, for years: simple categorized items are
really useful.

Everything I tried was cumbersome and ugly, and left me unable to access my
data when not at my computer.  When the [Omni Group](http://www.omnigroup.com/)
said they were making a GTD app, I was pretty excited.  They made a fantastic
[diagramming app](http://www.omnigroup.com/applications/omnigraffle/), the
first [outliner](http://www.omnigroup.com/applications/omnioutliner/) I'd ever
liked, a [web browser](http://www.omnigroup.com/applications/omniweb/) that I
actually paid to use, and [project
planning](http://www.omnigroup.com/applications/omniplan/) software that I
wished I had a reason to use.  Could their todo app miss the mark?

I got into the early semi-public beta, and once I figured out how to use it, I
loved it.  I loved it so much that pretty soon I threw away my stack of index
cards.  I got a lot of stuff done, and was pretty well able to ignore OmniFocus
while doing it.  I have already [written about
OmniFocus](http://rjbs.manxome.org/rubric/entry/1544) and how great it is.

One of the things I tried, and abandoned, while I was still on index cards was
[Hiveminder](http://hiveminder.com/), the GTD-ish todo manager from [Best
Practical](http://bestpractical.com/), the people who brought us Request
Tracker.  I don't use RT much, apart from rt.cpan.org, which I dislike, so
I wasn't looking at Hiveminder as the next thing I'd love -- I just knew it was
coming from people whom I knew and whose opinions I tended to respect.  When I
first used it, in (I think!) pretty early private beta, it was slow and didn't
do absolute everything I wanted.  For one thing, it couldn't, uh, print index
cards.  (I volunteered to rope a friend into making that work and never came
through.  I'm sorry, Jesse!)

Looking back, I think even then Hiveminder might've been able to do everything
I now do with OmniFocus.  It was just slow and I was really, really attached to
my index cards.

I've kept a corner of my eye on Hiveminder, though, and it keeps getting cooler
looking.  I can point a mail client at its IMAP server and deal with my todo
items as if they were messages.  Since it's IMAP and things have proper UIDs, I
can use [OfflineIMAP](http://software.complete.org/offlineimap) to sync my todo
lists to maildirs on my laptop, then move them around and sync them back... or
so I believe.  I can talk to Hiveminder over instant message and (via Twitter)
SMS.  I can email new tasks to Hiveminder, and I can empower other people to
send new tasks to me.

Beyond all that, it is multiuser and allows groups and group project
management, so I can create todo items for anyone working on a project to do.

What's keeping me from moving to Hiveminder?  Well, there are a few things.

First of all, I paid $40 for OmniFocus!  That's some serious money!  If I use
Hiveminder, I'm sure to want a pro account, which will run me $30, and I don't
want to get into the habit of jumping from one system to another.  That's
really the least of my concerns, though.

Another concern is, well, the iPhone.  I don't have one... but I probably will
get one when my T-Mob account runs out in July.  I'm sick of T-Mobile's lack of
3G, and I hate my current handset with great intensity.  I'm looking forward to
evaluating Android, but I think that once the SDK is out and Omni and other
awesome Mac ISVs are making great software, iPhone will still be the winner.
Speaking of Omni making iPhone software... it seems pretty darn obvious that
they will make a OmniFocus for the iPhone, and that it will sync with my
laptop.  I used to want an iPhone before iPhone existed, because I knew
OmniFocus would make an outliner for iPhone, and that could replace my index
cards.  Will there be a native Hiveminder app for iPhone?  Well, I'm doubtful,
although I can probably ask the friendly folks at BP.

Sure, sure:  I can talk to Hiveminder from my iPhone with IMAP, email, IM, SMS,
or HTTP.  That's not enough for me, though!  I know it isn't enough for Jesse
Vincent at BP, either.  A few conferences ago, he was one of a few people to
contribute to a brief group of lightning talks that began "I think, but I
cannot prove..."  His talk was about the fact that in Web 2.0, we're putting
all our data out in the cloud... and that when the cloud isn't accessible,
we're hosed.  I have a context in OmniFocus precisely for "things to do when
there is no network!"  I don't want to deal with having no access to my todo
just because I'm in a fallout shelter deep underground or (somewhat more
likely) on a bus in the middle of nowhere.  I want my iPhone to have a
synchronized copy of my data, ready to go.

Maybe the next generation of iPhone (or Android!) software will have a good
mechanism for making this happen.  [WebKit's client-side
database](http://webkit.org/blog/126/webkit-does-html5-client-side-database-storage/)
feature could be darn useful for that.  The alternative, after all, is that I
make a printout of my todos, making sure there's empty space for new items, and
that I fall back to that when I lose my network.  Then if I lose my network
connection after two hours of using it, my printout is two hours out of date
and I have to perform a two-way sync myself... by hand!

So, I am conflicted.  I need to produce a list of priorities for my todo
software.  Then I can use that as a rubric for picking a winner in the battle
for my mindshare.  I will post it when it's done.

