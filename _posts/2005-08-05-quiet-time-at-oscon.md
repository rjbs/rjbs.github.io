---
layout: post
title : "quiet time at oscon"
date  : "2005-08-05T18:30:17Z"
tags  : ["oscon"]
---
Well, frankly, I haven't had much.  That's not so bad, really, it just means that my time has been densely packed with activity.  In previous years, I've had good journals of my activity: I'd go to my hotel room at the end of the night, write down what I'd done, and crash.

This year, I've been getting back to Paul's only when completely exhausted, then getting up and going right in and to a session.  This helps me know I'm getting work's money's worth, but I'm definitely ready to get back home to my usually relaxed routine.

I'm also ready to get back to the gym.  I'm not sure, but I think I've put on about six pounds here.  I know I can shed those quickly once I'm not eating two almond croissants for breakfast daily, but it's still a little disconcerting. Too much good food is a little bit scary.

I've had a lot of good time chatting with the usual crowd, as well as some people I've never seen before.  I really like the Perl community, and I should try to see if the Python, Ruby, etc. communities are as cool.  The Lisp community certainly seems so.  Maybe I'll find out when I finally write a little more Python, Ruby, and/or Lisp.

I also picked up two Prolog books that Ovid recommended, so maybe I'll even find out what the Prolog community is like.  (How much Prolog community is there, beyond Ovid and Luke?  I bet I'll be scared when I find out.)

I haven't gotten as much hacking done as I would have liked, which is always the case for me.  I think it's the case for most people who come to these things, but I always want to be more like the insane hackers who manage to be at every good dinner out and also write a few thousand LOC and solve a few major problems before breakfast.

I ported Test::Builder to Python, which was very simple, but helped me remember a few things I'd forgotten.  It will work correctly as soon as I find out how emulate END{} or possibly make object destructors work properly at the end of runtime.  As it is, I have an object that has an object with an important destructor (the builder has a plan).  The destructor is called if I make sure the object is destroyed before the program exits, but it doesn't seem to happen during global cleanup.  More on that later, anyway.  If you know Python and want to help me learn a little, drop me a line.  (I think I need to use atexit.)

I did a little more Kwiki hacking, and I think I helped mako123 bust a little bug that was in the way of Kwiki::ToDo.  If I stay awake and alert, and my laptop does the same, I'll try to do a little more Kwiki hacking on the way home.  Maybe.  (I've seen Ingy around a few times, but I haven't felt like bugging him about Spoon.  Maybe later, maybe via email.)

I will surely have some more to say about the whole week later, but for now: it was a good OSCON. 
