---
layout: post
title : all bug trackers suck (bugzilla sucks most)
date  : 2005-10-07T13:34:10Z
tags  : ["bugzilla", "software", "stupid"]
---
Actually, I'm sure Bugzilla is better than some things.  I wrote a ticket tracker at IQE.  I think most small business programmers write a ticket system at some point.  Mine was sort of complicated, in a good way.  If the code hadn't sucked, I'd release it.  I think I'd like to get really good with RT instead, though.

Anyway, I hate Bugzilla.  We use it at work, and it utterly blows.

I wanted to change my normal search for "what should I do?" to exclude blocked bugs.  I can't work on them, so don't show them to me.  Well, none of the search options seemed to make this work.

"where bugs this depends on is equal to ''" eliminated nothing.

"where bugs this depends doesn't contain regex \d" eliminated way too much.

Other likely candidates failed.  Finally, I found the Mozilla IRC channel, where I asked about this.  I was told to make a positive search: "where bugs this depends" contains something, and then mark that boolean condition as "use negation."

"Thanks," I said, "but now I'm just more annoyed that I can't just search normally with the existing tools."

"Well," says the guy, "there's a patch to search for a field being empty, but the right way is to chart the search logic if you are doing fancy stuff, and that means you use the negation feature."

So, in Bugzilla, wanting to know the bugs you can actually work on is "fancy stuff."

FYIQ.
