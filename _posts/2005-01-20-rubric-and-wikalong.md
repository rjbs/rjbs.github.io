---
layout: post
title : "rubric and wikalong"
date  : "2005-01-20T03:05:00Z"
---
My friend John wrote Wikalong, an extension for Firefox that lets you share a little margin for the webbernet.  Basically, when you go to a page, you get a wiki page that's associated to the URL.  (I feel proud to be the person to first call it a wiki-margin for the intarweb.)
<pre><code>	http://www.wikalong.org/
</code></pre>

When John was first working on this, the first thing I thought of was, "It would be really cool if you could point it to a different wiki and take notes just with your friends."  Of course, John had already done this.

Recently, though, he showed off a way to point it to a web IRC chat, and it would drop you in a channel for the web page.  When he was here last month, I spiked out a little interface that made Rubric into a viable backend for Wikalong.

Now John has finished some changes I'd wanted put into Wikalong, so I made another pass at it.  He helped me get a Rubric installation set up on his server, and then I putzed around changing colors and fixing bugs.  I did a good bit of the bug-squashing while skyping with him.  That was productive, and we'll have to do it again.  I found a number of silly errors in the new query builder in Rubric, and I hacked in a lousy (but operational) error system.

Before, an invalid query part was dropped.  Now it will kill the query before it runs.  In other words, "{ user => 'fake_username' }" used to get dropped and all users' entries were listed.  Now, it immediately knows to return nothing.

I'll make it return a useful reason later!

I feel pretty good about the changes, and I should be able to get some more things done this coming weekend.

While I was hacking on Rubric, Gloria was driving to the gym, teaching yoga, and driving back.  It took her ages to get there and back due to the snow.  We got about three inches, I'd guess.  When she got home, we had cocoa and watched Project Runway.  It was amusing.  I am looking forward, though, to Austin being off the show.

Yes, that's right.  I have an opinion about who I wanted voted off the island. Ugh.

