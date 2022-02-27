---
layout: post
title : "mutt problems after debian upgrade"
date  : "2010-05-09T16:26:16Z"
tags  : ["mutt"]
---
I'm pretty darn cautious about upgrading stuff on servers, but for some reason
every once in a while I lose my mind and say, "I'm going to do a `dist-upgrade`
my primary workstation right before (bedtime, work, a deadline)."  I did that
last night.

Everything was fine, although I had to re-install a bunch of Perl libraries.
(I should be using `local::lib` or perlbrew more often.)  Then I ran `mutt` and
I got prompted for my password... even though it was connecting via a direct,
preauthenticated tunnel.

It took me a long time to feel certain that it was this:  When running `imapd`,
I got the following:

    * OK [ALERT] Filesystem notification initialization error -- contact your mail  administrator (check for configuration errors with the FAM/Gamin library)
    * PREAUTH Ready.

This should not have been an issue, as I understand IMAP -- but my
understanding isn't great.  It's a weird protocol.  I looked and looked for how
to disable the advanced IMAP idle features that needed the file monitors, but
as far as I could tell, Courier would always look for FAM or Gamin.  Finally, I
threw up my arms in frustration and installed Gamin.

Everything just worked!

