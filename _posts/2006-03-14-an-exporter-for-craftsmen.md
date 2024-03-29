---
layout: post
title : "an exporter for craftsmen"
date  : "2006-03-14T04:21:43Z"
tags  : ["perl", "programming"]
---
Sometimes, I get caught up in the metaphor, and I start to imagine my software
in terms of its convenient abstraction.  I picture my Template Toolkit sitting
on my workbench and I wonder where I the stencil for drawing an undef.  I
create a Socket and get visions of other programs plugging into a small opening
in mine.  I wonder whether Perl::Squish will someday collect the juices
squeezed out of my code.

When I think about Exporter, I can't help but think of some faceless business
producing an endless stream of identical products and shipping them all over
the world, where the provide moderate utlity for the consumer.
(UNIVERSAL::exports is aptly named, too, its covert operatives messing about in
your code so that you're forced to export, whether you want to or not.)

Anyway, the image is fairly depressing.  Though I stand in awe of Audrey Tang,
I don't want all my code to arrive in identically-shaped continers stamped
"MADE IN TAIWAN."  I am always interested in sharper tools: tools custom built
for my grip and purpose, manufactured just for me by an expert craftsman.

A few streams of consciousness converged around this idea.  I'd enjoyed
Damian's Perl Best Practices, but I felt like his Sub::Installer was a pretty
rude module.  It stuck itself in UNIVERSAL, ignoring the fact that it was only
needed here or there.  I wrote a replacement for it, Sub::Install, and I found
myself using it constantly.  I'd been doing a lot of code generation, and more
and more I would find myself building a few routines in a loop,
Sub::Install-ing them as I went.

Meanwhile, I had seen a number of independant discussions about how much people
appreciated a good SEE ALSO section in a module.  I felt the same way!  It's
like getting a car insurance quote from a firm that will, if they can't give
you the best price, tell you who can.  "This module is like these other
modules, which I'll tell you about, in case one of them is what you really
need."  It's just good customer service.  Writing a SEE ALSO section like that
made me feel like Santa Claus, directing this customer or that one over to
Gimbal's.  Sure, they might not buy this module, but they'd know I wanted to
help and would be back for more later.

I started to survey other modules that worked like modules I'd written, and in
general I was happy with the results:  I was not usually the absolute worst
choice out there.  One place I tended to fall down was in allowing for global
defaults.  For example, Text::Truncate provided a package variable that would
set the default elision marker;  String::Truncate, my module, did no such
thing.

My boss, Dieter, made this strike even closer to home when he wrote a routine
that used String::Truncate and defaulted the truncation length to the screen's
width.  He had to write a slightly ungainly subroutine which, with
Text::Truncate, could have been just an assignment to a package variable.  I
wasn't going to give up my integrity, though!  I couldn't bring myself to rely
on global variables for my code's behavior.  Instead, I decided to build a
curried routine to order and import it.  The user could write this:

    use String::Truncate :all => defaults => { length => $WIDTH };

    trunc("Some really long string that just goes on and on and on.");

Now that imported `trunc` would default to the given length, but nobody else
would see it.  The package's own version of the routine would assume nothing,
and other packages might import the routine with different defaults.

I was hooked, instantly.

I've been working on another module that has several class methods that provide
useful bits of data.  I wanted to export them, but curry away the method call,
so that these would be identical:

    use Data::GUID qw(guid_string);

    my $same  = Data::GUID->guid_string;
    my $thing = guid_string;

The exported `guid_string` would have the class name curried in, and if you
subclassed Data::GUID, you'd get a `guid_string` that curried in that class's
name.

I did more things like this at work, and more and more I found myself starting
a block with `sub import` and ending it with `Sub::Install::install_sub`.  The
idea had started small, but soon it was all I could think about: I wanted to
write an exporter using Sub::Install that could replace all these custom import
routines.

The big hang-up for me was the interface.  It had to make easy things easy and
hard things possible.  I wanted to write something that could be used anywhere
Exporter was without getting in the way, so that when the time came, it would
be easy to start using my exporter's more powerful features.

Anyway, there were some features I really wanted to make universally available.
We'd been trying to convert a lot of email-sending code to Email::Send, but
problems in Email::Send 2.04 prevented us; one of them was a problem with the
way it exported.  We could just call the `send` sub in the Email::Send package,
but we couldn't import `send` because we were already using that name here or
there.  It would have been a trival problem if this were valid Perl:

    use Email::Send qw(send_but_call_it_send_email_instead);

Sadly, it isn't, so we had to make do with forking Email::Send.  (Yes, patches
were filed.)  I wanted my exporter to make renaming a trivial, built-in option
for any user.

I kept thinking about the interface.  It had to be simple and flexible.
Listing two or three functions to export verbatim couldn't take more than a
line of code, or no one would use it.  It couldn't use package variables for
its configuration or I'd hate myself in the morning.  Fortunately, I had
already established one good future user: myself.  I had written a bunch of
modules that were just crying out for this exporter, and I now I'd know how I
was doing when I replaced their custom exporter with my new module.

(Sometimes I look at the directories in my `~/code` directory and notice that
the code I wrote just for fun, not to use, is often the most poorly designed.
I guess I know that if I'm going to use the software I'll have to make it
pleasnt to use, or I'll end up writing myself a lot of angry email.)

Finally, I sat down and the interface came to me in a flash:

    package Text::Tweaker;
    use Sub::Exporter -setup => {
      exports => [
        qw(squish titlecase) # always works the same way
        reformat => \&build_reformatter, # generator to build exported function
        trim     => \&build_trimmer,
        indent   => \&build_indenter,
      ],
      groups => { cutters => [ qw(squish trim) ] }
    };

and then later:

    use Text::Tweaker
      -cutters => { -prefix => 'text_' },
      reformat => { -as => 'prettify', margins => [ 5, 5 ], eol => 'CRLF' };

From there, it was a simple matter of programming.  A lot of the programming
(especially for the wonky bits of the feature set, not pictured above) gave me
grief, but never for long, and I always ended up feeling pretty good about the
outcome.  By the end of the weekend, I had gotten everything working and had
retrofitted a few of my modules successfully.  They still worked as they had,
and better.

I had replaced, at least for myself, the big faceless exporter with one skilled
craftsman, prepared to build anything a client might need.

I think it's going to be a lot of fun to use, maintain, refactor, show off, and
maybe, just maybe, extend.  I've already got one or two little feature
additions that I've already half-way coded up but that I'm waffling about
including: regex-based pseudo-groups, an unimport routine, and more.

Hopefully with this idea out of my head and into Subversion, I can get to work
on implementing the next one.

