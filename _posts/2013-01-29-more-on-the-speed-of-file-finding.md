---
layout: post
title : more on the speed of file finding
date  : 2013-01-29T03:33:15Z
tags  : ["perl", "programming"]
---
Last week I wrote about [the speed of Perl file
finders](http://rjbs.manxome.org/rubric/entry/1981), including a somewhat
difficult to read chart of their relative speeds in a pretty contrived race.
My intent wasn't really to compare the "good" ones, but to call out the "bad"
ones.  Looking at that graph, it should be clear that you "never" want to use
Path::Class::Rule or File::Find::Rule.  Their behavior is *vastly* worse than
their competition's.

There were some complaints that some lines were obscured.  That's okay!  For
example, you can't see File::Next because it's obscured perfectly by
File::Find, because they almost always take near to *exactly* the same amount
of time.  Heck, I don't even mind the relatively vast difference in speed
between the "slow" configuration of Path::Iterator::Rule given there and the
"fast" default behavior of File::Next.  I figure that in any real work, the few
minutes difference between their performance at million-file scale is unlikely
to be worth noticing for my purposes.

Beyond that, there are *so many* variables to consider when trying to actually
understand these speed differences.  I think that some of the reactions I got,
both privately and publicly, were interesting because the demonstrated to me
the danger of publishing benchmarks.  It was very clear *to me* what I was
measuring, and presenting, and why.  Readers, on the other hand, seemed more
likely to read more into things that I'd meant to present.  Most often,
benchmarks are seen as passing judgement on whether something is good or bad.
Heck, I said that myself didn't I?  I wanted to "call out the difference
between the good ones and the bad ones."

Oops.

Well, what I wanted to do was to see how fast the different libraries could
possibly be, given the fastest possible bare iteration over a bunch of
entities, since that's the starting point for any real work I'd do.  For
example, this was the test code for File::Next:

      my $iter = File::Next::everything({}, $root);
      while (defined ( my $file = $iter->() )) {
        last if $i++ > $max;
      }

Let's face it:  that's not much of a real world use case.  In real life, you're
going to want to look at the filename, maybe its size or type, and quite likely
you'll even (*gasp!*) open it.  All that stuff is going to stomp all over the
raw speed of iteration, unless the iteration is itself *really* out of line
with what it could be.

David Golden read my report and got to work figuring out why
Path::Iterator::Rule was lagging behind File::Next, and he sped it up.  Some of
that speedup was just plain speedup, but much of it comes from providing the
`iter_fast` iterator constructor:

      sub iter_fast {
        my $self     = shift;
        my %defaults = (
          follow_symlinks => 1,
          depthfirst      => -1,
          sorted          => 0,
          loop_safe       => 0,
          error_handler   => undef,
        );
        $self->_iter( \%defaults, @_ );
      }

Why is this one faster?  Well, it stops worrying about symlinks, so there's no
`-l` involved.  It doesn't sort names, which makes it unpredictable between
runs over the same corpus.  It doesn't worry about noticing one directory being
scanned multiple times (because of symlinks).  It doesn't handle exceptions
when testing files.  File::Next acts like this by default, too, but in the end,
you very often *want* these safeguards.

It's great if your program can iterate over 1,000,000 distinct files in four
minutes, but you'll feel pretty foolish when it takes forty minutes because you
forgot that you had a few symlinks in there that caused repeated scans of
subtrees!

Then there's the change to depthfirst.  There, we start to get into even more
situational optimization.  What tree-walking strategy is best for your tree?
Probably you should learn how to decide for yourself, and then make the right
decision.

Still, the availability of these options is *definitely* a great thing.  Not
only does it make the library more flexible, but it allows one to compare
File::Next with Path::Iterator::Rule as apples to apples.

Finally, there are plenty of things to judge more than the raw speed of the
library's fastest base configuration.  Path::Iterator::Rule, for example, has
a very pleasant interface, in my opinion:

      my $rule = Path::Iterator::Rule->new;
      my $iter = $rule->or( $rule->new->name('*.txt'),
                            $rule->new->name('*.html')
                          )
                      ->size('<10k')
                      ->file
                      ->readable
                      ->iter($root);

That's going to build about a half dozen subs that will test each file to
decide whether to include it in the results, and three of them will called for
each kick of the iterator (I think!).  That's fine, it's still really fast, but
you can start to imagine how this can get microöptimized.  After all, with
File::Next:

    my $iter = File::Next::files($root);
    while (defined (my $file = $iter->())) {
      next unless $file =~ /\.(?:html|txt)\z/;
      next unless -f -r $file;
      next unless -s $file < 10240;
      ...
    }

Will this be faster?  I bet it will.  Will I *ever* notice the difference…?
I'm not so sure.  If I thought it would matter, I'd perform *another*
benchmark, of my actual code.  I'd profile my program and figure out what was
fast or slow.

Again: beware of taking very specific benchmark tests as meaning anything much
about your real work without careful review.

Finally, I mention just to scare the reader:  did you know that
File::Find::Rule, though it looks outwardly just like Path::Iterator::Rule,
does not have that 3-6 subroutine call overhead?  See, it takes all the rules
that you build up and, just in time to iterate, builds them into a string of
Perl code that is then `eval`ed into a subroutine to execute as a single
aggregate test.

It's the nastiness of that code that prevented me from ever making good on my
threats to add lazy iteration to File::Find::Rule.  I'm glad, too, because now
Andy and David have provided me with better tools, and all I had to do to get
them was whine and make a chart.

The free software community is fantastic!

