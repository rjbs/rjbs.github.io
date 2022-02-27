---
layout: post
title : more notes from tiddlytown
date  : 2007-06-08T14:43:24Z
tags  : ["javascript", "programming", "tiddlywiki", "wiki"]
---
No sooner did I get my RPG notes put into nice comfortable TiddlyWikis than
version 2.2 was released.  Well, that's alright.  The upgrade didn't work with
the first, easiest (but weird) method they suggested, but the second method
(which is the one I would've guessed) worked:  start a new, blank TW.  Import
all your tiddlers.

I left out a few that were clearly causing problems, like my custom
stylesheets.  That's fine: my changes were minor and unimportant.

The new version has some changes I like (mostly cosmetic), some changes that I
look forward to liking (syncing imported tiddlers up with their remote source,
multiple workspaces), and some that sort of bug me (the backstage area's buggy
focus bugs me).

I've updated [my sandbox](http://rjbs.manxome.org/hacks/js/tiddlywiki.html) to
2.2, and I've done some tweaking to my plugins.  I've also imported, there,
some plugins that I think I'll find indispensable in the future.

I wanted to add completion to my "goto box" plugin, and then found that the one
at TiddlyTools did this.  Unfortunately, it kept screwing up its own access
key, making it useless.  This seems like a problem with access keys in general,
or maybe just Firefox, but it happened to the GotoPlugin more than to my
GotoboxPlugin, so I stuck with what worked.

I'm still using the excellent SinglePageModePlugin, which makes me feel like
I'm using a "real" wiki.  The whole "stack of tiddlers" thing just gets on my
nerves.  Do most people have only one paragraph or table per tiddler?

I guess I can see that being useful, but I'd probably end up looking mostly at
pages built up with inclusion.  Speaking of which, I found two plugins that
help with that:  one is PartTiddlerPlugin, which lets you name sections of a
tiddler and then include them elsewhere.  For my D&D wiki, the use is clear:
on my "Dwarf" page, I can write:

    <<tiddler [[Dwarven Religion/summary]]>>

...and then I can see the summary text on the overview page.

The other useful plugin, here, is [[TiddlerWithParamsPlugin]].  It implements
what those MediaWiki types call "transclusion."  It's "inclusion with
translation."  You can include a tiddler's text, but replace variables like
`$1` with arguments passed in.  I am very excited to share this possibly banal
hack:  I made a tiddler called Summarize.  It looks like this:

    !!$1
    //see main article [[$1]]//
    <<tiddler [[$1/Summary]]>>

Then, in my "Dwarf" article, I can actually write:

    <<tiddler Summarize with: [[Dwarven Religion]]>>

...and I get a section that looks like this:

    !!Dwarven Religion
    //see main article [[Dwarven Religion]]//
    Dwarves worship Tossy the Far-flung.  Blah blah blah...

Holy cow!  Along with the DisableWikiLinksPlugin, these make me feel like I'm
running a fast, prereq-free MediaWiki install.

The final plugin that I'm using, now, is BreadcrumbsPlugin.  It adds
breadcrumbs to the top of the page as I navigate around, which help me remember
what I was working on before I digressed five levels down.  Unfortunately, it
doesn't interoperate with my gotobox, but that's my problem.  I'll fix it
sometime soon.

The main thing that continues to bug me is the lack of a good catalog of
plugins.  Some are listed at TiddlyWiki.com.  Others are tagged as
TiddlyWikiPlugin on del.icio.us, but that's nigh-impossible to use as a useful
reference.  There's TiddlyTools.com, but it's slow and hard to use.  At least
one of its pages basically crashes Firefox, possibly by playing a lot of MIDI
music at once.  Why does this matter?  Well, the default TW search behavior is
to open all matching tiddlers.  I probably would've found the PartTiddlerPlugin
a lot faster if I'd been able to search for "include" without crashing.

Still, I remain a fan.  I'm hoping I've finished the "make it work the way I
want" yak, so I can start to get some "serious work" done.

