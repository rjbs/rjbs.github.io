---
layout: post
title : minicpan, minicpan2, and module naming
date  : 2005-03-14T12:53:00Z

---
<pre><code>	minicpan162.52s user 17.89s system 70% cpu 4:17.36  total
	minicpan229.35s user  1.74s system 62% cpu   50.064 total
</code></pre>

Above is my very unscientific speed comparison of minicpan (as released to CPAN) and minicpan2 (as sits in my Subversion).  I know minicpan2 will get slower as time goes on and I add the same features (and more) that minicpan already has.  Those features, though, are not going to slow it down more than a few more seconds, I think.

Right now I still have minicpan2 existing as a script that does its own thing. I'm about a third, or maybe half, done with the modules that will do the same work more generically.  CPAN::Mini::Archive represents an archive of modules (it's the SPA mentioned earlier).  By default, it assumes you're going to point it at a URI to the root of an archive with the normal 01mailrc and 02packages files.  I am pretty close to just declaring I won't handle 03modlist; I don't feel like writing a parser, and I don't intend to just eval code received from the network.

Anyway, CPAN:Mini::Archive works.  CPAN::Mini::Archive::WriteIndex (the name of which is not set in stone) also works, writing out index files from a C:M:Archive object.  Now I get to write the merger and mirrorer.  Their trivial forms exist, of course, in the minicpan2 script.  I just need to go ahead and write their less trivial forms.

I'm not sure that CPAN::Mini v2 will be CPAN::Mini.  It might be CPAN::Mini2, or something else.  I don't want to put myself in the position of releasing a same-named module that isn't compatible with previous extensions, especially after being among those who ranted about Apache:: in mod_perl 2.  Of course, if I can provide a similar enough interface, it's not an issue.

This kind of situation makes me feel that I'd like a more standard option for formal interfaces.  Of course, even if I had the ability to write both an interface and implementation, the problem would remain: I wouldn't have realized that I'd want to change things in this specific way.  Maybe the lesson in the future is to start with more leading underscores, and to remove them less readily.

We'll see what happens.  I guess CPAN::Mini might have a simple enough interface that I can make it a wrapper for CPAN:Mini::2.

