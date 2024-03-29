---
layout: post
title : "selenium depression"
date  : "2007-08-07T22:20:25Z"
tags  : ["programming", "testing", "web"]
---
I've been hearing such awesome things about Selenium for so long that I finally
decided I had to get into the game.  It helped that we had some code that
seemed like it would greatly benefit from testing with Selenium Remote Control.

We have an online message composer at work, powered by Asbru Software's [Web
Content Editor](http://editor.asbrusoft.com), which is pretty darn cool.  It
works by using the in-place HTML editor in your browser.  Our site uses this
automatically if and only if you are using a JavaScript-enabled browser that
seems compatible with it.

We had some problems with this feature, and we wanted to do some testing of it,
but since the form only lets you use the WCE if you've got JavaScript,
WWW::Mechanize wasn't going to be an ideal tool.  I said, "A-ha!  This looks
like a job for Selenium!"

I installed Selenium RC and Test::WWW::Selenium, and encounted my first
problem.  The server would hang at "starting Firefox."  Eventually I found out
that this was a known bug with Firefox 2, but was fixed in a dev snapshot.  The
stable release, though, is nearly a year old.  This seems like the kind of bug
that you really shouldn't leave in the wild for that long.  (I was later told
that the Selenium development community is schisming and not producing code,
but as far as I know that's just a rumor.)

Rather than install the snapshot, I installed the previous release, and it
worked just fine.  I giggled like a schoolgirl as I watched the a Firefox
window flip through web pages while a terminal window slowly displayed the TAP
output.  It was awesome.  I called over the boss and said, "Look!  We are
destined for success!"  She humored me and said, "That's great."

Once I hit the page with the WCE in it, though, I was stumped.  I tried sending
keypress events, I tried using the `type` method, I tried changing the contents
of innerHTML.  Nothing seemed to help.  I consulted with others who've used
Selenium more than I.  I've tentatively come to the conclusion that the
in-place HTML editor is deep voodoo, and not easily altered by Selenium.  (I am
going to do some more investigating on this front, though.)

From start to finish, this process took me about two work days (with some of
that time going to the usual distractions of bugs, questions, and so on).
Finally, unwilling to finish day two with no progress, I went back to good ol'
Test::WWW::Mechanize.  See, our problems have always been with post-processing
the produced HTML.  After all, the HTML given to us isn't even under WCE's
control, it's just generated by the remote browser and submitted to us.  WCE is
all sugar (though very delicious sugar) around that.  I could beat the website
into submission and force all our in-Mason post processing to fire, JavaScript
or no!

With some creative (well, not very) abuse of HTML::Form, I convinced the site
to let me use the WCE, and then just abused HTML::Form some more to submit my
own pre-rolled HMTL.  In ten minutes I'd done what I couldn't with two days of
Selenium.

What a depressing failure this effort was!  I don't really blame or discount
Selenium because of this.  I know now how to use it, and I'm really excited to
do so in the future -- or at least to use whichever fork or replacement ends up
being supported by Luke C.  I just wish that I'd ended up with a total success.

