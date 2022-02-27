---
layout: post
title : "overexposure to stupid password policies makes rjbs something something"
date  : "2008-01-01T19:53:22Z"
tags  : ["security", "stupid"]
---
I really like [1Password](http://1password.com/).  It's a Mac app that does the
"save my form information" really, really well, and does it with a
Keychain-stored, cross-platform system.  Now there's my1Password, which lets
you sync your password database to a web server.  The server stores everything
Blowfish-encrypted, and the encryption is only ever done client-side, so I can
log in to the web site from another computer and my data will not be decrypted
until it gets to the client-side JavaScript Blowfish implementation.  I feel
pretty good about it.  Even without the online synchronization, though, I
really like 1Password.

Since it remembers my passwords for me in all my browsers, I've begun to use
large, random, unrememberable passwords.  The newest beta added a column to
your account listing that shows how complex the password is.  I spent some time
going through older accounts, yesterday, and updated passwords.  I think I have
never been so overwhelmed by stupid password policies in such a short amount of
time.  Here are some highlights.

Of all my passwords, the worst remaining ones include one of my banks and my
student loan.  The Department of Education doesn't let me pick my own password,
and the bank in question limits me to eight alphanumerics.  It is incredibly
frustrating that Wikipedia, Chore Wars, Dopplr, and TiVo, for example, all let
me pick stronger passwords than my bank.  Another bank had stupid limits, too,
but not quite as stupid.  Thirty-two character passwords, but only
alphanumerics.

I guess some programmers are really scared about injection attacks, and don't
know quite how to prevent them.  I mean, look at this error message from
T-Mobile:

> Please do not use a space or ' or \" or ; or % or , in your password. 

See that backslash in front of the double-quote?  Yeah, that shows up on their
web site, too.  If they're afraid of SQL injection, I can tolerate the quotes
as misplaced caution.  I can even forgive the semicolon.  What's up with the
percent, though?  Are they worried that somewhere they have code that says:

    DELETE user WHERE password LIKE $given_password

Maybe they should block underscore, too, then.  Of course, maybe they're afraid
of having to deal with URI encoding, too, and the percent sign is an artifact
of that.  It could all be because they have an internal password hashing system
that just sucks.

Speaking of broken internals, how about Microsoft?  Microsoft Live (nee
Passport) gets points for having the novel "force me to change my password
every 72 days" option.  Unfortunately, minus several million for breaking
Messenger logins for, at least, Adium.  I was confounded by the fact that I
could log in through the web and not Adium, until I saw [this
bug](http://trac.adiumx.com/ticket/8252) that basically says: if you have a
long Live password, you must not use more than the first sixteen characters to
log in to MSN Messenger.  It just won't work, otherwise.  (While some of the
bug reports about this say that MSN doesn't let you set a long password, I can
promise that I set my long password via Microsoft's own pages, after logging in
to Hotmail.)

The bank providing my main mortgage let me set a very strong password, and even
lets me change my username (although it requires a username of at least six
characters), but doesn't have a page where I enter my username and my password
at once.  Instead, it has subscribed to the weird new trend: I enter my
username, submit, and then enter my password.  They really want me to upload a
photo, too, which will be shown to me to indicate that they really are my bank.
I understand that this is to fight phising, but it still bugs me.  I've done
enough customer support to know that I shouldn't expect (or, really, want) a
"no, I am not an idiot" button, but I still do want it.

Oh, speaking of usernames, my insurance provider should clearly check their
programmers for brain tumors.  They only allow alphanumerics in their
passwords, but they require that your *username* contain at least one number.
What?!  (Actually, I believe this has since been fixed.)

When I was trying to decide how I'd want to see all passwords handled, the only
characters I felt good ruling out of them were newlines and tabs (and control
characters, of course).  There are some real issues in handling some of the
remaining characters, though.  First of all, passwords should be accepted in
Unicode, so that you can use your puppy's name between your childrens'
birthdates, even if your puppy's name is Greek.  That probably means that I'd
want to be able to handle characters with the Letter, Number, and Punctuation
properties.  At first, I wanted to rule out spaces.  See, my brain had been
addled by all the sites that send an email when you change your password...
with the password in it!  Argh!  I got to thinking, "Well, if there is a space,
the user may be confused about where the password begins and ends."  It's
pretty simple, though: never print the password so the user can see it.  Heck,
I don't really want the service to be able to know what my password *is*!

Having space as a valid password character lets me use a correctly punctuated
sentence.  Maybe using English words isn't very secure, but since my mom won't
be using `x648::B2QR$p:nU3g,XR` as a password any time soon, I'd rather she use
"My God, it's full of stars!" than "frankblack" any day.

I'd definitely like to see OpenID used more places.  I got particularly
confused when trying to update passwords for various CPAN-related sites.  Some
use [Bitcard](https://www.bitcard.org/), which is like OpenID but undocumented
and mostly unused.  Some use their own login, and some use CPAN user logins.
If my CPAN user login got me an OpenID, I could use that everywhere.  (There
are some practical issues with this, mostly relating to the fact that currently
PAUSE ids are by approval only.)

Anyway, with nearly every password (except for the one or two that I can't
change(?!)) updated, I think I'm done ranting about passwords for a while.  I
will calm my nerves by heading back to deep space to rescue Princess Peach.

