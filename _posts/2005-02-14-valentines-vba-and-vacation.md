---
layout: post
title : valentine's, vba, and ... vacation?
date  : 2005-02-14T20:29:00Z

---
It's Valentine's Day!  That's all I have to say about it so far.  Tonight, Gloria and I are going to go to Ichiban for sushi, and I am looking forward to it, especially after today.

I've been working on this Excel problem at work.  I wanted to make a series of timelines showing the events performed on a set of devices across the course of a day.  I managed to figure out what kind of data Excel needed to see, and got all the "hard stuff" done.  Now, though, Excel is crapping out on something really simple, and I just can't tell why.

I decided to make the duration a parameter, to make it possible to request a week worth of data.  This makes a table with 150 to 250 rows.  (The meaning of a row is sort of hard to explain, but it's roughly an event.)  Excel barfs if there are more than 255 rows, because it can't chart that many series.  The bigger problem is normalizing the color on the series.  I want to set the color for each series based on its event type, which is in the first column.
<pre><code>	for my $series (in $chart->SeriesCollection) {
		$series->Interior->{Color} = $color{$series->{name}};
		$series->Interior->{Pattern} = xlPatternSolid;
	}
</code></pre>

The problem is that this just doesn't work!  For small SeriesCollections, everything is fine.  When they're larger, it just fails.  The assignment of patterns and colors doesn't seem to cause any trouble, but it just doesn't do what it should.

In VBA, this code would read (modulo the lookup of colors):
<pre><code>	For Each series in ActiveChart.SeriesCollection
</code></pre>
<ol>
<li value="series">Interior.ColorIndex = 1</li>
<li value="series">Interior.Pattern = xlPatternSolid</li>
</ol>
<pre><code>	Next
</code></pre>

This code fails in the same mysterious way.  Even more strangely, if I run either of those loops twice in succession, the second run works correctly.  It is mind-boggling!  I don't want to just run it twice, I want to fix it!

This was the fun part of my day, and I spent about an hour and a half on it. I also made a nice little form in OmniGraffle.  The rest of my day has been an utter horror.

We're supposed to furnish data to a customer, and we build a little tool to query, format, encipher, and transmit the data.  Now we need to send some historical data that was created before the SOPs existed that ensure our data is easy to query.  It's been hours of tweaking and examining results to see whether we're getting ever edge case.  The people I'm working with are only semi-responsive, and in the end I'm not going to make my promised deadline, so I will look like a jerk.

Lesson learned (again): don't make promises you can't keep.  I said I would get this done today even if I had to key everything by hand.  I neglected to think about the fact that even my hand-keyed data would need to be reviewed, rejected, and revised.

I am ready to go home, relax with my wife, and eat some sushi.  It would be nice to stay there (home) for a few days.

