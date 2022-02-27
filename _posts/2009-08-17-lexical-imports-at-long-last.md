---
layout: post
title : "lexical imports at long last"
date  : "2009-08-17T14:16:21Z"
tags  : ["perl", "programming"]
---
"Import things to a lexical scope" has been on my todo list for 
[Sub::Exporter](http://search.cpan.org/dist/Sub-Exporter/) for a long time, and
I often thought I had determined how to implement them in pure Perl, and was 
then often disappointed.  The problem is that I basically know zero XS and 
don't know how to mess around with B and the op tree.  Clearly this needs to 
change, because the programmers I know who can sling XS and B can do amazing 
things.

Typester's 
[Exporter::AutoClean](http://search.cpan.org/dist/Exporter-AutoClean) was 
finally close enough to a solution that I felt like I had to respond.  I knew 
that [Florian Ragwitz](http://search.cpan.org/~flora/)'s awesome end-of-scope 
hooks would make it easy, but I'd been putting it off.  I left 
Exporter::AutoClean open in a Firefox tab where it kept mocking me.

Finally, I was complaining on `#moose` that someone should write a Perl 6ish 
interpolation library for perl5, meaning that the following two lines would be
identical:

    "foo {$bar->baz( $x->y )}"
    
    "foo " . $bar->baz( $x->y )

Florian said, "That should be doable, but not until I get a lexical exporter."

Well, it's one thing to be goaded on by a browser tab, and another to be goaded
on by a human.  Florian showed me the sketch of code he'd thought would work 
and I refactored it to be a normal Sub::Exporter helper.  Now you can write 
a library like this:

    package My::Toolbox;
    use Sub::Exporter::Lexical;
    use Sub::Exporter -setup => {
      installer => Sub::Exporter::Lexical::lexical_installer,
      exports   => [ qw(bleep blorp) ],
      groups    => [ default => [ -all ] ],
    };

    ...

And when you use it, this happens:

    for my $x (@values) {
      use My::Toolbox;

      say bleep($x);
    }

That `bleep` routine is available inside the for loop, but outside the loop, 
it's not.  This means you can import routines much more freely, not worrying 
about conflicting or polluting names, because you can see the scope of the name
very clearly.  It's not quite generic lexical subs, but it's still quite nice.

I'm not sure when or where or how I'll start using this, but it's a tool I've 
wanted to have for a long time, so I'm pretty happy to finally have it, thanks
to Florian.

Now I wonder when we'll see Perl 6-style string interpolation.


