---
layout: post
title : kwiki templates
date  : 2005-08-01T17:58:09Z
tags  : ["kwiki", "perl", "programming", "wiki"]
---
Jim Brandt mentioned my previous Kwiki-related post to me, this morning, and I remembered that I forgot to mention one more little Kwiki hack.

Kwiki::Template::TT2 isa Spoon::Template::TT2 isa Spoon::Template. (Kwiki::Template::TT2 is not a Kwiki::Template, which isa Spoon::Template. That's fine.)  It handles, well, TT2.  It compiles the templates, which is a good thing.  They are compiled at request time, if they don't exist, which is fine.  It stores the compiled "ttc" files in the plugins directory of your Kwiki, which is not so fine -- at least for me.

See, Template Toolkit creates its compiled templates 0600, and they belong to the running user (of course), so now ./plugin/template/tt2/cache (or something) contains a bunch of files that user rjbs can't read.  So, now when I try to rsync my backup of my Kwiki install, rsync dies.  I tried using rsync's --exclude to get around this, but I think rsync must read before skipping, because it kept complaining.

Sure, I could mess about with stick permissions or other crap to make the files readable, but whatever.  Why do I want to worry about backing up compiled templates?  I made Kwiki::Template::TT2 take a little configuration directive for where to write its templates.  Typical Kwiki success story: after a (short) period of aggravation, I realied that three lines of code would make life better.  Having my backup scripts Just Work is a serious win.

Another little thought: assuming that Ingy might not want to make Spoon::Config use a real YAML parser, I thought it might be pluggable.  While I can, in theory, replace the YAML parser easily with a plugin, Spoon's so-called parse_yaml() is not just incomplete, it's wrong.  It wants nested arrays to look like this:

 key:
 - value 0
 - value 1

instead of this:

 key:
    &nbsp;&nbsp;- value 0
    &nbsp;&nbsp;- value  1

Well, maybe Ingy will be easy to convince.
