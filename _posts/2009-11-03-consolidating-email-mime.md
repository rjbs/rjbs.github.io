---
layout: post
title : "consolidating email::mime"
date  : "2009-11-03T22:57:42Z"
tags  : ["email", "perl", "programming"]
---
Originally, Email::MIME was part of the big initiative to make email modules
that each did one thing very well.  This got us a bunch of tools, including
Email::MIME.  Their API design was uneven, with some more successful than
others.  Email::MIME's API has been relatively reasonable to work with,
although it gets a bit hairy at the edges of quick-and-dirty email munging.

I have tried not to make it an omnibus of email handling, but I have tried to
make its edges a bit clearer.  One of the big hurdles to doing that has been
its division into three distributions: Email-MIME, Email-MIME-Creator, and
Email-MIME-Modifier.  (There are some other closely related distributions, but
they do not often cause problems.)

The distinctions between these libraries was pretty blurry, and the gain in
limiting prerequisites was fairly slim.  I have decided to go ahead and merge
them into one distribution which can be more easily worked on as a whole.
Email-MIME 1.900 includes all three libraries, along with all their tests.
Their history has been merged with that of the [Email::MIME
repository](http://github.com/rjbs/email-mime).

The final straw came when I was adding the new features found in 1.900: better
Unicode support.  It's not great, but it should help you do what you want a
little more easily.  Here are some quick examples:

    # build a message from unicode strings:

    my $email = Email::MIME->create(
      header => [
        Subject => encode('MIME-Header', $unicode_subj),
      ],
      attributes => {
        content_type => 'text/plain',
        charset      => 'utf-8',
        encoding     => 'quoted-printable',
      },
      body => encode('utf-8', $unicode_body),
    );

    # look at it again:
    my $subj = $email->header('Subject'); # returns a unicode string
       $subj = $email->header_raw('Subject'); # returns an MIME encoded string

    # notice that Simple's methods do not behave the same way
    my $simple = Email::Simple->new( $email->as_string );
    $subj = $email->header('Subject'); # returns a MIME encoded string

    # update the subject:
    $subj = $email->header('Subject'); # unicode string
    $email->header_set(Subject => scalar reverse $subj);
    # ... oops; we just put 8-bit chars in the header!

It's a pain.  The user is responsible for doing all the encoding.  Here's what
you can do in 1.900:

    # build a message from unicode strings:

    my $email = Email::MIME->create(
      header_str => [
        Subject => $unicode_subj,
      ],
      attributes => {
        content_type => 'text/plain',
        charset      => 'utf-8',
        encoding     => 'quoted-printable',
      },
      body_str => $unicode_body,
    );

    # update the subject:
    $subj = $email->header('Subject'); # unicode string
    $email->header_str_set(Subject => scalar reverse $subj);
    # ... the reversed unicode string is encoded first

So, basically, the `_str` suffix says "I am dealing with Unicode strings, not
octets."  You can use this to create new messages, change header values, change
the body content, and so on.

There are definite areas for improvement: Email::Simple should provide a
`header_raw` method, at least.  The default charset probably be UTF-8 for text
types.  Still, this should make it much easier to produce valid messages
simply, without worrying about more complex tools.

I'd like to eliminate the need for `attributes` in more circumstances, as I
think it's one of the last barriers to entry to make Email::MIME the "default
simple email library."  For the most part, I find that people who are using
Email::Simple, especially Email::Simple::Creator, are using it in inappropriate
situations.

Finally, I believe I may have just about hit the limit to how much Email::MIME
can be improved without significant changes to its API and structure.  I've
often looked at Mail::Box, because it is clearly capable of generating much
more correct mail, but I'm often warned away by those who have used it more
than I have.  I'd love to hear what's wrong with it -- as long as it's more
than "well, it should just do whatever it needs to without me saying anything."
I know that's not realistic.

