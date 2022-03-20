---
layout: post
title : "so long, module list!"
date  : "2014-03-26T14:48:03Z"
tags  : ["cpan", "perl"]
---
There's a file in every CPAN mirror called `03modlist.data` that contains the
"registered module list."  It's got no indenting, but if it did, it would look
something like this:

```perl
sub data {
  my $result  = {};
  my $primary = "modid";
  for (@$CPAN::Modulelist::data) {
    my %hash;
    @hash{@$CPAN::Modulelist::cols} = @$_;
    $result->{ $hash{$primary} } = \%hash;
  }
  $result;
}

$CPAN::Modulelist::cols = [
  'modid',       'statd', 'stats', 'statl', 'stati', 'statp',
  'description',
  'userid',      'chapterid',
];

$CPAN::Modulelist::data = [
  [
    'ACL::Regex', 'b', 'd', 'p', 'O', 'b',
    'Validation of actions via regular expression',
    'PBLAIR', '11'
  ],
  ...
];
```

It's an index of some of the stuff on the CPAN, broken down into categories,
sort of like the original Yahoo index.  Or [dmoz](http://dmoz.org/), which is
apparently still out there!  Just like those indices, it's only a subset of the
total available content.  Unlike those, things only appear on the module list
when the *author* requests it.  Over the years, authors have become less and
less likely to register their modules, so the list became less relevant to
finding the best answer, which meant authors would be even less likely to
bother using it.

Some things that don't appear in the module list: DBIx::Class, Moose, Plack,
Dancer, Mojolicious, cpanminus, and plenty of other things you have heard of
and use.

Rather than keep the feature around, languishing, it's being shut off so that
we can, eventually, delete a bunch of code from PAUSE.

The steps are something like this:

* stop putting any actual module data into 03modlist
* stop regenerating 03module list altogether, leave it a static file
* convert module registration permissions to normal permissions
* delete all the code for handling module registration stuff
* Caribbean vacation

There's a [pull request to make 03modlist
empty](https://github.com/andk/pause/pull/37) already, just waiting to be
applied… and it should be applied pretty soon.  Be prepared!

