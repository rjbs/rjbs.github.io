---
layout: post
title : "organizing documents, no help from adobe"
date  : "2007-06-15T03:21:52Z"
tags  : ["games", "perl", "programming", "rpg"]
---
I've got a bunch of documents that I want to organize, and I didn't want to use some database system, or rely on Spotlight (which I loathe) or anything annoying like that.  I wanted a different set of annoyances.  I wrote a little module (File::LinkTree::Builder) to build a tree of directories based on file metadata leading back to files in a storage area.  So, given (say) my iTunes library, it could build a tree in which I could look up /Rock/80s/Island and find every rock track from Island Records in the 80's.  The module is very simple and it lets you define how to find metadata.

Since a lot of the files I want to deal with are PDF, I thought I'd look into its own metadata system.  It has two, but the extensible one is XMP, the eXtensible Metadata Platform, which embeds a bunch of XML/RDF in the PDF. PDF::API2 has a way to get and replace this, so I figured I'd be on my way.

Well, the docs suck, and there's no non-image-related XMP module on the CPAN. I thought I'd just use XML::Simple, but I have to deal with goofy processing instructions, which it doesn't seem to support.  I'm getting close to just doing something brute-forcey.  Worst case, maybe I'll put YAML in a CDATA block and see whether it gets deleted by some Adobe tool while I'm not looking.

During my research into XMP, I found this, the most unhelpful technical documentation ever: http://support.adobe.com/devsup/devsup.nsf/docs/51963.htm 
