---
layout: post
title : perl has built-in temp files
date  : 2015-05-22T15:36:48Z
tags  : ["perl", "programming"]
---
I use temporary files pretty often.  There are a bunch of ways to do this, and
File::Temp is probably the most popular.  It's pretty good, but also pretty
complicated.  A big part of this complication is that it's meant to keep your
filename around until you're done with it, and to let you pick its name and
location.  Often, though, I don't need these features.  I just need a place to
stream a whole bunch of data that I'll seek around in later, or maybe just
stream back out.  In other words, instead of holding a whole lot of data in
memory, put it in a file.

See, if you're going to put data in a file, then close it, then ask some other
program to operate on it, it almost certainly needs a name.  You might open
that program and pipe data into it, but it's often much easier to just give it
a filename of a file on disk.  If you don't need that, though, the filename is
totally extraneous.  In fact, it just gets in the way by making it possible to
leak disk usage.  A filename is a reference to storage in use, just like an
open filehandle is.  Just like you can leak a RAM by leaving a reference
to a variable in global scope, you can leak storage by leaving a name on the
filesystem.  That RAM will come back when your program dies, but the storage
will wait until you erase the filesystem!

On most platforms, you can't create a truly anonymous filehandle, but you can
do the next best thing:  you can create a named file on disk, hang on to the
filehandle, and immediately unlink the name.  When your program terminates,
there will no longer be any reference to the data on disk, and it can be freed.

Perl even makes this easy to do:

    open my $fh, '+>', undef or die "can't create anonymous storage: $!";

This creates a file in your temporary directory (either `$TMPDIR` or `/tmp` or
your current directory) with a name like "PerlIO_TQ50Oh" and then immediately
unlinks it.  The magic comes from the use of an undefined value as the
filename.  That mode, `+>`, is nothing special.  It just means "create the
file, clobbering anything that's in the way, and open it read-write."  Now you
can write to it, seek backward, and then read from it.  This feature has been
there since *5.8.0*!  If you can't use it because of your perl version, you have
my sympathy!

Of course, maybe I'm weird in being able, ever, to make do with temporary files
like these.  I don't think so, though.  When I asked on IRC recently, whether I
was missing some reason that it wasn't more common, almost every single
response was, "Woah, I never heard of that feature."

Now you have!

