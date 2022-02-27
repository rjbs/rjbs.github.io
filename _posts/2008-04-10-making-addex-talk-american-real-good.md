---
layout: post
title : making addex talk american real good
date  : 2008-04-10T14:07:06Z
tags  : ["addex", "perl", "programming", "unicode"]
---
Look, I respect the diversity of foreign cultures and everything.  I try to
pronounce silly foreign names correctly, and I have learned to stop referring
to Holland as "the Netheregions."  In turn, could everybody please officially
transliterate their languages to 7-bit?  Honestly, it would make everything a
lot easier... at least for Addex, which is the top world priority, right?

I have some friends and colleagues who refuse to change their names "just
because my software is too parochial," so I've been forced to try to deal with
it.  See, Apple Address Book is all unicode, but Mac::Glue returns strings in
MacRoman when it can (read: for the names I've got in there).  My mutt doesn't
even like Unicode very much.  Anyway, too, if I want to send a message to my
friend Jos&eacute;, I want to be able to hit j-o-s-e-TAB.

So, I don't want to try to fix mutt and everything else, because that would
help too many other people.  I just want to help Addex users.

I had to go through a lot of weird steps to get this working.  The first
problem was to decompose the decoded-from-MacRoman Unicode that I was getting
back.  Then I dropped out the NUL at the end and any combining characters.
This didn't fix S&oslash;ren, whose stupid Viking name kept its stupid Viking
letter.  It turns out that LATIN SMALL LETTER O WITH STROKE doesn't decompose.
I figured this out only after assuming it was a Mac::Glue bug and whining at
pudge about it for a while.

You can see the horrible, horrible steps I've taken below.  This code will be
optional in the next App::Addex.

    use Unicode::Normalize qw(normalize);
    use Unicode::UCD 'charinfo';
    use charnames ':full';

    sub __degrade_to_ascii {
      return $_[0] if $_[0] =~ /^[\x01-\x79]*$/;
      my $decomp = normalize(D => $_[0]);
      my $recomp =
        join '', map { chr(hex($_->{code})) }
        map  {
          ($_->{name} =~ /^(LATIN \w+ LETTER .) WITH/)
          ? charinfo(charnames::vianame("$1"))
          : $_
        }
        grep { $_->{code} =~ /[^0]/ }
        grep { $_->{block} !~ /combin/i }
        map  { charinfo(ord substr $decomp, $_, 1) }  0 .. length $decomp;
    }


