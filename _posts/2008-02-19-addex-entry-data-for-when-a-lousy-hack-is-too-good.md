---
layout: post
title : "addex entry data: for when a lousy hack is too good"
date  : "2008-02-19T03:45:06Z"
tags  : ["addex", "perl", "programming"]
---
A lot of Addex features rely on your ability to put extra information onto
address book entries.  A really simple example is its generation of procmail
rules.  If it's going to filter mail from Mom into the "family/mom" folder, I
need to be able to tell it that I want that kind of filtering.  Address book
programs, though, are not usually designed to store all the information Addex
wants.

An address book entry in Addex only has a few attributes:

* a name
* a nickname (maybe)
* a list of email addresses
* a bunch of other attributes

The other attributes could all be set up with some kind of attribute
declaration blah blah whatever.  Instead, they use
[Mixin::ExtraFields::Param](http://search.cpan.org/dist/Mixin-ExtraFields-Param).  It's about one line of code and it just goes.

The first three data are pretty easy to get out of most address books.  After
all, they're some of the data that address books are meant to hold.  The "bunch
of other attributes" data are a little iffier.  These attributes are called the
entry's "fields."  Here are some things that you can use fields for:

* specifying the folder used for an contact's mail
* specifying an alternate sig file to use when mailing someone
* indicating which email address to use as default

Using the Apple address book plugin, fields are gathered by looking at the
"notes" section of the entry, which would be really useful for keeping actual
notes about contacts, if the editing UI wasn't so awful.  Addex looks for lines
that look like this:

    field: value

For example, the entry for my brother in law has this in its notes:

    folder: family
    default_email: /noaa/

Using the abook plugin, there are even fewer ways to add arbirary data, so you
have to configure plugin to relate the limit number of extra abook fields with
Addex "fields."

What I like about fields is that they're just so stupid.  I can add arbirary
snippets of data to an entry for any plugin to consume.  By avoiding all the
problems that won't really come up (like namespaces, datatypes, escaping) I've
made it really easy for myself to add new features.

I may write one more little piece about the (current) Addex workflow, if I
decide it's worth the time.  Then I'll be done talking about Addex for a while,
at least until I write some fun new plugins.

