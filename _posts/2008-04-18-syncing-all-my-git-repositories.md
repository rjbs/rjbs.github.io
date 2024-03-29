---
layout: post
title : "syncing all my git repositories"
date  : "2008-04-18T03:15:51Z"
tags  : ["git", "programming"]
---
Inspired by my recent adventures in on-plane USB flash drive git repository
swapping, I ordered a USB storage device.  It seemed like getting a micro SD
reader would be fairly multipurpose and expandable, so I ordered a teeny tiny
micro SD reader that came with a 2 GB card and adapters for mini and regular
SD.  This thing is *tiny*.  If I put a quarter on top of it, you can barely see
it.

The next task, of course, was to make it really easy to clone all my work onto
it, both for easy access and for use as a swappable git repository in dire
situations, like the flight to YAPC.  I threw this program together.  It's
rough around the edges, but I imagine that it will be very useful in the
future, and that I might expand its features a bit for more general use.

```perl
#!/usr/local/bin/perl
use strict;
use warnings;
use Path::Class;

my $ROOT = dir("/Volumes/RJBS-KEY");

print "key drive not mounted; skipping\n", exit unless -d $ROOT;

my %remote = (
  'code/projects' => [ 'git.codesimply.com'   => '/git/*'        ],
  'rjbs/code'     => [ 'git.rjbs.manxome.org' => 'git/code'      ],
  'rjbs/conf'     => [ 'git.rjbs.manxome.org' => 'git/conf'      ],
  'rjbs/talks'    => [ 'git.rjbs.manxome.org' => 'git/talks/*'   ],
  'rjbs/writing'  => [ 'git.rjbs.manxome.org' => 'git/writing/*' ],
);

sub clone_from_to {
  my ($remote, $path) = @_;

  my ($remote_leaf) = $path =~ m{/?([^/]+)/?\z};

  my ($local_root, $local_leaf) = $remote =~ m{(.+)/([^/]+)\z};

  my $is_starry = $remote{$remote}->[1] =~ m{\*\z};

  my $clone_in = $is_starry
               ? $ROOT->subdir($remote)
               : $ROOT->subdir($local_root);

  my $pull_in = $clone_in->subdir($remote_leaf);

  my $prefix = $pull_in->relative($ROOT);

  if (-d $pull_in) {
    chdir $pull_in;
    print "$prefix: $_" for `git pull -q`;
  } else {
    $clone_in->mkpath;
    chdir $clone_in;
    my $host = $remote{$remote}->[0];
    my $root = $path =~ m{^/} ? '' : '/~rjbs/';
    $path =~ s/ /\\ /g;
    my $url = "ssh://$host$root$path";
    print "$prefix: $_" for `git clone -q $url`;
  }
}

for my $remote (keys %remote) {
  my ($host, $path) = @{ $remote{$remote} };

  my @dirs;
  if ($path =~ m{(.+/)\*\z}) {
    $path = $1;
    @dirs =`ssh $host find $path -type d -mindepth 1 -maxdepth 1`;
    chomp @dirs;
  } else {
    @dirs = $path;
  }

  clone_from_to($remote, $_) for sort @dirs;
}
```
