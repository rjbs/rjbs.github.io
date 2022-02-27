---
layout: post
title : "hilarious bug visible in perl 5.10.1's perldoc"
date  : "2009-10-28T15:33:19Z"
tags  : ["perl", "pod"]
---
There's a bug in, I think, Pod::Simple.  It's been fixed, and affects only one release of the perl distribution: 5.10.1.  Its effect is really amusing, though.

In Pod, there are commands that look like this:

    =head1 This is a header.

    =begin :Region

    =encoding utf-8

That third one notes the encoding of the document.  In this broken version of the Pod tools, the `=encoding` command is overzealously detected and any paragraph containing that string is effectively invisible in the output of the `perldoc` command used to read perl's documentation.

Here is the literal source of the documentation for the Pod documentation format itself -- the section describing `=encoding`:

    =item C<=encoding I<encodingname>>   X<=encoding> X<encoding>

    This command is used for declaring the encoding of a document.  Most
    users won't need this; but if your encoding isn't US-ASCII or Latin-1,
    then put a C<=encoding I<encodingname>> command early in the document so
    that pod formatters will know how to decode the document.  For
    I<encodingname>, use a name recognized by the L<Encode::Supported>
    module.  Examples:

      =encoding utf8

      =encoding koi8-r

      =encoding ShiftJIS

      =encoding big5

    =back

    C<=encoding> affects the whole document, and must occur only once.

Every single paragraph contains `=encoding`, except for the unrelated `=back` command, so all documentation of this command silently disappears when reading the documentation.

I thought I was losing my mind!
