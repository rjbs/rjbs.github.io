---
layout: post
title : vim wish list: columns
date  : 2005-08-10T14:04:38Z
tags  : ["vim"]
---
I wish I could tell Vim that the file I'm editing is X-delimited values and have it replace the X's with whitespace.  That's not my real wish, though, because I usually use tab's for the X's, anyway.

My real wish is that I could tell Vim that the file I'm editing is tab-delimited, and each tabstop should be just wide enough to make the columns line up and not overlap.  If the first column is all three-digit numbers, the first tabstop can be five.  If second column is email addresses, the second tabstop might need to be 35.

A bonus might be a maxcolwidth option, which would truncate and append "..." when needed.  (Long values could be displayed again when the insertion point gets near them.) 
