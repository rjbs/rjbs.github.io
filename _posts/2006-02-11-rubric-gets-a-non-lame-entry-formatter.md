---
layout: post
title : rubric gets a non-lame entry formatter
date  : 2006-02-11T02:11:40Z
tags  : ["perl", "programming", "rubric"]
---
For a long, long time, I have thought, "It will be way cool to have better text-to-html in Rubric!"  I really wanted a decent markup system for doing this, and I didn't want to make any decisions.  Decisions are hard.  Instead, I punted: "I'll figure it out later!"

I just put in a default filter to keep my paragraph breaks, and I was happy. The only problem was that code snippets came out ugly, but that wasn't a big deal.  I didn't filter HTML, so I just wrapped them in CODE elements and coped. This made it easy-ish for them to get passed on to use.perl.org, too.  Still, it pretty much sucked.

Later on, I added the @private tag for "entries that only I can see."  I recently got a bug that it still leaks a data (like tag counts), but that's not the point.  The point was that I'd finally picked a way (the @-prefix) to designate tags reserved for the system.

Someone decided that it would be a good idea to run a public (open registration) Rubric installation, and quickly noticed that he was open to cross-site scripting.  Since I wrote Rubric for use just by me, I wasn't scrubbing HTML (remember?  I just stuck in ``<code>`` blocks, above!).  I told him how to change the TT2 filter that was being used, but it got me thinking, again, about making this easier.

Even later, I implemented a feature that a number of people had wanted: tag values.  Honestly, I didn't really see much use.  If I wanted "language:perl" I would just use "language perl" and avoid the weird mixing of tags with attributes.  Lately I've had a few ideas about when this might be interesting to use, but at the time I had just one reason to implement it: @markup.

The idea was that I'd create a system tag called @markup, and it would have a value.  That value would indicate the way in which the entry's body should be rendered form.  This would not be part of the Rubric::Renderer, but would be a set of pairs, mapping @markup values to Rubric::Entry::Formatter::Whatever classes.  Rubric::Entry would provide an `as_whatever` method (possibly soon to be `as('whatever')`) that would return the formatted entry body; the renderer would use that.

I implemented this a while ago, providing two bundled formatters:  Nil and HTMLEscape.  Nil is the default: it does nothing but maintain HTML line breaks. HTMLEscape does what you think: it escapes anything that needs to be escaped for HTML, so you see just what the text contained.

I should probably rename these.

Anyway, nobody much noticed when I released this, but I started getting more questions about making the text-to-HTML better.  Now I had a simple answer: write a plugin and use it!  Dan said he was writing one, and I was really excited to see someone do it, but I don't think it's been released yet.  I wrote a feature that I thought would be cool, but nothing cool was being done with it!

Well, last week I brought some music from work that got me wanting to write an entry quoting some lyrics.  I didn't want to have to actually _type out_ all those blockquotes!  Blockquote is way, way too long for an element name, you know.  It was time to write a useful formatter!

I was almost sad when it only took about two minutes.  It certainly took much longer updating my post-from-vim-and-also-to-use.perl script than writing the formatter.

The new formatter, which is formatting this entry (I hope!) is Rubric::Entry::Formatter::Markdown.  It uses Text::Markdown, which couldn't be much simpler to use.  Ignoring blank lines and POD, it's just twelve lines of code.  I'll be uploading it tonight.

I am pretty happy about this.  I may not need to write another formatter for a while, now... unless I wrote VimColorize!
