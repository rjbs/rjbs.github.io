---
layout: post
title : "addex and hiveminder, together at last"
date  : "2008-02-27T02:33:06Z"
tags  : ["addex", "email", "hiveminder", "perl", "productivity", "programming"]
---
I've written [too much](https://rjbs.cloud/tags/#addex) already
about [Addex](http://search.cpan.org/dist/Addex) so I will only review for just
a few paragraphs.  Addex uses your address book to produce configuration for
your various mailtools.

During this process, it creates an AddressBook object with many Entry objects,
each of which has a bunch of EmailAddress objects.  Those all have a label
(like "work") and an address (like "charlie@xigc.edu").

Meanwhile, [Hiveminder](http://hiveminder.com/) also has a bunch of email
features.  One of these, available to Pro accounts, is the ability to assign a
task to anyone with an email address, even if he doesn't use Hiveminder.  Every
Pro account gets a secret.  Let's say our secret is "energylegs."  Now, if I
want to assign a task to my buddy Logan, I can send an email to
`wx@deptk.gc.ca.energylegs.with.hm`.  The address breaks down into "his
address," then "my secret," then "with.hm."

If I send an email there, Logan will get an email saying, "Rik really wants you
to do something for him.  Click here and accept it, or click here and tell him
to go pound sand."  Heck, even if my contact just deletes the message, I'll
have a record of the request so that I can follow up on it through other means.

One of Addex's output plugins produces a mutt-style aliases file, giving me
aliases like "dad" and "gloria" and "hdp."  It also gives me secondary aliases
like and "hdp-work" and "gloria-pager."  Today, I uploaded a new plugin to
automatically adds a Hiveminder address for everyone in my address book.  Now I
have a "dad-todo" and "gloria-todo" and "hdp-todo."  If I know you, I probably
have an easy way to send you a request, too!

Enabling this was easy.  I just install
[App::Addex::Plugin::Hiveminder](http://search.cpan.org/dist/App-Addex-Plugin-Hiveminder)
and add the following to my `.addexrc`:

    plugin = App::Addex::Plugin::Hiveminder

    [App::Addex::Plugin::Hiveminder]
    secret = energylegs

That's it!

There are a bunch of configurable things to let me say "actually send todo
items for this person to a different address" and other similar variations on
the default behavior.  Basically, though, you just add three lines to your
configuration and start demanding work from other people.  What better way to
manage your workload than to get others to do it for you?

