---
layout: post
title : "author tests: no more pointless test failures?"
date  : "2008-02-25T03:41:58Z"
tags  : ["perl", "programming"]
---
The latest release of CPAN::Mini needs to be replaced, because it contains
stupid OS X 10.5 resource fork crap.  That's not why I'm going to replace it,
though.

It also had a `t/perl-critic.t` file to check things against my Perl::Critic
config.  To keep other people from thinking things are busted, I put this in
place:

    if ($ENV{PERL_TEST_CRITIC}) {
      if (eval { require Test::Perl::Critic }) {
        Test::Perl::Critic::all_critic_ok();
      } else {
        plan skip_all => "couldn't load Test::Perl::Critic";
      }
    } else {
      plan skip_all => "define PERL_TEST_CRITIC to run these tests";
    }

Then, today, I got test failure report because somebody else happened to have
that environment variable set.  Oops!  I could make more and more elaborate
tests, but that just seems like a long battle with FAIL waiting to happen.

I've actually had this problem a few times, and it seemed like a nice solution
would be the idea of an "extra tests" directory.  This came up a few times on
the perl-qa mailing list, and it seemed like a great 90% solution.

Today, I combined my problem, this idea, and my long-standing desire to write a
Module::Install plugin.  I uploaded
[Module::Install::AuthorTests](http://search.cpan.org/dist/Module-Install-AuthorTests) earlier this evening.

Basically, it lets you add a line like this to your Makefile.PL (assuming that
you use Module::Install):

    author_tests('xt');

Then, if you're "the author" the tests are run during make test.  If you're
not, they aren't.

Module::Install has a pretty simple idea of whether you're the author.  If an
`./inc` directory doesn't exist when you run the Makefile.PL, one is created,
and all the required Module::Install code it put into it.  Then, a directory is
created called `./inc/author`.  If that directory exists, you're the author.
If it doesn't -- because `./inc` existed already when you ran the Makefile.PL,
because you got the whole thing in a tarball from the CPAN -- then you are not
the author.

So, for someone's smokebot to run my author tests, they'll need to create a
directory in the unpacked dist before running the Makefile.PL.  I think I'm
safe.

Further, moving `pod-coverage.t` and friends to `./xt` looks like it won't
affect my kwalitee rating at CPANTS.  A look at
[Module-CPANTS-Analyse](http://search.cpan.org/dist/Module-CPANTS-Analyse/)
makes it look like it will find the tests with no problem, but I won't have to
worry about every old smoker on the internet running them and telling me that I
forgot a `=back` when I didn't.

I think just about all my dists will get new releases in the next few weeks.

I really need to start using ShipIt or Joseki or something.  I'm afraid I will
end up writing my own.  I should update my Module::Starter templates, too,
which are wildly out of date with how I actually construct dists, now.

For now, though, I'm really happy with this plugin.  Hooray!

