---
layout: post
title: software freedom
date: "2002-01-02T11:49:00Z"
---

[ rjbs, March 2022: I don't actually know the original date of this post! ]

In the realm of "free software" and "open source software," there's a lot of
talk of freedom:  software that is free (like beer), software that is free
(like speech), and what freedom is, anyway.  Freedom is a pretty important
concept on its own, and people tend to get pretty worked up about even minor
differences in definitions and implementations of 'freedom.'  Now, I'm not
complaining!  I'm all for people having philosophical arguments.  In fact, I
thought I might throw my own hat into the ring.

Richard Stallman, the founder of the <a href='http://www.fsf.org'>Free Software
Foundation</a> and the GNU project, is one of free software's most infamous
crusaders.  He said, in his <a
href='http://www.gnu.org/philosophy/free-sw.html'>free software definition</a>
that there are four kinds of freedom involved in software:

<ol start="0">
<li>freedom to run a program for any reason</li>
<li>freedom to study the program's workings and modify it</li>
<li>freedom to redistribute copies</li>
<li>freedom to improve the program and release your improvements</li>
</ol>

If a program is licensed such that all four freedoms are granted, it is
(says Stallman), *free software*.

In a recent <a
href='http://www.oreillynet.com/cs/weblog/view/wlg/526'>column</a>, Tim
O'Reilly (of <a href='http://www.ora.com'>O'Reilly and Associates</a> fame)
wrote that he thought Stallman had gotten Freedom Zero wrong.  More basic than
the right for the user to run the program, he said, is the author's right to
dictate the terms of his program's use and for users to accept or reject those
terms.  In other words, if I can't choose to make my software non-free, I have
been stripped of an even more fundamental freedom.

In their <a
href='http://linux.oreillynet.com/pub/a/linux/2001/08/15/free_software.html'>rebuttal</a>,
the FSF writes:

> Tim O'Reilly says the most fundamental software freedom is: "The freedom to
> choose any license you want for software you write." Unstated, but clearly
> implied, is that one person or corporation chooses the rules to impose on
> everyone else. In the world that O'Reilly proposes, a few make the basic
> software decisions for everyone. That is power, not freedom. He should call
> it "powerplay zero" in contrast with our "freedom zero".

What they fail to address is that O'Reilly qualified his Freedom Zero as
requiring that the user have the freedom to choose to accept or reject the
license.  If there really exists an opportunity to choose alternatives -- and
by this I mean software that is alternately licensed -- then users have
freedom.  They may choose to give up some of their freedoms of use or
modification for the sake of acquiring some high-quality software.  Tim argues
that the practises of corporations like Microsoft are objectional not because
of their software's licensing, but because the corporation conspires to deny
users the freedom to choose alternative software.  Under Tim's scheme, users
would not be "choosing between masters," as the FSF claims, but choosing
whether or not they needed total freedom to modify their software.

I cannot find any reason to believe that software *must* be released with all
of Stallman's freedoms granted, but I will grant that the software isn't
offerred entirely "freely" unless all five freedoms are granted.  (That is,
Stallman's four and O'Reilly's one.)  These freedoms do not add up to the GNU
Public License, however, because it strips users of the freedom to release
their derived works under a "less free" license.  So, if the GPL doesn't
exactly fit the bill, what should we use?

I'm not sure.  There are a few issues that make it hard for me to see a clear
solution to this problem.  Firstly, while I don't think that everyone should be
*required* to grant all users unlimited access to redistribute their software,
they should do it anyway.  What's at stake here is the commercial software
industry.  There exist, now, many companies that make their living by writing
software that is useful to a large market (large enough, at least, to generate
revenue) and selling it with a license such that it's not legal for consumers
to freely duplicate and redistribute the software.  This business model likens
the software engineers and programmers to authors, who make their living by
selling copies of their works.  For their works to generate revenue, free
redistribution must be prohibited.

By creating (or supporting) corporations that do nothing but create software,
the market homogenizes itself, especially as regards software that will be used
by all parts of the market:  operating systems, "productivity" software, simple
utility application.  When developers begin writing software for a large,
generalized market, the needs of the small, specialized consumer go unmet.  The
specialized consumer is, then, forced either to implement workarounds or to
develop their own software.  Because proprietary software cannot generally be
modified, extended, or redistributed, the small market customer can't extend
the generic product and contribute its extensions back into the product as a
whole.  While some proprietary products offer frameworks for developing modular
add-ons, these are only useful if the special customization is a modular
addition, rather than a change to the internal architecture.

A more effective model for development is to remove the generic software
corporation from the picture and instead allow consumers to develop their own
software directly.  Projects are defined by working groups comprised of
developers hired by potential consumers.  Instead of spending thousands of
dollars on generic software, consumers will use software that is available for
free, and invest their money in the adaptation of that software for their own
needs.  Corporations that cannot afford full time programmers can contract
development or can make agenda-influencing donations to freelance project
developers.  These developers would work on their project full time and be
subsidized by donations made by parties that want modification or enhancements
to the software but can't justify the expense of a full time development staff
(or of tasking their own developers with these modifications).   Even companies
that can't afford even to make donations to the project are better off, because
they are no longer paying for permission to install and run software that does
not fully meet their needs.

To realize this scenario, free software projects must become large enough and
supported enough to compete with proprietary commercial software products in
the area of usability.  Proprietary software is often believed to have a lower
"total cost of ownership" because sufficiently skilled administrators for
commercial software are less expensive to maintain.  While I don't know whether
the total cost of ownership is lower with commercial software, an administrator
for a GNU/Linux system will probably cost more to salary than a Microsoft
Windows administrator because he requires greater knowledge and skill to
accomplish many common tasks.  A GNU/Linux (or FreeBSD, etc).  administrator,
though, will have a greater generalized knowledge of the system, and will be
able to provide more customized and comprehensive solutions, especially because
he will have a knowledge of other existing free products, which he can install
and configure in lieu of his systems's default solution.

The GPL, ensures that the software may be modified, reverse enginneered, and
redistributed, and also ensures that all derivative works will be likewise
free.  This license eliminates the need for any form of complex legal contract
between developers of the product.  Competing products will be able to borrow
directly from each others' achievements, accellerating the advancement of all
projects in one scope.  The rights of the individual are not compromised
because they choose to accept the terms of the GPL by using the GPL'd software.
Microsoft objects that free software will destroy innovation because there will
be no incentive to engineer better software.  On the contrary, because the
desire to *have* better software will exist, so will the desire to *make*
better software, because the users of software will become, to a large extent,
its creators.  Because there will be no incentive to eliminate competition or
obfuscate problems with code, those driven to create better software will be
more free to improve the software, rather than its marketing.

I believe that Tim O'Reilly's Freedom Zero is real, and should be respected.
Non-free licenses seem sensible for software projects that are essentially
works of art, such as games, audio/video displays (what we once called
"demos"), and interactive fiction.  For projects that aim to create operating
systems, servers, and applications for productivity or general business-related
functions, only professional software-writing corporation benefit more from
proprietary software than from free software.  Licenses like the GPL promote
the lasting freedom of the software, and should be favored.
