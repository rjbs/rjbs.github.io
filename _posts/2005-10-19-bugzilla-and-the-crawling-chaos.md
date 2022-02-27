---
layout: post
title : "bugzilla and the crawling chaos"
date  : "2005-10-19T04:31:54Z"
tags  : ["software", "stupid"]
---
Wow.  Bugzilla.

I recently complained that it was obnoxious that I had to upgrade Bugzilla just to be able to search for bugs that had no open blockers.  "Gosh," I thought, "Isn't that some of the most important data you could get from you work order system?"

Still, it was more important to get the feature than to complain about it, so I decided to do both.  I upgraded our Bugzilla to 2.20 today, only to realize that I had been misled.  Version 2.20 made it possible to query for bugs with no blockers, but not to ignore blockers that had been resolved.  The crew on the Bugzilla IRC channel seemed to consider this a very complicated feature to implement.

I was worried for my sanity, because I'd just spend half an hour or so looking through some of the uppermost Bugzilla internals, where insane things are done with typeglobs (seemingly because the programmers don't understand the difference between runtime and compile time), do-file, and other sharp and rarely-needed tools.  When your application's code (not, say, it's supporting library-building library's code) contains "@::varname" more than two dozen times, you need to stop what you are doing right now.

Anyway, I dove in to try to address this problem, and made several false starts.  I finally gave up when I found a hash being stored in an array (and then saw the elements shifted off two-by-two into $key and $value); its keys were eval-able into regex that would match comma-joined tuples of query part descriptions.  Its values were coderefs that would alter in-scope lexicals, used as registers, to return values.  I felt it would be best to admit defeat and move on, because I was really getting scared.

This evening, though, I put on a brave face and went back into Bugzilla::Search and found a way to do what I wanted.  See, Bugzilla searches, these days, are translated into those stringified tuples I mentioned above.  The key is to make a tuple that does what you want.  The tuples are, if I recall correctly: (name, operator, value).  There was no name that corresponded to the query I wanted, so I looked around until I found it.  It turned out that they're stored in the fielddefs table.  I was feeling good about this, until I realized that the "name" was not just the CGI query parameter used to build the chart, but was actually the column name that would be put into the SQL directly.  "bugid" really put "bugid" right there in the SQL.  Since there was a "display name" column used to produce the description of the query in the dropdown, all I had to do was create a field named this:

    bugs.bug_status NOT IN ('VERIFIED','RESOLVED') AND bugs.bug_id IN (
      SELECT blocked FROM dependencies WHERE dependson NOT IN (
        SELECT b2.bug_id FROM bugs  b2 WHERE b2.bug_status NOT IN ('VERIFIED','RESOLVED')))

Of course, I had to extend the maximum length of the name field (from 64 characters), but with that done, everything is fine.  I tack the above onto my query string, followed by "==0" or something like that, and it works.

Yes.  The SQL snippet goes in the query string.

I think I'll go to bed, now, and pray to dream of Cthulhu, and not Bugzilla.
