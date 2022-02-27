---
layout: post
title : things learned while implementing rx
date  : 2008-09-03T03:34:49Z
tags  : ["javascript", "perl", "php", "programming", "python", "ruby", "rx"]
---
Rx was a lot of fun to implement.  It's all about data in memory, not
representation in files, so I got to design it that way, too.  I spent a lot of
time thinking about what the various kinds of in-memory structures were that
I'd need to validate, and then I'd think about how to represent schemata to
validate them.

This was all done outside the realm of any one language or representation,
although I used JSON as a guidepost: it needed to be able to represent any
schema available in core Rx.  Then, once I had the idea down, I'd write a test
file or two for the new type of schema I'd devised.  An Rx test file looks
something like this:

    {
      "schema": {
        "type": "//seq",
        "contents": [ "//int", "//str", "//int" ],
        "tail": {
          "type": "//arr",
          "contents": "//bool",
          "length"  : { "max": 2 }
        }
      },

      "pass": {
        "arr": [
          "0-str-3",
          "0-str-3-T",
          "0-str-3-T-F"
        ]
      },

      "fail": {
        "arr"  : [ "0-str-3-18", "0-str-3-T-str", "0-str-3-T-F-T" ],
        "bool" : "*",
        "null" : "*",
        "num"  : "*",
        "obj"  : "*",
        "str"  : "*"
      }
    }

It provides the schema, then calls out specific accept and reject data from the
Rx test data repository.  Then it's up to each implementation to load the test
data, instantiate the schema, and see if it gets the expected results.

I wrote five distinct implementations of Rx.  Perl, JavaScript, PHP, Python,
and Ruby, in that order.  When writing each implementation, I tried not to look
back at the previous implementations, so that I'd avoid at least a little bit
of direct porting.

Some of the implementations definitely turned out better than others, although
much of that was a factor of how tired I was when I was writing the bits that
should've been better polished.  I'm sure, too, that someone with more
experience in those languages could've done better than I did.  Still, I think
I did pretty well, and it was a fun exercise.  I got a good view of things I
really like or don't like about these languages.

The biggest headache in Perl was dealing with the lack of distinct scalar
subtypes.  JSON::XS and boolean.pm go a decent way to making it possible to
have a "this value only means true or false" scalar, but in Real Programming I
have rarely needed True or False very much.  1 and 0 do me just fine.  Number
and String types, though, would be greatly appreciated.  I think I'd very often
want to just use a plain old scalar and trust myself to do the right thing, but
sometimes I'd really like to know how a value started life -- and fatals when I
try to implicitly change its nature.  I tried for a while to look at the
underlying guts of the scalar -- IV, PV, NV, ETCV -- but that was pointless.
It changes too freely.

The place where Perl beat out everything else, and by large margin, was scope.
Python, Ruby, and JavaScript lack block scope.  This is really a huge deal.  If
you're used to being able to create a variable at the smallest scope possible,
and now it's getting set all over the place, you will begin to wonder what the
hell is going on.  Worse, there's no way to require that you declare variables.
They're created on first assignment.  The canonical example of how this sucks
is something like:

    setting = default
    if not opt.get('setting') is None:
      seting = opt['setting']

    print("current value is %s" % seting)
    do_something(setting)

Augh!  We've made a typo twice, but since the first time it was an assignment,
we created that variable -- and because there's no block scope, the variable is
still there for the second typo, and it gets passed in... as long as the `if`
block was run.  The variable is created at runtime, so if `seting` wasn't
assigned to, we'll get a runtime error.  In Perl, we would've gotten a compile
time error when we would have presumably declared `my $setting` and then tried
to use `$seting` without declaring it.

The use of the `get` method is also there so I can point out the way it bugs
me:  it's also a runtime error to look up a dictionary entry that doesn't
exist, so you have to use one of the dictionary access methods to avoid an
exception.  This actually has saved me a few times, but it bothers me that I
have to use a method.  Python's use of methods versus built-in funtions versus
syntax has always struck me as really haphazard.

In Ruby, the lack of block scope bit me hardest with something like this:

    value = [ ]
    arr.each { |value| do_something }

Okay, so more descriptive variable names would help, but... come on, that's
just awful!

I really enjoyed Python's built-in exceptions, even if only because it means
that I always got a nice stack trace, and even if the stack trace is
upside-down.  It certainly beat Ruby, where the stack traces seemed always to
be slightly weird and confusing and, more importantly, had mediocre error
messages.  Ruby also had trouble with extra commas.

For example, these are valid:

    x = [ 1, 2, 3, ]

    obj.method(1, 2, 3)

...but these are not:

    x = [ 1, 2, 3, , ]

    obj.method(1,2,3,)

That last one becomes really annoying when you've written:

    obj.method(
      compute_first_argument,
      compute_second_argument,
    )

Oops!

JavaScript mostly allows trailing commas, but Microsoft's implementation gets
it wrong, so you must be fastidious about avoiding them.

