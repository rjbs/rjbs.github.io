---
layout: post
title : "why I'm not sold on YubiKey OTP"
date  : "2015-03-07T19:19:44Z"
---
[ **update**: I added a bit of an update at the end, in which I find that my fundamental worries were wrong, because the system is less convenient than I hoped!  So it goes.  ☹  I decided to post this anyway, because the thoughts were worth thinking, so maybe somebody else will find them interesting to see.  Or not.  Who even reads this thing? ]

Lots of people and sites now urge (or even require) you to set up two-factor
authentication.  This usually means something that emulates those old LCD RSA
SecurID key fobs you used to see on the university administrators' keyrings, if
you attended my college when I was there.  (Have we met?)  The idea here is, in
part, that even if someone intercepts your login once, they will no longer be
able to use it later.  You may have one password (probably "kittens" or
"123456") that you use over and over, but the other password — the *second
factor* — can only be used once.

There's more going on here, but I think this is a safe simplification.

In reality, most sites use
[TOTP](http://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm), so
the password is valid many times, but only within a small window, usually
between 30 and 90 seconds.  A man-in-the-middle attack can get the full set of
credentials, but they're only valid within a small period of time, so they
can't be held in escrow for a delayed attack.

TOTP is built on top of
[HOTP](http://en.wikipedia.org/wiki/HMAC-based_One-time_Password_Algorithm), in
which there's a counter that's incremented with each use.  TOTP just replaces
the incrementing counter with a timestamp.  Otherwise, HOTP can be a bit
trickier to use:  the verifier needs to know the counter being verified, or at
least the minimum counter not previously seen, to prevent replay attacks.  TOTP
just replaces the counter with the current time.  Both are built on a shared
secret which is shared only between the remote server and the user.

The hassle of TOTP, to once again grossly oversimplify, is that we tend to use
a device other than our computer to store the shared secret.  We put it on our
phone, or a little keyfob, or the like.  When we log in, we need to look at
that, slide to unlock, find the site in a list, and then type in the six digits
onto the web page.  This is why we're often quick to click "trust this computer
for a month."

A [YubiKey](https://www.yubico.com/products/yubikey-hardware/) is a little [USB
HID](http://en.wikipedia.org/wiki/USB_human_interface_device_class) device that
will enter your OTP *for* you.  When you tap it, it emits a string of
characters (because it's pretending to be a keyboard) and then enter.  Those
characters are your one-time password.  You don't need to unlock your phone,
swipe things, or any of that.  You just tap your USB port.  Great!

Now, there are complications.  Since your YubiKey doesn't know what site you're
logging into, it needs to use a single secret.  It doesn't have a clock, so it
uses (something analagous to) HOTP.  Remember that when you're using
counter-mode OTP like HOTP, you need to know the minimum unused counter to
prevent replay attacks.  To allow sites to synchronize their "last seen
counter" data, there's a "YubiCloud" server.  They way you're expected to
verify an OTP string is to send it to this server, which will reply with a
yea/nay.  If the OTP is cryptographically valid, but for an already-validated
counter, it will be rejected.  Once you've verified the OTP, you can't use it
again.  This is secure.

The problem is that not everybody wants to use a server run by some third party
as part of their system.  This is a pretty understandable desire, and it can be
met: there are several implementations of verification servers that one can run
to do local verification without talking to the cloud.  You can run your own
server, and if YubiCloud is down, you can still verify.  You can also feel
secure that if YubiCloud's logs are leaked, no one will learn the usage pattern
of your users.

See, your users *could* be identified, more or less, from those logs.  Because
your YubiKey device has a single secret, your "user id" is visible across all
the sites where you use it.

So, now we've got a world where many sites are running their own local
verification servers.  This creates a new problem: they are not synchronizing
their "last seen counter" data.  Imagine that a user has accounts with two
different services, A and B.  They log into A every day and into B rarely.

If site A is compromised, the OTPs used to log into it can be held in escrow to
be used against B later.  The fact that they have been verified already won't
matter, because A and B do not synchronize their last seen counter data.  If,
like many users, this user is using the same email address and password, then
there is nearly no security present.  (Remember, everybody: don't use the same
password everywhere.)

As more sites run their own YubiKey OTP, the threat of having your OTP held in escrow
increases.  The precomputed attack on TOTP isn't mitigated by avoiding
counters.  It's avoided by having shared secrets on a *per server* basis.

I haven't performed a very careful reading of the specifications involved here,
but from what I can tell, my concerns are warranted.  I would be *delighted* to
hear that I am mistaken.  I don't think that this is a critical exploit that
makes the whole system worthless, but I do think it indicates that
per-server-secret TOTP is more secure than YubiKey.  Of course, it's also less
convenient.  Isn't that always the way?

YubiKey devices now also support FIDO U2F.  That's based on private key
cryptography.  The server issues a random challenge which the attacker must
sign, so playback is of negligible use, given challenges over a large enough
space.  There's more to it than this, but it seems clearly to be a more secure
system.  Unfortunately, it's also more complex for services to implement.
Isn't that always the way, too?

[**update**]  I think what I'm finding is that since a YubiKey validation server is acting as a key escrow, you can't actually use one key against more than one server.  You need to pick which one server you'll work against.  This swings things back towards secure, but away from convenient.  I will continue looking for documentation on the subject.
