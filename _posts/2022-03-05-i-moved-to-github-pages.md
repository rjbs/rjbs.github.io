---
layout: post
title : I moved my blog to GitHub pages
date  : "2022-03-05T21:53:08Z"
---

In 2004 or so I wrote [Rubric](https://metacpan.org/dist/Rubric), which was
initially intended to be a bookmark manager, and then I added notes to it, and
then it very quickly became the software powering my blog.  It's pretty crufty
under the hood, being built in CGI::Application, which was a nice web framework
in 2004, but never really modernized in the ways I would've liked.

My deployment of Rubric was also a mess, running under FCGI for ages.  I
didn't want to think about the various (minor?) security problems in Rubric.  I
just wanted to be able to write new blog posts without a hassle.  Rubric made
that possible, because I'd written a little program that would launch Vim, let
me edit a post, and then would publish it.

On the other hand, I kept wanting to overhaul my blog to be something that
wasn't abandonware.  (It doesn't matter if I was the original author, it was
still abandonware, because there was no way I was going to do any significant
maintenance work!)

I made a few abortive attempts, over the last two years, to move to something
else, mostly [Zola](https://www.getzola.org/), which we use at work, and which
is fine.  It wasn't complicated, but it was just complicated enough that I
needed friendly docs than I found in front of me.

Last week, I made another go, this time looking at GitHub Pages, which uses
Jekyll.  This seemed about equal in complexity, but I found [Jekyll
Now](https://github.com/barryclark/jekyll-now), a repo I could clone and edit
to get started.  I did that, and it has been just fine.  It's not perfect, but
I feel pretty good about how quickly I got everything working.  I definitely
have a lot of semi-broken posts, and I'll probably work on them over time, but
it's already just fine.

## exporting my posts

I wrote a very mediocre program to dump my blog posts out of Rubric into
something I could publish to Jekyll.  I say "very mediocre", but it got the job
done and now I never need to run that program again, so maybe what I should say
is "supremely successful".

Here it is, in all its successful mediocrity:

```perl
#!/usr/bin/env perl
use v5.35.0;
use utf8;

use Cpanel::JSON::XS;
use DateTime;
use DateTime::Format::RFC3339;
use DBI;
use Path::Tiny;

my $date_fmt = DateTime::Format::RFC3339->new;

my $dbh = DBI->connect(
  'dbi:SQLite:dbname=rubric.db',
  undef,
  undef,
  { sqlite_unicode => 1 },
);

my $sth = $dbh->prepare(q{
  SELECT *
  FROM entries
  WHERE body IS NOT NULL
    AND body <> ''
});

$sth->execute;

my %seen;
my %map;

while (my $entry = $sth->fetchrow_hashref) {
  my $name = $entry->{title};

  # I regret nothing.
  $name =~ s/Ⅰ/I/g;
  $name =~ s/Ⅱ/II/g;
  $name =~ s/Ⅲ/III/g;

  $name = lc $name;

  $name =~ s/'//g;
  $name =~ s/\s+\K-(\d+)/minus $1/g;
  $name =~ s/[^-a-z0-9]/-/g;
  $name =~ s/-{2,}/-/g;
  $name =~ s/^-//;
  $name =~ s/-$//;

  my $when = DateTime->from_epoch(epoch => $entry->{created});
  my $rfc3339 = $date_fmt->format_datetime($when);

  $name = substr($rfc3339, 0, 10) . "-$name";

  if ($seen{$name}++) {
    die "DUPE: $entry->{id} $name\n";
  }

  say "$entry->{id} $name";
  my $path = path('jekyll')->child("$name.md");

  my $title = $entry->{title};
  $title =~ s/\\/\\\\/g;
  $title =~ s/"/\\"/g;

  my $body = $entry->{body};
  $body =~ s/\x0d\x0a/\n/g;

  # Actually, this ended up being a mistake.  I thought it was good enough,
  # but my use of leading whitespace for code blocks was very uneven, and
  # sometimes this ended up making the code seem extra-indented.
  #
  # Over time, I'll update any posts I care about to move them to fenced
  # code blocks with syntax highlighting.
  $body =~ s/^  /    /mg;

  my @tags;

  my $tag_rows = $dbh->selectall_arrayref(
    q{SELECT * FROM entrytags WHERE entry = ?},
    { Slice => {} },
    $entry->{id},
  );

  for my $tag_row (@$tag_rows) {
    my $tag = $tag_row->{tag};

    next if $tag =~ /\A@/; # Used for @markup:md generally.

    next if $tag eq 'journal'; # Redundant?

    # In Rubric, you can have a tag with a value, so if the tag is
    # campaign:beyond, then the tag is "campaign" with the value
    # "beyond", which is useful to filter by the tag at all, or just
    # the tag with that value.
    if ($tag eq 'campaign' && $tag_row->{tag_value}) {
      $tag = "rpg-$tag_row->{tag_value}";
    }

    push @tags, $tag;
  }

  # Why does this say toml?  Well, when this script was first written,
  # it was for Zola, which uses TOML in the front matter.
  my $tags_toml = q{};
  if (@tags) {
    $tags_toml = "\ntags  : ["
               . join(q{, }, map {; qq{"$_"} } @tags)
               . "]";
  }

  my $content = <<~"END";
  ---
  layout: post
  title : "$title"
  date  : "$rfc3339"$tags_toml
  ---
  $body
  END

  $path->spew_utf8($content);

  $map{$entry->{id}} = $name;
}

my @duped = grep {; $seen{$_} > 1 } keys %seen;

if (@duped) {
  warn "Saw more than one entry for...\n";
  warn "- $_\n" for @duped;
  die "Fix it!\n";
}

path("sitemap.json")->spew(
  Cpanel::JSON::XS->new->canonical->pretty->utf8->encode(\%map)
);
```

That `sitemap.json` file, generated at the end, was there so I could set up
redirects from my old URLs to my new ones.  I also took this opportunity to
move from `rjbs.manxome.org` to `rjbs.cloud`.  Beyond being a slightly more fun
domain, it's a lot easier to read outloud, when needed.

## futzing with Jekyll

Of course, I couldn't leave well enough alone and wanted to make the site look
a bit different.  I did just a few basic tweaks so far.  My CSS skills are
pathetic, but I'm happy with what I did to start.
[Joe](https://joewoods.dev/), who knows what he is doing, gave me a tip or two
on achieving what I wanted.

I will definitely continue to poke at the CSS.

The bigger thing, though, was the paginator.  There's a Jekyll pagination
plugin, which I turned on, but I think it's not built for somebody with a
thousand blog posts.  It wanted to show every single page:

![bad pagination](/assets/2022/03/bad-paginator.png)

I wanted something that would have previous and next, first and last, and then
a range of pages around the current one.  This wasn't *hard*, per se, it was
just stupid.  Writing it required doing some arithmetic, but the template
system available ([Liquid](https://github.com/Shopify/liquid)) doesn't really
do arithmetic.  I will elaborate.

You can't write:

```liquid
{{ "{%" }} if x > y + 1 %}
```

If you do… honestly, I'm not sure what happens.  There is no `+` operator in
Liquid, but the above does not fail to compile.  I would like to know more, but
I don't want it enough to dig.  Anyway, it turns out you have to do this,
instead:

```liquid
{{ "{%" }} assign y1 = y | plus: 1 %}
{{ "{%" }} if x > y1 %}
```

I know this is not the greatest horror in the history of programming, but it's
a week later and I'm still grumbling.  Sorry.  The good news is that I got it
working.

![good pagination](/assets/2022/03/good-paginator.png)

With that done, I spent some time looking at the formatting of code blocks.
I went through a bunch of blog posts and switched to fenced code blocks with
file types.  I learned two things:  First, I'd need to improve the color scheme
being used.  (I haven't done that yet.)  Second, the behavior you get when you
suggest an unknown file type isn't great.

For example, my post about [solving the 24 game in
Forth](/blog/2016/08/solving-the-24-game-in-forth/) has, you know, *Forth* code
in it.  Unfortunately, if you give `forth` as the file type, the block stops
being presented as a code block at all and looks really weird.  I can probably
fix this, but it means that until then, I need to be careful about not casually
using non-handled file types.

Even if I went and implemented Forth highlighting (ha!), I don't think it would
really help.  It would have to make it into GitHub's platform, which probably
takes a bunch of time to happen.  The alternative, of course, is to use Jekyll
but host the files myself.  I think I'd rather suffer through unhighlighted
Forth!

## what's next?

I don't know.

This all came out of me taking some time off.  I had too much leave piled up,
and had to take some, and anyway it was a good idea to take some just to
unwind.  More than halfway through my week off, I realized that I hadn't really
done anything I felt good about.  I tried to remember the various fun projects
I'd had floating around in my head, and none came to me.  This felt like a sign
that I needed to work on taking more time off in general.

Anyway, one thing I did have in my todo list was a few (not very interesting)
thoughts on future blog posts.  This made me think I should just go ahead and
fix my blog.  I think it's fixed enough for now, and I'm sure I'll do more, but
the next step is really "new content."

Writing new stuff probably means *doing* new stuff, which sounds great, but
I'll need to do it.  So, what's really next is probably not so much playing
with Jekyll as remembering all the other stuff I thought I might do, doing
that, and then maybe blogging about it.  Wish me luck!
