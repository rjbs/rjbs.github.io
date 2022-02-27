---
layout: post
title : naming and numbering perl
date  : 2013-02-20T03:21:36Z
tags  : ["perl"]
---
Matt S Trout wrote a very reasonable [suggestion to brand the current Perl 5
implementation as Pumpkin
Perl](http://shadow.cat/blog/matt-s-trout/names-and-numbers/).  The gist is
something like, "take the emphasis off of 5, which sounds like one less than 6,
and put it on the thing itself: the really nice language, all plump and ready
to be [used in a pie](http://perladvent.org/2012/2012-12-02.html)."  I can get
behind that.

The part that starts to wrankle me is this:

> So what if next year's release, instead of saying
>
>     perl revision 5, version 20
>
> said
>
>     pumpkin perl, version 20

It's not that I think Matt's proposal says we should drop the five as its
first, key point.  It's a bit more: "Look, everybody knows this is five.  Focus
on the thing that does keep changing and marking nice improvements!"  (I will
state for the record that I do not want to remove the five from many places,
although moving it around a little might happen.)  The problem is the huge
influx of expectation that this is really *is* about dropping the five and
using this as some sort of breaking point with history.  This frustrates me for
a few reasons.

There's an occasionally repeated refrain that "if only we could break backward
compatibility," Perl 5 would surge forward with new innovations.  "We'd finally
throw off the yoke of `some feature the speaker doesn't use` and be free!" The
problem, of course, is that somebody else uses that feature.  Pretty often the
speaker is his own somebody else, and just doesn't realize it.  Prototypes?
Test::More.  Tied variables?  DBI and Config.  AUTOLOAD?  CPAN and Encode.
Typeglobs?  Much of the Net namespace (not to mention anything that exports).
Other times, the feature is old and goofy, but not really in the way of
anything.

So there's one blocker to breaking backward compatibility: you'll make it a
nice language in which you'll get to reimplement all the stuff you love about
using the language.  *Whoops!*

That's not the most important blocker, either.  The more important blocker is
that nobody is actually coming forward and saying, "If we can break `X`, we can
get a big improvement to `Y`."  Maybe this is because there is a feeling that
backcompat is so deeply entrenched, and so pervasive about the smallest foibles
of the language that there is no point.  I think this would be a shame, because
I can pretty confidently say that we *can* break backward compatibility for the
right win.  How much, for what?  I don't know.  We'd need to see an offer, and
then a patch.

Of course, there are limits.  Perl is used to power multi-billion-dollar
businesses.  This constrains its paths forward.  It won't cease to exist, nor
will it be abandoned, but it can't break the code bases of those businesses.
Also, note that I'm speaking in the plural.  If there was one massive
enterprise that owned Perl and drove it forward, there would be a very clear
set of guidelines for what could break: anything but the code making billions
of dollars for the sponsors.  Instead, there are a bunch of enterprises and
upgrading them all in sync and keeping all their code working forever is not a
simple matter.

This is the problem with success.  As a language grows successful, it loses
agility.  That's one of Perl 6's strengths: it hasn't yet become a big success,
so it can change anything it wants whenever a design flaw is made.  If we want
to regain that kind of agility, all we have to do is agree to give up our
success.

That's what forking a project is about: you get a whole bunch of code (warts
and all) for free, without the burden of success.  Then again, maybe after a
brief and extremely liberating romp through the free prairies of obscurity, you
can try to steal the success of your ancestor.  Remember: you'll be giving up
that agility again.

*This* is where I get back to *liking* Pumpkin Perl.

If you want to break backward compatibility, you can sketch out your plan and
say, "Hey, I figured out that if we drop support for `reset`, we can get a 4%
speedup to `local`!"  This will result in a response of "no, never!" or "yes,
surely!" or "hm, show us a patch?"  If it goes in, great.  There's a
deprecation period to ease everybody off of `reset`, and then `local` gets
faster.  If it doesn't, what do you do?

Either you grin and bear it, or you go work on another Perl.  The Perl you work
on doesn't care about `reset`.  Heck, it doesn't care about `dump`, either, so
you can save another 2% on something there.  You won't be working on Pumpkin
Perl, of course, but on Antelope Perl, or Hubbard Perl, or [Kurila
Perl](http://perlbuzz.com/2007/11/gerard-goosen-talks-about-kurila-a-perl-5-fork.html).

Are these forks viable?  Of course.  They are viable as long as they have
people using them, just like Pumpkin Perl.  Perl is free software, so anybody's
fork can continue to incorporate changes from the mainline, while it's
possible, and changes determined to be massive improvements can be brought back
to Pumpkin Perl after a proving period.  GitHub showed us all that forking is
good, because a fork is just a branch.  That works here, too, and naming "the"
`perl5` is a way of saying, "This is one branch: the most conservative,
commonly relied-upon one."  The distinction it creates from Perl 6 is, to me, a
minor side benefit.

Matt's posts have all been very clearly trying to avoid talking about forking
perl and breaking backcompat, so I hope he isn't bothered to see me going
directly to those two topics in this post.  A lot of other responses went
there, though, and I think those topics really need to be addressed.

If "Pumpkin Perl" is going to be a thing, it's going to be a very low-key
change:  we'll call the thing at `perl5.git.perl.org` "pumpkin perl," and it
will answer to `use 5.x.y`, and it will still say "revision 5, version X," more
or less.  The freedom we get is a freedom of expression, granted by having a
clearer way to refer to one branch of perl as an equal amongst others.  By
giving the first fork a name, we make room for future forks to exist and have
their own names, without having to "break" this one.

