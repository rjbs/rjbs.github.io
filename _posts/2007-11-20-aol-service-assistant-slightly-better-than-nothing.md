---
layout: post
title : aol service assistant, slightly better than nothing
date  : 2007-11-20T03:05:03Z
tags  : ["aol", "macosx", "perl", "programming", "software", "stupid"]
---
For a long time, my parents have been held hostage by AOL.  AOL, for ages, made
it nearly impossible to use any tool other than their mega-integrated awful
front end to The Internet.  Even once they set up IMAP, you were stuck with
their Favorites and Address Book.  This was a big deal for my dad, who has a
gigantic contact list.  I've been heckling him to use Apple's Address Book for
ages, but he couldn't get out.

Recently, AOL published the [AOL Service
Assistant](http://www.apple.com/downloads/macosx/internet_utilities/aolserviceassistant.html),
which lets you set up your Mac to work with your AOL settings.  Most of this is
trivial, but it exports your AOL Favorites (read: bookmarks) and your Address
Book.  This was great news, and I put it to use when setting up a new Mac for
my mom a few weeks ago.

The big snag was that it exports contacts in a completely asinine way.  As far
as I can tell, AOL's contact list has no concept of "person" or "group."  It
just associates a name with a list of one or more email addresses.  When you
export your contact list to Address Book, each entry becomes a group, and each
address in it becomes a person.  That means that if you had
"grandma@example.com" as the address for your "Nanny Smith" entry, you will now
have a group called "Nanny Smith" with one person.  That person will have no
name, just an email address.

This is totally insane.

Mac::Glue made fixing this a whole lot less hateful than it might have
otherwise been.  Here's the script I used:

    #!/usr/bin/perl
    use strict;
    use warnings;

    use Mac::Glue ':glue';

    my $addr = Mac::Glue->new('Address Book');

    my @groups = $addr->prop('groups')->get;

    my %emails_for;
    my %groups_for;

    for my $group (@groups) {
      my $name = $group->prop('name')->get;
      my @people = $group->prop('people')->get;

      if (@people == 1) {
        # a one-address group is probably a person
        my $person = $people[0];
        my ($email) = map { $_->prop('value')->get } $person->prop('email')->get;
        push @{ $emails_for{ $name } ||= [] }, $email;
      } else {
        # ...but a multipe-address group is probably a group for real real
        my @emails =
          map { $_->prop('value')->get }
          map { $_->prop('email')->get }
          @people;

        for my $email (@emails) {
          push @{ $groups_for{ $email } ||= [] }, $name;
        }
      }
    }

    my %local_part;
    for my $email (keys %groups_for) {
      print "$email\n";
      my ($local_part) = split /\@/, $email;

      unless (grep { $_ eq $email } map { @$_ } values %emails_for) {
        my $i = ++ $local_part{ $local_part };
        $emails_for{"$local_part $i"} = [ $email ];
      }
    }

    # Okay, we've learned all we can, let's obliterate all the bogus cards.
    $_->delete for $addr->prop('people')->get;

    for my $name (keys %emails_for) {
      my @emails = @{ $emails_for{ $name } };

      my ($first, $last);
      ($first, $last) = split / /, $name, 2;

      # Set up the address book card
      my $person = $addr->make(
        new => 'person',
        with_properties => {
          'first name' => $first,
          'last name'  => $last,
        },
      );

      # Add the person's email addresses
      for my $email (@emails) {
        $addr->make(
          new => 'email',
          at  => location(end => $person->prop('emails')),
          with_properties => {
            label => 'Home',
            value => $email,
          }
        );
      }

      # Put each individual back into the groups in which they originally appeared.
      my %group;
      $seen{ $_ }++ for map { @{ $groups_for{ $_ } || [] } } @emails;

      for (keys %group) {
        next unless my $group = $addr->obj(group => whose(name => equals => $_));

        $person->add(to => $group);
      }
    }

Basically, it converts any group with only one address into a person.  For any
group that had more than one address, if it can find a "person" for that
address (in other words, that address appeared in another group with no other
addresses) then the group remains a group, now with that person (and probably
others) in it.  It's not perfect, but it got my mom's 200+ member contact list
into a state where hand-correcting it was not a huge problem.

I'd like to think that AOL will fix this in a future release, but I doubt it.
I think that it's not just awful programming, it's a mismatch between the data
structures of AOL's and Apple's address books.

