---
layout: post
title : firefox quick searches
date  : 2005-01-13T14:51:00Z
tags  : ["firefox"]
---
At the LUG meeting on Tuesday, I saw that Brian R. was using the Google bar in Firefox.  It's 2005 and people are still using the Google bar!  The guy giving the presentation had the default Google widget still on his address bar.  Why is that damn thing still there?

Because people don't know about quick searches and keywords.  I've mentioned them before, but only in the context of importing to them from OmniWeb.  Here's an explanation for Brian and everyone else who's wasting time with trivial search plugins to Firefox.

Go visit Google and search for something.  I'm going to search for "rjbs" because I'm egotistical.  Google generates this URI for the search:
<pre><code>	http://www.google.com/search?ie=utf8&oe=utf8&q=rjbs
</code></pre>

It says "search for the query 'rjbs' with the input and output encoded in UTF-8."  (I have notes on all of the parameters, but more on that another day.) 

I'll be really egotistical, now, and bookmark that search.  I'll hit Ctrl-D (I could just go to the Bookmark menu and take "Bookmark this page" but I don't like clicking) and then click OK to save the bookmark.

Now, when I'm curious about what's going on with my name, I can go click that bookmark.  Of course, that's sort of silly, so I can take that bookmark and make it more useful.  In the Bookmarks Manager (in the Bookmark menu) I can find that bookmark and bring up its properties.  Here, I see more fields than there were before, including one called "keyword."  If I give a bookmark a keyword, I can use that word to open it.

So, if I wanted to make this bookmark sillier, I could give it the keyword "rjbs" and then just type "rjbs" into the address bar.  It would open this bookmark.

I'm going for /less silly/, though, so I'm going to make this sort of an abstract bookmark.  In the Location field, I'll replace "rjbs" with "%s" so the Location looks like this:
<pre><code>	http://www.google.com/search?ie=utf8&oe=utf8&q=%s
</code></pre>

I'll give the bookmark the keyword "g".  If I type "g" into the address bar, now, it searches for "%s" -- a pretty useless search.  The magic is that I can type more /after/ the "g" in the address.  So, to search for myself, I go to the address bar and type "g rjbs".  Firefox replaces the magic "%s" in the Location field of the bookmark with everything after the space after "g" and that turns it into a search for rjbs.

I can type "g hot pants" or "g mini site:apple.com" and get those searches.

So far, this saves you no keystrokes.  Now you're hitting Ctrl-L, g, space to Google instead of Ctrl-L, tab to get to the Google box.  The great thing is that this is obviously not a Google-only approach.  I don't need some goofy drop-down with my search engines, either.  I just need more bookmarks.  Here are some that I like:
<pre><code>	keyword: imdbt
	address: http://www.imdb.com/find?tt=on;q=%s
	purpose: "imdbt Stripes" finds IMDB data on the Murray/Ramis classic
</code></pre>
<pre><code>	keyword: dist
	address: http://search.cpan.org/dist/%s
	purpose: "dist Rubric" finds the information on my Rubric package
</code></pre>
<pre><code>	keyword: nf Hackers
	address: http://www.netflix.com/Search?v1=%s
	purpose: lets me find and enqueue a movie with Angelina Jolie's boobs
</code></pre>

I keep all my search bookmarks on my site for future reference; they might be helpful examples:
<pre><code>	http://rjbs.manxome.org/links/search.html
</code></pre>

These are generated from my ow5sh script, using my OmniWeb shortcuts, which are like Firefox's quick searches.  That script is also around:
<pre><code>	http://rjbs.manxome.org/hacks/perl/#ow5sh
</code></pre>

You don't need to worry about generating these URIs yourself, though.  If you right-click in a form field in Firefox, you can usually pick "Add a Keyword for this search..." and it will do all the work for you.  How cool is that?

Basically, if you search someplace often, or use a well-defined URI structure often, you can turn your typing into one of these quick searches and save yourself a lot of time.  Google barring is so 2001.

