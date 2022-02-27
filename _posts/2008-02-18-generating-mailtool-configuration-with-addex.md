---
layout: post
title : generating mailtool configuration with addex
date  : 2008-02-18T13:52:42Z
tags  : ["addex", "email", "perl"]
---
I've [complained](http://rjbs.manxome.org/rubric/entry/1414) before about how
stifling I find GUI mail apps.  I can't commit a few twitches to muscle memory
that allow me to perform useful and complex operations the way I can with mutt.
There are some things that GUI apps get right, like high-level folder browsing,
but mostly I just despise them.  Mail.app's integration with Address Book
always tempted me, because I am pretty careful about putting everyone into it.
It was irritating to get nothing out of it.  Ages ago, I wrote a little program
with [Mac::Glue](http://search.cpan.org/dist/Mac-Glue) that would generate a
mutt aliases file from my address book.  Later it grew to produce some other
configuration, and finally it became
[addex](http://search.cpan.org/dist/App-Addex).

I've [written about
addex](http://rjbs.manxome.org/rubric/entries/tags/addex/created_before/2008) a
little before, but never anything comprehensive.  I realized that I really had
to write up an explanation after the nth conversation with a Close Personal
Friend that went like this:

    <rjbs> I'm so happy with Addex.  It's one of the most useful things I've
    written.

    <friend> What's Addex?

Addex is a tool that turns address book information into mailtool
configuration.  It's a very simple program, most geared toward making it easy
to write extensions.  The existing plugins are, unsurprisingly, geared toward
my needs.  When I run `addex`, this is what happens:

1. addex gets all the entries from the Apple Address Book.app
2. addex produces a SpamAssassin whitelist file to whitelist everyone I know
3. addex produces a YAML file describing how to filter mail into folders
    * this replaces my previous use of the Procmail plugin, and is used by my custom Email::Filter script
4. addex produces a file of mutt aliases, one for every combination of each entry's name, nickname, and email address, along with mutt hooks, setting up message saving and .sigs

All of this works right out of the box except, obviously, for the YAML dumper.
I had to write that plugin for myself, and it took about 20 lines of code.

Configuring addex is really easy, and the way configuration works was so
satisfying to implement that [I wrote about it
already](http://rjbs.manxome.org/rubric/entry/1435), long before writing much
about addex itself.

My `.addex` file looks more or less like this:

    addressbook = App::Addex::AddressBook::Apple
    output = App::Addex::Output::Mutt
    output = App::Addex::Output::SpamAssassin
    output = AddexYAML

    [App::Addex::Output::Mutt]
    filename = mutt/alias-abook

    [AddexYAML]
    filename = abook.yaml

    [App::Addex::Output::SpamAssassin]
    filename = spamassassin/whitelists-abook

When I run `addex`, the requested classes are loaded and initialized with the
supplied configuration, then addex gets to work.

Output plugins are really easy to write, especially if they do the usual thing
and write some text to a file for each entry.  For example, here's the entire
code of the SpamAssassin plugin:

    package App::Addex::Output::SpamAssassin;
    use base 'App::Addex::Output::ToFile';

    sub process_entry {
      my ($self, $addex, $entry) = @_;

      $self->output("whitelist_from $_") for grep { $_->sends } $entry->emails;
    }

...and that's it.  The base class takes care of dealing with file IO.  Of
course, it would be easy to write a more complex plugin.  I keep thinking I
might write one that uses Mac::Glue to setup Mail.app rules, either by
performing the scripting events as it goes or by writing out an AppleScript
program to do it later.  It would be easy, assuming it's possible!

When I first got addex into a fit state for human use, I tried to convince all
my Close Personal Friends to use it.  (If you're wondering how well that went,
see above.)  What I found was that a lot of people were now using Mail.app or
Thunderbird.  The few who were still using mutt were either using no address
book or `abook`.  I sat down and wrote a second AddressBook class to handle
`abook` configuration, and it took under an hour.  Someday, I've love to write
a Gmail or Exchange plugin -- well, for some value of "love to" anyway.

Still, I'm one of the few users of addex, and that's fine with me.  Even if
nobody else uses the darn thing, it still saves me loads of time.  I'm hoping
to release at least one new plugin in the next week or so, and maybe as I
release more, I'll snag a few more people, even if it's just a few more friends
who are tired of hearing me rant about it and finally give in to trying it.


