---
layout: post
title : "bible references, red bull, reading books, being relaxed"
date  : "2005-01-16T18:10:00Z"
---
I just got back from 7-11.  Gloria is having lunch with one of her fellow instructors from the gym, so I decided to slum it up and get a hot dog.  This is also what I did last week when she was at a kickboxing workshop.  I got a "spicy italian sausage" and a can of Red Bull.  The sausage was pretty good, although a little greasy.  It would've been good if patted dry and impaled on a stick.  I had an empty water glass on my desk, so I poured my red bull into it. This was the first time I've really seen red bull, as I usually drink it right from the can.

I had expected it to be a horrifying glowing off-green ichor, but it wasn't. It looks sort of like ginger ale or a pale Irish whisky.  I don't think I'll pour it much in the future, though, as its bouquet isn't really very good.  It smells sort of artificial, which isn't surprising.

The thing worth noting, though, is the amount of red bull in a can.  It's 8.3 ounces, which was enough to fill my glass to its normal level.  Most sodas are now bought and sold in twenty ounce bottles, and have about as many calories per ounce than red bull.  I wonder how many people would really still be thirsty for soda after drinking an eight ounce can, and how many would be fine with water, their desire for sweetness satisfied.

I haven't really consumed much soda in the past year or so, now.  Now and then I have a diet soda, and very occasionally I have a soda at the movies.  It's OK now and then, but I can't imagine consuming the amount of soda I used to, and that many people still do.

Yesterday, Gloria and I saw House of Flying Daggers.   It had some good fight scenes and beautiful photography, but it wasn't really amazing.  The story didn't really grab me, I guess.  Before the movie, we stopped into the grocery by the theater and picked up a (twenty ounce) bottle of Diet Cherry Vanilla Dr. Pepper.  It was pretty good.  The vanilla made the cherry taste very mellow, and I wouldn't mind drinking it again once in a while.  I think I drank most of the bottle, and I think it was a little more than I'd want.  Maybe it'll be in cans at 7-11 soon.

Now that all our entertainment software is shelved, we're looking at our book situation again.  We have more books than we have shelving room, or at least enough books that shelving everything is not practical.  We'll definitely acquire a new bookshelf sometime in the not-too-distant future, but in the meantime, there are still some piles.  I poked at some of them today, making a "reading now" pile, a "read soon" pile, and a "finished" pile.

Reading now:
<ul>
<li>America: The Book</li>
<li>Reading Rilke: Reflections on the Problems of Translation</li>
<li>Gödel, Escher, Bach</li>
<li>The 7 Habits...</li>
<li>Notes from Underground</li>
<li>On Free Choice of the Will</li>
<li>John Betjeman's Collected Poems</li>
<li>The Brand You 50</li>
<li>Stealing Sheep</li>
</ul>

To Read Soon:
<ul>
<li>Fletch</li>
<li>Eats, Shoots & Leaves</li>
<li>The Wrestler's Cruel Study</li>
</ul>

I need to read fewer books at once!  I'm thinking that it should be easy to use Rubric to keep track of what I'm reading with some console tools.  I can tag books with 'todo' or 'inprogress' and update them now and then with status. Then I can check modification against creation and see if I'm letting the book collect dust.

Speaking of Rubric, I got the query engine redone and now redone again (sort of), and I think 0.04 will be done soon.  I need to prove out the "create users when needed" stuff, so that when a domain user is already authenticated through HTTP, but has never used the rubric before, Rubric can just create an account for him when he connects.  It should be easy, and that's the last todo left for that release.

I thought I'd get that done, today, but instead I decided to work on something else.  I've been thinking that it would be keen to use something other than a URI as the optional unique key for an entry, and one thing that came to mind was bible verses.  I've been thinking about having "John 8:32" tagged as "truth freedom" with a body that contains my thoughts on it.  Shawn S. asked why I wouldn't use a tag "jn8:32" and the answer was that users might write their tags in different ways.  With an object to replace the Link object, the user's entry can be canonicalized (no pun intended).

Toward that end, or at least because it got me thinking, I've started playing around with Religion::Bible::Reference, now headed into the CPAN.  I'm all over the place on the internal implementation, but it mostly does what it should for now, and I think it'll get better quickly, and then won't need much updating. I've thought about iterating over ranges to do something like this:
<pre><code>	for (bibref("num2:50-2:2")->verses) {
		print $bible->get_verse($_);
	}
</code></pre>

It's made me long for Python or Ruby's iterators.

Still, I'm having fun, which is good.  Now, back to bible hacking.
