---
layout: post
title : "more little git n-liners"
date  : "2009-06-29T20:15:37Z"
tags  : ["git", "perl", "programming"]
---
I mean, they're not one-liners.  They're full programs.  They just do something
really really simple.

This one blows away all remotes (left over from, say, GitHub) and adds all the
remotes for users on our `git.example.com` git-on-ssh hosting box.

    #!/usr/bin/perl
    use strict;
    use warnings;

    {
      package Git::Our::Remotes;
      use base 'App::Cmd::Simple';

      use autodie qw(:default :system);
      use Cwd;
      use Getopt::Long::Descriptive;
      use Term::ReadKey;

      my $HOST = q{git.example.com};

      sub opt_spec {
        return (
          [ 'dry-run', "be like quality department; don't actually do anything" ],
        );
      }

      sub _runcmd {
        my ($self, $opt, $cmd) = @_;

        if ($opt->{dry_run}) {
          print "running: $cmd\n";
        } else {
          system($cmd);
        }
      }

      sub validate_args {
        my ($self, $opt, $args) = @_;

        my $user = $ENV{USER};

        unless (defined $args->[0]) {
          my $cwd = getcwd;
          $cwd =~ s{.*?/?([^/]+)\z}{$1};
          $args->[0] = $cwd;
        }

        my $repo = $args->[0];

        $self->usage_error("too many args given") if @$args > 1;
        $self->usage_error("do not run as root")  if $user eq 'root';
        $self->usage_error("illegal repo name")   if $repo !~ /\A[-_a-z0-9]+\z/;
        $self->usage_error("you should run this in a repo") if ! -d '.git';
      }

      sub run {
        my ($self, $opt, $args) = @_;

        my $repo = $args->[0];

        # should be using a library!
        print "press any key to reset all remotes for repo '$repo'";
        Term::ReadKey::ReadMode 'cbreak';
        Term::ReadKey::ReadKey(0);
        Term::ReadKey::ReadMode 'normal';
        print "\n";

        my $user    = $ENV{USER};
        my @others  = grep { $_ ne $user }split / /, (getgrnam('staff'))[3];

        my @remotes = `git remote`;
        chomp @remotes;

        $self->_runcmd($opt, "git remote rm $_") for @remotes;

        $self->_runcmd($opt, "git remote add deploy git\@$HOST:$repo.git");
        $self->_runcmd($opt, "git remote add origin $user\@$HOST:git/$repo.git");

        for my $o (@others) {
          $self->_runcmd($opt, "git remote add $o $user\@$HOST:~$o/git/$repo.git");
        }

        print "remotes created!\n";
      }
    }

    Git::Our::Remotes->import;
    Git::Our::Remotes->run;

...and that's it.  Anyone can run `git ourremotes` to fix remotes setup.  If
the user hasn't set up his own hosted ssh remote, he can just run `git hubclone
--bare-only` using the script I blogged about on Saturday.  Done!

