---
layout: post
title : "rubric now running under fastcgi"
date  : "2008-05-12T02:58:29Z"
tags  : ["lighttpd", "perl", "programming", "rubric", "web"]
---
In case anyone has been thinking, "Gosh, I haven't seen anything from rjbs
lately," the reason is ridiculous.  It's not that I've been busy (but I have)
or lazy (but I am).  It's that I've been stupid.

When I relocated some of my hosted services to Linode (who, by the way, are
awesome), I decided that running Rubric as a CGI script was insane.  It's
always been slow and inefficient, and I knew I could make it much, much faster
by making the process persistent.  On my previous host, where
[TIMS](http://thisismystation.com) also ran, I saw how much faster Rubric could
be under mod_perl, but I had some minor problems and wasn't interested in
futzing with Apache, which I vaguely dislike.

On my new host, I switched everything to lighttpd, and I figured I'd use
FastCGI.  I thought this would be trivial, but the state of the art for moving
CGI things to FastCGI seemed to be lousy.  Someone finally pointed me at Stevan
Little's fantastic FCGI::Engine.  It did exactly what I wanted, making Rubric
work with no code changes at all... or so I thought.

First, query parameters stopped changing.  The first query to hit the daemon
would have its `QUERY_STRING` parsed and nothing else would ever get looked at.
I fixed that by shoving an `initialize_globals` call in Rubric's run method.
Things seemed alright until I tried to log in to post.  No matter what, HTTP
POST requests were coming through with no content.  I stared at it until I gave
up, and then I couldn't post anything new because I couldn't log in.

That was that, until tonight.  I checked on my Hiveminder todo list and saw 78
things to do.  (Good grief!)  The second one is a reminder to get new App::Cmd
stuff done by a week ago, and I thought, "Gosh.  I should get that done, and
then post an explanation of why the changes are so good."

Then I thought, "I can't post anything new, my Rubric won't let me log in!"

Then I thought, "I need to fix Rubric under FastCGI before I start on any of
the other 78 things in my todo list."  I guess this is a story about being
lazy and busy, too.

I resorted to looking through the source of Rubric, CGI::Application, FCGI,
FCGI::Engine, and other things.  I finally noticed that FCGI::Engine passed a
CGI::Simple query into the code it called -- a fact that was not documented.
Once I added the dozen-or-so characters needed to tell Rubric to use that query
instead of a newly-built one, everything just worked.  Awesome!  Once again, it
goes to show that reading the source is always a good strategy.

I've filed a ticket suggesting that the docs should mention the parameter.

Now I need to get to work posting old news!

