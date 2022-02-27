---
layout: post
title : sixapart cheers and jeers
date  : 2008-12-10T04:35:04Z

---
A few months ago I took a look at where to publish this journal.  For a long
time (years?) I've been posting simultaneously to rjbs.manxome.org and
use.perl.org.  I control rjbs.manxome.org and it does more of what I want, but
it didn't support comments.  use.perl.org supported comments and had more
readers, but little things about it kept bugging me.

I really, really didn't want to have to install and maintain any new blogging
crap on my server, so I was looking at hosted solutions.  I also wanted to get
all my old posts into it, so it had to have an importer.  I decided on Blogger,
but their importer was marked experimental and didn't seem to work the way they
suggested.  Finally, after a few hours, I gave up in disgust.

Then a week or two ago, I decided to have another look.  I saw that LiveJournal
had no import mechanism, but Vox did.  I had to dig for it, because its help
document pointed me through two non-existent pages to find it.  I played "Guess
the URL" and won.

The importer seemed reasonable.  I couldn't just give it an XML file, as it
wanted to get a page that *referred to* an XML file.  It turned out that while
it said it wanted Atom, it was happy with RSS, so I tweaked the RSS feed from
my Rubric install and pointed it there.  It said, "I see about a thousand
entries," and they looked right, so I hit the big green button.

Entries started to appear, out of order, and very, very slowly.  I couldn't see
total progress anywhere.  I couldn't even get a total entry count, so I had to
keep adding up yearly amounts.  After a few *hours* it seemed to stop, having
imported two hundred entries.  Had it failed?  Was it stalled?  Who knows!
There was no feedback.

In the meantime, I learned that while they did have a comment system, you
couldn't leave comments using your OpenID.  You have to have a Vox account...
and this is a Six Apart product?  What?  It also had annoying ads and didn't
want to let me use my own domain.  (I would have been willing to pay for
turning off ads or using my domain.)

Finally, I gave up and deleted my account.  I got a farewell email that
suggested I try another Six Apart product, LiveJournal.  Oops!

I looked into Moveable Type, but I really didn't want to install anything.
Anyway, I'd used it before, and posting to it from Perl was a pain.  The API
documentation didn't make it clear how to tag my entries or use specific
formatters.  I really didn't want to post through its web interface.  Eh.

TypePad looked like it might be better, but the pricing wasn't right and I
encountered stupid problems when trying to sign up for a trial.  Its importer
didn't seem like it was going to do the trick, either.

Finally, when I was nearly giving up, someone (Jonathan S.?) suggested TypePad
Connect.  Like Disqus, it's a system for making a comment section magically
appear on your page, using JavaScript.  Unlike Disqus, it support OpenID.  Now,
it doesn't support it very well yet, in my opinion, but it supports it well
enough that I know people can leave comments using their OpenID, rather than
needing to create a stupid account with my comment service provider.

After about five or ten minutes of signing up and looking at example code, I
had comments.  After about five or ten more minutes, they looked slightly less
awful.

My impression right now is that Six Apart has a lot of balls in the air, and it
seems like their balls are competing with one another.  They do similar things,
with different strengths, and it's not clear that any one is singled out to
become the One Blog.  This seems weird and wrong to me, but I know nothing
about the blog market.

I'm just glad I can publish to one place.

This means I'm going to have to get back to developing Rubric!

