---
layout: post
title : constructing email messages painlessly
date  : 2009-01-25T03:57:08Z
tags  : ["email", "perl", "programming"]
---
Building email messages is a pain.  Even if you use a library to build the
message string for you, you have to know a lot of crap and pay attention to a
lot of details.  If you know what those details are, it's a pain.  If you don't
know what they are, you don't feel any pain until later, when you find out all
the ways things went wrong.

It's more of a pain, too, when trying to set up multipart emails that are sent
all the time, like subscription notifications, welcome messages, reports, and
so on.  I've seen a lot of awful solutions to this problem.  My favorite awful
solution was when I saw some code that took a complete, encoded MIME message
and used it as a template.  You'd have to pass it variables properly encoded
with the right Content-Transfer-Encoding for the part into which the variable
was used, sometimes passing two versions of one variable.  Also, as I recall it
used Python's format operator, so it all looked like a massive printf string.

Then there are all the awful messages I get from vendors who build terrible
MIME messages with broken encodings or text parts poorly converted from HTML
(or empty!).  Also, American Express has ignored my repeated complaints that
while they provide a perfectly legible plaintext part, they do not render it,
so I see all their template variables instead of my information.

We set out to solve this problem internally a while ago, and I think it was a
pretty big success.  It made it very easy to throw together email templates
that were maintainable, comprehensible, and that our web guy could edit easily.

There were some problems, though.  The biggest one, for me, was our code's
reliance on one of YAML's more powerful features: tagging.  We used tags to
describe parts of the message in its YAML-based definition file, but dealing
with YAML tags in Perl is still awful.  Rather than pin our hopes to that
improving, we've replaced that design.

Actually, we've rewritten the entire library.  I think it should be easier to
use, easier to extend, and easier to understand.  I'm very, very excited to
start using it for all our internal messages.  (Once again, this is Pobox
saying, "We'd love to release this code, but not until we can rewrite it
entirely based on the lessons we've learned.  Normally I don't like that kind
of thinking, but I thinks it keeps serving us (and the CPAN) well!)

The library is called Email::MIME::Kit.  It can be fairly significantly
customized, but a fairly simple configuration, close to the stock one, works
like this:

You create a directory, which we call a message kit, or mkit, and put a bunch
of files in it.  These files are used in assembling the kit, and the most
important is the manifest.  We decide to write our manifest in YAML:

    ---
    validator: Rx
    renderer:  TT
    header:
    - From:    '"Customer Support" <cs@example.com>'
    - To:      '[% account.email_address.for_header %]'
    - Subject: 'Your Invoice, Number [% invoice.number %]'
    alternatives:
    - type: text/plain
      path: body.txt
    - type: text/html
      path: body.html
    attachments:
    - assembler: InvoicePDF
      attributes: { filename: invoice.pdf }

When we send a customer a bill, now we can say:

    my $kit = Email::MIME::Kit->new({ source => 'share/msgs/invoice.mkit/' });

    my $email = $kit->assemble({ account => $account, invoice => $invoice });

    $transport->send($email, { ... });

The kit will validate the stash.  Our example uses an
[Rx](http://rjbs.manxome.org/rx/) schema, but writing a validator plugin is
trivial.  With that done, the message is assembled.  The top-level part is
assembled by the standard assembler, but the one attachment consults a custom
assembler that retrieves or generates a PDF from our billing system.

The only thing the designer needs to do is edit the text and HTML files in the
message kit.  These don't need to know anything about the fact that they're
going into email.  They will be properly encoded as needed.  Even the headers
are checked for non-ascii text and encoded as MIME headers (encoded-words) if
needed.

While the templates don't need to know they're going to be part of email, it
can be useful.  This is part of a manifest in Email::MIME::Kit's test suite:

    - container_type: multipart/related
      type: text/html
      path: better-alternative.html
      attributes:
        charset: utf-8
      attachments:
        - type: image/jpeg
          path: logo.jpg

The HTML template can get the Content-ID of any attachment easily enough,
meaning that you can attach the images you want to reference in your HTML,
rather than rely on web connectivity.  Your template might contain:

    <img src="cid:[% cid_for('logo.jpg') %]" />

It's worth noting that this is all possible with the standard assembler, but
wordy.  I think we'll probably end up writing an assembler that optimizes for
multipart/related HTML-and-content parts.

Among the pieces that can be replaced are the KitReader (so you could decide to store the kit in a tarball, a database, or a webservice, for example), the ManifestReader (so you can use JSON, YAML, XML, or Perl to describe your kit's manifest), the Assembler (which actually builds the message parts), the Renderer, and the Validator.

I imagine there are at least a few bugs related to autoencoding, and I expect
I'll find one or two features that I need to add in the next few weeks, but
right now I'm very happy with the code, and I've just uploaded it to the CPAN.
If you find it useful,  or if you hit a problem, let me know!

