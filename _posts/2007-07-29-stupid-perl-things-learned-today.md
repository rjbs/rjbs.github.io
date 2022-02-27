---
layout: post
title : "stupid perl things learned today"
date  : "2007-07-29T02:44:10Z"
tags  : ["perl", "programming", "stupid"]
---
I was doing some maintenance on E'Mail::Acme, today.  It was failing tests on
perl 5.6.2, and it turned out that I had found a number of weird changes in
behavior between 5.6 and 5.8, most of which will never affect well-behaved
programmers.  Here are some of them.

    my $object = bless {} => "Foo'Bar";

    print ref $object; # prints "Foo'Bar"

    tie my %hash, "Tie'RefHash";

    print ref tied %hash; # prints "Tie::RefHash"

In other words, if you tie a variable into a class that uses the apostrophe
instead of double-colons for namespace separation, the underlying blessed
reference will have double-colons in its ref string anyway, even though this is
not the behavior for blessing.

This is the same between 5.6 and 5.8.

Why does this matter?  Well, because *this* changes:

    my $obj = tied %hash;

    print $obj->isa("Tie'RefHash") ? "ok" : "not ok";

perl 5.6 will print "not ok" because it doesn't think that a `Tie'RefHash`
object isa `Tie::RefHash`.  perl 5.8 will print "ok," because it does.

If you are checking what kind of object implements your tied variable, and you
are checking for an object that has an apostrophe in its class name, you should
expect portability problems if you do not use double-colons in your isa call.

If you are checking this, you already have a lot of problems.  One more can't
hurt.

Here's another fun problem.  E'Mail::Acme used to contain this code:

    use overload '%{}' => sub {
      tie %{*{$_[0]}}, q<E'Mail::Acme::Header> unless %{*{$_[0]}};#'
      return \%{*{$_[0]}};
    };      

On perl 5.6, every time the E'Mail::Acme object was used as a hashref, a new
header was generated.  This is because on 5.6, tied hashes' SCALAR method (what
to do when evaluated in scalar context) is not used.  Tied hashes in scalar
context are undefined.  I had to stick a `defined` after `unless`.

I expect that I will find yet more insane problems with ties, package names,
and portability as times goes on.  Thanks, E'Mail::Acme!

