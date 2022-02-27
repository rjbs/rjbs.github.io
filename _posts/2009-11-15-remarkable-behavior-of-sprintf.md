---
layout: post
title : "remarkable behavior of sprintf"
date  : "2009-11-15T19:56:18Z"
tags  : ["c", "perl", "programming"]
---
I've been working on a library for writing sprintf-like routines.  This has led
me to learn quite a lot about sprintf.  If you're ever looking to be amazed at
how complex one routine can be, look at `perldoc -f sprintf`.  It's not the
most complex builtin in Perl 5 (I think), but it's up there.  I think `open`
wins.

Anyway, here is some Perl:

    printf "I will charge you %u percent more than Bob.", 10;

This prints:

    I will charge you 10 percent more than Bob.

Great, so let's use a literal percent character:

    printf "I will charge you %u%% more than Bob.", 10;

    # I will charge you 10% more than Bob.

This should not be surprising.  When looking at how Darren Chamberlain's
String::Format library handles this, I saw that he generates a mapping so that
'%' is treated as the literal percent sign.  This struck me as wrong, because
it meant that all the formatting codes would continue to work.  In otherwords,
you could say:

    print stringf "Look! %10%\n";

    # Look!          %

I updated my parser to ignore formatting codes that looked like this, but just
for safety's sake double-checked perl's behavior:

    $ sprintf "Look!  %10%\n"
    Look!           %

Woah!  Wow.  You can left align, too, at least.  I didn't get into many other
weird possibilities.  This just struck me as totally insane, so probably
brought in from C.  I decided to check:

    #include <stdio.h>

    int main() {
      printf("Hello, world %10%\n");
      return 0;
    }

...which got me...

    ~$ gcc hello.c
    hello.c: In function ‘main’:
    hello.c:4: warning: conversion lacks type at end of format
    hello.c:4: warning: unknown conversion type character 0xa in format
    ~$ ./a.out
    Hello, world          %

So, I thought maybe we were seeing the same behavior for a different reason: C
was seeing two formats: `%10` which lacked a conversion type and `%\x0A`
because of the newline after the terminal percent sign.  This is what the
warnings suggested, but I got confused when I changed the format to `%-10%` and
the output became:

    ~$ ./a.out | xxd
    0000000: 4865 6c6c 6f2c 2077 6f72 6c64 2025 2020  Hello, world %  
    0000010: 2020 2020 2020 200a                             .

So... the percent sign is being left aligned, despite warnings (still there)
that seem to imply it's being interpreted differently.

I was probably a fool to even think about writing anything resembling
`sprintf`.  I don't regret it yet, but I'm sure I will.

