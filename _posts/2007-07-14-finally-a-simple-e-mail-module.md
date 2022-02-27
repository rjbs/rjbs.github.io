---
layout: post
title : finally, a simple e-mail module
date  : 2007-07-14T20:52:45Z
tags  : ["email", "humor", "perl", "programming"]
---
Email::Simple is, I think, a pretty popular module.  Quite a few other Perl software distributions require it or its subclass Email::MIME.  I think its popularity is due in no small part to the very simple interface it provides. There's no need to remember that sometimes you need the "bodyhandle" method and that sometimes you need "open."  There's no need to keep track of encodings or parts or much of anything.  It's just a header and a body and that's about it.

Now and then, I've made Email::Simple do a little more or a little less.  I'd like to address the "how big should it be?" question, but until I have a definitive answer, I know what I have to expect:  complaints.  "Why can't it read an mbox??" and "Why would you want to be able to NOT fold headers??" and so on.

I have produced a simpler interface for e-mail, which I think will be the least thing people are likely to ask for.  The beauty of it is, there are no methods. It's just data!  Lots of Perl programmers are wary of objects, but they all love to make hashes of things.  This just takes that a step further:

    $e_mail->{From} = '"Ricardo Signes" <rjbs(my initials)@example.org>';
    $e_mail->{To  } = 'jj@dyno.o.mt';
    $e_mail->{Subject} = "Re: (no subject)";

    @$e_mail = "No, I think that's a great idea."
             , "I'll see you there.\n\n"
             , "> Would it be stupid to go crash PyCon this weekend?"           
             , "> I have Monday off, so we can get totally plastered."
             ;

There's your e-mail, constructed in a nice, Perlish style.  You can, of course, assign more than one at once:

    $e_mail->{Bcc} = [ 'police@cityofbethlehem.gov', 'sire@eschelon.coop' ];

You can always fix up your headers, later, too:

    # Prune secret internal headers.
    my $rcvd = $e_mail->{Received};
    for (reverse 0 .. $#$rcvd) {
      delete $rcvd->[ $_ ] if $rcvd->[ $_ ] =~ /\.internal /;
    }

Simple!

One of Email::Simple's big weaknesses is that it lacks support for multipart mail.  Email::MIME supports it, but has a bunch of prerequisites.  My new offering requires only core modules, but does offer multipart mail support:

    $e_mail = ( ... set up top-level e-mail ... );
    $attach = ( ... set up attachment ...);

    push @$e_mail, $attach;

Done!

Well, not quote done, right?  The purpose of an email is to be sent. Email::Simple is hardly useful on its own, because it can't send mail. Email::Send is confusing, has prerequisites, and means you're stuck dealing with more *objects*!

Our email structure can be sent easily with no external modules:

    $e_mail->();

Or, if you don't have `sendmail` in your path:

    $e_mail->('/path/to/sendmail-alike');

It's [already available on the CPAN](http://search.cpan.org/dist/E-Mail-Acme/).


