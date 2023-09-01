---
layout: post
title : "Remember the Milk, its API, and a new Perl client"
date  : "2019-11-06T02:11:37Z"
tags  : ["perl", "programming"]
---
Hey, I'm finally writing another post about things I did on my week off in
August!

I use Remember the Milk for my personal todo lists.  It's pretty good!  I've
been using it for years, and I wax and wane in my attention to my tasks, but
it's been a good help and I'm glad to have it.  I'd be even happier with some
changes, but more on that later.

Years ago, I built [Ywar]({% post_url 2013-07-25-i-get-points-for-blogging-this
%}), and I still use it.  It tracks my habits, when possible, using the APIs of
services where I leave footprints.  Am I weighing myself?  Am I exercising?  Am
I doing some reading?  Am I closing todo items in Remember the Milk?  I get a
congratulatory push notification when I hit a goal, and I get an email in the
morning telling me what I should do today.  These notices help keep me paying
attention and motivated.  One of the reasons this has worked okay — although
I'll definitely admit that Ywar has not remained a massive force for
productivity of late — is that it's there's not much extra work involved.  It
looks at what I'm already doing and records whether I did what I wanted.  This
means I have good "did exercise" feedback when I go for a run, because my
running app logs to RunKeeper, but nearly no feedback when I lift weights,
because my weightlifting app has no API.  Less friction leads to greater
success.

So, I wanted to apply this to my interactions with RTM.  Its web UI is pretty
good, and there's a native macOS app that's pretty good, too.  (Its macOS app
is just the web UI, but I'll take it!)  They're both extra apps, though, and
I have complicated feelings about how many distinct apps or tabs I want.  I
won't try to spell it out here, I'll just say: I wasn't as happy as I could be
using their UI.

At work, we have [a cool bot](https://github.com/rjbs/Synergy) that provides a
chat interface to some of our internal services.  I wanted to do the same thing
for RTM, which should have been no big deal, except that the existing Perl
client library for RTM,
[WebService::RTMAgent](https://metacpan.org/module/WebService::RTMAgent), is a
synchronous, blocking interface, and Synergy is event-driven and async.  I
looked at making it work with futures, but I didn't really want to.  It was
built on the XML interface, it uses AUTOLOAD, and I just didn't really like its
construction.  (I have used it for years, though, and it's never really been a
problem.  It's just not what I wanted to built on.)

Instead, I built a new client library,
[CamelMilk](https://github.com/rjbs/WebService-RTM-CamelMilk), modeled lightly
on something we'd built at work recently.  You feed it your API key and secret,
and it can manage auth tokens for users and call API methods.  API calls return
futures that, when ready, produce simple objects.  Here's how it looks, more or
less, in use in the Synergy plugin:

```perl
my $rsp_f = $self->rtm_client->api_call('rtm.tasks.add' => {
  auth_token => $token,
  timeline   => $tl,
  name  => $todo_description,
  parse => 1,
});

$rsp_f->then(sub ($rsp) {
  unless ($rsp->is_success) {
    $Logger->log([
      "failed to cope with a request to make a task: %s", $rsp->_response,
    ]);
    return $event->reply("Something went wrong creating that task, sorry.");
  }

  $Logger->log([ "made task: %s", $rsp->_response ]);
  return $event->reply("Task created!");
})->else(sub (@fail) {
  $Logger->log(...);
})->retain;
```

Nice!  This code is called in response to a user saying `todo eat a whole pie
^tomorrow`.  It returns immediately while the API call happens in the
background and it replies when it's all done.  I wrote a little command line
program to go along with the library for setting up auth tokens and making
one-off API calls.

While writing this library, though, I ended up feeling less excited than when I
started.  It turns out:  I don't like the Remember the Milk API.  The first
problem is *timelines*.  Here's what the API docs say:

> Timelines enable the Remember The Milk API to allow certain actions to be
> undone. The Remember The Milk web application requests a new timeline every
> time the application is visited — it is up to the API user to determine how
> often to request a new timeline. Timelines do not expire, but they must
> always be used.
>
> Timelines can be thought of as long-running database transactions within
> which individual sub-transactions (API method calls) can be reverted. The
> start of a timeline is a snapshot of the state of a users' contacts, groups,
> lists and tasks at that point in time. Method calls can be reverted
> continouously until the start of the timeline is reached.

So, that `api_call` call above was actually inside another call:

```perl
my $tl_f = $self->timeline_for($event->from_user);

$tl_f->then(sub ($tl) {
  my $rsp_f = $self->rtm_client->api_call('rtm.tasks.add' => {…});
  ...
);
```

Either we have a timeline id for that user already ready or we go get one,
meaning there's either an additional API call or local state management.  That
timeline id, though, means that you can later undo some methods.  Sort of a
niche use, but neat, but it complicates all sorts of actions.  As long as
you're tracking known timelines for undo, why not track transactions on your
own so you can compute the inverse transaction and reply them when needed?
Then you'd only do that when you might want to undo.

In practice, what I do, and what at least some other clients do, is make a
timeline, cache the id, and never, ever think about it unless you call undo
which (I predict, sans evidence) almost nobody ever, ever does.

This isn't my real beef, though, it's just a foreshadowing of it.  The real
beef is that it takes too many HTTP requests to do anything non-trivial.  Let's
say that I have some paperwork I need to file, so I have a todo for it.  I just
found out that it's due Friday!  I want to set it to priority 1, add the due
date, remove the "boring" tag and add the "omg" tag.  That will require I call
these methods:

1. rtm.tasks.setDueDate
2. rtm.tasks.setPriority
3. rtm.tasks.removeTags
4. rtm.tasks.setTags

Every one of these is its own HTTP transaction.  What happens when you fail
partaway through your series of calls?  I guess it's time to call undo
— possibly more than once, since you may need to undo several transactions.

Here's how it might work in [JMAP](https://jmap.io) if JMAP task lists were a
standard.  You have a task with id 123 and you want to do the updates above.
You'd make a single JMAP call:

```javascript
methodCalls: [
  [ "Task/set", {
      "update": { "123": {
        "dueDate": "2019-11-08T00:00:00Z",
        "priority": 1,
        "tags/boring": false,
        "tags/omg": true,
      } },
    },
    "a",
  ]
]
```

Note that the update argument is an object with the id as a key.  You can
update many tasks at once.  Note, too, that Task/set and its arguments are in
an array.  You can update multiple kinds of things at once.  I could create two
new lists and all their items like this...

```javascript
methodCalls: [
  [ "TaskList/set", {
      "create": {
        "work": { "name": "Work Stuff" },
        "home": { "name": "Home Todos" }
      },
    },
    "a",
  ],
  [ "Task/set", {
      "create": {
        "w1": { "name": "Get Hired", "listId": "#work" },
        "w2": { "name": "Get Raise", "listId": "#work" },
        "h1": { "name": "Take Nap",  "listId": "#home" },
      }
    },
    "b"
  ]
]
```

Working with a protocol like this makes working in an event loop driven system
really nice.  You have a lot of options, but a simple one is to stick all your
updates into one call, then report back all their results to the individual
calling futures, with only a single HTTP transaction required.

Turns out, working with JMAP can really spoil you for other APIs.

Anyway, despite the API being a bit of a drag, Remember The Milk remains great,
and I continue to get things done by using it.  Now I can get more things done
by talking to my Slack bot about my agenda, which is great, and if you want,
you can go use the code I wrote for it, too.  I've had a look at the network
inspector while using RTM, and they've clearly got a better protocol for their
UI to use.  Maybe someday it will be published for mere users like me, too!

