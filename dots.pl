#!/usr/bin/perl
use v5.12.0;
use warnings;

my @repos = qw(
  rjbs-dots
  rjbs-vim-dots
);

my $home = $ENV{HOME};

my $IS_FM_VM    = -f '/etc/fmisproduction.boxdc';
my $START_OVER  = $IS_FM_VM;
my $UPDATE_ROOT = $IS_FM_VM;

chdir($home) || die "can't chdir to $home: $!\n";

unless (-d "dots") {
  mkdir("dots") || die "can't mkdir dots: $!\n";
}

if ($START_OVER) {
  unlink("$home/.bashrc") || warn "couldn't unlink ~/.bashrc: $!";

  if ($UPDATE_ROOT) {
    for my $file (qw( /root/.bashrc /root/.vimrc /root/.gitconfig )) {
      system('sudo', 'rm', '-f', $file) && warn "couldn't unlink $file: $!";
    }
  }
}

for my $repo (@repos) {
  chdir("$home/dots") || die "can't chdir to $home: $!\n";

  die "$repo already exists!\n" if -e $repo || -l $repo;
  system('git', 'clone', "https://github.com/rjbs/$repo.git");
  die "error cloning $repo\n" if $?;

  chdir($repo) || die "can't chdir to $home/code/$repo: $!\n";

  system('git', 'submodule', 'init');
  die "error doing submodule init\n" if $?;

  system('git', 'submodule', 'update');
  die "error doing submodule update\n" if $?;

  system("$home/dots/rjbs-dots/bin/link-install", "--really");
  die "error installing $repo\n" if $?;

  if ($UPDATE_ROOT) {
    system('sudo', "$home/dots/rjbs-dots/bin/link-install", '--really');
    warn "error installing $repo to ~root\n" if $?;
  }
}

if ($IS_FM_VM) {
  for my $file (qw( /root/.ssh/config )) {
    system('sudo', 'rm', '-f', $file) && warn "couldn't unlink $file: $!";
  }
}
