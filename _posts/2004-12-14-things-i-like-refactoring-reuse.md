---
layout: post
title : things i like: refactoring, reuse
date  : 2004-12-14T19:43:00Z
tags  : ["perl", "programming", "xp"]
---
Refactoring code is the best.  By making a promise to myself to refactor (mercilessly), I can get my code written quickly,  It isn't beautiful, but it works.  I get to write lots of code.  Then, when it works, I get to go back /and write it again/!  Not only that, but I get to make it better.  Then, because it's better, I can use it to do more things, which I code quickly, and then get to re-code.

"I will show less mercy in my refactoring" would be a good New Year's resolution for any programmer.

Also fantastic is having a really, really nice set of tools at one's disposal---and not just that*, but knowing how to use them.  It's also nice to see unintended ways to use them, although that's not as easy a skill to acquire.  The more I write code, lately, the happier I feel as it takes fewer and fewer words to say what I mean.  The clarity of the code feels like it enhances the code's meaning, like a haiku.  As in a haiku, the utter simplicity of the image is, itself, complex and profound.  (I realize that I am no Basho of coding, but I am feeling less like a Bukowski.)

I rewrote some ugly parsing code, today.  It reads my blog entries, pulling out the "name: value" headers and the body, and does some processing on the values. It was darn easy to replace with Email::Simple, which is now going to show up in a lot of my non-email code.  Config::Auto keeps teasing me with ideas for improvements that I can't quite put my finger on.  I know I can do something simpler with SQL::Abstract to Rubric's most important search method tiny.  And maybe it's time to get back to Querylet and GutenbergRoget?

Last week, I was feeling bad about coding.  I am feeling good, today.  I think I just needed some positive re-enforcement.  Halo 2 co-operative might have helped, too.  I wish I could play co-op online!

[*] Another resolution: I will try to stick to just one way of writing em-dashes.  Probably \w---\w, as in LaTeX.

