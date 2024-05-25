---
layout: post
title : "I wrote some code to use the 1Password CLI"
date  : "2024-05-25T12:00:00Z"
tags  : ["perl","programming","security"]
---

Every time I store an API token in a plaintext file or an environment variable,
it creates a lingering annoyance that follows me around whenever I go.  Every
year or two, another one of these lands on the pile.  I am finally working on
purging them all.  I'm doing it with the [1Password
CLI](https://developer.1password.com/docs/cli/get-started/), and so far so
good.

## op

1Password's CLI is `op`, which lets you do many, many different things.  I was
only concerned with two:  It lets you read single fields from the vault and it
lets you read entire items.  For example, take this login:

![a screenshot of my Pobox login](/assets/2024/05/pobox-pw-item.png)

You can see there are a bunch of fields, like `username` and `password` and
`website`.  You can fetch all of them or just one.  It's a little weird, but
it's much easier to get a locator for one field than for the whole item.  If
you click the "Copy Secret Reference" option, you'll get something like this on
your clipboard:

```
"op://rjbs/Pobox/password"
```

You can pass that URL to `op read` and it will print out the value of the
field.  Here, that's the password.  Getting one field at a time can be useful
if you only need to retrieve a password or TOTP secret or API token.  Often,
though, you'll want to get the whole login at once.  It would mean you could
just store the item's id rather than a cleartext username and a reference to
the password field.  Or worse, a reference to the password field and another
one to the the TOTP field.  Also, since each field needs to be retrieved
separately with `op read`, it means more external processes and more
possibility of weird errors.

The `op item get` command can fetch an entire item with all its fields.  It can
spit the whole item out as JSON.  Here's a limited subset of such a document:

```json
{
  "fields": [
    {
      "id": "password",
      "type": "CONCEALED",
      "purpose": "PASSWORD",
      "label": "password",
      "value": "eatmorescrapple",
      "reference": "op://rjbs/Pobox/password",
      "password_details": {
        "strength": "DELICIOUS"
      }
    }
  ]
}
```

Unfortunately, 1Password doesn't make it trivial to get the argument you need
to pass `op item get`, but it's not really hard.  You can use "Copy Private
Link", which will get you a URL something like this (line breaks introduced by
me):

```
https://start.1password.com/open/i?a=XB4AE5Q2ESODUTKETZB3BQGCM4
    &v=flk3x357inyiw22qpoiubhsgin
    &i=7wdr3xyzzym2xgorp4zx22zq3h
    &h=example.1password.com
```

The `i=` parameter is the item's id.  You can use that as the argument to `op
item get`.  Alternatively, given the URL like `op://rjbs/Pobox/password` you
can extract the vault name ("rjbs") and the item name ("Pobox") and pass those
as separate parameters that will be used to search for the item.

But why do either?  You can just use Password::OnePassword::OPCLI!

## Password::OnePassword::OPCLI

Here are two tiny examples of its use:

```perl
my $one_pw = Password::OnePassword::OPCLI->new;

# Get the string found in one field in your 1Password storage:
my $string = $one_pw->get_field("op://rjbs/Pobox/password");

# Get the complete document for an item, as a hashref:
my $pw_item = $one_pw->get_item("7wdr3xyzzym2xgorp4zx22zq3h");
```

Hopefully by now you can imagine what this is all doing.  `get_item` returns
the data structure that you'd get from `op item get`.  You can look at its
`fields` entry and find what you need.  It does have one other trick worth
mentioning.  Because it's a bit annoying to get the unique identifier for an
item id, you can pass one of those `op://` URLs, dropping off the field name,
like this:

```perl
# Get the complete document for an item, as a hashref:
my $pw_item = $one_pw->get_item("op://rjbs/Pobox");
```

I'm currently imagining a world where I stick those URLs in place of API tokens
and make my software smart enough to know that if it's given an API token that
string starts with `op://`, it should treat it as a 1Password reference.  I
haven't implemented everything I need for that, but I did write something to
use this with Dist::Zilla

## Dist::Zilla and 1Password

The first thing I wanted to use all this for was my PAUSE password.
Unfortunately for me, this was sort of complicated.  Or, if not complicated,
just tedious.  I made a few false starts, but I'm just going to describe the
one that I'm running with.

Dist::Zilla is the tool I use (and wrote) for making releases of my CPAN
distributions.  It's usually configured with an INI file, like this one:

```ini
name    = Test-BinaryData
author  = Ricardo Signes <cpan@semiotic.systems>
license = Perl_5
copyright_holder = Ricardo Signes
copyright_year   = 2010

[@RJBS]
perl-window = long-term
```

Each section (the things in `[...]`) is a plugin of some sort.  If the name
starts with an `@` it's a bundle of plugins instead.  But there's another less
commonly seen sigil for plugins: `%`.  A percent sign means that the thing
being loaded isn't a plugin but a *stash*, which holds data for other plugins
to use.  These will more often be in `~/.dzil/config.ini` than in each project.

The `UploadToCPAN` plugin, which actually uploads tarballs to the CPAN, looks
in a few places for your credentials:

* the `%PAUSE` stash (or another stash of your choosing)
* `~/.pause`, where CPAN::Uploader usually puts these credentials
* user input when prompted

The `%PAUSE` stash was slightly overspecified in the code.  It had to be a bit
of configuration with the username and passwords given as text.  What I did was
relax that so that any stash implementing the (long-existing) Login role could
be used.  Then I wrote a new implementation of that role,
[Dist::Zilla::Stash::OnePasswordLogin](https://metacpan.org/pod/Dist::Zilla::Stash::OnePasswordLogin).
In that version of the stash, you only need to provide an item locator, and it
will look up the username and password just in time.  So, I have something like
this in my global config now:

```ini
[%OnePasswordLogin / %PAUSE]
item = op://rjbs/PAUSE
```

Who cares if somebody steals this URL?  They can't read the credential unless I
authenticate with 1Password at the time of reading.  Putting other login
credentials into your configuration for other plugins is similarly safe.  Now,
when I run `dzil release`, at the end I'm prompted to touch the fingerprint
scanner to finish releasing.  Not only is it more secure, but it feels very
slightly like I'm in some kind of futuristic hacker movie.

What more could I want from my life as a computer programmer?
