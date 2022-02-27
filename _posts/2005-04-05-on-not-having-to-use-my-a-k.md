---
layout: post
title : "on not having to use my a-k"
date  : "2005-04-05T02:53:00Z"
tags  : ["perl", "programming", "rubric", "work"]
---
I've got to say, it was a good day.  I got to work and, after finishing my yogurt, I flipped through the bug reports and feature requests on de.lirio.us and put them on my to do list.  There's a user named era who has really been cranking them out.  I ended up with fourteen line items for Rubric and felt somewhat intimidated by the fact that my to do list was half-full at eight in the morning.

Work started off badly.  Sales wan't interested in John C's neat-o CRM system that he showed me over the weekend, and I was frustrated by trying to work on One World cases.  Then I had to fix some problems with an Access ODBC problem, which led me to find more missing features (or at least obfuscated and undocumented ones) in Access's object model.  Then I couldn't figure out why I couldn't get FTP working through the firewall.  (It doesn't help that the Windows XP ftp client doesn't do passive mode.)

Things got more fun around half past two, when someone in the lab discovered that one of their critical little tools no longer worked.  It's something they use to calculate settings for some equipment, and it was written in BASIC.  I got it almost working, despite new and draconian security policies, before obtaining permission to rewrite the darn thing.  Actually, it wasn't that I got permission.  I was trying to, when my boss said, roughly, "Well, can I ask you to rewrite that?  Would you mind?"

Mind?  Heck no!  It was something new to do, which I'm short on, at work, lately.  It took me about nintey minutes, mostly because of this bizarre expression (munged):
<pre><code>	X = ((1 / XINV) - (LOG(X))) / LOG(10)</code></pre>

Clearly, I thought, the parentheses are wrong!  The author wanted x log 10! The program was being used, though, so I went with it.  The results were wrong, and when I changed it to do what I thought was natural, it worked.  I don't know if the compiled program was from a different source, or if BASIC quietly ignores parens.  Either way, it was odd.

Maybe tomorrow I'll rewrite the configuration tool for that program.  It should only take a few minutes to make it use YAML, like the other engineering software.  Huzzah!

I listened to more Life of Pi on the way home.  I really enjoy the writing and reading, but I'm a little tired of the constant theme of "and that's why all religions are the same and compatible!"  Maybe it's just these recent few chapters, though.

Once home, I watched Venture Brothers.  Brock killed two men with his bare ass.

I started in on my Rubric todos, taking just two little breaks: one for the totally awesome paella that Gloria made, and one to take the piggies into the library and watch them play a little.  It was awesome.  The three of them ran around, mostly playing follow the leader.  They jumped and squeaked and ran and fell over.  They are the best.

My daily accomplishments chart shows that I spent about three hours on Rubric, and finished all but five of my goals.  This isn't so bad, given that four of the five that I didn't complete were big silly overarching things like, "rewrite the way stashes are passed to templates" and "refactor the configuration file."  They're both easy, but they're not ten minute jobs.

Well, but then again, they should be.  Maybe tomorrow I'll try to one-up myself.
