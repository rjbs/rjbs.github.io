---
layout: post
title : "perl email project non-synergy"
date  : "2007-05-25T21:23:54Z"
tags  : ["email", "perl", "programming"]
---
The last bug of the day was, "Why is this process getting so big?"  See, it was
getting an HTTP upload, creating an Email::Simple::FromHandle, then delivering
it.  It should all have been streaming around, nothing in memory.

Then we realized that Email::LocalDelivery was dealing with the string at once,
because it was written before ::FromHandle.  Here's the bizarre thing, though:

Email::LocalDelivery accepts only a string to deliver.  In fact:

```perl
croak "Mail argument to deliver should just be a plain string"
  if ref $mail;
```

It calls the deliver method on the various Email::LocalDelivery::* classes,
like ::Maildir, which says:

```perl
sub deliver {
  my ($class, $mail, @files) = @_;
  $mail = Email::Simple->new($mail)
    unless ref $mail eq "Email::Simple"; # For when we recurse
  ...
}
```

Unfortunately, ::Mbox does nothing of the sort, only writing a string to a file
with no provision for receiving an Email::Simple object, so the exception in
Email::LocalDelivery can't really be fixed without bizarre consequences:
partial deliveries based on the delivery targets.

I'll probably fix this in all the E::LD:: classes I control, then try to get
the other CPAN modules fixed, then hope nothing on the darkpan breaks.  At
least I can fix the streaming delivery in Email::LocalDelivery::Maildir and
call its deliver method directly, because hey, THAT's a great idea...

