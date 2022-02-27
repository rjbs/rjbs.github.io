---
layout: post
title : mini-cpan, mod-start, math-calc
date  : 2005-03-08T03:11:00Z

---
The CPAN mirror on my laptop now has an index that starts like this:
<pre><code>	File:       02packages.details.txt
	Description:Package names found in directory $CPAN/authors/id/
	Columns:    package name, version, path
	Intended-For: Automated fetch routines, namespace documentation.
	Written-By: CPAN::Mini
	Line-Count: 28162
	Last-Updated: Tue Mar8 03:08:06 2005
</code></pre>

If you never do anything interesting with your mini-CPAN mirror (you have one, right?) then this won't be at all interesting to you.  If you do, however, you've probably had to deal with some minor annoyances, like the fact that CPAN::Mini doesn't rewrite the 02packages file as needed.  Now, if you filter a module, it will not be in your index.  If you add a private set of modules CPAN::Mini can take care of them for you, merging your indexes as it goes (like mcpani).

Unfortuantely, it's not nearly done yet.  It's just a new minicpan script that hasn't yet been turned into a nice set of subclassable modules.  Still, it works, and I have the impression that it's actually a good bit faster than the current minicpan.  This surprises me, since I'm using Parse::CPAN::Packages liberally, and it takes some time to parse the 02packages file.

Tomorrow I'll do more work on making it prettier.  I've got lots of refactoring to do, which should be fun!  I'm looking forward to making it easier to multiplex remote sources, write smarter filters, and just do cooler things.

I released a new Module::Starter today, fixing some stupid little bugs that have been sitting in RT for altogether too long.  I think I'll release another version tomorrow to fix a little bug I hadn't gotten to this morning.  I should also overhaul my plugins, and maybe finally switch my own code to svn.  It was really nice to be able to 'mv' files inside an svn rep, today.

Meanwhile, at work, the programmer-in-training is still working on implementing Math::Calculator.  I'm not sure how the week is going, because I have no real baseline for comparison.  I'm interested to see how he feels about the whole endeavor, later.  Personally, I'm very frustrated at work, but for other reasons.  Supporting the ERP system is a big drain, largely because I work and work at it, but keep ending up emailing the guy who used to maintain it and asking for help.  It's too big and arcane.  I wish previous maintainers had (as I begged) maintained documentation.

Snoozer is still doing well.  I haven't seen her drink any water, yet, except for one tiny sip when we held her and basically put the bottle to her mouth. We've taken her out of her cage a few times, and she's being pretty friendly when we do so.  The only trouble has been actually catching her and getting her out of the cage.

I wish she'd stop soiling the PVC pipe that she hangs out in!

