---
layout: post
title : "please write tests"
date  : "2006-05-30T19:53:00Z"
tags  : ["perl", "programming"]
---
This weekend, a few of the friends I've made through work came to Bethlehem to
see whether the ice cream joints that I'd raved about were really all that.
I'll say more about that later; the short version is: of course they were.
While they were here, I pointed out the route I take to get to the bus and
answered some questions about how long it took me to get to and from the
office. Usually, it's a twenty or thirty minute walk to the bus, then a two
hour bus ride, then a five minute walk. Those numbers can fluctuate a little,
but not much. Someone asked why I'd want to cope with such a big commute, and I
explained that my new job was better. This led to the question, "Well, how much
better?"

Given that one of my guests was my boss, it seemed like an awkward question to
answer, and I think I gave some sort of non-answer. For the record, I really
like my job, and I think the commute is not a big deal, most of the time.

The reason I'm writing about this under the heading "please write tests,"
though, is that my job could be better. We have a lot of code. The lib
directory in one of our largest bundles of code is nearly a half meg. It all
does its job, and is not entirely incomprehensible, especially compared to some
other code I've worked with. The problem comes about when we need to make
changes.

Almost everyone needs to make changes to existing code. I think that this has
been the bulk of my work, even when the existing code is just code I wrote a
few months ago. Nearly any professional programmer must, I think, be pretty
familiar with the ups and downs of maintenance programming. Sure, the code
worked when it was written, but then it was serving a quarter million requests
per day, and now it's working on three million and it needs to be optimized.

Profiling code usually easy, and it's often possible to quickly find the
lowest-hanging fruit and take a swing at plucking it. I've been doing a lot of
this lately, and I keep encountering a problem like one that Dominus has
written about numerous times: a really, really fast algorithm is only useful if
it gets the right answer. Often, I make a bunch of improvements and then a day
later find some new, subtle bug that I've introduced. Why? Well, I didn't have
a test for the behavior that changed, because I didn't realize it was related
and because it wasn't previously tested. Then, worse, I find that the affected
code isn't easy to test because it's only available as part of a long,
integrated pipeline of actions that are expensive and complex to test from end
to end. This violates the Andy Lesterism that used to hang on my wall at the
old job: "Don't write code you can't test."

For a long time, I was weak-willed and lazy, and when I encountered this
problem I said, "Well, I'll just fix it and test it by hand a few times." Ha!
This has an obvious and well-known result: the bug returns later, and I look
twice as stupid. After encountering this kind of problem a few weeks ago, I was
sick of it, and declared, "That's it! I'm refactoring all this code so that it
can be tested, and then I'm writing tests, and none of you are going to stop
me!" Unsuprisingly, no one objected, and now a lot of the code that had been
giving me grief is now really easy to test, refactor, and sight-read. When an
obscure but long-standing bug showed up today, I was able to add a test to the
suite, prove the bug, then code it away. I threw a little party in my terminal
to celebrate.

      $ perl -lMTime::HiRes=sleep -e'$|++; printf "\rO%s-%s", qw(\ | /)[$_%3],
      qw(&lt; = &lt; |)[$_%4], sleep 0.25 for 1..20;'

Still, I keep encountering little problems like this. Sometimes it's that I
don't have the tests I want, sometimes it's that it's hard to write the tests I
want, and sometimes it's that the tests don't provide enough coverage to serve
as documentation of all the code's behavior. Providing these tests (and/or the
ability to produce them through refactoring) is strangely tedious and
rewarding, but not as rewarding (I suspect) as merely improving the software in
customer-visible ways would be. Some code that I'm taking over has a larger
audience than just us, too. I mentioned the BounceParser earlier this week, and
I'm also trying to shape up Mail::Audit. Both of these have been on the CPAN
for quite a while, and I'm sure I'm going to break someone's code as I "fix"
the modules, because their test suites (if I may use that phrase here) do not
clearly document all the code's behaviors. Yes, many of them can be extracted
from the documentation, but in my experience, even good documentation is often
pretty selective.

I was very happy when I heard good feedback from Tom (my replacement at IQE)
about the state of things I'd left behind. Sure, there were some complaints and
funny looks, but for the most part I'd left things tested and documented, and
that meant that he could sit down and pick up where I left off. I know that
this goes a long way toward making a job better. I think that it's only fair to
think that when I leave a job for a better one, the person taking my old job
should be able to find himself doing the same thing. I want to leave things in
a good, maintainable state. The best way to do that is to provide a nice,
clear, comprehensive test suite

So, please, write tests. If not for your own sake, then for the sake of the
person who takes over after you. If he doesn't buy you a beer for having done
so, I will.

(Limited time offer, one beer per MLOC tested, offer void wherever beer is
sold.)

