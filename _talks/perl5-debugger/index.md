---
title: "The Perl 5 Debugger: Wuh?"
description: "how to use the perl 5 debugger, which is useful but mysterious"
date: 2020-06-26
tags: [ perl, programming ]
urls:
  - label: Video
    url: https://www.youtube.com/watch?v=LtAGbUYTnR0
---

## Abstract

95% of all debugging is print statements, but once or twice a year, a problem
shows up that is best attached with perl5db.pl, the venerable core Perl 5
debugger. Like a light saber, it dates back to a forgotten time and its
operations are poorly understood. Unlike a light saber, it is not elegant, and
nobody aspires to use it. Also, it can cut limbs right off. Still, it’s a very
useful multi-purpose tool, and if you learn how to use it, it can save a lot of
time and clear up a lot of mysteries.

This talk will cover what the debugger is, how to use it at a basic and
intermediate level, how to customize it, and at least one or two stories about
how it is very, very awful.

## Notes

I originally gave this talk internally at Fastmail, in our now-defunct internal
talk series known as TFcon, aka The Fastmail Con, aka WTF Con.  Every once in a
while, I'd be pairing with someone and fire up the debugger.  They'd usually
say, "Woah, what's that?"  I use the debugger daily as a REPL or for doing
one-offs, and a couple times a year I really use it as a debugger.  It's a
mess, but it's worth knowing!
