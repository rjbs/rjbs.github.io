---
layout: post
title : publishing parts of my tiddlywiki
date  : 2008-11-15T04:19:56Z
tags  : ["perl", "programming", "tiddlywiki", "wiki"]
---
Some time ago I wrote that I had [moved my D&D wiki to
TiddlyWiki](http://rjbs.manxome.org/rubric/entry/1444).  This has worked pretty
well, although I've mostly given up storing YAML in my TiddlyWiki -- mostly
because I didn't end up using the tools that used it all that much.  Maybe next
time.

Anyway, I'm getting close to starting my next game, and I've been doing much
more work on the wiki for that one, and I have been annoyed at all the copying
and pasting I've been doing.  I want to give some of the content to the players
but keep most of it private.

I looked at using two TiddlyWikis, but of course I'd want a single one to edit.
I thought maybe I could have the second be for the players, and I'd sync it
from mine.  It was going to be a pain, though, to edit the list of synced
pages.  I really wanted to say, "sync everything tagged Public."

Then I realized that I didn't want this, either.  I want to be able to put
secret data on my wiki pages, and to easily give the page to my players -- sans
the internal notes.

My solution is an ugly hack that I think will work just fine.  I've set up a
shared folder on [Dropbox](http://getdropbox.com/) where my players will save
their notes, maps, and so on.  I made a folder in that share where I'll put
articles about house rules, mechanics, and so on.  It's all stuff from my wiki,
published with a script that iterates over my TiddlyWiki finding and
reformatting pages with the Public tag.  It strips out private notes, replaces
transclusion with cross reference, and does some other stuff.

I thought I'd be able to publish HTML using some CPAN module, but the only
TiddlyWiki formatter on the CPAN seems to be vaporware.  In the end, I decoded
that wiki markup is easy enough for the players to read.  I think this will
work really well.

Here is the hacky script I'm using:

    use strict;
    use warnings;
    use 5.010;
    use HTML::TreeBuilder;
    use Text::Autoformat;
    use Text::Balanced qw(gen_extract_tagged);

    my $extractor = gen_extract_tagged(map quotemeta, qw( [[ ]] ));

    my $tree = HTML::TreeBuilder->new->parse_file($ARGV[0]);

    my @tiddlers = grep { ($_->attr('tags') || '') =~ /\bPublic\b/ }
                   $tree->look_down(_tag => 'div');

    sub eq_pad {
      my ($str) = @_;
      my $total = 73 - length $str;
      return "$str " . ('=' x $total);
    }

    sub filename {
      my ($title) = @_;
      $title =~ s/\W+/-/g;
      return lc "$title.txt";
    }

    for my $tiddler (@tiddlers) {
      my $title = $tiddler->attr('title');
      my $fn = filename($title);
      open my $fh, '>', $fn or die "can't open $fn to write: $!";

      my $tag_str = $tiddler->attr('tags') || '';
      my @tags;
      while (length $tag_str) {
        my $tag;
        ($tag, $tag_str) = $extractor->($tag_str);
        if ($tag) {
          push @tags, $tag;
          next;
        } else {
          push @tags, split /\s+/, $tag_str;
          last;
        }
      }

      my $mod_date = $tiddler->attr('modified') || '';
      my (@date) = $mod_date =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})$/;

      say $fh 'Title   : ', $title;
      say $fh 'Tags    : ', join ', ', sort @tags;
      say $fh join ' ', 'Modified:',
        ($mod_date ? (join('-', @date[0,1,2]), join(':', @date[3,4])) : '??'),
        'by', $tiddler->attr('modifier') || '?';
      say $fh '';

      my $text = $tiddler->as_text;
      $text =~ s{<part \w+>\n}{}g;
      $text =~ s{</part>\n?}{}g;

      $text =~ s/^!!(.+)$/"\n\n== " . eq_pad($1) . "\n"/meg;

      my @chunks = split /\n{2,}/, $text;
      my @xref;

      for my $chunk (@chunks) {
        last if $chunk =~ /^----/;
        next if $chunk =~ /@@/;

        $chunk =~ s/\[\[([^\]|]+)(?:\|[^\]]+)?\]\]/$1/g;
        if ($chunk =~ /<<tiddler Template:Summary with: ([\s\w]+)>>/) {
          push @xref, $1;
          next;
        }

        if ($chunk =~ /^== /) {
          $chunk .= "\n\n";
        } else {
          $chunk = autoformat $chunk
        }
        print $fh $chunk;
      }

      say $fh "SEE ALSO: $_" for @xref;
    }

