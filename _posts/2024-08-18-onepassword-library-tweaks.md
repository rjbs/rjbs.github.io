---
layout: post
title : "tweaking my 1Password library to bug me less"
date  : "2024-08-18T12:00:00Z"
tags  : ["perl","programming","security"]
---

A few months ago, I wrote about [a new 1Password library for Perl]({% post_url
2024-05-25-onepassword-cli-library %}), which I was using to stop putting
sensitive information into my environment.  I was pretty happy with this!  It
meant I could put a pointer to my credentials in my configuration, instead of
the credentials themselves.

After a few days of use, though, I realized there was pretty annoying problem:
the URL-like strings that 1Password's `op` tool uses to find things don't
include account names.  The tool doesn't search all your accounts for a given
item.  It just checks the "current" one.  (You can toggle which is "current"
with `op signin`, but ugh.)  I have more than one 1Password account, and I
wanted to have both personal and work credentials available on my laptop while
doing work.  This was going to mean having a second environment variable, like
`APPNAME_CREDENTIAL_ACCOUNT` in addition to the first variable that stored the
`op://vault/item/field` string.  It's just one more field, but it's one more
field all over the place, and it meant complicating the library that was meant
to just get a password from a string.  It bugged me.

I finally fixed this in the new version.  Now, there's another format of string
you can specify:

      opcli:a=${Account}:v=${Vault}:i=${Item}:f=${Field}

You don't have to specify everything, so you can still skip the vault and field
names to fetch a complete item (as long as the item locator is unambiguous).
On the other hand, now you *can* specify the account name.

With this finally done, I think I'll be updating a bunch of little programs to
fetch credentials from 1Password!