On the subject of lousy error messages and syntax, though, PHP is a bigger
winner.  I mean, we all know that [PHP should never be
taught](http://zestyping.livejournal.com/124503.html), but there were a few
things that I didn't realize.  Some of them are that PHP's model of truth is
bizarre, that its notions of equality and really-equal-equality are demented,
and that its class indirection (at least prior to 5.3.0) stink.  My absolute
favorite lesson, though, was with exceptions.

I had some code in this form:

    try {
      print "about to try\n";
      $x = y();
      print "done trying\n";
    } catch (Exception $e) {
      print "caught exception\n";
    }

I saw "about to try" but not "done trying" and then this:

    Catchable fatal error: Object of class stdClass could not be converted to
    string in /Users/rjbs/code/projects/Rx/php/Rx.php on line 54

What was going on?!  Why couldn't I catch this thing?  I would have been
willing to believe that it was some kind of ultra-fatal uncatchable error,
except for the label: *Catchable fatal error*.

About 45 minutes later, I found the answer:  Catchable fatal errors can't be
caught with 'catch'.  Instead, you must have a global error handler in place.
If you're a Perl programmer this is like saying, "Built in exceptions can't be
caught by eval; you will need a `$SIG{__DIE__}` in place."  Wow.

Of course, pointing out flaws in PHP (holy cow, its arrays!) is like shooting
duck in a barrel.  I'll just give you one more:

This code:

    <?php
    $x::$y = 10;
    ?>

Generates this error:

    Parse error: syntax error, unexpected T_PAAMAYIM_NEKUDOTAYIM in
    FILE on line 2

Apparently that's Hebrew for "double colon" or something.  Given the fact that
I get this error nearly any time I try to get at class data indirectly, it
would be nice if the error message was in the same langauge as the rest of the
error messages and of the programming language itself.  Oh well.  Maybe when I
upgrade to PHP 5.3.0, this syntax will be valid and I won't care.

I had more trouble with Ruby than just its scope and commas, though.  It
provides a Range class, which I thought would be great for representing, well,
ranges.  Unfortunately, Ruby ranges are either exclusive at both ends or
inclusive at both ends.

Ruby has Perl's lovely postfix statement modifiers, but they become pretty ugly
once you need to use a line continuation marker:

    @type_registry.check_and_register( type ) \
      unless @type_registry.has_handler_for?(type)

That backslash really bugs me.  I also didn't like the hoops I had to go
through to deal with instance or class data.  I couldn't just say:

    class MyClass
      @@datum = 10
      class_attr_accessor :datum
    end

There was more than one way to do it, all annoying.  I also couldn't change the
value for that attribute on a subclass without rewriting the methods involved,
too.  I think it would be possible, with some use of Ruby's introspection, but
I really wanted it to Just Work.  I imagine someone has written a nice module
to solve that problem, already... of course that's only a very, very small
subset of the problems solved for me in Perl in Moose.  When do we get... um...
Rooster?

Moose aside -- since I didn't use it -- it was very pleasant, in every non-Perl
language, to have object construction taken care of for me.  That is, my
initializer got passed a new object, which I initialized.  I didn't have to do
anything to construct the object itself.  Scope comes back into things here,
though.  With Moose, I can define the attributes of my class and then I can't
(politely) act like there are other slots than those I gave it.  In Python,
Ruby, JavaScript, and PHP, I can easily (and accidentally) add more attributes
to an object whenever I want, just by assigning to them.

Python's namespaces continue to irritate me.  In most other languages, I
implemented something called Rx.  In Python, the Rx namespace was applied to
everything in Rx.py, so I needed to call the main thing Rx.Factory.  That's
fine, but what's weird is that I do that by defining `class Factory`.  That
means that Rx.Exception is `class Exception`.  That futher means that from then
on, in Rx.py, `Exception` means the Rx exception class.  To get the "real"
Exception class, I need to use `__builtins__.Exception`.  Ugh.`

In the end, though, I really enjoyed working with all of the languages in
question, except for PHP.  Working with PHP was depressing and frustrating.
Python wasn't really my style -- but big points for having a built in set type.
Beyond that, it was also a totally reasonable language to work in.  I think it
has more annoyances than Perl, for me, but I can definitely see how someone
might feel the other way.  JavaScript was loads of fun, but I think it needs a
bit more sugar for making constructors for derived objects.  I don't think we
need classes in JavaScript, but I also wouldn't mind typing `x.prototype.y` a
lot less.  Ruby, as always, was a lot of fun to program in.  I'd surely use it
more if the CPAN weren't such a massive time-saver.

I often think that my first gems contribution (after Rx, I suppose) will be
Sub::Exporter in Ruby.  That will be fun.

I'm sure I have lots more foibles to report about, but right now that's
everything that springs to mind.

Are you an expert Ruby, PHP, Python, or JavaScript programmer?  I'd love your
feedback on why my implementation of [Rx](http://rjbs.manxome.org/rx) sucks.

