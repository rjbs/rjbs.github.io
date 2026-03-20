---
layout: post
title : "experiments with claude, part ⅲ: JMAP-Tester coverage"
date  : "2026-03-16T12:00:00"
tags  : ["programming","perl","agents"]
---

Here's another post in which I fiddle around with Claude Code and determine
that it is not just spewing out nonsense and bugs, but instead is doing *kinda*
what I would've done, at least enough to reduce my total effort.  This time,
writing tests.

## Project Three: JMAP-Tester test coverage

Okay, I progressed from [code I'd throw away]({ post_url
2026-03-10-experiments-with-claude-i }) to [code I would keep but not look
at]({ post_url 2026-03-13-experiments-with-claude-ii }).  I was progressing up
the totem pole of how much cultural value we put on code.  What was the next
least respected code?  Tests, of course.

Now, I actually love tests, and like treating them like first-class code, and
building libraries to make testing better.  One of those libraries is
JMAP::Tester, which we use in tons of our testing.  Until pretty recently, it
didn't have all that much testing of its own.  That is: JMAP-Tester was used to
test things, but was not itself tested.  In December, as part of adding some
features to JMAP::Tester, I started to expand its test coverage.  This was
rewarding and useful, but I didn't get to 100% coverage.  I used to strive for
100% (well, 95% coverage) on my code, but these days… well, who has the time?

Turns out, Claude has the time.  This one was pretty darn impressive.  You can
read [the whole
transcript](https://static.rjbs.cloud/claudelog/jmap-tester-coverage.html), but
here's an accurate summary:

{% chat %}
rjbs:  This project is a CPAN distribution.  Produce a coverage report,
  which you can do with "dzil cover".  Find low-hanging fruit to add test
  coverage and draft the tests.
* time passes
claude:  I've increased test coverage from about 50% to about 95%.
{% endchat %}

That was it!  You can read [the pull
request](https://github.com/fastmail/JMAP-Tester/pull/59).

Well, there were a couple more bits, mostly me saying, "Make it look like how
I'd have written it" (literally), and some git faff.  I did go through and
tweak the code to be more readable and better organized.  I could've given
Claude clearer instructions to avoid most of that, or had standing instructions
about it… but really, it was a good way to keep my mind engaged while I
reviewed that the code was testing what it should be, *anyway*.

If "write more coverage tests" was the only thing I could get out of Claude,
it'd still be huge, but obviously there's more.  I'll keep posting…
