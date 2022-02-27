---
layout: post
title : email::folder woes (part n)
date  : 2007-11-27T23:44:55Z
tags  : ["email", "perl", "programming", "stupid"]
---
I mumbled something about Email::Folder hating me, today, but I was too busy to
explain, and I promised that I'd write down my annoyances later.  I'd love to
fix these problems soon, but for now it's easier to just grumble about them,
and it will make me feel better.

To print all threads in a maildir, *very* naively, I might write something like
this:

    my $maildir = Email::Folder->new('./Maildir/');

    while (my $email = $maildir->next_message) {
      my $subject = $email->header('subject');
      next if $subject =~ /^re:/i;
      print "$subject\n";
    }

Great!  There are all the non-reply subjects, more or less.  They're not in
order, though, and I want to see them in order.  Email::Folder's iterator is
not ordered, and there is no uniform way to request that it be ordered.  To get
messages in order, we'll need to get them all and then sort.  That's not such a
bad obstacle, really.

    my $maildir = Email::Folder->new('./Maildir/');

    # the sort isn't interesting
    my @emails = sort { ... } $maildir->message;

    for my $email (@emails) {
      my $subject = $email->header('subject');
      next if $subject =~ /^re:/i;
      print "$subject\n";
    }

Now, the problem here is that we've now loaded every email at once.  They're
loaded as Email::Simple objects, which means the entire message content is
loaded into memory at once, so if I had a huge maildir, I now have a huge perl
process.

Email::Folder provides a `bless_message` method, which is used to create the
Email::Simple objects.  Each time the Email::Folder object's `next_message`
method is called, the Email::Folder::Reader (subclassed for the storage medium)
gets the message content from the underlying storage and returns it as a
string.  Email::Folder then passes it to `bless_message`, which by default
passes it to Email::Simple.  It's being passed around as a string, meaning that
we're copying the full text of each (possibly huge) message a few times before
returning the object and throwing away the raw string.

It would be easy to make the Maildir reader return filehandles, but
`bless_message` also needs to be replaced to handle them.  Then the problem is
that if you try to do this:

    my $folder = Email::Folder::MessagesFromFH->new('mbox');

...you will be hosed, because you will get a Email::Folder::Mbox, which reads
messages out as strings.  You need to either write a `bless_message` that
handles strings and filehandles, or you need to override `new` to prevent
anything that won't use the right reader.

All I wanted to do was implement a cooler version of `frm`!

Hopefully I will wake up fresh in the morning and feel energized to actually do
something constructive, rather than just whine.

