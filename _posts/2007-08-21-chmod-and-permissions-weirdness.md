---
layout: post
title : "chmod and permissions weirdness"
date  : "2007-08-21T14:36:05Z"
tags  : ["cygwin", "perl", "programming", "testing"]
---
[This test
report](http://www.nntp.perl.org/group/perl.cpan.testers/2007/08/msg582815.html)
has been making me scratch my chin.  It boils down to something like this:

    SKIP: {
      chmod 0222, $filename;

      skip "chmodded 0222 but file is still -r", 1 if -r $filename;

      eval { IO::File->open($filename, '<') or die "fail"; };
      like($@, qr/fail/, "we can't open an unreadable file");
    }

This works everywhere I've tried it, including with Strawberry Perl on Windows
XP.  I haven't tried it myself under Cygwin.  I'm not really concerned with
this specific problem per se, because I know I can contact Chris (the tester)
and ask for help.  I'm more wondering, in general:  huh?  Is this sort of thing
a Cygwin weirdness that I should know about for portability's sake?  Does I
need to always use filetest.pm?

