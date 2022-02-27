---
layout: post
title : "smarkmail: sending multipart/alternative html mail from mutt"
date  : "2007-04-09T14:44:37Z"
tags  : ["email", "mutt", "perl", "programming"]
---
Some people really want to see fancy HTML mail.  They want italics and inline
images and all sorts of nonsense that makes my teeth itch.  I used to ignore
any such mail that I got, because it was mostly from people from whom I didn't
expect good mail.  Then I started getting more mail like that from my family,
and I groaned and set up a `mailcap` entry to make Mutt dump the HTML messages
to text with `w3m` or `lynx` and it was bearable again.

Now that I'm sending lots of links to images to the extended family ("Look how
cute my baby was *today*!"), I'm getting back a little more confusion about
these crazy text links and non-attached photos... still, I'll be damned if I'm
going to run Mail.app and wait ages for it to get running, complain about
certs, crash, and so on.  (This complaint goes for all other GUI mailers I've
used.  See a previous rant on the subject.)

At some point, I realized that it would be really easy to use Markdown to
convert text to HTML for email, just like I do for lots of other things (like
this journal post, for example).  I was a little stung when I realized that
Mutt wouldn't let me build a MIME message via my editor: it strips the
Content-Type and MIME-Version headers.  I got around that by writing my own
`sendmail` replacement.

It's not quite ready for use yet; I need to decide on a way to indicate that
the message is ready to send, and I need to test it with a few quoting styles.
I'd also like to make it use the desperately-in-need-of-dev-release
Email::Sender rather than Email::Send.  I'd love to make [Addex](http://search.cpan.org/dist/App-Addex) help decide who gets HTML mail.  Still, it basically works.

    use strict;
    use warnings;

    use Email::MIME;
    use Email::MIME::Creator;
    use Email::Send ();
    use Text::Markdown ();

    sub markdown_email {
      my ($email) = @_;

      my $body_text = $email->body;

      my $html = Text::Markdown::markdown($body_text, { tab_width => 2 });

      my $html_part = Email::MIME->create(
        attributes => { content_type => 'text/html', },
        body       => $html,
      );

      my $text_part = Email::MIME->create(
        attributes => { content_type => 'text/plain', },
        body       => $body_text,
      );

      $email->content_type_set('multipart/alternative');
      $email->parts_set([ $html_part, $text_part ]);
    }

    my $text = do { local $/; <STDIN> };

    my $email = Email::MIME->new(\$text);

    markdown_email($email);

    my $rv = Email::Send->new({ mailer => 'SMTP' })->send($email);
    die "$rv" unless $rv;

I'll make noise again when it's done-er.

