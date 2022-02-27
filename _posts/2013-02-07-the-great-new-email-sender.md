---
layout: post
title : "the great new Email::Sender"
date  : "2013-02-07T14:33:39Z"
tags  : ["email", "perl", "programming"]
---
Yesterday I released Email::Sender 1.300003.  This is a pretty important release!

First, it is the first production release of
[Email::Sender](https://metacpan.org/release/Email-Sender) to use
[Moo](https://metacpan.org/release/Moo) instead of
[Moose](http://moose.iinteractive.com/).  This doesn't affect my code much,
because I use Moose all over the place already.  On the other hand, your code
might speed right up.  On my laptop, for example, the test suite now runs in
20% the time it used to.  I'm hoping this helps people feel freer to move to
Email::Sender, which really does make life easier for writing email-related
code than previous email sending libraries did.

So, I'm delighted to have the work of Justin Hunter and Christian Walde in
place, making the Moo-ification possible, not to mention that of Dagfinn Ilmari
Mannsåker, Frew Schmidt, and Matt S Trout on porting Throwable to Moo, which
was essential to making the rest of the conversion possible.  Thanks!

Like I said, though, the Moo-ification doesn't change most of my code very much
(yet?), but I'm still very excited.  Why is that?

Right now, I've got a large stack of "technical debt payment" tasks scheduled
at work.  Many of these are quite old, and many are in the form "we switched
90% of our code to some new system, but 10% remains on the old system; convert
the final 10% so we can reduce our total code complexity."  We talk about this
at the office as "killing snowflakes."  Look, that subsystem is unique and
special and not like anything else!  It is a delicate, beautiful snowflake!
**Kill it!**

Amongst those snowflakes being killed is our use of
[Email::Send](https://metacpan.org/release/Email-Send).  (Note the lack of the
<i>-er</i>.  This is the precursor to Email::Send<i>er</i>.)  We don't actually use
Email::Send, exactly, because it's so broken.  Instead, we use an internal
fork, the design of which strongly influenced the eventual creation of
Email::Sender.  It really had to go!

Unfortunately, it wasn't quite possible yet.

One of the *great* strengths of Email::Sender::Simple is that you can redirect
all mail by setting an environment variable.  This is very useful in tests,
where you can say something like:

    $ENV{EMAIL_SENDER_TRANSPORT} = 'Test';

    maybe_send_some_mail;

    my @deliveries = Email::Sender::Simple->default_transport->deliveries;

...and then inspect what mail would have been sent.  Of course, doing this via
an environment variable within one process isn't that compelling.  You could
just assign a global.  On the other hand, *this* is a big deal:

    $ENV{EMAIL_SENDER_TRANSPORT} = 'SQLite';

    fork_and_maybe_send_mail_in_any_process;
    wait;

    my @deliveries = deliveries_from_db('email.db');

This is useful for testing something like an exploder that forks to do its
work.  The next step is testing how code behaves when the email transport
fails.  This has always been possible with the Failable transport, which wraps
another transport and forces failures however the programmer likes.
Unfortunately, it works via code references, which can't be easily passed in
the environment.  What's worse is that it turned out that *no* configuration
could be passed to a wrapped transport via the environment.  Oops!

This has been fixed!  So, imagine this extremely simple (but quite useful)
wrapper:

    package Test::FailMailer;
    use Moo;
    extends 'Email::Sender::Transport::Wrapper';

    use MooX::Types::MooseLike::Base qw(Int);

    has fail_every    => (is => 'ro', isa => Int, required => 1);
    has current_count => (is => 'rw', isa => Int, default  => sub { 0 });

    around send_email => sub {
      my ($orig, $self, $email, $env, @rest) = @_;

      my $count = $self->current_count + 1;
      $self->current_count($count);

      my $f = $self->fail_every;
      if ($f and $count % $f == 0) {
        Email::Sender::Failure->throw("programmed to fail every $f message(s)");
      }

      return $self->$orig($email, $env, @rest);
    };

This makes it easy to say "every third message fails."  Then, to make your test
configure it for spawned processes:

    $ENV{EMAIL_SENDER_TRANSPORT} = 'Test::FailMailer';
    $ENV{EMAIL_SENDER_TRANSPORT_fail_every}      = '3';
    $ENV{EMAIL_SENDER_TRANSPORT_transport_class} = 'SQLite';
    $ENV{EMAIL_SENDER_TRANSPORT_transport_arg_db_file} = 'failtest.db';

    fork_and_maybe_send_mail_in_any_process;
    wait;

    my @deliveries = deliveries_from_db('failtest.db');

Done!

Using these tools together (in their internal-Email::Send-like version) was
instrumental to allowing us to confidently refactor our code, because we could
test it in ways we never could before.  Now that everything has been moved to
one email library, it's even easier to rely on these testing systems.  I'm
looking forward to improving them even more.

