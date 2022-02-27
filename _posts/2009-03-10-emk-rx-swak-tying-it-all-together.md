---
layout: post
title : emk, rx, swak: tying it all together
date  : 2009-03-10T14:30:36Z
tags  : ["email", "perl", "programming", "rx"]
---
At long last, I've begun really tying together a number of things all meant to
be used together.  So far, it's been a huge success and I'm really happy with
it.  They are:

* [Email::MIME::Kit](http://search.cpan.org/dist/Email-MIME-Kit)
* [Data::Rx](http://search.cpan.org/dist/Data-Rx)
* [Path::Resolver](http://search.cpan.org/dist/Path-Resolver)

EMK is something of a templating system for whole MIME messages.  I [wrote
about EMK before](http://rjbs.manxome.org/rubric/entry/1724), explaining why
it's useful and how it works and how I tried to avoid being just another
templating system.

[Rx](http://rjbs.manxome.org/rx) is an extensible cross-language data
validation system.  It's extensible and easy to use in many places.  I've
[written a bit about it](http://rjbs.manxome.org/rubric/~rjbs/rx) already, and
I'll probably write more as it gets better in the future.

Path::Resolver is not a dispatcher.  I mention this only because a few of the
other guys in #moose have been working on
[Path::Dispatcher](http://search.cpan.org/dist/Path-Dispatcher/) and
[Path::Router](http://search.cpan.org/dist/Path-Router/), which *are*
dispatchers, and I am *not* working on that problem.  Instead, this is more of
a generic form of
[HTML::Mason::Resolver](http://search.cpan.org/dist/HTML-Mason/lib/HTML/Mason/Resolver.pm).
You give it something that looks like a path and, if it can find it, it hands
you back the content of the entity at that path.  The gimmick is that you can
write resolvers that look at things other than the filesystem.  I'd always
thought of Mason's facility for pluggable resolvers as sort of cute until
Dieter wrote
[MasonX::Resolver::WidgetFactory](http://search.cpan.org/~rjbs/MasonX-Resolver-WidgetFactory-0.007/lib/MasonX/Resolver/WidgetFactory.pm)
and let us use
[HTML::Widget::Factory](http://search.cpan.org/dist/HTML-Widget-Factory)
objects as if they were paths.  It's pretty amazingly useful.

Path::Resolver comes with routines for looking in directories,
[File::ShareDir](http://search.cpan.org/dist/File-ShareDir/) installs, tar
files, [DATA sections](http://search.cpan.org/dist/Data-Section/), and (of
course) the actual filesystem.  It needs work, but it works for what I need.

[EMK SWAK](http://search.cpan.org/dist/Email-MIME-Kit-KitReader-SWAK/) ties EMK
and Path::Resolver together and [EMK
Rx](http://search.cpan.org/dist/Email-MIME-Kit-Validator-Rx) does the same for
EMK and Rx.  Now I can write a manifest like this:

    ---
    kit_reader: SWAK
    renderer: TT
    validator:
    - Rx
    - combine: all
      path: /dist/Pobox/rx/system-message.json
      schema:
        type: //rec
        rest: //any
        required:
          account: { type: /perl/obj, isa: Pobox::Account }
          invoice: { type: /poboxrpc/invoice }
    alternatives:
      - type: text/plain
        path: body.txt
      - type: text/html
        path: body.html
    attachments:
      - type: application/pdf
        body: "[% invoice.as_pdf %]"

This is exciting, for me, for a few reasons.  For one thing, it's nice to see
the code I wrote getting more and more practical use without revealing some
secret and horrible design flaw.  (I guess I'll have to wait until later for
that.)  For another, as more things are stored in YAML or JSON rather than
code, it means that more people can make changes to our system without touching
the Perl.

The biggest todo left on the table is improving Data::Rx's error reporting.
I'm not looking forward to doing it, but I'm looking forward to it being done.

