---
layout: post
title : "ical glue trouble"
date  : "2004-05-29T20:23:00Z"
tags  : ["code"]
---
Why does this work: <pre>   tell application "iCal"<br />
<pre><code>  tell last calendar<br />
      make new event at end with properties {summary:"foo"}<br />
    end tell<br />
</code></pre>

    end tell </pre>

But not this: <pre> use Mac::Glue qw(:glue);<br /> <br /> my $ical = new Mac::Glue "iCal";<br /> <br /> my $calendar = $ical-&gt;obj(calendar =&gt; gLast);<br /> print $calendar-&gt;prop("title")-&gt;get, "\n\n";<br /> <br /> $calendar-&gt;make(<br />   new =&gt; 'event',<br />   at  =&gt; location('end'),<br />   with_properties =&gt; { summary =&gt; "foo" }<br /> ); </pre>

