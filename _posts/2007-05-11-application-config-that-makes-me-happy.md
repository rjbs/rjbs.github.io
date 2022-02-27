---
layout: post
title : application config that makes me happy
date  : 2007-05-11T03:10:25Z
tags  : ["addex", "perl", "programming"]
---
So, I've done a bit more hacking on
[addex](http://search.cpan.org/dist/App-Addex), some of which was to make it
usable by a larger group of people.  More on that in another entry, though.

The other thing I did was finally get around to changing the config file format
just a little.  It took a tiny bit of work, but I'm really, really happy with
it.

I wanted to use an INI file format, because the "sections and name/value pairs"
was really well-suited to what I wanted.  The problem was that I wanted some
multi-value entries.  One option was to parse the values by hand.  At first,
that's what I did.  I read in with Config::Tiny, then split the relevant
values.  The problem was that this was only really possible with the root set
of options, not with the rest.

I looked into extending Config::Tiny, but it wasn't going to happen, so then I
looked into the eight hundred and sixty four other config parsers (most of
which seem to be for INI files) on the CPAN.  Some of them did what I want, but
were way, way too feature-laden, including some things that I'd count as
misfeatures.  I nearly used Config::IniHash, but then I realized that its
multivalue support required that either (a) every property can be a multivalue,
and therefore all properties are arrays refs or (b) you declare all the legal
multivalue for all possible sections when you request that the file be parsed.
(a) seemed really obnoxious and (b) seemed impossible, since I wouldn't know
all the multivalues until I knew what plugins would be loaded.

See, here's my `addex.ini`:

    addressbook = App::Addex::AddressBook::Apple
    output = App::Addex::Output::Mutt
    output = App::Addex::Output::Procmail
    output = App::Addex::Output::SpamAssassin

    [App::Addex::Output::Mutt]
    filename = mutt/alias-abook

    [App::Addex::Output::Procmail]
    filename = procmail/friends.rc

    [App::Addex::Output::SpamAssassin]
    filename = spamassassin/whitelists-abook

The default section is `classes`, which sets up some core behaviors.  Following
that, each plugin's configuration goes in its own section.  Until I knew what
plugins would be loaded, I couldn't set up multivalues.

My solution was to make the config reader event-driven (in the lamest sense of
the phrase).  When a `change_section` event occurs, it loads the plugin,
queries it for multivalue properties, and then keeps going.  If they occur at
all, multivalue properties are always arrayrefs.  If a non-multivalue property
appears more than once in a section, an exception is raised.

As an aside: in App::Addex, once the config is read in, each plugin is
instantiated into an object like this:

    $plugin = $plugin_class->new($config->{plugin_class});

Each plugin can, thus, be fully configured via this very simple config format.
I think I'll use it again and again.

What really made me happy, though, is that this isn't just yet another
specialized config reader.  App::Addex::Config is a subclass of
Config::INI::Reader, which acts a lot like Config::Tiny, but has a fair number
more methods which can be overridden in subclasses, so that making an INI file
reader with some special behaviors is very easy.  I may or may not write
Config::INI::Writer to even the balance.  I feel compelled to, but I don't
think I have any need.

