---
layout: post
title : time, time, time (-based classes and objects)
date  : 2006-02-19T15:22:33Z
tags  : ["perl", "programming"]
---
Someone complained, looking at the beta version of some new reports, that the "when" field was too precise.  They didn't need "17 days and 6 hours ago," "17 days ago" would do.  I was doing this with Sean Burke's Time::Duration, wrapped by my own Time::Duration::Object, which just turns a number of seconds into an object with methods based on the functions provided by Time::Duration.  It's been a very useful module, but I never noticed that it had a major bug.

    my $duration = Time::Duration::Object->new(87000);
    say $duration->ago;

The above code outputs "1 day and 10 minutes ago," which is just right.  The following code should limit itself to one unit -- meaning "1 day ago." Instead, it outputted something like "just now."

    my $duration = Time::Duration::Object->new(87000);
    say $duration->ago(1);

I was pretty perplexed, until I went to look at the code.

    for (@methods) {
      my $method = \&{"Time::Duration::$_"};
      *{$_} = sub {
        push @_, ${(shift)};
        my $result = &$method(@_);
        bless \$result => 'Time::Duration::_Result';
      }
    }

The above constructs the methods in Time::Duration::Object.  TDO objects are just blessed scalars containing their number of seconds.  Do you see the moronic error?

Well, the arguments to the method should always be `(object, args...)` but I screwed up.  I said to push the object onto the stack, so it was effectively `(args..., object)`.  That works great when args is an empty list, but not so much when there are some arguments.  Instead of calling `ago(87000,1)` my method was calling `ago(1,87000)`.  So, this was a one-word fix, which was a nice change.

I added a test, too.

After doing that, though, I decided I had better up the test coverage.  I found that it was already 100%, and then realized that it had been 100% even before I added that test.  There is no branch or condition regarding whether `@_` is populated, and adding one just to get coverage testing to show up would've been silly.  This major but unseen bug does a great job of demonstrating that 100% coverage is not enough to ensure that your code works perfectly -- or even very well at all.  I *knew* that already, but it's nice to have it rubbed in, now and again.

The more depressing thing (I guess) is that this module has been on the CPAN for something like sixteen months and nobody noticed -- presumably because I'm the only person using it.  Oh well, I still think it's useful!

I was actually doing this through our internal subclass of Time::Piece.  I'm a big fan of Time::Piece, because it's simple and nearly always good enough for what I need.  The problem is that subclassing it has traditionally sucked. There are a few reasons, but the biggest is that it's in the horrible habit of blessing objects into `__PACKAGE__`, meaning that all (or most) objects constructed by subclasses end up being Time::Piece objects instead of whatever they should be.  For example:

    my $time = Time::Piece::SwatchBeats->localtime;
    my $tomorrow = ONE_DAY;

Oops!  `$tomorrow` is a Time::Piece object.  It will not stringify into your awesome [Swatch Internet Time](http://en.wikipedia.org/wiki/Swatch_Internet_Time) string.

This kept biting me in the butt, especially when writing a test for `ago`'s precision.  I'd build a "yesterday-ish" object and check `ago`, only to be told "can't find method ago via the DynaLoader" or some such crap.

Matt Sergeant was very receptive to my bitching, and accepted my patch to Time::Piece.  Version 1.09 is on the CPAN, and can be properly subclassed. Hooray!
