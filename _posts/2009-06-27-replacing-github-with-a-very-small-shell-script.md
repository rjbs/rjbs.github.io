---
layout: post
title : replacing github with a very small shell script
date  : 2009-06-27T19:08:39Z
tags  : ["git", "perl", "programming"]
---
...not really.  I still really like using GitHub, and (obviously) they do much
more than I could churn out in a weekend, let alone an hour.  Also, I used
Perl.

That said, we've recently stopped using them for work code.  Things just didn't
work out.  I hope we can migrate back to them someday, but for now we needed to
make a change.

We're using
[gitosis](http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way),
now.  I've used it before, and it's a really fantastic little tool.  As with
most good tools, it does one job and does it very well.  That means that it
doesn't get in the way of the workflow you want to use.

That also means it doesn't go out of its way to make any particular workflow
easy.  That's fine!

I had originally thought we'd be fine having users share their repos from their
home directories, as everyone has read access to every other user's homedir.
This ended up being tedious and stupid, for a number of reasons, including that
each user puts his code in a different subdirectory under home.  (Each choice
other than my own just seems so unnatural!)

When we were using GitHub, we had a program that did something like this:

* ensure that master-user/repository existed
* fork it to you/repository if needed
* clone you/repository to cwd

I updated this program to work on our gitosis setup with uniform per-user
repository URLs.  After all, a GitHub fork is just a clone with a tiny smidge
of added metadata, near as I can tell.

The master user in our scenario is `gitosis@git.example.com`, and every user
also has a login on that box.  Here's the program:

    #!/usr/bin/perl
    use strict;
    use warnings;

    {
      package Git::Hubclone;
      use base 'App::Cmd::Simple';

      use autodie qw(:default :system);
      use Getopt::Long::Descriptive;
      use Sys::Hostname::Long;
      
      my $HOST = q{git.example.com};

      sub usage_desc { '%c %o <repo>' }
      sub opt_spec {
        return (
          [ 'bare-only', "do not create a local clone, only hub copy" ],
        );
      }

      sub validate_args {
        my ($self, $opt, $args) = @_;

        my $user = $ENV{USER};
        my $repo = $args->[0];

        $self->usage_error("no repo name given") unless $repo;
        $self->usage_error("do not run as root") if $user eq 'root';
        $self->usage_error("illegal repo name")  if $repo !~ /\A[-_a-z0-9]+\z/;

        if (! $opt->{bare_only}) {
          $self->usage_error("already in a git repository!")       if -d '.git';
          $self->usage_error("directory './$repo' already exists") if -d $repo;
        }
      }

      sub run {
        my ($self, $opt, $args) = @_;

        my $user = $ENV{USER};
        my $repo = $args->[0];

        if (hostname_long eq $HOST) {
          require File::HomeDir;
          require File::Path;
          require File::Spec;

          my $git_dir  = File::Spec->catfile( File::HomeDir->my_home, 'git' );
          my $repo_dir = File::Spec->catfile( $git_dir, "$repo.git" );

          unless (-d $repo_dir) {
            File::Path::mkpath($git_dir);
            system qq{git clone --bare gitosis\@$HOST:$repo.git $repo_dir};
          }
        } else {
          system "ssh $HOST git hubclone --bare-only $repo";
        }

        unless ($opt->{bare_only}) {
          my $clone_cmd = qq{git clone $user\@$HOST:git/$repo.git};
          system $clone_cmd;
        }
      }
    }

    Git::Hubclone->import;
    Git::Hubclone->run;

I should really fix up App::Cmd::Simple to not require that import for
package-in-program applications.  Still, I'm pretty happy with how easy this
was!  Special thanks go out to Paul Fenwick for `autodie`, which saved me
having to write *loads* of error checking.

