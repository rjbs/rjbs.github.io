---
layout: post
title : class::dbi, triggers, and tolerances
date  : 2004-08-24T00:54:00Z
tags  : ["code", "perl"]
---
I'm a real newbie to Class::DBI.  I've known about it for quite a while, but I never used it until OSCON, when I attended Casey's crash course.  I got a nice crash course once I got home, too, when I had to figure out how to make Class::DBI work with MSSQL and ODBC.  Some of the problems I had were self-inflicted, like when I didn't realize I had to include default options (like DBIx::ContextualFetch) if I subclassed db_Main.  A few others were caused by ActiveState's apparently broken Class-DBI ppd, which claimed to be 0.96 but was really 0.95.  I did find a nice little bug in Class::DBI itself, though, which apparently only mattered with ODBC+MSSQL.  I'm hoping to see my name in the changelog for 0.97; I'll settle for seeing 0.97 at all, though.  I'm trying to avoid needing custom versions of CPAN modules at work.

At any rate, after a few days of reading and hacking, I've got Epitaxy::Substrate backended by Class::DBI, and life is good.  At first, everything was just varchars, which was fine for testing but useless for real life.  Now, Epitaxy::Substrate was one of the main reasons for creating Number::Tolerant.  The goal is to use N::T to simplify the representation of specifications that are full of "x +/- y" values.  In our old system, it took a bunch of columns to represent something like that, and it was really awkward and confusing.  The code that tried to figure out whether things passed or failed was horribly ugly, even though it wasn't doing much at all.

Casey had told me, at OSCON, that inflate and deflate would let me store objects in columns, and lo and behold they did.  Of course, this meant I needed write a good method for inflating strings into tolerances.  That was a pile of fun.  I refactored a bunch of N::T, and (strangely) ended up with more code. Fortunately, it was also better.

When it was time to connect the web form to the Substrate object, it looked like I was going to have to construct tolerances from the web input before creating the object.  Fortunately, it seems that Class::DBI has a simple way to deal with that, too.  I made a little trigger that seems to be doing the trick.
<pre><code>	sub _set_tolerance {
		my ($value) = @_;
		if (UNIVERSAL::isa($value, 'Number::Tolerant')) {
			return 1;
		} elsif (my $tolerance = Number::Tolerant->from_string($value)) {
			$_[0] = $tolerance;
			return 1;
		} else {
			return 0;
		}
	}
</code></pre>

I think this is working, although I need to try it out more.  I admit that my testing has gotten a little lax around this problem, mostly because I've been writing my code on my PowerBook, where I can't easily run tests against the MSSQL database.  I wish we used a friendlier server!

At any rate, I've grown really fond of Class::DBI already, and I think I'll definitely be using the hell out of it in time to come.

I also wish I could contrive more uses for Number::Tolerant.  It's simple, but I've had a lot of fun.

