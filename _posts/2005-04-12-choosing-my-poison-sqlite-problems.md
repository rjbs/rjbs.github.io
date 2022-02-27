---
layout: post
title : "choosing my poison: sqlite problems"
date  : "2005-04-12T13:34:35Z"
tags  : ["perl", "programming", "rubric", "sqlite"]
---
I really, really like DBD::SQLite, but I wish it didn't have such irritating little quirks.  I'm not sure how much of the problem is SQLite and how much is DBD::SQLite, but it drives me batty.  Here's today's example:

In Rubric, you can query for entries with a given set of tags, or you can specify you want exact_tags, and it queries for entries with /only/ those tags. I do that by using the normal "has these tags" query and then checking the number of total tags against the requested set.  It's simple, though maybe not elegant.

I had written the count-checking clause like this:

<code>(SELECT COUNT(tag) FROM entrytags WHERE entry = entries.id) = $count</code>

This should have worked, but with DBD::SQLite I kept getting the error that there was no such column as entries.id.  I'm fairly certain that the problem is that the subselect is not run in the context of the containing select, so it can't see the entries table against the tuples of which it should be comparing entrytags tuples.

I've had to code around this subselection bug once or twice before, and I was sick of it.  I saw there was a newer DBD::SQLite, so I updated.

Then another bug showed up.  In Rubric::User, I say the following:

<code>__PACKAGE__->set_sql(tags_counted => <<'' );
SELECT DISTINCT tag, COUNT(*) AS count
FROM entrytags
WHERE entry IN (SELECT id FROM entries WHERE user = ?)
GROUP BY tag
ORDER BY tag</code>

This has always worked fine, but with DBD::SQLite 1.08 it seemed to stop quoting usernames, so I get DBIx::ContextualFetch complaining that it's getting a non-numeric value.  I don't know just what's going on there, but something that was working now isn't.  Argh!

So, I just went back to 1.07 and rewrote my count as follows:

<code>id IN (SELECT entry FROM entrytags GROUP BY entry HAVING COUNT(tag) = $count)</code>
