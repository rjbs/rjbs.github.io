---
layout: post
title: mutt and Fastmail go together
date: "2022-03-06T14:50:19-05:00"
tags: [ "email", "fastmail", "mutt" ]
---

This is not a long paean for mutt or Fastmail, although I'm a big fan of both.
It's more of a Stupid Mutt Trick.

I did nearly all my email reading in mutt for about twenty years.  It's very,
very good.  It's not for everybody, but it was for me.  Over the last five
years, I've moved to doing nearly all my email reading (and writing) in
Fastmail.  I replaced my custom Perl filters (which had replaced my use of
`procmail`) with Fastmail's rules.  I made some very small adjustments to how I
did things with my email to make it all go smoothly.  I also wrote just a
little custom JavaScript to add a couple things to the Fastmail UI that I
wanted.

Still, sometimes I open up mutt, especially when I need to read the Perl 5
developers mailing list.  These days, I sometimes read mail in mutt, then pop
into Fastmail to write a reply.  I wanted to make this easier, and of course
mutt makes it easy to make things easy.

First, I added these lines to my `.muttrc`:

```
macro index F ":set wait_key=no\r|~/bin/open-fm\r:set wait_key=yes\r"
macro pager F ":set wait_key=no\r|~/bin/open-fm\r:set wait_key=yes\r"
```

This creates a keyboard binding.  **F** will pipe the contents of the current
message to a program called `open-fm`.  Normally, when you pipe a message to a
program, mutt asks you to press a key when you're done.  I've disabled that,
here.

(Why two lines?  One sets up the keybinding when listing messages, the other
when reading an individual message.)

The way the program works is tied to how Fastmail's URLs work, which isn't a
stable API.  I figure, if they change, I can adapt.  If I can't adapt, at least
I had a good run.  Anyway, a Fastmail email URL looks something like this:

```
https://www.fastmail.com/mail/Inbox/Mxxxxxxxxxxxxxxxxxxxxxxxx?u=yyyyyyyy
```

The Mxxx is the id of the email being viewed, as determined by the underlying
[Cyrus IMAP](https://www.cyrusimap.org/) server.  It just so happens that the
email id is `M` plus the first 24 characters of the SHA1 digest of the
message's bytes.  The yyy is my account id, which is always in the URL while I
use Fastmail.  Both of these are data you need to do anything with JMAP, by the
way.

I wrote this program:

```perl
#!/usr/bin/env perl
use v5.34.0;
use warnings;
use Digest::SHA;

my $sha = Digest::SHA->new(1);

while (<<>>) {
  # mutt will give us unix line endings, but the real message uses
  # network line endings, and it matters because we need the right digest!
  s/\n/\x0d\x0a/g;
  $sha->add($_);
}

my $digest = $sha->hexdigest;

my $uid = q{my-uid-here};
my $env = q{beta};

my $url = sprintf q{https://%s.fastmail.com/mail/-/M%s?u=%s},
  $env,
  substr($digest, 0, 24),
  $uid;

system('open', $url);
```

Sadly, I don't know a way to do the reverse and make mutt open to exactly the
right message!
