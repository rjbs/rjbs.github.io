---
layout: post
title : "firefighting, friends, and flushing"
date  : "2005-02-01T03:10:00Z"
---
Thursday afternoon I moved our main production database from one server to
another.  We'd done that before, and it was a big hassle.  This time, I had
experience with the process, and I made a nice plan for how to do it.  I used
OmniOutliner, and I really got to see how much nicer OO3 is, even for simple
things.  The plan was pretty good, happily enough, but of course there were
complications.

Some were little things: making two MSSQL servers talk is not, for me, an exact
science.  I don't do it very often, and I think there are quirks that I don't
know about.  Other problems were the result of people relying on old Access
front-ends to work that were basically retired.  Those were easy to fix: I
pointed people at the new front-ends.  The big problem was the huge corpus of
Excel spreadsheets used to analyze data.

Excel has an "external database query" function, but it's really lousy.  See,
Excel is a good tool for simple data analysis, and it's very easy to use.  Once
you get data into it from an external source, it's powerful enough for most
users' simple needs.  The problem is getting the data in.  See, by default
"external database query" uses MS Query.

MS Query, in Excel, creates something called a QueryTable.  QueryTables are so
crufty that even the previous edition of O'Reilly's Excel VBA book said, "Don't
use these."  Worse, MS Query itself doesn't seem to have been updated since
Office '97 or so.  It can't access file DSNs that are unmapped drives.  It
won't even let you edit its associated DSN string.  Once you've linked to a
database on host A, good luck relinking to host B... with the GUI that is.
After much hair-pulling and gnashing of teeth, I found some horrible VBA-tips
site that pointed out that the DSN was accessible in the r/w "Connection"
string on the QueryTable object.  A little VBA-looping later and I had a macro
that users could run to update their queries.

Still, why must it be so hard to let users perform external queries?
Microsoft's official stance on MS Query seems to be, "MS Query is out of date.
Don't use it.  Instead, use ADO."  That's great; are they going to help Bob the
Physicist learn how to write VB and use ADO?

Most of the fires have since been put out on that, and this week I should be
able to move the rest of the databases.  It's a nice change of pace from the
Eternal Project I've been on for ages.  That project is sort of like a death
march with no urgency or goal.  That's how it's begun to feel to me, anyway.  I
have a feeling things are going to get bleaker before they get brighter, too.

I have a few other new things to do this week, one of which has me playing with
Crypt::CBC, which is fun.

On the topic of firefighting, there was recently a good bit of it done
downtown.  The print shop at the corner of Main and Broad caught fire and
nearly burned down.  Gloria said that when she drove by it later, the streets
were covered in a sheet of ice; the hoses' water had frozen on the ground.  I
went to the dentist on Friday morning, walking past the scene, and the streets
were clean.  The trees, though, were still encased in ice.

<center>
<a href="https://www.flickr.com/photos/rjbs/albums/72157594427572839" title="the alphagraphics fire, 2005-01"><img src="https://live.staticflickr.com/138/326725438_682c19f701_z.jpg" alt="the alphagraphics fire, 2005-01"></a>
</center>

Bryan came up this weekend.  He rolled in Saturday morning and stuck around
until last night.  We watched a bunch of Law and Order, played through all of
Halo 2 in co-op mode, and wondered where John C was.  John said he might come,
but didn't.  It was his loss; he could've played with the new toy Bryan gave me
for Christmas:

<center>
<a href="https://www.flickr.com/photos/rjbs/328829289/in/photolist-v4kz8-v4kuv-uUE1y-v4kjX/" title="unicron"><img src="https://live.staticflickr.com/144/328829289_672966814b_z.jpg" alt="unicron"></a>
</center>

Eric said, "What's a unicron?"  I was horrified at the question, and when I
explained he told me that he should be excused, because he's younger than I.
"Look," I said, "I'm not 400, but I know who Hamlet is."  What's wrong with
kids today?  It's not like I was expecting him to know some obscure charcter
like Frenzy or something.

Today I stayed home and did some planning for the rest of the week's work.  I
ate my hot dog (they had a cheeseburger big bite ready at 7-11, thankfully) and
finished off the diet soda.  Gloria and I watched the last four episodes of
Battlestar Galactica.  In the course of all this, there was trouble: our toilet
wouldn't flush properly.  I tried to clear it with a long bit of wire, and then
borrowed my parents' plunger.  None of this helped, so I called our landlords.
Around 19:30, one of them came by with a plunger identical to the one I'd used.

He started plunging, saying, "If this doesn't work, you can call a plumber on
your own."  I was pretty annoyed, because I had already done some plunging. Let
me say, though, that this guy really plunged the heck out of that hopper. There
was water splashing everywhere and all manner of strange noise came out of the
pipes.  I didn't see anything get unclogged, but everything is flowing properly
now, which is good.  Nobody should have to wake up in the middle of the night
and feel worried about using his toilet.

I have more to say, but now I think I'll turn in and maybe do some reading.
"Stealing Sheep" has remained a good read, although I'm getting through it very
slowly.  I almost picked up another Fletch book, but I'm going to wait until I
work through more of my current stack.
