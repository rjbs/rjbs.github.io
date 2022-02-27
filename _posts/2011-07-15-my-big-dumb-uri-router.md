---
layout: post
title : my big dumb URI router
date  : 2011-07-15T15:47:32Z
tags  : ["perl", "programming"]
---
While hacking on a large system at work, months ago, I spent about a day
looking at every URI router or request dispatcher on the CPAN.  That day, I was
feeling really unhappy with all of them.  They all seemed just fine, if you
were starting from scratch and had no particular vested interest in how your
router worked.  For me, though, none of them quite cut it.  I decided it wasn't
worth trying to change the design for the rest of the application.  I would
just write a new, bespoke router.

This week, again, I needed to put some routing between the HTTP request and the
templates.  I looked over the routers on CPAN again.
[Path::Router](http://metacpan.org/module/Path::Router) came closest, to what I
needed, but it was missing a few features.  Its maintainers were (cautiously)
welcoming to patches, but it quickly became clear to me that it would take
longer for me to understand how to add what I wanted than it would take me to
re-implement the features I wanted.

Am I nuts to write two routers in under six months, when there are at least a
dozen already on the CPAN?  I don't think so.  Right now, it seems like routers
are just something that it's easy to re-do each time.  Different applications
call for different routing mechanisms, and building one is an afternoon's work.
If I don't build a few more routers over the next few years, I'll be pretty
surprised.

As for the router I just made, I think it's actually pretty decent, but hardly
something I'm going to advocate that everyone else go use.  Its implementation
was inspired by my desire to keep using [Mason](http://masonhq.com/) for
templates.  I really like Mason, at least as a templating system.  I like the
way its templates can be broken down and can easily use each other.  I like the
way that many parts of it can be replaced as components.  I haven't seen
another system that I like as much.  None of this is to say, though, that Mason
is without its own massive glaring problems.

One of them is that once you remove it from the context of Apache or a similar
full-featured HTTP daemon, you realize how many features it's missing.  For
example, there's no way to trivially tell Mason which templates are okay to
serve to HTTP requests and which are only for internal use.  There's no magic
filename like `index.html`, unless you want to use a dhandler -- and then you'd
have two problems.  What I really wanted was a router that would sit between
Mason and the web request, doing just that one job that Apache used to do.  I
wanted it to auto-populate a list of templates that were known to be directly
reachable by the user, but I wanted to be able to add routes with placeholders,
too.  I wanted to be able to simulate Mason's dhandler.

For all this, I only needed a few simple kinds of routes:

    /about/careers        # simple, static path
    /user/:uid/profile    # a path with named placeholders
    /posts/:list/query/*  # a path with a slurpy star -- "the rest of the URI"

These are all easy to route, and cover all of Mason's standard routing and
more.  The placeholders could be typed.  The slurpy star works for dhandlers.
A few existing routers handled this, but not all with this exact set of
features, or with the ability to easily add routes after construction, and so
on.

I ended up with a router like this:

    my $router = Router::Dumb->new;

    $router->add_route(  Router::Dumb::Route->new({
      parts  => [ qw(about careers) ],
      target => 'endpoints/about/careers',
    });

    $router->add_route(  Router::Dumb::Route->new({
      parts  => [ qw(user :uid profile) ],
      target => 'view/user/profile',
    });

    $router->add_route(  Router::Dumb::Route->new({
      parts  => [ qw(posts :list query *) ],
      target => 'view/list/query',
    });

This is boring to type, but that's okay, because I knew I wouldn't have to.  I
was going to organize Mason's `comp_root` like this:

    ./comp_root
    ./comp_root/endpoints/INDEX
    ./comp_root/endpoints/about/INDEX
    ./comp_root/endpoints/about/careers
    ./comp_root/view/user/profile
    ./comp_root/view/list/profile
    ./comp_root/widget/userbox

Anything in `endpoints` was automatically routable.  The `INDEX` files would
handle requests for their containing directory -- otherwise, directories would
not be routable.  Templates outside of the endpoints directory would only be
reachable by explicit routes (like routes to the view templates), or from
within existing templates (like common widgets in the widget directory).

I wrote a helper class that would take a router and a directory and map files
inside it to routes.  That covered the endpoints directory.  Next up, I needed
to map to the view templates, so I made another helper that would read routes
from a simple (read: dumb) text file that looks like this:

    /user/:uid/profile    =>    /view/user/profile
      uid isa Int

    /posts/:list/query/*  =>    /view/list/query

This would set up the routes to the target, and add type constraints if
requested.  It's a dumb file format, but I can replace it whenever, because
it's not part of the router.  It's just a file for a tiny helper that converts
the file's contents into the lower-level work of calling the router's
`add_route` method.

This had another nice benefit:  with our Catalyst applications, our web
designer would often add a page to the site, only to find that it wasn't
reachable.  We needed an action for it.  We had a few hacks to work around
this, but they were grotty and unsatisfactory.  Now, he can either put it in
the endpoint directory or edit an extremely simple and straightforward text
file to make the new page immediately available -- no need to screw around with
the controller classes.

All told, this took a couple hours of work.  I put [the source for
Router-Dumb](https://github.com/rjbs/Router-Dumb) on GitHub, but I'm not sure
there's a reason to publish it to the CPAN:  if your router needs aren't
exactly mine, maybe you'll be happy with the other dozen routers already up
there.

