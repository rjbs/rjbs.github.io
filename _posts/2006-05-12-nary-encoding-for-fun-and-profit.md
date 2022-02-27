---
layout: post
title : "nary encoding for fun and profit"
date  : "2006-05-12T14:52:48Z"
tags  : ["perl", "programming"]
---
I got an email from Tom about a problem he was having with Number::Tolerant.
That reminded me to have a look at releasing the trivial changes I had sitting
in my repository.  While doing that, tab completion reminded me of
Number::Nary, so I went and had a look at it.  In 0.05, I'd removed a secret
feature that I'd written into 0.04.  It was very badly done in 0.04, as I
recall, but I re-added it correctly, and that makes me happy.

Number::Nary does n-ary encoding of numbers into different digit sets.  I've
written before about its work-related uses, but I also have a silly
play-related use that is now officially supported.

    #!/usr/bin/perl -l
    # jaencode - encode a number in Japanese syllables

    use strict;
    use warnings;

    # missing: a i u e o n chi tsu shi (non-uniform length)
    use Number::Nary -codec_pair => {
      digits => [ qw(
        ka ki ku ke ko ta te to sa su se so na ni nu ne no ha
        hi fu he ho ma mi mu me mo ya yu yo ra ri ru re ro wa wo 
      ), ]
    };

    sub xlate { $_[0] =~ /[a-z]/ ? decode($_[0]) : encode($_[0]) }

       if (@ARGV == 0) { die "usage: jaencode <string ...>\n"  }
    elsif (@ARGV == 1) { print xlate($ARGV[0]);                }
    else               { print $_ . ": " . xlate($_) for @ARGV }

Then:

    knave!rjbs$ jaencode 867 530 999
    867: mino
    530: nuna
    999: yaka

    knave!rjbs$ jaencode mino nuna yaka
    mino: 867
    nuna: 530
    yaka: 999

I feel like there are probably other fun or useful things to do with this
(where "this" is either Number::Nary or jaencode), but I don't know what, yet.

