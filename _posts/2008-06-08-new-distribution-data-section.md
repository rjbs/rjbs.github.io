---
layout: post
title : new distribution: data-section
date  : 2008-06-08T00:18:54Z
tags  : ["perl", "programming"]
---
I've, uh, been writing a lot of new general-purpose modules this week. This happens sometimes when I suddenly find myself writing a new program and I want to reuse mostly generic tricks that I wrote into an old program. I split a lot of things out of Rubric, eventually, and now I'm splitting things off of this and that. I broke Config::INI::MVP::Reader out of App::Addex::Config, Mixin::Linewise out of Config::INI, and this next module out of Software::License -- although it's something I've done in other ways, before.

Basically, it lets you retrieve hunks of data from your package's DATA section, if you just delimit it properly. So, assuming a normal configuration, you can say something like:

      package Letter::Rejection;
      use Data::Section -setup;

      sub reject {
        my ($self, $who) = @_;
        my $template = $self->data_section('rejection');

        my $letter = $$template;
        $letter =~ s/RECIPIENT/$who/g;
      }

      sub accept {
        my ($self, $who) = @_;
        my $template = $self->data_section('acceptance');

        my $letter = $$template;
        $letter =~ s/RECIPIENT/$who/g;
      }

      __DATA__
      ___[ rejection ]___
      Dear, RECIPIENT:

      Sorry, no thanks.

      Sincerely,
      Rik

      ___[ acceptance ]___
      Dear, RECIPIENT:

      Fine, we'll print it.

      Sincerely,
      Rik

This is sort of like Inline::Files, but that works with source filters, and contains the warning:

      It is possible that this module may overwrite the source code in files that
      use it. To protect yourself against this possibility, you are strongly
      advised to use the -backup option described in "Safety first".

Ugh.

The other useful feature is that these data section data are inherited. If you request the section foo from your class, and it doesn't have that section in its DATA section, but one of the classes between it and the one that used Data::Section does, you'll get that.

This behavior can be switched off.
