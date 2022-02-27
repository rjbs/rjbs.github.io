---
layout: post
title : logging changes in Dist::Zilla were not complete
date  : 2010-03-12T04:15:10Z
tags  : ["distzilla", "perl", "programming"]
---
In short, there was just too much copy and paste.  It wasn't really trivial,
either.  Here's an example of code that appeared in both
Pod::Weaver::Role::Plugin and Dist::Zilla::Role::Plugin:

    for my $method (qw(log log_debug log_fatal)) {
      Sub::Install::install_sub({
        code => sub {
          my ($self, @rest) = @_;
          my $arg = _HASHLIKE($rest[0]) ? (shift @rest) : {};
          local $arg->{prefix} = '[' . $self->plugin_name . '] '
                               . (defined $arg->{prefix} ? $arg->{prefix} : '');

          $self->weaver->logger->$method($arg, @rest);
        },
        as   => $method,
      });
    }

This is gross for a few reasons, but I think that its basic grossness should be
obvious.  I didn't want anyone to have to copy this around.  The replacement is
really nice:

    has logger => (
      is   => 'ro',
      lazy => 1,
      handles => [ qw(log log_debug log_fatal) ],
      default => sub {
        $_[0]->weaver->logger->proxy({
          proxy_prefix => '[' . $_[0]->plugin_name . '] ',
        });
      },
    );

We say, "I'm a plugin of something with a logger.  If I need to log anything,
I'll ask for a proxy to that logger, and my proxy will have a custom prefix."

This proxy is a Log::Dispatchouli::Proxy, which closely emulates much of
Log::Dispatchouli, but with some bits localized and some bits off limits.  For
example, that `proxy_prefix` can't be changed after the fact, but we could turn
debugging on or off without affecting the parent logger.

Because I'm using proper delegation again, I can make things lazy again, and I
can make it easy to tweak the behavior of one plugin for testing purposes.

This logging work has taken more time than I expected, but I think it will
really pay dividends.  I hope to get the new logging code documented and all
the relevant updates deployed to the CPAN tomorrow.  For now, I'm beat and I'm
going to bed.

