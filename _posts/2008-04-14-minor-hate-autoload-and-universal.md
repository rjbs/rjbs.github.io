---
layout: post
title : minor hate: autoload and universal
date  : 2008-04-14T18:06:50Z
tags  : ["perl", "programming", "stupid"]
---
I just spend twenty minutes or so on this nonsense.

A number of our objects get decorated by
[Mixin::ExtraFields::Hive](http://search.cpan.org/dist/Mixin-ExtraFields-Hash),
which lets us say:

    $object->hive->some->random->path->to->datum->SET(1);

It's a nice convenient way to store arbitrary hierarchical data about stuff.

I was trying to store the "moniker" of the test object being stored:

    $object->hive->test->moniker->SET($moniker);

This kept failing, saying I couldn't call "SET" on "hive."  What?

Well, UNIVERSAL::moniker was getting in the way.  Argh!  I hate UNIVERSAL.  I
will never abuse it outside of Acme again.

