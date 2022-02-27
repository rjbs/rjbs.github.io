---
layout: post
title : "email addressing sucks"
date  : "2007-04-23T15:39:06Z"
tags  : ["email", "programming", "stupid"]
---
I know that most people know how much email addresses suck, but I found this
message in Mutt while looking for something else, and I thought it was a nice
illustration.

A user of Email::Valid writes:

> I was doing some testing with Email::Valid, and I came across this:
>
>     $ perl -MEmail::Valid -e \
>         "print Email::Valid->address('dave@#%^&*$.com') \
>          ? 'yes' : 'no'"
>     yes
>     $
>
> This prints "yes", and I don't understand why that address would be
> seen as valid. It doesn't seem to matter what characters are in the
> domain part of the address, it always gets marked as valid.

I replied:

> Let's have a look!
>
>     dave@#%^&*$.com
>
> You don't think this should be valid.  Let's consult the RFC.
>
> Section 6.1 says that an address must be <addr-spec>.  That is:
>
>     local-part "@" domain
>
> I'm guessing you don't dispute that "dave" is a valid local-part.  A
> <domain>  must be:
>
>     sub-domain *("." sub-domain)
>
> I'm also guessing you don't dispite that "com" is a valid sub- domain.  So,
> is "#%^&*$"?  Well, let's see...
>
>     sub-domain = domain-ref / domain-literal
>
>     domain-literal = "[" *(dtext / quoted-pair) "]"
>
>     domain-ref = atom
>
> There are no square brackets, so there is no domain-literal involved.  That
> means that if "#%^&*$" is a valid atom, it is also a valid domain-ref, and
> the address matches the addr-spec pattern.
>
> The atom pattern is:
>
>     atom        =  1*<any CHAR except specials, SPACE and CTLs>
>
> None of those characters are space or control characters.  The
> specials are:
>
>     specials    =  "(" / ")" / "<" / ">" / "@"  ; Must be in quoted-
>                 /  "," / ";" / ":" / "\" / <">  ;  string, to use
>                 /  "." / "[" / "]"
>
>  None of them are specials, either!  Are you shocked?  Don't be!
>  RFC822 sucks!
>
>  I hope this helped.  Good night! :)


