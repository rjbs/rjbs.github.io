---
layout: post
title : "new distribution: pod-eventual"
date  : "2008-06-07T16:08:25Z"
tags  : ["perl", "programming"]
---
I've been wanting to do some mucking around with POD.  I started a little down
this route a few weeks ago with
[Pod::Coverage::TrustPod](http://search.cpan.org/dist/Pod-Coverage-TrustPod/),
and what I found was that it was really a pain in the butt to easily say, "this
file contains POD.  Give me the content of hunks between `=begin foo` and `=end
foo`.  I'm sure it's possible, and that if you understand Pod::Simple you can
do it fairly quickly, but I just got too confused and side-tracked trying to
figure it out.  I really just wanted to get a hunk of data by saying something
like:

    my @hunks = Pod::Imaginary->parse('file.pm')->for_formatter('foo');

Later, this sort of thing started to bite me again, because Pod::Simple seems
much more geared to... well, to getting things right.  I mean, it doesn't want
you to make up directives all over the place, it understands the relationship
between over and item, and it cares about what's inside of text paragraphs
(like C<> and all that).

After talking about it with Dieter for a while and growing more grumpy, I
realized that this was just like the INI parsing situation.  POD is just a line
oriented data format.  I could just write a little state machine to collect POD
events and do whatever I wanted.

So, Wednesday after ABE.pm, I wrote Pod::Eventual.  It reads POD and collects
lines into events, which look something like these:

    my @events = (
      { type => 'command', command => 'head1', content => "NAME\n" },
      { type => 'text',    content => "Pod::Eventual - read POD as events\n" },
    );

Sure, it doesn't realize that most people would consider that text paragraph to
be "part of" the header.  That's fine!  It means it also doesn't need to be
special cased the other way to handle this:

    =for HTML
    <hr />

    ...and now some text!

In that case, the paragraph is definitely *not* part of the `for` construct.

Pod::Simple works something like this, under the hood, but it's much more
complicated.  Pod::Eventual ignores the structure of the document beyond
paragraphs, and it doesn't look at the content of the text paragraphs.  It also
might just get some cases wrong.  (Failing tests welcome!)

Still, it makes it very easy to write quick (but accurate) POD handling code.

My hunk-finder from above could probably be:

    my @hunks = grep {
      $_->{content} =~ /^foo$/m
      and ($_->{command} =~ 'begin' .. $_->{command} =~ 'end')
    } Pod::Eventual->read_file('file.pm');

...or something very like it.

