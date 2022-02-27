---
layout: post
title : omniweb vs. firefox, round two
date  : 2006-03-25T15:37:18Z
tags  : ["firefox", "omniweb"]
---
I'm not sure if this is really round two, three, or what.  It's not the first time that I've made an attempt to quit OmniWeb for another browser.

Traditionally, the big things that kept me loving OmniWeb (roughly in order of importance) were:

1. native Mac OS feel (keybindings, etc)
2. saves windows and tabs between sessions
3. multiple window groups, somewhat like virtual desktops
4. zoomed editing
5. excellent tab system (not just the thumbs, but copy/paste, status, etc)
6. slightly superior quick search feature
7. per-site preferences

Yesterday, I decided I'd try to solve these problems in Firefox.  On the way home from work, I got my laptop working with John's GPRS phone and started installing the extensions he suggested.  Here's how I've done with Firefox, so far.

### native Mac OS feel

This is the simplest feature, probably, but the biggest deal-breaker.  If I'm used to using Emacsy keybindings in everything (except for, ironically, my text editor), I am not going to be enthused about using Mozilla-y keybindings for my browser.  I want to hit C-a to go to the beginning of the URL bar.

This was also one of the more annoying problems to solve.  I used [this helpful article][] from MozillaZine.  I found a lot of other advice, but this article was the only thing that seemed likely to work.  At first, it didn't.  In fact, it caused Firefox not to open properly again.  I think, in the end, that the problem may have been that I needed to use the `-0` switch when rebuilding `toolkit.jar`, but I'm just not sure.  I might have made some other mistake the first time or two.

[this helpful article]: http://kb.mozillazine.org/Emacs_Keybindings_(Firefox)

At any rate, C-a and C-k and C-u and others now work.  I wish up and down worked to go to start and end of line, but I think that will be trickier because of situations in which they need to be cleverer.  I'll worry about those, later.  C-a was the real blocker.

