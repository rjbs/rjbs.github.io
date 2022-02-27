---
layout: post
title : "padwalking, paperwork, and productivity"
date  : "2005-03-29T20:56:00Z"
tags  : ["perl", "productivity", "programming", "pvoice", "xbox"]
---
First, a question.  When I run this code:
<pre>
use Data::Dumper;
use PadWalker qw(peek_my);
{
my $lex = "HELLO";
sub pad {
    my $l = shift;
    warn Dumper(peek_my($l));
    print "While you're here, I'll print my enclosed scalar: $lex\n";
}
}
pad(0);
</pre>

Why does it tell me that $lex is a reference to undef?  No one had an answer for me.  I don't really understand pads very well.

OK, that's that.  Work today was slow.  I worked to put together the framework for the "last" part of the Big Hateful Project, and got a few things converted from the RJBSORBMS to Class::DBI, which was a good thing to do.  Tomorrow I'll start canonizing test data and writing scripts to rebuild pristene test databases.  Then I can start writing tests for this last phase of stuff.

I'm unable to feel enthused about it.

At the end of the day, I needed to put together some example flow charts for some changes I want to make in our quality (ISO 9001) system, and got distracted by some other OmniGraffle work I wanted to do.  I have this simple todo list that I use at work, and I wanted to make a companion form listing what I'd accomplished.  The to do list is anything I need to do.  "Call Joe back" or "reboot inbtcfmailwindows1" are valid entries, even though they take no time.  I wanted something that would show me, hour by hour, how I spent my life.  I produced the form, and struggled for a while trying to get OmniGraffle to print both forms side by side on one piece of paper.  I couldn't get it to work.

Right now they're both about five and a half by eight inches, and I have them on a half-size clipboard.  Having two sheets, though, means that I can't see both at once.  I might combine the forms and use a full-size clipboard.  I need to think about it and see how it goes as is.

I'll post the forms soonish.  So far, the to do list has served me well.

I'm hoping that I will be horrified at seeing how many waking hours get NOTHING written next to them, and that this will force me to do more.

One thing I /did/ do recently was proofread half of the forthcoming pVoice manual.  pVoice is Jouke Visser's free speech-for-the-handicapped software. It provides the neediest people with the ability to communicate, and it does it for free.  It makes me feel proud of free software and the Perl community, and (of course) Jouke specifically.  I'm happy just to help out a little.

This morning I installed pVoice on my workstation and toyed around with it. Very neat stuff!

Oh, and finally: my replacement DVD drive for my Xbox came.  The Xbox now boots, but won't play games.  I've emailed Llama to ask how I can return the disk, and what else I should try.  Research is suggesting that the hard disk is keyed to the motherboard's eeprom, so I can't swap it.  I may need to borrow a memory card and transfer the files from the old Xbox to a new Xbox.  Thanks a lot, Redmond!
