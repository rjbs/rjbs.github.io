---
layout: post
title : "coping with solaris cron"
date  : "2008-10-18T16:25:04Z"
tags  : ["cron", "perl", "programming", "solaris"]
---
More and more, we're eliminating Linux boxes in favor of Solaris.  This is
generally not a huge deal, but one of the niggling details has been Sun's cron.
It sucks.  It sucks because it uses a constant as the subject of its alert
messages.  If you have a lot of servers running a lot of cron jobs, generating
a lot of output, you end up with a display that looks like this:

     1 N Oct17 Super-User      (  7)   Output from "cron" command
     2 N Oct17 Super-User      (  7)   Output from "cron" command
     3 N Oct17 Super-User      (  7)   Output from "cron" command
     4 N Oct17 Super-User      (  7)   Output from "cron" command
     5 N Oct18 Super-User      (  7)   Output from "cron" command
     6 N Oct18 Super-User      (  7)   Output from "cron" command
     7 N Oct18 Super-User      (  7)   Output from "cron" command
     8 N Oct18 Super-User      (  7)   Output from "cron" command
     9 N Oct18 Super-User      (  7)   Output from "cron" command
    10 N Oct18 Super-User      (  7)   Output from "cron" command
    11 N Oct18 Super-User      (  7)   Output from "cron" command

Seriously?

So, I put in a change request to have this fixed.  Deploying Vixie cron was
going to be a massive pain (I was told) so instead we updated our use of puppet
to ensure that our cronjobs were run by a wrapper script.  I'm really happy
with it, as it eliminates a few other crappy wrapper scripts and gets me what I
wanted to begin with.  There are a few internal modules used below, but it
should be trivial to replace them with whatever you want.  (I've removed a few
constants, too.)

Maybe I'll CPANize this later.

    #!/usr/bin/perl
    use strict;
    use warnings;

    use Digest::MD5 qw(md5_hex);
    use Fcntl qw(:flock);
    use Getopt::Long::Descriptive;
    use ICG::SvcLogger;
    use IPC::Run3 qw(run3);       
    use String::Flogger qw(flog);
    use Sys::Hostname::Long;
    use Text::Template;
    use Time::HiRes ();

    my ($opt, $usage) = describe_options(
      '%c %o',
       [ 'command|c=s',   'command to run (passed to ``)', { required => 1 } ],
       [ 'subject|s=s',   'subject of mail to send (defaults to command)'    ],
       [ 'rcpt|r=s@',     'recipient of mail; may be given many times',      ],
       [ 'errors-only|E', 'do not mail if exit code 0, even with output',    ],
       [ 'sender|f=s',    'sender for message',                              ],
       [ 'jobname|j=s',   'job name; used for locking, if given'             ],
       [ 'lock!',         'lock this job (default: lock; --no-lock to not)',
                          { default => 1 }                                   ],
    );

    die "illegal job name: $opt->{jobname}\n"
      if $opt->{jobname} and $opt->{jobname} !~ m{\A[-a-z0-9]+\z};

    my $rcpts   = $opt->{rcpt}
               || [ split /\s*,\s*/, ($ENV{MAILTO} ? $ENV{MAILTO} : '...') ];

    my $host    = hostname_long;
    my $sender  = $opt->{sender} || sprintf '%s@%s', ($ENV{USER}||'cron'), $host;

    my $subject = $opt->{subject} || $opt->{command};
       $subject =~ s{\A/\S+/([^/]+)(\s|$)}{$1$2} if $subject eq $opt->{command};

    my $logger  = ICG::SvcLogger->new({
      program_name => 'cronjob',
      facility     => 'cron',
    });

    my $lockfile = sprintf '.../cronjob.%s', $opt->{jobname} || md5_hex($subject);

    goto LOCKED if ! $opt->{lock};

    open my $lock_fh, '>', $lockfile or die "couldn't open lockfile $lockfile: $!";
    flock $lock_fh, LOCK_EX | LOCK_NB or die "couldn't lock lockfile $lockfile";
    printf $lock_fh "running %s\nstarted at %s\n",
      $opt->{command}, scalar localtime $^T;

    LOCKED:

    $logger->log([ 'trying to run %s', $opt->{command} ]);

    my $start = Time::HiRes::time;
    my $output;

    $logger->log_fatal([ 'run3 failed to run command: %s', $@ ])
      unless eval { run3($opt->{command}, \undef, \$output, \$output); 1; };

    my %waitpid = (
      status => $?,
      exit   => $? >> 8,
      signal => $? & 127,
      core   => $? & 128,
    );

    my $end = Time::HiRes::time;

    unlink $lockfile if -e $lockfile;

    my $send_mail = ($waitpid{status} != 0)
                 || (length $output && ! $opt->{errors_only});

    if ($send_mail) {
      require Email::Simple;
      require Email::Simple::Creator;
      require ICG::Sendmail;
      require Text::Template;

      my $template = do { local $/; <DATA> };
      my $body     = Text::Template->fill_this_in(
        $template,
        HASH => {
          command => \$opt->{command},
          output  => \$output,
          time    => \(sprintf '%0.4f', $end - $start),
          waitpid => \%waitpid,
        },
      );

      my $subject = sprintf '%s%s',
        $waitpid{status} ? 'FAIL: ' : '',
        $subject;

      my $email = Email::Simple->create(
        body   => $body,
        header => [
          To      => join(', ', @$rcpts),
          From    => qq{"cron/$host" <$sender>},
          Subject => $subject,
        ],
      );

      ICG::Sendmail->sendmail(
        $email,
        {
          to      => $rcpts,
          from    => $sender,
          archive => undef,
        }
      );
    }

    __DATA__
    Command: { $command }
    Time   : { $time }s
    Status : { join('', flog('%s', \%waitpid)) }

    Output :
    { $output || '(no output)' }

