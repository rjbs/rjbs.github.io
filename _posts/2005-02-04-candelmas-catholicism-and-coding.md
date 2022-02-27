---
layout: post
title : candelmas, catholicism, and coding
date  : 2005-02-04T04:33:00Z

---
I haven't been to Mass in quite a while, and I got to thinking that it's a pretty good time to try to start going again.  Tuesday night while Gloria was at yoga practise, I walked over to St. Anne's and checked out the schedule. The church was closed, but I copied down the contents of their display board.

It always strikes me as a little weird that I can't just walk into the church at any reasonable hour.  Or maybe they figure that 19:30 isn't a reasonable hour.

So, I headed back the next morning for Mass.  It was Candlemas, which I'd never seen.  The Mass was pleasant, although a little off, and the blessing of the candles was totally unexciting; I still enjoyed it.  With only the first four or five rows of pews occupied, though, I think the priest could've gotten away with skipping the microphone.

I'm trying to feel more motivated to feel motivated, and to avoid the meta-work yak-shaving that often robs me of both time and energy.  While looking for some information on the church calendar, I found this site:
<pre><code>	http://www.easterbrooks.com/personal/calendar/index.html
</code></pre>

It's very cool as far as the data goes, but it's not my favorite thing to look at, and I'd love to have the data available for general use.  I emailed the owners of the site, asking for the underlying data and promising to release tools to the public domain.  I'm really hoping to hear back soon, and I'm especially hoping to get the data.  I think I will be sad if they say no.

In the meanwhile, I'm working on Religion::Bible::Reference again, trying to bring its range parsing more into line with useful ranges.  Before, I handled "John 3-4" and "John 3:4-5"; then I changed things to accept "John 3:4-5,3:7-8" but what's more common is "John 3:4-5,7-8"

I didn't want that to read as "book three, verses four through five; also, books seven through eight" so I'm giving up on some other cases to handle the ones I care about more.  It's this sort of work that really makes me feel like a lousy programmer.  I'm not very good at parsing, and I basically don't write serious algorithms.  I need to make a serious effort to learn these things before I become unable.  Lately, I feel I am growing stupider every day.

Still, I made some decent progress with the code tonight.  I'm not happy that I'm going to have to leave it with failing tests, but I'm not going to stay up too late to fix it.

In other news:  "Stealing Sheep" is still a very enjoyable read, and makes me feel enthusiastic about going to church (and I am hoping that actually going to church will not ruin that enthusiasm).  I moved more databases at work, and everything went well; I am really getting to love using OmniOutliner to make my plans.  Saturday I will go see Queensryche play in Philly.  (Is there a "yuml" HTML entity?)  Wednesday I will go to Trevor's to watch the premier of the original Battlestar Galactica series on DVD.  In late April I will go to Gloria's sister's wedding -- but I got the tickets today.

