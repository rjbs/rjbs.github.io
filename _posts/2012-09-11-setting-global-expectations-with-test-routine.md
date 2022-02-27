---
layout: post
title : "setting global expectations with Test::Routine"
date  : "2012-09-11T22:25:48Z"
tags  : ["perl", "programming"]
---
Today I finished a bunch of work that significantly improved the test suite of
[our billing system](http://github.com/pobox/Moonpig).  It all sprang from two
of my favorite things coming together:  [adding more `print`
statements](http://rjbs.manxome.org/rubric/entry/1897) and
[Test::Routine](http://advent.rjbs.manxome.org/2010/2010-12-21.html).

I'm going to simplify the truth a little bit, but here's what happened.

Sometimes, a customer pays for a year in advance at $20 per year.  Six months
later, he or she upgrades to a more expensive tier of service — let's say $40
per year.  Now, instead of six months left, the customer only has three months,
because the rate at which the paid balance is being drawn down has doubled.
The customer now has two options:

1. live with the three month difference
2. pay $10 to get back to the original expiration date

We call option 2 "psyncing" for historical reasons.

When the billing system notices that the customer's expiration date has
changed, it generates a quote to restore the original expiration date and sends
it to the customer.  The customer can ignore it (because it's just a quote) or
can pay it.

A problem showed up not too long ago, where a customer received a quote saying
something like, "If you pay this bill, your expiration date will be January 1,
2020."  Unfortunately, it was wrong.  It should have said 2019.  The problem
had to do with how expiration dates were calculated, and was fascinating, but
only to me, so I won't relate it here.  The point was:  I had to fix this.

The psync code is pretty complicated, and I really didn't want to break
anything.  We had tests, but they largely tested that the things we expected
did happen.  Not enough tested that things we didn't expect didn't happen.
That's sort of hard to test for!  Still, I wanted to make sure that when I
changed the psync code, we didn't start sending lots of psync notices where we
hadn't before.

I went into the psync code and had it print out a big `YOU JUST PSYNCED!` every
time it sent a notice.  Unfortunately, I saw a bunch of notices in tests that
shouldn't have caused any.  I spent some time trying to figure out what I'd
broken, but I had no luck.  Finally I went back to the deployed branch and
added the same notice... and there it was!  The tests were doing psyncing in
places we'd never expected, and because it didn't affect the limited
expectations we had established, we never noticed.

I slowly went through the tests on the master branch, figured out why they were
psyncing, and either added a "this should psync" assertion or fixed the code to
avoid it.  Adding those assertions was easy because of Test::Routine.

With Test::Routine, we write our tests as roles that can be composed before
running.  Our billing system is based around customer records called "ledgers,"
and one of the most commonly-used Test::Routine roles in the system is
LedgerTester.  It provides useful behavior for testing all kinds of
ledger-related stuff.  I added this method:

      sub assert_n_deliveries {
        my ($self, $n) = @_;
        my @deliveries = $self->get_and_clear_deliveries;
        is(@deliveries, $n);
        return @deliveries
      }

Then, in any test where I wanted to say "by this point in the test I expect to
see 1 message," I'd just call that method.  I went through the code with the
errant psyncs and added expectations.  Unfortunately, they didn't always help!
I knew that the test was sending a psync, because of my big blinking red
notice, so I'd add an assertion that there was one delivery.  What I didn't
know was that it was also sending 22 invoices for unrelated reasons!  I wanted
a way to make sure that I'd accounted for *every single delivery* from *every
single test* and I didn't want to have to copy and paste a lot of crap all over
the place.

So, back to LedgerTester!  Among other things, it does something like this:

      around run_test => sub {
        my ($orig, $self, @rest) = @_;

        local $ENV{MOONPIG_STORAGE_ROOT} = $self->tempdir;
        $self->$orig(@rest);

        Moonpig->env->clear_storage;
      };

This means that every individual test in any LedgerTester routine will get its
own temporary storage space for the persistence layer.  Incidentally, if you
can't tell why that storage space would be different between runs, it's because
LedgerTester composes another Test::Routine role, HasTempdir:

      has tempdir => (
        is   => 'ro',
        isa  => 'Str',
        lazy => 1,
        default => sub { tempdir(CLEANUP => 1 ) },
        clearer => 'clear_tempdir',
      );

      before run_test => sub { $_[0]->clear_tempdir };

Thanks, roles!

Anyway, all I did was update that `run_test` advice:

      around run_test => sub {
        my ($orig, $self, @rest) = @_;

        local $ENV{MOONPIG_STORAGE_ROOT} = $self->tempdir;
        $self->$orig(@rest);

        my @deliveries = $self->assert_n_deliveries(0, "no unexpected mail");
        for (map {; $_->{email} } @deliveries) {
          diag "-- Date: " . $_->header('Date');
          diag "   Subj: " . $_->header('Subject');
        }

        Moonpig->env->clear_storage;
      };

Now every time a test method ran, if its assertions didn't add up to the total
mail count, there would be a failing test telling me how many unexpected
messages I got and what they were.  I reran my test suite and about 25 files
started failing.  I went through each file without looking at its test results,
added assertions where I thought they belonged, and I got quite a bit closer to
the right results.  Some places, though, things were really surprising!

For example, sometimes instead of paying a virtual invoice to get funds onto a
customer, we'd just shove money into the account in a way that could never
happen in production.  This meant that the invoice would go unpaid and dunn
endlessly.  Oops!  Then fixing that would expose further problems in the
invoicing schedule in the test.  It also exposed a serious bug in the way that
coupons were being handled.  This was a bug that I'd theorized might exist, but
hadn't yet proved, and adding those five lines above had done it for me.

Doing this update revealed a number of other minor problems, too, as any
refactoring often does.  More importantly, though, it demonstrated that not
only *should* we try to set up expectations about every side-effect in our
tests, we *can* do so, and pretty easily too.  Without Test::Routine, this
would've been a much bigger hassle.

