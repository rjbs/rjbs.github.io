---
layout: post
title : "the stupidest profiler I could write"
date  : "2013-08-24T03:10:22Z"
tags  : ["perl", "programming"]
---
There's a stupid program I rewrite every few months.  It goes like this:

```
perl -pe 'BEGIN{$t=time} $_ = sprintf "%0.4f: $_", time - $t; $t = time;'
```

It prints every line of the input, along with how long it had to wait to get
it.  It can be useful for tailing a log file, for example.  I wanted to write
something similar, but to just tell me how long each line of my super-simple
program took to run.  I decide it would be fun to do this with a Devel module
that would get loaded by the `-d` switch to perl.

I wrote one, and it's pretty dumb, but it was useful and it did, in the end, do
the job I wanted.

When you pass `-d`, perl sets `$^P` to a certain value (on my perl it's 0x073F)
and loads `perl5db.pl`.  That library is the default perl debugger.  You can
replace it with your own "debugger," though, by providing an argument to `-d`
like this:

```
$ perl -d:SomeThing ...
```

When you do that, perl loads Devel::SomeThing instead of `perl5db.pl`.  That
module can do all kinds of weird stuff, but the simplest thing for it to do is
define a subroutine in the DB package called DB.  `&DB::DB` is then called just
before each statement runs, and can get information about just what is being
run by looking at `caller`'s return values.

One of the bits set on `$^P` tell it to make the contents of each loaded file
available in a global array with a funky name.  For example, the contents of
`foo.pl` are in `@{"::_<foo.pl"}`.  Woah.

My stupid timer keeps track of the amount of time taken between statements and
prints your program back at you, telling you how long was spent on each line,
without measuring the breakdown of time spent calling subroutines loaded from
elsewhere.  It expects an *incredibly* simple program.  If you execute code on
any line more than once, it will screw up.

Still, it was a fun little exercise, and maybe demonstrative of how things
work.  The code documentation for this stuff is a bit lacking, and I hope to
fix that.

```perl
use strict;
use warnings;
package Devel::LineTimer;
use Time::HiRes;

my %next;
my %seen;
my $code;
sub emit_trace {
  my ($filename, $line) = @_;
  $code ||= do { no strict; \@{"::_<$filename"}; };
  my $now = Time::HiRes::time();

  $line = @$code if $line == -1;

  warn "Program has run line $line more than once.  Output will be weird.\n"
    if $seen{$line}++ == 1;

  unless (keys %next) {
    %next = (start => $now, line => 1, hunk => 0);
  }

  my @code = @$code[ $next{line} .. $line - 1 ];

  my $dur = $now - $next{start};

  printf STDERR "%03u %04u %8.04f %s",
    $next{hunk}, $next{line}, $dur, shift @code;

  my $n = $next{line};
  printf STDERR "%03u %04u %8s %s",
    $next{hunk}, ++$n, '.' x 8, $_ for @code;

  %next = (start => $now, line => $line, hunk => $next{hunk}+1);
}

package DB {
  sub DB {
    my ($package, $filename, $line) = caller;
    return unless $filename eq $0;
    Devel::LineTimer::emit_trace($filename, $line);
  }
}

END { Devel::LineTimer::emit_trace($0, -1) }

1;
```

With the module above installed in `@INC` somewhere, you can then run:

```
$ perl -d:LineTimer my-program
```

...and get output like...

```
000 0001   0.0000 #!perl
000 0002 ........ use 5.16.0;
000 0003 ........ use warnings;
000 0004 ........ use Email::MessageID;
000 0005 ........ use Email::MIME;
000 0006 ........ use Email::Sender::Transport::SMTP;
000 0007 ........
001 0008   0.0093 my $email = Email::MIME->create(
001 0009 ........   header_str => [
001 0010 ........     From => 'Ricardo <rjbs@cpan.org>',
001 0011 ........     To   => 'Mr. Signes <devnull@pobox.com>',
001 0012 ........     Subject => 'This is a speed test.',
001 0013 ........     'Message-Id' => Email::MessageID->new->in_brackets,
001 0014 ........   ],
001 0015 ........   body => "There is nothing much to say here.\n"
001 0016 ........ );
001 0017 ........
002 0018   0.0028 my $smtp = Email::Sender::Transport::SMTP->new({
002 0019 ........   host => 'mx-all.pobox.com',
002 0020 ........ });
002 0021 ........
003 0022   1.7395 $smtp->send($email, {
003 0023 ........   to   => 'devnull@pobox.com',
003 0024 ........   from => 'rjbs@cpan.org',
003 0025 ........ });
```
