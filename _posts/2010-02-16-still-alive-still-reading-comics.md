---
layout: post
title : "still alive, still reading comics"
date  : "2010-02-16T23:43:50Z"
tags  : ["comics", "perl", "programming"]
---
I haven't written anything about programming in a long time, now.  I stopped
when I was work on my [Advent calendar](http://advent.rjbs.manxome.org/) and
never really got back to writing in my journal.  I'm still doing plenty of
coding, I'm just not writing about it here much.

I'll have to fix that.

What I have been doing, though, is reading comics.  I downloaded an archive of
comics that are no longer in print, and they came in
[CBR](http://en.wikipedia.org/wiki/Comic_Book_Archive_file) format.  It's
basically a rar-compressed file with a bunch of images.  I've been reading them
with the excellent OS X program [Sequential](http://sequentialx.com/).  It's
the first program I've used for reading comics that made the experience
enjoyable.

I hit a snag, though.  It uses OS X's "smart" file sorting, which is often
pretty stupid.  For example, given these two files:

    Report 21.doc
    Report 123.doc

...it will sort them in the order shown above.  That makes sense, but it's not
what things expect, and it's sometimes a problem.  For example, the comics
contained images like this:

    Page 01.jpg
    Page 02.jpg
    Page 0304.jpg
    Page 05.jpg

That third file is a two-page spread.  Traditional asciibetical sort would put
them in the correct order, but the stupid OS X sort did this:

    Page 01.jpg
    Page 02.jpg
    Page 05.jpg
    Page 0304.jpg

That's because 304 is larger than 5.

Fortunately, the comic book archive format is really simple and stupid, and I
was able to batch convert everything like this:

    #!/usr/local/bin/perl
    use 5.010;
    use strict;
    use warnings;
    use autodie;

    for my $file (<*.cbr>) {
      say $file;
      (my $dir = $file) =~ s/\.cbr\z//;
      mkdir $dir;
      chdir $dir;
      system(unrar => e => "../$file");
      my @files;
      for my $image (grep { -f } <*>) {
        (my $new = $image) =~ s/-([0-9]{2})([0-9]{2})\./-$1,$2./g;
        rename $image => $new if $new ne $image;
        push @files, "$dir/$new";
      }
      chdir "..";
      system(zip => "$dir.cbz" => @files);
      system(rm => -rf => $dir);
      unlink $file;
    }

I'm sure it has a big pile of problems, but it let me read my comic book pages
in the right order and took about five minutes to write.  Thanks, Perl.

