---
layout: post
title : "Test::PgMonger, which you should probably not use"
date  : "2016-05-14T17:52:06Z"
tags  : ["perl", "programming"]
---
[JMAP](http://jmap.io/) is a protocol that is meant to replace IMAP, CalDAV,
CardDAV, SMTP, ACAP (ha ha), and probably some other protocols that aren't
springing to mind.  Like IMAP, it's meant to make it easy to synchronize
offline work with an authoritative server.  It does this by dividing up the
data model into collections of discrete types, with each collection in a known
and addressable state.

I'm not writing this post to talk about JMAP itself, though.

The JMAP model can be useful for things other than email, contacts, and that
sort of thing.  Why not make other things syncable in the same way?  I've been
writing a library to make this easy (or at least less difficult) to do.  Given
a [DBIx::Class](https://metacpan.org/pod/distribution/DBIx-Class/lib/DBIx/Class.pod)
schema, my library [Ix](https://github.com/pobox/Ix) constructs a JMAP-like
method dispatcher as well as a Plack application to publish it.

Ix is not even remotely ready for doing real work, so I'm not writing this post
to talk about Ix, either.

Since an Ix application uses a database for storing all its entities, its test
suite needed a database.  I started out by using my usual strategy for testing
simple database stuff: SQLite!  I love SQLite.  It is great.  For each test, I
could make a new SQLite database, deploy the DBIx::Class schema, and run tests.
Then I'd delete the file.  Done!

As the SQL that I was generating got more complex, I realized that using SQLite
was no longer a good idea.  It was great for getting started, but now I needed
to run my tests against the same setup I'd have in production.  I installed
postgresql on my testing box and [Postgres.app](http://postgresapp.com/) on my
laptop.  (By the way, have you seen Postgres.app?  It runs Postgres, as you, on
your Mac, just like a normal OS X app.  It puts a elephant in the menu bar.
Neat!)  I still needed something to create and destroy my Postgres databases,
though, since they weren't just files anymore.

I had a look at [Test::Database](https://metacpan.org/pod/Test::Database), but
it didn't do what I needed.  I'll write (at least to BooK!) about the specific
problems, but basically Test::Database's view of test databases is that they
aren't nearly as single-use or disposable as what I wanted, and it wasn't easy
to extend.  Eventually, I wrote my own dumb little library, inspired by parts
of Test::Database.  It is called
[Test::PgMonger](https://github.com/rjbs/Test-PgMonger/blob/master/lib/Test/PgMonger.pm)
(pronounced "pig monger"), and it's stupid and effective.

The PgMonger object has credentials to PostgreSQL with permissions to create
new users and databases.  For now, I'm just assuming that localhost is trusted
and I can use the `postgres` user.  It uses those credentials to create a new
user and a new database under a unique prefix.  That database gets cleaned up
at program exist, and there's a way to tell the PgMonger to kill all the
databases that match its creating pattern, in case some escape deletion due to
crashes or other screw-ups.

This is a really simple hunk of code, and even so it needs more refinement.
Hopefully Test::Database can pick up the things I need so that I'm freed from
thinking about this one-off thing.  For now, though, this has made my testing
really painless!

