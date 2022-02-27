---
layout: post
title : "the perl 5.10 lexical topic"
date  : "2013-10-03T00:18:38Z"
tags  : ["perl", "programming"]
---
In Perl 5.10, the idea of a lexical topic was introduced.  The topic is `$_`,
also known as "the default variable."  If you use a built-in routine that
really requires a parameter, but don't give it one, the odds are good that it
will use `$_`.  For example:

    s/[“”]/"/g;
    chomp;
    say;

These three operations, all of which really need a parameter, will use `$_`.
The topic will be substituted-in by `s///`, chomped by `chomp`, and said by
`say`.  Lots of things use the topic to make the language a little easier to
write.  In constrainted contexts, we can know what we're doing without being
explicit about every little thing, because our conversation with the language
has been topicalized.

Often, this leads to clear, concise code.  Other times, it leads to horrible,
hateful action at a distance.  Those times are the worst.

Someone somewhere deep in your dependency chain has written:

    sub utter {
      $_ = $_[0];
      s/[“”]/"/g;
      chomp;
      say;
    }

And you write some code like:

    for (@files) {
      log_event("About to investigate file $_");
      next unless -f && -r;
      investigate_file;
    }

Somewhere down the call stack, `log_event` *sometimes* calls `utter`.  `utter`
assigned to the topic, but didn't localize, and if nothing between your code
and `utter` localized, then it will assign to *your* topic, which happens to be
aliased to an element in `@files`.  The filename gets replaced with a logging
string, the string fails to pass the `(-f && -r)` test, so it isn't
investigated.  This is a bug, but it's not a bug in *perl*, it's a bug in your
code.  Is it a bug that this bug is so easy to write?

Well, that's hard to say.  I don't think so.  It's quite a bit of rope, though,
that we're giving you with a *default*, *global* variable that often gets
*aliased* by default!

If the variable wasn't *global*, though, this problem would be cleared up.
We'd have a topic just for the piece of code you're looking at, and you could
hold the whole thing in your head, and you'd be okay.  We already have a kind
of variable for that: lexical variables!  So, Perl 5.10 introduced `my $_`.

So, to avoid having your topic clobbered, you could rewrite that loop:

    for my $_ (@files) {
      log_event("About to investigate file $_");
      next unless -f && -r;
      investigate_file;
    }

When `log_event` is entered, it has no way to see your lexical topic — the one
with a filename in it.  It can't alter it, either.  It's like you've finally
graduated to a language with proper scoping!  The built-in filetest operators
know to look at the lexical topic, if it's in effect, so they just work.  What
about `investigate_file`?  It's a user-defined subroutine, and it wants to be
able to default to `$_` if no argument was passed.

Well, it will need to get updated, too.  Previously it was written as:

    sub investigate_file {
      my ($filename, @rest) = @_ ? (@_) : ($_);

      ...
    }

Now, though, that `$_` wouldn't be able to see your lexical topic.  You need to
tell perl that you want to pierce the veil of lexicality.

    sub investigate_file (_) {
      my ($filename, @rest) = @_ ? (@_) : ($_);

      ...
    }

That underscore in the prototype says "if I get no arguments, alias `$_[0]` to
whichever topic is in effect where I was called."  That's great and does just
what we want, but there's another problem.  We put a `(_)` prototype on our
function.  We actually needed `(_@)`, because we take more than one argument.
Or stated more simply: the other problem is that now we're thinking about
prototypes, which is almost always a road to depression.

Anyway, what we've seen so far is that to gain much benefit from the lexical
topic, we also need to update any topic-handling subroutine that's called while
the topic is lexicalized.  This starts to mean that you're auditing the code
you call to make sure that it will work.  This is a bummer, but it's only one
layer deep that you need to worry about, because your lexical topic ends up in
the subroutines `@_`.  It does not, for example, end up in a
similarly-lexicalized topic in that subroutine.  Phew!

The story doesn't end here, though.  There's another wrinkle, and it's a pretty
wrinkly one.

One of the cool things we can do with lexical variables is build closures over
them.  Behold, the canonical example:

    sub counter {
      my $i = 0;
      return sub { $i++ }
    }

Once `$_` is a lexical variable, we can close over it, too.  Is this a problem?
Maybe not.  Maybe this is really cool:

    for my $_ (@messages) {
      push @callbacks, sub { chomp; say };
    }

Those nice compact callbacks use the default variable, but they have closed
over the lexical topic as their default variable.  Nice!

Unfortunately it isn't always that nice:

    use Try::Tiny;

    for my $_ (@messages) {
      ...
      # a dozen lines of code
      ...

      try {
        ...
      } catch {
        return unless /^critical: /;
        log_exception;
      };
    }

Even though they look like blocks, the things between squiggly braces at `try`
and `catch` are subroutines, so there's a calling boundary there.  When the
sub passed to `catch` is going to get called, the exception that was thrown has
been put into `$_`.  It's been put into the *global* topic, because otherwise
it just couldn't work.  It can't communicate its lexical topic into a
subroutine that wasn't defined within its lexical environment.  Subroutines
only close over lexicals in their defining environment.

Speaking of which, there's a lexical `$_` in the environment in which the catch
sub is defined.  In case you're on the edge of your seat wondering: yes, it
will close over that topic.  The `$_` in the catch block won't match a regex
against the `$_` that has the exception in it, it will match against the
lexical topic established way back up at the top of the `for` loop.  What about
`log_exception`?  Well, it will get one topic or the other, depending on its
subroutine prototype.

And, hey, that's one of the two ways we can fix the `catch` block above:

    catch sub (_) {                 ┃   catch {
      return unless /^critical: /;  ┃     return unless $::_ =~ /^critical: /;
      log_exception;                ┃     log_exception($::_);
    };                              ┃   };

You can take your pick about which is worse.

The last time [this topic (ha ha) came up on
perl5-porters](http://www.nntp.perl.org/group/perl.perl5.porters/2013/02/msg198987.html),
it wasn't clear how this would all get fixed, boiling down to something like
"maybe the feature can be fixed (in a way to be specified later)".

…and that's why `my $_` became experimental in Perl 5.18.0.  It seems like it
just didn't work.  It was a good idea to start with, and it solves a real
problem, and it seems like it could make the whole language make more sense.
In practice, though, it leads to confusing action-at-a-distance-y problems,
because it pits the language's fundamentals against each other.  If we fix the
lexical topic, it will almost certainly change how it works or is used, so
relying heavily on its current behavior would be a bad idea.  If we *can't* fix
the lexical topic, we'll remove it.  That makes relying on its behavior just as
bad.  When relying on a feature's current behavior is a bad idea, we mark it
experimental and issue warnings, and that's just what we've done in v5.18.0.


