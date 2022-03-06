---
layout: post
title : "use disposable ramdisks!"
date  : "2015-05-08T14:42:58Z"
tags  : ["perl", "programming"]
---
Recently I wrote about [my dumb CPAN metafile
analyzer]({% post_url 2015-04-30-my-stupid-cpan-meta-analyzer %}), and how I'd tried to keep
it fast.  One of the things I tried to speed it up was creating a ramdisk for
all of the archive extraction.  The speed boost in this case turned out to be
low, but it isn't always.  (Also, I inexplicably used a journaling filesystem
.)  When you're doing a ton of file operations, the difference between physical
storage and in-memory can be huge.

It was useful for another reason, though: I was running the program on an OS X
system with a case-insensitive filesystem.  A few tarballs on the CPAN have
case conflicts, which would cause errors in analysis.  Instead of running
against `/tmp`, I set up my program to build a case-sensitive filesystem on a
ramdisk and use that.  It's easy, here's the code:

```perl
use 5.20.0;
use warnings;
package Ramdisk;
use Process::Status;

sub new {
  my ($class, $mb) = @_;

  state $i = 1;

  my $dev  = $class->_mk_ramdev($mb);
  my $type = q{Case-sensitive Journaled HFS+};
  my $name = sprintf "ramdisk-%s-%05u-%u", $^T, $$, $i++;

  system(qw(diskutil eraseVolume), $type, $name, $dev)
    and die "couldn't create fs on $dev: " . Process::Status->as_string;

  my $guts = {
    root => "/Volumes/$name",
    size => $mb,
    dev  => $dev,
    pid  => $$,
  };

  return bless $guts, $class;
}

sub root { $_[0]{root} }
sub size { $_[0]{size} }
sub dev  { $_[0]{dev}  }

sub DESTROY {
  return unless $$ == $_[0]{pid};
  system(qw(diskutil eject), $_[0]->dev)
    and warn "couldn't unmount $_[0]{root}: " . Process::Status->as_string;
}

sub _mk_ramdev {
  my ($class, $mb) = @_;

  my $size_arg = $mb * 2048;
  my $dev  = `hdiutil attach -nomount ram://$size_arg`;

  chomp $dev;
  $dev =~ s/\s+\z//;

  return $dev;
}
```

So, you can call:

```perl
my $disk = Ramdisk->new(1024);
```

…and get an object representing a gigabyte ramdisk.  Its `root` method tells
you where it's mounted, and when the object is garbage collected, the
filesystem is unmounted and the device destroyed.  This means that for any code
that's going to use a tempdir, you can write:

```perl
{
  my $ramdisk = Ramdisk->new(...);
  local $ENV{TEMPDIR} = $ramdisk->root;
  call_that_code;
}
```

There's overhead to making the ramdisk, but it's not programmer overhead, and
that's the important part.  All you have to do is figure out whether it's worth
it.

I didn't put my ramdisk code on the CPAN, because there's already
[Sys-Ramdisk](https://metacpan.org/release/Sys-Ramdisk), which does nearly the
same job.  I didn't use it because I "just wrote mine" because I thought it
would be faster than finding an existing solution.  It's probably a better
replacement for what I wrote, because it probably wasn't written in twenty
minutes at a bar.

