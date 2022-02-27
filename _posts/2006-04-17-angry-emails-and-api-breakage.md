---
layout: post
title : "angry emails and api breakage"
date  : "2006-04-17T23:50:14Z"
tags  : ["perl", "programming"]
---
I did some overhauling to a module a few months ago.  I added a new interface
to it, and left the old one in with a deprecation warning.  After a little
while, the original author uploaded a new release that totally removed the old
interface.  Within a day or two I'd received comments on IRC and via email.
They were all something like, "The new interface is definitely better, but I
had code using the old one!"

This kind of angry email is a great compliment.  It tells you that your code is
valued enough that someone relies on it and would like to keep using it -- as
long as you don't break your promises anymore.  Your public API, after all, is
a promise.  You can cross your fingers when you make it, by putting in a big
**THIS MIGHT CHANGE** warning, but as likely as not people will rely on it
anyway, if it's good.  If you don't even provide that warning, people will
assume that things will be backwards compatible forever.  The CPAN (which has
spoiled me for doing serious work in other languages that I like more than
Perl) helps enforce this promise in a few ways.  For one, more people have easy
access to your code, and to code that requires your code.  For another, even if
you go from "v1" to "v2" -- which largely identifies when APIs can break --
there is no way to indicate that in your distribution metadata.  Some of the
mod_perl team pushed for this when Apache::Request (and more) modules were
going to come out for Apache 2.  Apache::Request 1.x and 2.x weren't going to
be interchangeable, but they had the same name.  The request to add metadata to
do this was denied, so they had to move to a new namespace.

The `only` module does a bit to mitigate this problem, but it ends up with the
same issues as Firefox's extension compatibility metadata.  Authors are
encouraged to give a maximum compatible version, and their code then breaks for
no reason other than that arbitrary metadata.  (I am under the impression that
the 1.5.0.x versioning is, in part, a way to deal with this, but I'm not a
Firefox developer.)

The "sacred promise" nature of APIs came up recently in a discussion with Johan
Lodin, who wrote Sub::Define.  Sub::Define is a similar module to my
Sub::Install.  (Both, in turn, are reactions to our mixed feelings about
Sub::Installer.)  We talked about the extensibility mechanisms provided by both
our modules.  He said something like, "supporting new behaviors is hard.  How
do you do that in a clean, safe way?  What if you change the interface?"

I responded that, basically, you don't.  You offer a new interface, maybe, but
you leave in some kind of support for the old one.  Otherwise, your users' code
breaks when they upgrade -- and, sure, they should know that upgrading from
0.03 to 2.91 might cause problems, but they'll upgrade anyway.  Once you break
their code by changing things, they will no longer trust you, and you will have
a harder time getting any market penetration.  They will send you angry emails.
(Maybe you don't care.  That's OK, but you should be ready to receive those
emails.)

After talking with Johan, I decided to steal some of his ideas, and got back
into the guts of Sub::Install.  I was not thrilled to find that I'd documented
one interface to a subsystem (which I suggested avoiding), but implemented
another.  My tests were written to the implementation, so they passed.  The
documented interface was superior.

Today, I uploaded a new release to the CPAN.  It has a number of little
improvements, one of which is fixing the code to match the documentation.  I'm
not sure whether I'm breaking a promise now, or mending my ways for a
previously broken one.  More than that, I'm really not sure whether I'm hoping
to receive any "complimentary" angry emails.

