---
layout: post
title : "putting named captures to awesome use"
date  : "2008-01-17T19:58:20Z"
tags  : ["perl", "programming"]
---
Well, I think the use I put them to is awesome, but it's part of an IRC
interface to something, so there's sort of a maximum cap on awesomeness.

Anyway, here's some slightly simplified code (using MooseX::POE):

    my @MSG_PATTERNS = (
      qr/item\s+(?<x>-?\d+)\s*,\s*(?<y>-?\d+)\s*/ => 'item_report',
      qr/grid/                                    => 'grid_summary',
    );

    event irc_public => sub {
      my ($self, $kernel, $nick, $msg) = @_[OBJECT, KERNEL, ARG0, ARG2];

      for (my $i = 0; $i < @MSG_PATTERNS; $i += 2) {
        my ($pattern, $method) = @MSG_PATTERNS[ $i, $i + 1 ];
        next unless $msg =~ /\A$pattern\z/;
        my $result = $self->$method({{ "{%" }}+});
        if (ref $result) {
          $self->privmsg($self->channel => $_) for @$result;
          return;
        } else {
          return $self->privmsg($self->channel => "$nick: $result");
        }
      }
    };

The important points are:

1. the regex pattern with named captures like: `(?<x>-?\d+)`
2. the method call that passes in `{ %+ }`

See, if the pattern matches, all the named captures end up in the magic
variable `%+`.  That means that after this line:

    "item (3, -1)" =~ qr/item\s+(?<x>-?\d+)\s*,\s*(?<y>-?\d+)\s*/

That variable contains:

    (x => 3, y => -1)

Basically, by using named captures, I can allow these rules to set up named
arguments for methods!  I don't need to futz around with converting from a list
of positional matches into anything else.  I don't even really need to validate
(for this application) because I've *already* matched them against a validating
regular expression.  I know this is a very simple application of named
captures, but the amount to which it simplified this code is amazing.  It
turned a tedious three step process (extract, translate, dispatch) into an
elegant two step process, eliminating translation.

I look forward to future applications of 5.10's fun new features.

