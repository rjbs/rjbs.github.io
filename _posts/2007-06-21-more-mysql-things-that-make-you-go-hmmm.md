---
layout: post
title : "more mysql things that make you go hmmm"
date  : "2007-06-21T12:31:25Z"
tags  : ["mysql", "stupid"]
---
I know that there's a MySQL 5 out.  I do.  It's just that upgrading a big
system takes time, and there usually has to be some pressing reason.  I've just
found one more reason to upgrade sooner:  as far as I can tell, MySQL 4 can't
have fields that are not null and have no default.

In a real relational database, I'd say:

    CREATE TABLE events (
      id          integer PRIMARY KEY SERIAL,
      event_time  datetime NOT NULL DEFAULT current_time,
      event       varchar(128) NOT NULL,
    );

Then, you could:

    INSERT INTO events (event) VALUES ("I ate breakfast.");

The `id` and `event_time` fields would get populated automatically.  If you
tried to insert without an event value, though, your transaction would be
rejected.  "Look, buddy, this table exists to store these data, and if you
don't provide them, there's no point in make a new tuple."

Well, MySQL's behavior is actually to say, "Hey, you forgot to specify a
default when you made that NOT NULL field.  I'll add one for you."  Each
datatype [has its own default
default](http://dev.mysql.com/doc/refman/4.1/en/data-type-defaults.html), and
those get applied when you create your table.  You can't cleverly say "DEFAULT
NULL," because MySQL will stop you.

So, what am I reduced to?  Well, I guess I could do something like this:

    CREATE TABLE events (
      id          integer PRIMARY KEY SERIAL,
      event_time  datetime NOT NULL DEFAULT current_time,
      event       varchar(128) CHECK (event IS NOT NULL),
    );

So, `event` can be null, except the check constraint clause asserts that it
must not be.  I guess that would... no, wait... what?!  I quote the fine
manual:

    The CHECK clause is parsed but ignored by all storage engines.

Right.  Time to implement more data integrity in the application layer for now.

