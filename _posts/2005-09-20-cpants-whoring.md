---
layout: post
title : "cpants whoring"
date  : "2005-09-20T03:21:07Z"
tags  : ["perl", "programming"]
---
I think the preferred term is "gaming," but I don't feel the need to whitewash it.  I am a kwalitee monger.

I had a little Querylet-based report on the CPANTS data that I used to run to see how my distributions were doing; in generaly, I did quite well, and usually ranked in in the top five or ten authors.  Mostly I lost out on "your code must be required by other people," but that's ok.  I don't expect many modules to require, say, Games::Nintendo::Mario.  (It would be neat to see something use it, though, and might motivate me to get around to adding more data to it.)

Domm threw up a neat little front-end to the data, though, and I went back to see how I was doing.  Overall, things looked fine.  One or two dists of mine had a failed test that I had already fixed in Subversion.  The big offender, though, was IPC::Run3.

I took over IPC::Run3 for work, while working with the Freeside billing system. Freeside is in many ways torturous, and I have thrown my hands up in the air many times because of it.  One of those times, however, Freeside was not directly to blame.  It used IPC::Run3 to run some external programs, and IPC::Run3 basically would not function under the debugger, because (if I recall correctly) it would, under certain conditions fail to import a module, a routine of which it was using as a bareword.  So, it would (as Adam might say) "not be Perl under some conditions" and it would fail to compile.

It was sort of an irritating Heisenbug, and I really needed it to go away, because not being able to use the debugger was a serious problem for me.  I asked whether the maintainer would update it, and ended up becoming the maintainer.  (Dear Reader, are you interested in taking over?  I'm done with it.)

I got my changes made and uploaded, and didn't give a second through to the fact that it had broken POD, had no pod-coverage.t (I hate that Kwalitee test), and had no README.  I've fixed all of these, although the POD coverage is pretty lousy.  I've added a lot of blank stubs, but at least now all the methods are enumerated, if not always described.

I enjoy whoring for Kwalitee points.  Maybe once I get a smoke system set up at work, I'll look at getting a custom Kwalitee smoker, too. 
