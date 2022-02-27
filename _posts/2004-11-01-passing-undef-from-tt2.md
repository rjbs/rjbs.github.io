---
layout: post
title : "passing undef from tt2"
date  : "2004-11-01T17:34:00Z"
---
url: http://template-toolkit.org/pipermail/tt3/2004-March/000050.html

It makes pretty clear the reason behind a problem I was having Friday.  I wanted to include some objects from a search in a template, doing something like this:
<pre><code>	USE helpdesk = Class("Helpdesk::Cases");
	cases = helpdesk.search(
		zone => 'IT',
		time_closed => undef
	);
</code></pre>

It seems, basically, that I just can't pass undef.  TT2 doesn't support the idea of undef, so it gets turned into an empty string.  I tried a few tricks, but nothing really helped.  I'd rather not have to write methods in the called class, although I suppose I could do something tricky in the class between all my classes and Class::DBI, filtering input before calling SUPER::search.

Is there some clever trick people are already using for this?

