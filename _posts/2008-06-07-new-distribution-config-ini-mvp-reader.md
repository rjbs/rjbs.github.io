---
layout: post
title : "new distribution: config-ini-mvp-reader"
date  : "2008-06-07T15:23:01Z"
tags  : ["perl", "programming"]
---
Some time ago, I [wrote about Addex's
config](http://rjbs.manxome.org/rubric/entry/1435), which used a slight
variation on INI files and really hit the spot for what I needed.  It was
possible because of the way Config::INI::Reader acts like a state machine,
turning each line into a simple event that can be handled however you want.  By
default, of course, it mostly collects data and adds it to a structure.

With App::Addex::Config, each data section relates to a package, and that
package may provide a method that says which named properties get multiple
values and show up in the provided data as an arrayref.

In work on a new project, I found that I wanted this behavior again, and I
finally refactored it into its own module,
[Config::INI::MVP::Reader](http://search.cpan.org/dist/Config-INI-MVP-Reader).

I had a few more needs for the refactored version, so the output of the reader
is now a bit odd, but very easy to handle, and you can have multiple sections
for one plugin.  The only downside, which really bothers me not at all, is that
you can't "re-open" a section that you've started and then left.

Here's a sample of what you can do with MVP:

    ; given this .ini file as input:
    name = Paprika Beans
    edible = no

    [Kitchen]
    layout = standard

    [Ingredient / paprika]
    amount = 2 tsp

    [Ingredient / water]
    amount = 1 cup
    step = pour

    [Ingredient / beans]
    amount = 1 cup
    step = soak
    step = boil
    step = cool
    step = mash
    step = fry

You get this:

    [
      { '=name' => '_', name => 'Paprika Beans', edible => 'no' },
      { '=name' => 'Kitchen', '=package' => 'Kitchen' },
      { '=name' => 'paprika', '=package' => 'Ingredient', amount => '2 tsp' },
      { '=name' => 'water',   '=package' => 'Ingredient', amount => '1 cup',
        step => [ qw(pour) ] },
      { '=name' => 'beans',   '=package' => 'Ingredient', amount => '1 cup',
        step => [ qw(soak boil cool mash fry) ] },
    ]

I consume this output by popping off the first element and using it to
configure the application, and then instantiating plugins from each of the rest
of the entries and adding them to the application.

I suspect that in the future, the stuff I'm working on will may need more
sophisticated configuration, but it will be easy to allow other configuration
formats.  For now, this one is really nice and simple.

