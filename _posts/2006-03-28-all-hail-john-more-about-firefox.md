---
layout: post
title : "all hail john! (more about firefox)"
date  : "2006-03-28T17:16:18Z"
tags  : ["firefox"]
---
This is part two in my "All Hail" series.  John C. is my friend and coworker, and he knows a lot more about Firefox than I probably ever will.  He wrote Wikalong and a few other neat XUL-based geegaws.  He's the one who helped me figure out what extensions to start with when trying to emigrate from OmniWeb. (I think I've since repaid him just a little by getting him to use Tab Mix Plus.)  Even though John is, incomprehensibly, considering moving away from Bethlehem: All hail John!

I complained, in an earlier entry, that I was going nuts because Firefox didn't have "up" mapped to "start of line" or, worse, "shift+up" mapped to "select to start of line."  Today I pulled up my platform bindings file to add them, thinking it would be easy:  I'd added the emacs-y bindings, and it was dead simple.  I added them, but then much to my surprise I saw that they were already there, a bit further down.  Despite that, they just didn't work.  I tried a bunch of other related bindings, and they all worked fine.  Firefox happily respected all the bindings except for the two I was hoping to use.

After some grumbling, I handed my laptop to John, who poked at my bindings, then at his Firefox.  In short order he declared, "It's got to be form autocompletion; that uses the VK_UP and VK_DOWN events on all input boxes."  I would have never thought of this without having to ask grumpy Firefox developers or use some sort of horrible event debugger!  I disabled form completion and the keys worked (not in the URL bar, but that's no big deal), and there was an added benefit:  no more obnoxious form autocompletion, which I just hadn't bothered disabling yet.

Every time a form asked for my email address, it would try to suggest I use an email address I'd used for some other side; then, to add insult to injury, I couldn't just hit shift-up to select it and overwrite it! 
