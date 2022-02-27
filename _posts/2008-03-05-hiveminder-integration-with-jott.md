---
layout: post
title : hiveminder integration with jott
date  : 2008-03-05T21:18:44Z
tags  : ["hiveminder", "jott", "perl", "productivity", "programming"]
---
[Jott](http://jott.com) is a really neat service that lets you Do Stuff via
your cell phone.  The default Stuff you can do is "send email and SMS" and
"setup a reminder."  There's also a very [simple
API](http://jott.com/jotters/index.php/developers) for writing your own
applications (called Jott Links).  It works something like this:

1. you call the toll-free Jott number
2. you speak the name of the Jott Link you've set up
3. you speak a message
4. Jott issues a web request with data including your id and the message
5. the service does something and replies to Jott
6. Jott sends you a reply

There are Jott Links for Twitter and other things that I don't care about.
There isn't one for Hiveminder.  Zak Greant made a [video demonstrating
Hiveminder and Jott together](http://jott.com/jotters/index.php/developers),
which has Jott send mail to the task-by-email interface of Hiveminder.  This
isn't bad at all, but it puts all kinds of crap into your task, because Jott
sends pretty chatty email.

I wrote a Jott Link service in about ten minutes (much of which was test time,
waiting for Jott to transcribe my messages).  It uses CGI.pm and
Net::Hiveminder to create a very concise task.  I need to add more features to
it, but I'm in no rush.  I am secretly hoping that the guys at Best Practical
will write a much better version, complete with a user setup link, so that
everyone can use their link, rather than running his own, each on a different
server.

Here's my code:

    #!/usr/bin/perl
    use strict;
    use warnings;
    BEGIN { $ENV{HOME} = '/home/rjbs' }
    use CGI qw(:standard);
    use Net::Hiveminder;

    my ($pw, $key) = `cat /home/rjbs/.hiveminder`;
    chomp($pw, $key);

    my $hm = Net::Hiveminder->new(
      email    => 'user@example.com',
      password => $pw,
    );

    my $user_key = url_param('userKey');
    my $message  = url_param('message');

    die unless lc $user_key eq lc $key;
    $hm->create_task("$message\n via Jott.com");

    print "Content-type: text/plain\n\nCreated.";

Obviously, this is a horrible hack.  Still, it means I can open my phone, hold
down 5, and dictate todo items right into Hiveminder.

There are a lot of little problems with Jott, some of which strike me as
significant usability issues, but they're all very fixable, and I look forward
to seeing them fixed.  I'll write more about them later.  Here's the one that
irked me the most last night:  Jott says that to write a Jott Link, you should
expect an HTTP POST.  You do, in fact, get a POST, but all of the data is in
the URL query string, not in the content of the request.  Huh?

Well, whatever.  All their problems are fixable, and the service looks like it
will be great.

