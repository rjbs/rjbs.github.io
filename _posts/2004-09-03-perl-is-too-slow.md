---
layout: post
title : "perl is too slow"
date  : "2004-09-03T01:45:00Z"
---
...but first: an updated on my Apple Care.

I called back, ready to be bold and tell them, "A ha!  It IS within warranty, because the product line is less than a year old!"  I got cut off, "We don't offer phone support for that product, sir."

"I don't need phone support!  I need an RMA number.  It's mechanically broken."

"Use the web."

"You redid your support directory yesterday.  There is no generic repair request page."

"Use an Apple Store."

"They're far away."

"Use your local repair place."

"It's not convenient!  Just give me an RMA number.  It will take less time than arguing!"

So, he puts me on hold for twenty minutes or so, and finally says, "Well, sir, I can get you a case number, but I'll have to charge you $50.  When it's determined to be a hardware problem, though, we'll mark that non-billable and you won't get billed."

Right... well, buh-bye.  The mouse goes to Double-Click this weekend, and I demand satisfaction.

Now, back to the topic at hand!

Someone on the LVLUG[1] mailing list asked for a simple way to randomly play a bunch of ogg files.  His GUI players weren't working well.  Another guy volunteered a shell script which was, imho, pretty primitive.  I took the opportunity to show off Perl in its role as "better scripting" and produced this:
<pre><code>	http://rjbs.manxome.org/hacks/perl/#mprand
</code></pre>

To defend his honor, the shell script author produced a program to randomize its arguments and reprint them to eliminate the need for a playlist file.  It was written in C, 35 lines long, and... well, you know.  It was C!  I replied that this would do, in Perl:  print sort{rand()<=>.5}<>   [2]

Sure, it's lousy, but it works and took two seconds to think of and one more to write down.

"But Perl is too SLOW!" came the reply.  A little benchmarking showed one iteration of Perl to be .004 seconds slower than C.  Assuming it took ten minutes to code in C, it will only take 150,000 iterations for the author to regain his time.  When will people learn?  In almost all cases, to make shell scripts more cost-effective, reduce human time, not machine time.

[1] Lehigh Valley Linux Users Group

[2] Yes, that sorts input, not args.  When I switched to @ARGV, I was surprised that it was faster to join with "\n" than to change the value of $, -- I am not interested enough to research, but maybe someone out there wants to tell me...

