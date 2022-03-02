---
layout: post
title : "yet another wretched perl tutorial"
date  : "2007-10-09T01:08:09Z"
tags  : ["perl", "programming", "stupid", "tutorial"]
---
Sorry, I mean "PERL tutorial."  I guess there are so many of these that it's
like shooting fish in a barrel, but I found [yet another
one](http://www.tizag.com/perlT/) today while looking for some JavaScript docs.
Seriously, why isn't there a really good installable JS reference yet?

Anyway, some highlights:

> Scalars are very straight forward. Notice that we used a period (.) between
> each of our variables. This is a special kind of operator that temporarily
> appends one string to another.

In case you were wondering:

> `&&` is for numbers, `and` is for strings

I generally start with, `ready?? okay!!`:

> The first line of every PERL script is a commented line directed toward the
> PERL interpreter.

What sigil do I need for URL variables?

> Files with special characters or unusual names are best opened by first
> declaring the URL as a variable. This method removes any confusion that might
> occur as PERL tries to interpret the code.  Tildas in filenames however
> require a brief character substitution step before they can be placed into
> your open statements.

I'm glad I don't have to deal with CHMOD values myself.

> With sysopen you may also set hexidecimal priviledges; CHMOD values. Sysopen
> also requires the declaration of a new module for PERL. We will be using the
> Fcntl module for now, more on this later. Below we have created a basic HTML
> (myhtml.html) file.

Perl tracks the first line you print, apparently:

> We have to introduce some HTTP headers so that PERL understands we are
> working with a web browser.

It's more precise not to pass in a list, I guess.  Maybe it saves us from
checking return values:

```perl
foreach $file (@files) {
  unlink($file);
}
```

My favorite, though, was the "qw operator."  You know.  It produces a list.

Oh, and of course nothing uses strict.
