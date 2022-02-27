---
layout: post
title : "writing tiddlywiki plugins is fun"
date  : "2007-06-04T12:44:45Z"
tags  : ["javascript", "programming", "tiddlywiki", "wiki"]
---
I've finished converting all my OmniOutliner and LaTeX notes to TiddlyWiki, and
along the way I've found a few things I didn't like or that I thought were
missing.  Rather than just bitch, I though I'd fix these problems, and doing so
has been a load of fun.  Hacking on TiddlyWiki gives me the same kind of joy
and awe that I felt when I first started programming in Ruby.  In a lot of
ways, I think TiddlyWiki is what Kwiki wants to be.  Nearly everything builds
atop a few simple structures, and everything is pluggable.  Writing plugins is
easy, editing templates is trivial, and only a very few lines of code are
needed to add new features.

### problem one: multiple tiddlers per page

The unit of content on a TiddlyWiki is the "tiddler," which is equivalent to a
"page" in most wikis.  When you use TW, clicking on links opens the new tiddler
below all the other open tiddlers and sends the browser focus down to it.  This
means that as you work, you have more and more tiddlers open.  This might make
sense if you're really editing "microcontent," whatever that is, but for
longish pages, it can get quite annoying.

I thought about trying to fix this, but then found an exiting plugin at
TiddlyTools.  To import a plugin, you provide your TW with a URL to another TW.
It fetches it and lists all the tiddlers in it.  You select the ones you want
and hit import -- then they're in your TW.

This works for plugins because plugins are just tiddlers.  They're special, but
only just barely.  They are tagged with "systemConfig" and are evaluated as
JavaScript.  To add your own plugins, you just make new tiddlers.  To add
someone else's, you just import them.

I installed the "SinglePageModePlugin" and that was that, problem solved.

### problem two: jumping to a page

Sometimes, I'm editing a tiddler and I have an idea or remember something that
I need to write down in another tiddler.  As far as I can tell, I have three
options to get there:

1. navigate there
2. search for the page name, wait for the search to complete, and click it
3. edit the URL to put the page name in the fragment, then reload

All of these take too long and are stupid.  I want to be able to type
"Illithid" and go to that page.  Adding this feature was trivial.

I made a new tiddler called GotoboxMacro, then wrote a little JavaScript on it.
The JavaScript is simple: it adds an object to `config.macros`, and that object
has a `handler` method.  It's called with the location in the document where
the macro appeared (and other arguments) and it adds content there.  In the
case of a gotobox, it adds a text input that listens for carriage returns and,
when they occur, close all open tiddlers and open the one named in the box.
It's also got an access key, so I can hit control-G to goto goto.  Total code:
about 25 lines.

### problem three: the missing link page

There's a core macro called "list" that lists things.  It can "list missing" to
show you tiddlers to which you've linked, but which don't exist.
Unfortunately, it didn't work for tiddlers linked to with the "forced link with
title" syntax:

    [[mind flayer|Illithid]]

Fixing this was simple enough:  I fired up firebug, traced the method that
updated each tiddler's list of links, and found a stupid logic error.  One
line-change later, it worked.  (It also turned out that this was fixed in a
better way in Subversion, but I didn't know that until I was done!)

### problem four: linking forward from a tiddler

Every tiddler displays the toolbar.  The toolbar displays a selection of
"commands", which are defined much like macros.  One of the core commands is
"references," which pops up a menu of tiddlers that link to the current
tiddler.

I wanted something that did the reverse:  since my content is sometimes long, I
wanted a way to see all the pages to which I linked, so I could jump forward
without searching for the link on the page.  I wrote a command called "links"
that did just this.  I created an object in `config.commands` with a `handler`
method.  It uses TW's methods to get the current tiddler, find its links,
create a popup menu, and add the links to it.  Total code: about 25 lines.

### problem five: sharing my plugins

Well, these plugins were really useful to me, and I want to share them.  Given
the way that plugin importing works, this is trivial:  I created a new, empty
TiddlyWiki, then imported the plugins to it, then published it on my web
server.  Now anyone else can import those plugins to their TW.

TiddlyWiki is fantastic!  Now all I need is for the JavaScript vi script to be
licensed such that I can use it on my TW.

[Come use my plugins.](http://rjbs.manxome.org/hacks/js/tiddlywiki.html)

