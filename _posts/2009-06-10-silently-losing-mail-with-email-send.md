---
layout: post
title : silently losing mail with email::send
date  : 2009-06-10T15:07:22Z
tags  : ["email", "perl", "programming"]
---
Let me start off by reassuring you:  I'm not going to go on and on about how everyone needs to stop using Email::Send *forever*.  I will stop once nobody is using it anymore.

So, want another reason to stop using Email::Send?  If your system isn't configured to send mail, its default behavior is *to throw the mail away and report success*.

If you specify what transport to use, that's great.  For portable code, though, you don't want to specify a transport.  You want the system to find one intelligently for you.  Email::Send supports this in a quirky way: it tries every installed transport, in its default configuration, until one works.

What's the problem with that, beyond some inefficiency?  Well, one of the transports is the "Test" transport, which shoves mail into a global variable and always reports success.

Normally, due *entirely* to the *coincidental* ordering of Module::Pluggable results, this is not a problem.  Either SMTP or Sendmail transports usually work, and they come before Test in the alphabet.  Yes, seriously.

Here's a fun test case:

    #!/usr/bin/perl
     use strict;

    # Let's pretend we're on Win32 or elsewhere with no smtpd on 127.0.0.1:25
    # This doesn't simulate that condition, really, but it simulates the end
    # result as far as the default Email::Send strategy is concerned. -- rjbs,
    # 2009-06-10   use Test::Without::Module 'Net::SMTP';

    use Email::Send;
    use Email::Send::Test;
    use Email::Simple;
    use Test::More;

    # Let's pretend we're on Win32, again, and there is no sendmail binary in the
    # path. -- rjbs, 2009-06-10
    $Email::Send::Sendmail::SENDMAIL = 'does-not-exist';

    {
      my @deliveries = Email::Send::Test->deliveries;
      is(@deliveries, 0, "we start with no test deliveries");
    }

    my $text = <<'END';
    From: rjbs@example.com
    To: rjbs@example.com
    Subject: foo

    hi there
    END

    my $email = Email::Simple->new($text);
    my $rv = Email::Send->new->send($email);
    diag "result of sending mail: $rv";

    my @deliveries = Email::Send::Test->deliveries;
    is(@deliveries, 0, "we should not ever fall back to Test");

    done_testing;

This test fails.  If you try to let Email::Send figure out how to send your mail, and you aren't running on a system with its own MTA, Email::Send will pick "send to dev null" and assure you that everything is okay.

Email::Sender::Simple will, given no transport, try to pick one, and will throw an exception if it doesn't work.  Fixing the default transport globally is trivial via numerous means.  Try it now, it's in dev releases on the CPAN.
