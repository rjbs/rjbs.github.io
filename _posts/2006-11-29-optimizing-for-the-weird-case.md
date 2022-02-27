---
layout: post
title : "optimizing for the weird case"
date  : "2006-11-29T03:54:02Z"
tags  : ["email", "perl", "programming"]
---
Holy cow!

    knight!rjbs:~/code/pep/Email-Simple/tags/1.996$ perl -I lib readmail headers.msg 
    just started                :   1360    28328
    after require File::Slurp   :   2228    28704
    after slurping              :  12192    38656
    after require Email::Simple :  12248    38656
    after construction          : 129368   159816

If you try to build an Email::Simple from a message with 10,000 unique headers,
be prepared to give up some RAM.  It's not quite as bad if you just have 10,000
values for one header:

    knight!rjbs:~/code/pep/Email-Simple/tags/1.996$ perl -I lib readmail oneheader.msg 
    just started                :   1360    28328
    after require File::Slurp   :   2228    28704
    after slurping              :  11040    37504
    after require Email::Simple :  11096    37504
    after construction          :  87380   114852

Still, this is nuts...

    knight!rjbs:~/code/pep/Email-Simple/tags/1.996$ ls -l *head*msg
    -rw-r--r-- 1 rjbs rjbs 5092896 Nov 28 08:29 headers.msg
    -rw-r--r-- 1 rjbs rjbs 4504001 Nov 28 08:56 oneheader.msg

It should not take 100 MB to store five meg message in an object!

The latest trunk of Email::Simple makes this just a bit better:

    knight!rjbs:~/code/pep/Email-Simple/trunk$ perl -I lib readmail headers.msg
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  12196    38656
    after require Email::Simple :  12260    38656
    after construction          : 114444   144892

    knight!rjbs:~/code/pep/Email-Simple/trunk$ perl -I lib readmail oneheader.msg
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  11044    37504
    after require Email::Simple :  11112    37504
    after construction          :  74184   101656

That's hardly a big improvement, though.  Reading the message in as a
reference, a new feature in the trunk, doesn't help much either: the memory
usage isn't in the body storage or copying, it's in the data structures used to
store the header.  Despite the massive data structure, I decided that my first
"simple" fix would be to replace this code:

    for (split /$mycrlf/, $$head) {
      #  ... parse the field ...
    }

With this "better" code:

    my $head_txt = $$head;
    while ($head_txt =~ m/\G(.+?)$mycrlf/g) {
       my $line = $1;
       # ... parse the field ...
    }

What made it better?  Well, position-marking regex are less commonly used, so
surely they're an efficiency trick, right?  Well, no.  Actually, I thought this
would help me approximate a lazy split, moving from one record separator to the
next as I process each line.  The problem is that I apparently can't use a
pattern with `/g` on a dereferenced scalar.  I need to make a copy in memory,
which takes up a lot of space.  In fact, if I'm going to copy it, I might was
well just split!  So, back to looking for useful improvements.

Email::Simple headers are stored as three data structures, two hashes and an
array, which are called the *head*, the *header names*, and the *order*.  The
head has one entry for each header-name; the value is an arrayref of every
value for that header, in the order they should appear in the header.  The
order a list of header names, including duplicates, in the order in which they
appear.  The header names, bizarrely, relate the lowercased version of a header
to the latest casing of it to appear in the input... this is almost certainly a
bug introduced when fixing other problems with the header.  Still, it means
that this message:

    Foo: Alfa
    foo: Bravo
    Bar: Charlie
    FOO: Delta
    Baz: Foxtrot
    Baz: Gulf
    bar: Hotel

is stored like this:

    $head = {
      Bar => [ qw(Charlie) ],
      bar => [ qw(Hotel)   ],
      Baz => [ qw(Foxtrot Gulf) ],
      Foo => [ qw(Alfa) ],
      FOO => [ qw(Delta) ],
      foo => [ qw(Bravo) ],
    };

    $order = [ qw(Foo foo Bar FOO Baz Bar) ];

    $header_names = {
      bar => 'Bar',
      baz => 'Baz',
      foo => 'FOO',
    }

That's a lot of repeated data!  Given all those unique headers in our first
test message, we're going to have to store every header name four times: once
in the head, once in the order, and twice in the header names.  
Given all those repeated headers, we're still going to store the header name
10,003 times -- once for the entry in the head, twice in the header names (once
lowercased and once verbatim), and ten thousand times in the order.

I guess it's nice to have a super-fast lookup, but how many headers are there
really going to be, in a normal message, that you want to have such heavy
duplication for optimization?  Is hash lookup really going to be faster in real
time than a linear search by name acros a hundred headers?  If you have ten
thousand headers (for... some reason), would you rather that searching take a
few milliseconds longer, if it costs you fifty megs of RAM?  My wager, here, is
that you'd rather optimize for the common case and save plenty of memory for no
noticeable change.

So, I replaced the head, the order, and the header names with "headers."  It's
just a reference to an array of pairs.  The above message is now:

    my $headers = [
      Foo => 'Alfa',
      foo => 'Bravo',
      Bar => 'Charlie',
      FOO => 'Delta',
      Baz => 'Foxtrot',
      Baz => 'Gulf',
      bar => 'Hotel',
    ];

Nice and simple.  How does it compare memory-wise?

    ~/code/pep/Email-Simple/trunk$ perl -I lib readmail headers.msg
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  12196    38656
    after require Email::Simple :  12260    38656
    after construction          :  57804    82732

    ~/code/pep/Email-Simple/trunk$ perl -I lib readmail oneheader.msg 
    just started                :   1364    28328
    after require File::Slurp   :   2232    28704
    after slurping              :  11044    37504
    after require Email::Simple :  11108    37504
    after construction          :  52756    78232

Not great; an eight meg message probably shouldn't take forty megs.  Still,
savings twenty to sixty megs isn't a bad start.  I think I'll cut a development
release (which will secretly require the newest Email::MIME, for forward compat
reasons) and see what bugs are shaken out.

