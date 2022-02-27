---
layout: post
title : more portable mutt configuration tricks
date  : 2008-03-03T03:50:27Z
tags  : ["email", "mutt", "perl", "programming"]
---
I have a fairly complicated mutt configuration.  It could probably do with more
streamlining, but it's pretty easy for me to update, because of the way I
generate it.

Some of it, of course, comes from [Addex](http://search.cpan.org/dist/Addex).
That's only some of it, though.  Namely, the folder hooks, folder
subscriptions, and a lot of the aliases.  That leaves a lot of things
unconfigured: default headers, folder names and locations, connection methods,
helper programs (i.e., the mailcap), OpenPGP and S/MIME config, keybindings,
colors, and all sorts of other little things.

A lot of these I really do want to set myself, once, by hand.  I want the same
basic colors everywhere, for example.  A lot of other things vary from host to
host.  On the server to which mail mail is delivered, my mail is laid out in
Courier-style Maildirs, so my inbox is in `~/Maildir/{cur,new,tmp}` and one of
my folders is `~/Maildir/cpan/{cur,new,tmp}` and so on.  On my laptop, where I
sync that mail with OfflineIMAP, I end up with my inbox in
`~/Maildir/INBOX/{cur,new,tmp}`.  Some folders are renamed, others are omitted.
That affects save hooks, folder hooks, folder subscriptions, and other
settings.

At work, I have an entirely different set of folders, as well as a different
From header, a different sig, and other different settings.  On all my
machines, I have different helper applications.  On my workstation at work,
which I use only via ssh, I can't open images.  On my laptop, I need to use a
wrapper around Preview.app.  Elsewhere, I might want to use Firefox.  On some
machines, I want HTML rendered with lynx, and if there's no lynx, html2text
will do, and so on.

So, a lot of my mutt configuration is generated for me by little programs,
either when I run mutt or when I deploy its configuration to my homedir from
a git checkout.

Since it's important to know what machine I'm running on, I have a module
called WhichConfig.  It exports a routine, `which_config` that tells me what
configuration to use.  For the most part, this is either a hostname or
"default."  It works like this:

1. if the hostname is a known hostname, use that config
2. if we find a known string in `ifconfig`, use the associated config
3. use default config

The `ifconfig` check is pretty crude, but very, very effective.  I look for the
MAC address on hosts for which I control the hardware and IP address on hosts
that I don't.  It's easy to change the way the test works, but so far this has
always worked.  Many of the rest of my tools rely on WhichConfig.

The first application is simple; my muttrc contains this line:

    source `~/.mutt/which-config`

`which-config` just prints out a filename based on the appropriate config.
That file contains settings that I just want to set by hand on each host.

A more interesting (but still very simple) helper script is `folder-finder`.
It finds all the relevant maildirs for the current configuration and subscribes
to them.  It knows how to find both Courier-style and OfflineIMAP-style folders
and normalize their names.  It runs every time I run mutt, so that it will find
folders that have been recently created.  Unfortunately, mutt can't include the
multi-line output of a script via the "source" directive or backticks
mechanism, so I end up with this in my muttrc:

    source `~/.mutt/folder-finder > ~/.mutt-folders; echo ~/.mutt-folders`

This minor inelegance is definitely worth the benefits.

Finally, there's `make-mailcap`.  This program looks at WhichConfig and looks
for known useful commands in `$PATH`, then reads in `/etc/mailcap` and dumps an
output file into `~/.mutt/mailcap`.  This file is used as the mailcap file,
which mutt uses to figure out how to view or print attachments.  This is useful
for dumping HTML mail to text (when it has no useful text alternative), or for
opening pictures and PDFs in Preview, xv, or xpdf.  Over time, I imagine I'll
add more and more helpers to `make-mailcap`, but the most useful one is
`osx-preview-img`.  When mutt uses a helper program to open an attachment, it
generally sees a specification like "`lynx -dump -force_html '%s'`" and
replaces the `%s` with the name of a temporary file, which is deleted after the
command exits.

In MacOS X, the way to open a file in a GUI application is usually to use the
`open` command, like this:

    $ open -a Preview some-image.jpg

The problem is that `open` exits nearly instantly, having send a request to
Preview.  mutt then deletes the temporary file, and Preview sends a SIGWTF.  My
helper program copies the tempfile to another location and has Preview open
that.  It never cleans up that tempfile, but since it's under /tmp, I know the
OS will clean it up on reboot.  In the future, I may look at using Mac::Glue to
write a helper that won't leave clutter in /tmp, but I'm not too worried about
it for now.

All of this stuff has been so useful to me that I feel like I should bundle it
up and drop it on the CPAN, but I'm not sure whether (or how) anyone else would
find much of it useful.  I think I need to work more on it and see if it can be
turned into a simple module to attach plugins to, sort of like Addex, but just
for mutt configuration.

