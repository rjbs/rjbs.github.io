---
layout: post
title : "strict pbp creationists"
date  : "2007-10-22T00:47:32Z"
tags  : ["perl", "programming"]
---
I liked Damian Conway's book Perl Best Practices.  It had a lot of sound advice
that can help a programmer or programming group decide on a set of house rules.
For those who aren't interested in making a lot of decisions, it can even be
used as a pre-built set of standards (although a few of its suggestions,
generally those involving modules releaed by Damian for the book, are
untenable).

Perl::Critic provided a fantastic way to check your code gains the rules in
PBP, or against many other kinds of rules, and it became quite popular.

What has begun to really drive me nuts is the application of these rules
without regard to how they affect the program.  More than once, now, I've seen
code changed to comply with PBP, only to be completely broken as a result.  To
paraphrase Mark Jason Dominus, apparently it is important to these programmers
to get the wrong answer as maintainably as possible.

Sure, tests would solve this problem, but Perl::Critic can't tell you that you
have uncovered branches.  It can just tell you that you separated statements
with a comma, or that you named a method after a builtin.

Here's tonights example, which drove me to rant about this:

    sub prepare_report {
      my ($self, $file) = @_;
      $self->analyze($file)->report;
    }

Oh no!  There's no explicit return statement!  We better fix that or
Perl::Critic will complain!

    sub prepare_report {
      my ($self, $file) = @_;
      $self->analyze($file)->report;
      
      return;
    }

Ugh!