I also installed some other nice little extensions to help with the look and feel.  [Grapple (Eos Pro)](https://addons.mozilla.org/themes/moreinfo.php?id=1323&application=firefox) gives me a much more Mac OS-like appearance for Firefox.  [Stop-or-Reload Button](https://addons.mozilla.org/extensions/moreinfo.php?id=313&application=firefox) gives me a single button that toggles between stop and reload, depending on the loading state. [Fission](https://addons.mozilla.org/extensions/moreinfo.php?id=1951&application=firefox) replaces the status bar with a Safari-like color coding of the URL bar background color.

### saves windows and tabs between sessions

### multiple window groups, somewhat like virtual desktops

I installed [SessionSaver .2](https://addons.mozilla.org/extensions/moreinfo.php?id=436).  Why is the .2 part of its name?  I don't know.

When I quit Firefox, my session is now saved.  When I restart, everything opens.  It opens much faster than OmniWeb.  Incidentally, people sometimes tell me that they use Firefox and Safari: usually Firefox, but sometimes Safari when they need more speed.  I like to amuse them by saying I use Firefox and OmniWeb: usually OmniWeb, but sometimes Firefox when I need more speed.  It seems to me that the difference between OmniWeb and Firefox is larger than that betewen Firefox and Safari.

Anyway, I believe that SessionSaver will also take care of "multiple workspaces," if I squint at it longer.  For now, though, I'm going to do without.  SessionSaver seems very powerful, but its interface is weird.  I think it's trying to have a next-generation interface or something, but I feel like it's trying to be too clever.

### zoomed editing

This is what OmniWeb calls this feature.  When you find a textarea control on a page, there's a little plus button on its corner.  Clicking that brings up a large text edit pane, so you can have a reasonably sized area to type.  This is useful when a "Send Us Email" or "Post an Essay" field is big enough for about three sentences at a time.  It also has a "import file" button, which is incredibly useful when pasting code or pre-written text.

I think [MosEx](https://addons.mozilla.org/extensions/moreinfo.php?id=40&application=firefox) will do what I want, but some people now claim it's abandoned.  I'll do without for now, but this will need to be fixed before I feel totaly at home.

### excellent tab system (not just the thumbs, but copy/paste, status, etc)

Well... I don't know.  I'm not sure whether this will be fixed nicely in Firefox.  There are too many competing tab extensions, all of which have too many preferences with mediocre defaults.  I actually didn't install any of them.  SessionSaver and core Firefox pretty much cover the most important tab-related features.  I can (crudely) re-order tabs.  I get a basic status on each tab.

The things I miss include:

* selecting several tabs, cutting, and pasting to another window
* tab thumbnails
* tab drawer

I use a lot of tabs.  Having them in the tab bar is annoying: the tab headers get so small that I can see, at best, the site's favicon.  In OmniWeb, the tabs go vertically in a drawer.  This means that I can see many more at once.  Shawn Sorichetti, in his blog entry about [making FF work like WW](http://sackheads.org/~ssoriche/blog/archives/000186.html) suggested [Vertigo](https://addons.mozilla.org/extensions/moreinfo.php?id=1343&application=firefox), but I haven't tried it yet.  I think it will be a let-down, and that I'll miss the really nice features.  The difference between a sidebar and a drawer might seem subtle at first, but it's a big deal; they consume space in different ways.

### slightly superior quick search feature

In most browsers, Firefox included, you can type a URL that you've visited to find it in your history.  Generally, you must type it left to right, possibly ignoring domains below the second level.  In OmniWeb, you can type bookmark names, URLs, history URLs, names of sites in the history, words that appear in any part of any URL in the history, and so on.  It makes it much easier to get back to where you were.

Shawn suggested [myurlbar a](https://addons.mozilla.org/extensions/moreinfo.php?id=1722&application=firefox), a badly named extension that provides a good feature.  It could use a little tweaking, but it does the job well enough that I consider that feature entirely covered.

In Firefox, you can build "quick searches" that let you type keywords and parameters into the URL bar to perform searches quickly (hence the name).  I've [written about this before](http://rjbs.manxome.org/rubric/entry/556).  OmniWeb does this too, and slightly better:  in OmniWeb, parameterized shortcuts don't consume the unparameterized name.  That means I can use "`w 90210`" to get the weather for Beverly Hills, but "`w`" to get local weather.  I use this so rarely that I'm not concerned about the fact that I needed to rename my local weather link to "`w.`".  In fact, I had already dealt with this when I wrote my [OmniWeb-to-Firefox shortcut converter](http://rjbs.manxome.org/hacks/perl/ow5sh).  I'm afraid it might not work perfectly, now, with the latest Netscape::Bookmarks.  It worked well enough for me, though, yesterday.

### per-site preferences

In other words, "this site's insane designer uses tiny fonts; when I browse here, use 110% font size" and "don't allow cookies from this site, except for this cookie that I approved," or "no JavaScript here."  I'm sure Firefox can do this, if I look around, but I haven't yet.

### more stuff

Of course, I didn't just want Firefox to be as good as OmniWeb.  If I'm trading up, I want to trade way up.  I had the Firefox DOM Inspector installed, although now it looks like it might be core again.  I also installed the [Web Developer](https://addons.mozilla.org/extensions/moreinfo.php?id=60&application=firefox) Toolbar.  Doing work on web pages (either static or dynamic ones) without these tools is a real pain.  Once you use them, it will be hard to go back.  Even when I was most in love with OmniWeb, I used Firefox for these tools.

Obviously, I installed John's excellent [Wikalong](https://addons.mozilla.org/extensions/moreinfo.php?id=251&application=firefox) extension to get a nice little margin in which to write notes.  (It can use Rubric, as a back-end, too.)

I installed [Adblock](https://addons.mozilla.org/extensions/moreinfo.php?id=10&application=firefox) to, um, block ads.  OmniWeb had an ad blocking feature, as well.  I didn't use it much.  I don't know if I'll use this one much, either. It just seems like a good idea.  I also installed [Flashblock](https://addons.mozilla.org/extensions/moreinfo.php?id=433&application=firefox), which blocks Flash plugins (unless I click "play" to let them show up).  This is a nice way to avoid high loading times, high CPU usage, and other problems. Actually, even using Firefox is a nice way to avoid OmniWeb's seemingly random CPU spikes.

Firefox and OmniWeb (and Safari) all have integrated RSS support.  The RSS support in all three stinks.  It's a pain to use, and just isn't very useful.  I want to use a real RSS reader.  There are a bunch of RSS readers for Firefox, or in XUL, but I already have one I love: [NetNewsWire](http://ranchero.com/netnewswire/).  I spent something like $25 on it, and I'll be damned if I'm giong to give up using *two* pieces of expensive software in one day.  Instead, I found [Feed Your Reader](http://projects.koziarski.net/fyr/), which lets you send RSS to your `feed:` handler; mine is NNW, so when I click the little transmission button, NNW pops up its "Subscribe?" dialog.  Awesome!

Lastly, I installed [Greasemonkey](https://addons.mozilla.org/extensions/moreinfo.php?id=748&application=firefox). I don't have any plans for how to use it yet, but I've seen too much cool stuff done with it to not want to play around with it.  (I could probably also use HTTP::Proxy for this, but I'm focusing on Firefox toys for now.)

So far, I am happy with Firefox.  We'll see if I get totally fed up in a few days.  I might need to do something about the up arrow not going to column zero; that's bitten me a few times as I wrote this entry.  Apart from that, I think I may just stay here.

One last note:  my friend and former co-worker Thomas wrote a keen plugin called Gnusto.  It's a z-machine compiler; it compiles to JavaScript and then lets you play z-machine games in Firefox.  How cool!  It hasn't been updated for Firefox 1.5, though, and I'm not likely to use it when I have Zoom.  Still, I had a look at it and saw this great comment by "OGRastamon":

> `> TAKE BUFFERED ANALGESIC`
>
> You take the buffered analgesic but it does little decrease the pain you feel
> at the loss of Gnusto.
