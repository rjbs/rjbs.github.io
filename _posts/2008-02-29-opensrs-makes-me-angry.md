---
layout: post
title : "opensrs makes me angry"
date  : "2008-02-29T23:14:07Z"
tags  : ["dns", "programming", "stupid"]
---
I was tasked with dealing with a bug, this week.  Sometimes, people would look into registering a domain, and our site would tell them it was available.  This was pretty bogglesome, and it was especially annoying because dealing with it meant dealing with OpenSRS.  OpenSRS's API is all kinds of goofy, but I had not noticed how goofy it can be until today.

When I send a request for lookup, I expect to get a response back telling me whether a domain is available or taken.  If a domain is available, the response code is 210.  If it's taken, the response code is 211.

So, here's an example response when looking up an unregistered domain, zuoizxoz.com:

    response_code   => '210',
      response_text => 'Domain available',
      attributes    => {
        status  => 'available',
        reason  => undef,
        matches => [qw(zuoizxoz.com zuoizxoz.net zuoizxoz.info zuoizxoz.biz)],
        email_available => undef,
        price_status    => undef,
      }

Great, right?  It's available, so I got a 210.  It also let me know that some other domains were available.  Then here's a response for a taken domain:

    response_code   => '211',
      response_text => 'Domain taken',
      attributes    => {
        status          => 'taken',
        reason          => undef,
        email_available => undef,
        lookup          => {
          'cnn.org'  => { 'status' => 'taken', 'match' => undef },
          'cnn.net'  => { 'status' => 'taken', 'match' => undef },
          'cnn.info' => { 'status' => 'taken', 'match' => undef },
          'cnn.com'  => { 'status' => 'taken', 'match' => undef }
        },
        price_status => undef
      }

I get a 211 response because the domain is taken, and it tells me that the alternatives are taken, too.  Oh well!

Then, finally, there's my little ego search for my own domain:

    response_code   => '210',
      response_text => 'Domain available',
      attributes    => {
        status          => 'available',
        reason          => undef,
        matches         => [qw(manxome.info)],
        email_available => undef,
        lookup          => {
          'manxome.org' => { status => 'taken', match => undef, },
          'manxome.net' => { status => 'taken', match => undef, },
          'manxome.com' => { status => 'taken', match => undef, }
        },
        price_status => undef
      },

Er, wait... I asked about manxome.org.  I know it's taken, because I own it. Why did I get a 210 response code?  Oh... because manxome.info is available. manxome.org is there in the lookup, saying it's taken.  So, looking up manxome.org replies "available" because manxome.info is available.  Great.

My first pass at fixing this was to say:

    available if response == 210 and requested_domain in matches

Of course, this failed.  It seems that sometimes if there's no other match than
the requested domain, I don't get a list of matches with the available domain
in it.  Instead, I end up having to say:

    available if response == 210 and attributes.lookup.$domain.status != taken

The OpenSRS XML API documentation, as of ten days ago, does not seem to explain this.


