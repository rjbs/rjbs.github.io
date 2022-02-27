---
layout: post
title : when to localize $@?
date  : 2008-08-29T00:42:20Z
tags  : ["perl", "programming"]
---
Today I spent a good while trying to figure out why I wasn't seeing a runtime error from code that looked like this (grossly simplified):

    eval {     ...     $object->method_that_doesnt_exist;     ...   };   if (my $error = $@) {     log($error);   }

Fortunately, this is something like the third time I've encountered this error in the past six months, and I am now quick to guess at it.  Some of the code in the eval created an object that had a DESTROY handler, and it threw an exception without first localizing $@.  This clobbered the real exception, so by the time the eval block was exited, $@ was empty.  Ugh!

I learned my lesson the first time: I'm careful, now, to make sure my own DESTROY methods localize $@, because they can be invoked when I least expect it.

Where else does one have to remember to be Really Careful?  Is there anything that provides sufficient sugar to make this painless? 
