---
layout: post
title : coding and confusion
date  : 2005-05-25T01:58:14Z
tags  : ["perl", "programming", "rubric", "work"]
---
Today wasn't my best day for coding.  On the bus in I got password recovery on Rubric working.  That is, if you forget your password you can jump through some hoops to get a new one.  It's not quite working yet, though, and I didn't feel like working on it this evening.  Frankly, it's not a feature I care about much, as I can just update the database.  Some other users, though, want to be able to do this, and it seems like a useful request.  It's at least given me some reasons to do some refactoring (and some work on Rubric, in general), and that's good.

At work, I made a number of really boneheaded and strange mistakes.  Three times I caused stupid errors by reversing pretty obvious things.  First, I did something like "if spam, count as ham; if not spam, count as spam."  Then, "if true, false; else, if false, true."  Finally, "quotient = denomenator / numerator."

If I was replying to Andy's blog, I'd say something like, "I've learned that I need to be more mindful of seemingly trivial lines in my code, especially when that code takes an hour to produce test results." 
