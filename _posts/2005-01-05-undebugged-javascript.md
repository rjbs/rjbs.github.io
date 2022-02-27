---
layout: post
title : "undebugged javascript"
date  : "2005-01-05T21:25:00Z"
---
It makes me sad that MSIE has no useful JScript debugger.  There's a debugger, but it's horrible and approaches useless.  There's also no equivalent to Mozilla's DOM Inspector, which is wildly useful.

Because of this, I tend to write my JavaScript code while debugging and exploring with Firefox.  When it works, I take it over to MSIE to see how much I need to tweak to make it work.  That part of the exercise is torture, and involves a lot of trial and error and blind flying.  One good thing about it is that I tend to learn a number of ways to solve any one problem: the first three ways don't work in MSIE, but the fourth does and once it's working I know a bunch of new things about JavaScript.

I wanted to get some things done at work that have been shelved for a while; basically, I needed to tie together a few of my previous JS hacks to make a single dynamic form for creating semiconductor specifications.  (I'm simplifying, here.)  I needed a form that could have a variable number of entries providing attribute/value pairs, and I needed the value input widgets to be appropriate to the attribuet being entered.  So...
<pre><code>	http://rjbs.manxome.org/hacks/js/all_together.html
</code></pre>

It should be refactored and made easier to build from parts.  Right now, a lot of the JS is in the template for the production version of that form.  Still, it works.  It started working around quarter to two, but only in Firefox and Safari/OmniWeb.  MSIE quietly ignored the "(other)" option on the combo box. This was weird, since my combo box code worked in MSIE.

I spent the next two hours poking around, and I determined these things:  MSIE will not (but other browsers will) respect this kind of code:
<ol>
<li value="selectElement">setAttribute("onChange","function_name(this)");</li>
</ol>

MSIE will not, as far as I can tell, let me setAttribute a function to onChange or onchange, either.

I can create an event listener and attach it to the object, but I need to produce a fair amount of code to do that, because the MSIE event model is different from the DOM2 model.  It struck me as overkill to write twenty or thirty lines of code to say "attach X to event Y on object Z."

MSIE will respect code like this:
<ol>
<li value="selectElement">onchange = function() { function_name(this) };</li>
</ol>

So that's what I did.  There was a point in my groping around that I tried to use a generator to produce that function, but it didn't work.  I may try that again, later, when I'm cleaning things up.

The more JavaScript I write, the more I enjoy writing it.  I also get more annoyed with its strange quirks, which I should write down.  Of course, given that my use of JS is so minimal, the quirks I see are probably nothing compared to larger-scale issues.  Here are two simple ones:

It blows my mind that replaceNode is called with (newNode, oldNode); it seems like a mistake to not take (oldNode, newNode) because the comma could then be read or thought of as "with."

The behavior of the for/in loop is horrible.  Given an object, it loops over properties.  Given an array, it loops over indices (not elements).  Given an object that "acts like an array" it loops over properties.  Really, all the objects that are supposed to act like arrays suck.

