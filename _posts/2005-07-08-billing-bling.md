---
layout: post
title : billing bling
date  : 2005-07-08T16:41:03Z
tags  : ["perl", "programming"]
---
I'm setting up a little cross-program data validation.  Program A does a little validation of some data which it will pass to Program B, which wants to be very strict.  Since I don't really care about the data, even once it's in Program B, I'm trying to make Program B relax a little bit.

This has led me to this morning's programming observation:  in a billing system, maybe the main "bill" subroutine shouldn't be over three hundred fifty lines longs. 
