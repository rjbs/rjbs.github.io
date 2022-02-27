---
layout: post
title : "recursive \"make test\""
date  : "2005-06-09T01:21:34Z"
tags  : ["perl", "programming", "testing"]
---
Shawn Sorichetti, God bless his soul, gave me what I'd long wanted: a sample test script for testing Rubric::WebApp using HTTP::Server::Simple and Test::WWW::Mechanize.  It wasn't the Mech stuff I was worried about, but the HSS.  Shawn gave me two little files to drop in place and see the whole thing work.  Now I am set to start testing all kinds of crap!

I got to a point where I wanted to start organizing my test files into directories, and I remembered that while prove can do recursive test files with -r, MakeMaker doesn't use Harness that way by default.  Neither Shawn nor Andy had a ready-made solution, so I got a really weird urge to do something silly, and wrote this:

    test => {          TESTS => join " ", sub {       my $w; $w = sub {          map { -d $_ ? $w->($_) : /\.t\Z/ ? $_ : () } grep { ! /^\./ } <$_[0]/*>       };       $w->("t");     }->()   },

That incantation will now live in the WriteMakefile calls of my more complex distributions, and I will smile every time I see it.
