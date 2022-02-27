---
layout: post
title : mutt, procmail, and the apple address book
date  : 2007-03-07T04:38:40Z
tags  : ["addex", "email", "mutt", "perl", "programming"]
---
It seems like everyone I know is using Thunderbird or Apple Mail, these days.
Sometimes, I feel a little left behind.  I still run mutt.  Then again, every
time I try to use a GUI mail application, I feel stifled.  It just isn't smart
enough.

Still, it's really nice to put things in one place and have them show up
everywhere you need them.  Apple Mail's integration with Address Book is nice
-- although really, I just want it to look up email addresses for me.  The
whole iChat integration I can live without.

A few years ago I wrote a script that would dump my Address Book into a file
containing mutt alias entries to be sourced into my muttrc, and that got me a
good bit of what I wanted.

Meanwhile, I also use procmail to sort my mail.  Sure, I should use
Email::Filter or something, but I've got a lot of intertia and a lot of
built-up rules.  I've been getting annoyed that my `friends.rc`, which sorts
mail from friends and family into folders, has grown out of date, and I kept
wanting to tie it to Address Book.

Today, I rewrote my `abook` script to do that, and to be more generally
extensible and awesome as time goes on.  (I also ended up reorganizing a lot of
my mail-config files and writing a Makefile.  I feel exceptionally nerdy.)

I will eventually release [abook](http://rjbs.manxome.org/hacks/perl/abook) as
a dist on the CPAN, but even now it's pretty useful.  It can dump two files:
one is a set of procmail recipes, the other a set of mutt config lines.  Right
now, it just helps sort mail, creates aliases, and can enable custom
signatures.  In the future, I'll probably also have it dump SpamAssassin
whitelists, make use of Address Book groups, and maybe even update Pobox
whitelists.

I also updated my mutt configuration to better cope with some OS X stupidity.
OS X's DHCP client doesn't seem to have a "do not change my hostname" option.
I had some mutt configuration loaded conditionally based on current hostname,
which broke when I'd get on the office or cellular network.  Now I've updated
it to check things like the ethernet address of the current computer.  I added
[offlineimap](http://software.complete.org/offlineimap) configuration for my
work IMAP account, and hopefully tomorrow I'll make it easy to access both
personal and work email from one mutt instance no matter where I am, with the
same folder names and key bindings.

Of course, whatever procmail-replacing script I write will have to have
pieces built by `abook`!  I'm not sure if anyone else out there is using this
set of tools: mutt, procmail, and Apple Address book.  If so, maybe `abook`
will be useful for you, too.

