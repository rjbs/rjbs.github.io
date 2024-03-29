---
layout: post
title : "extending my tolerance"
date  : "2004-12-07T04:16:00Z"
---
I really couldn't stomach the idea of working on the shipping system today, so I opened up the old bug list and looked around.  One that caught my eye was a stupid little bug in the CGI form parser for part of our requirements system. It was having trouble turning a field in the form "FLOAT - FLOAT" into a tolerance -- with Number::Tolerant, that is.

It turned out that the regex was just a little broken, mostly because I punked out and used some moronic off-the-cuff regex instead of lifting one from the perlfaq (or Regexp::Common, which I don't use much).  While in there, though, I realized that Number::Tolerant can handle "x <= 10" but not "x < 10" and other similar problems.  Basically, it had no way of excluding endpoints.  After consulting with some engineers, sadly, I found that this was required.

On one hand, this was a pain, because it required a good bit of poking and testing.  I had to spend a lot of time picturing the number line.  On the other hand, it was fun, because it required a good bit of poking and testing.  I got to spend a lot of time picturing the number line.

I got sort of hooked on getting the test coverage up, and I just got it to 100% a few minutes ago.  I know, though, that the code itself doesn't yet cover 100% of the problem.  I need to get the "to" tolerance working with one or more excluded endpoint, and to make the stringification of that make more sense, I'm going to rewrite stringification to be more algebraic and less English.  That's probably good, since most of the engineers try to write it with algebraic symbols, anyway.  (I always have to say, "For now, write 'or less.'"

Still, it's been nice to get some more work done on that.  It's been especially nice to open up a piece of software that I wrote months ago and not be full of loathing for the way it's done.  The Changes files says it's last updated in August, so that's a good spell.  I did get a little feeling, today, that I was reimplementing inheritance, badly, but I think I thought that last time, too. I'm not too worried about having to fix it, if that's the case, anyway.

After work, Gloria and I watched some TV, and she made a totally awesome Greek salad with lamb.  The smell reminded me of our Easter roast, and it was just great.

I played some more Halo 2, with Paul, who showed me the ropes on a few maps and game types.  It was a lot of fun, and made me more excited about playing Live with non-gamer freaks.  Paul is a Good Egg.  I also tried out Crimson Skies. I'd given it a go at a kiosk at a store, once, and it didn't impress me.  I'm sort of liking it, though, and dogfights against friends sounds fun.

I don't think there will be gaming this weekend; I'd been looking forward to it, but people have had plans change, so I reckon we will reschedule (to next year, it looks like).  I'm sure Gloria and I will find things to do.  (There's always Netflix.  Maybe I should re-order the queue with that in mind.)

It's pretty late, and I'm finally tired.  I'm going to sleep.

