---
layout: post
title : "gui mail apps considered stifling"
date  : "2007-03-19T15:57:49Z"
tags  : ["email", "mutt", "software"]
---
About two weeks ago, I was singing the praises of mutt, patting myself on the
back for improving my mail toolchain configuration, and complaining that GUI
mail apps always make me feel stifled.  I was asked to elaborate, so here goes.

### external editor

My complaint is almost entirely that GUI MUA's are not very easily configurable,
and not usually very configurable at all.  The first place this bugs me is in
the mail composer.  I write plain text email messages.  I use a very good tool
for writing plain text, Vim.  When I write plain text that happens to be an
email message, I don't want to use a different tool -- especially since I will
be less familiar with it, and since it will surely be less powerful than Vim.

There have been hackish extensions for Mozilla products to use external
programs for text editing, but they've always felt clunky, and have never
worked very well on OS X.  Outlook has long offered the ability to use an
external program, but unfortunately that program is Word.  To be fair, I don't
need most of the power of Vim when composing an email, but it's annoying to
forget that I've been forced into an inferior editor and end up with `{c{[...]`
in the middle of my message.

### from address

I don't know how much non-spam email I receive in a day.  (Note to self: add
metering to `procmailrc`.)  It's at least a few hundred, I think, because of
the automated messages and mailing lists that I'm on.  I use `procmail` to sort
these into folders, and one of the ways I do that is by using a different
receiving address for most things.  It's easier than looking for telltale
headers, because a single procmail rule can tell that, for example,
`rjbs-perl-bogus@ml.manxome.org` goes to the `inbox/perl/bogus` folder.  Of
course, this means that when I send mail to that list, I want to send from that
address.  With Mutt, I can just write a hook or two that change my sending
address based on the destination or the folder that I'm looking at when I start
composing.  Even better, I can (and did) write a program with a list of the
lists that I'm on, and it can generate all the lines I need for my `muttrc`,
including setting up mailing list recognition, hooks for automatically setting
the from header, and other special configuration.

In GUI MUA's, it much more of a pain to have multiple "from" addresses.  Some
require that they're tied specifically to an "account" object, which gloms in
all sorts of other settings.  Others (like Mail) just give you a drop-down menu
of all your configured addresses, which is insane if you have, like I do,
hundreds.  Setting them automatically is basically a non-starter.

### flexible definition of "mailbox"

Most mail programs have a pretty limited definition of a mailbox.  It's usually
something like, "a mailbox is either a file on disk in a proprietary format or
a set of messages accessed across IMAP or POP."

Mutt can read mailboxes stored in mbox, Maildir, and mh format.  It can read
messages via POP or IMAP, and it can tunnel either of those across SSH.
Tunneling across ssh is a huge deal, because in combination with `ssh-agent`,
it means that mutt can access remote mailstores with no interactive
authentication required, and without storing your password in Yet Another
Questionable Password Repository.

Sometimes, I've got a folder of mail that I want to browse just this once, for
whatever reason.  In almost every GUI MUA that I've used, I would need to add
an account to my preferences, which would usually involve a bunch of menus,
clicking, and maybe a wizard or two.  (In Outlook, I might not need to add it,
but I would need to be able to browse to it on an Exchange server, which is
just as tedious.)  With Mutt, I can just use the `-f` switch and give a file
or network location, and Mutt reads the folder.

### custom display

Mutt's displays are hugely configurable.  Every status bar can be rewritten,
as well as the format of every item listing, as far as I know.  The color of
any bit of the display can be configured, including parts of the body.  For
example, this line in my `muttrc` does a good job at highlighting any email
addresses in the body:

    color body      brightgreen   default      [-0-9A-Za-z.]+@[-0-9A-Za-z.]+

These lines say "messages are listed in grey, unless they're unread, in which
case they're white, unless they're PGP signed, in which case they're green, and
they're brighter green if they're unread":

    color index     white         default      ~A
    color index     brightwhite   default      ~U
    color index     green         default      (~g|~G)
    color index     brightgreen   default      "(~g|~G) ~U"

At best, most GUI MUA's let you change a few colors and the columns shown in
item listings.  What's worse, you usually can't change the formatting of the
columns, except by changing the global display of that type of datum.  So, if I
have some folders that are guaranteed to contain messages only from a given
month, I can't say, "in this folder, display date as the two digit day of
month."

### message signing

Actually, these days most, if not all, of the major GUI MUA's support S/MIME or
PGP/MIME, even if only through a plugin.  Mutt's superiority comes from
integration with hooks.  I can say things like:

* always sign mail, except to mom, who is confused by the signature every time
* always use gpg, unless sending to client X, who prefers S/MIME
* sign mail with the correct key for the address I'll be sending as

### the keyboard

Saying that a CLI MUA is better than a GUI MUA because it uses the keyboard
isn't begging the question.  GUI MUA's also use the keyboard, but they tend to
do so poorly.  They provide convenient (usually) keystrokes for what the
authors believe are the most popular features, but configuration beyond that
tends to be very difficult, if it's possible at all.  In Mutt, it's trivial
to reconfigure every key.  I have a bunch of bindings to make it more Vim-like.
Here's a small sample:

    bind index ^B previous-page
    bind index ^F next-page

    bind index gg first-entry
    bind index G last-entry

    bind index z<Enter> current-top
    bind index z<Return> current-top
    bind index zz current-middle
    bind index z- current-bottom

Here's a very slightly clever macro:

    macro index ~ ":macro index ^] c=spam.\`date\ +%Y.%m\`\\r\r^]"

Hitting the tilde key in the index takes me to the current spam folder (where
my procmail is dumping spam), regenerating the name of the folder each time --
because if it was only defined when the `muttrc` was loaded, it would become
inaccurate if the month changed during a `mutt` session.

### multiple configuration profiles

Mac OS X has a "location" setting, and I think Win32 has something similar.
They let you have different profiles for various things based on whether you're
at home, at work, or so on.  Unfortunately, every single program does not tie
into them, so it's not so easy to say, "If I'm running at work, connect to the
really fast internal IP, but otherwise use the VPN."

I wrote a little script called `which-config`, which I use like this:

    source `~/.mutt/which-config`

`which-config` decides what file to include in `muttrc` based on things like
the MAC address of the hardware it's running on, the current IP address, and so
on.  I could easily extend it to check OS X location, time of day, or whether
I'm running under sudo.  At present, it's fifteen lines long, counting the
shebang, strictures, and warnings.

### attachment handling

Since it's a console program, Mutt can't (practically) display HTML, images,
or video inline.  That's okay, because I am not usually that interested.  It
does something really useful instead:  it consults the `mailcap` file to figure
out how to handle attachments.  So, if I receive a `multipart/alternative`
message, Mutt will first try to display the text part.  If there is none, it
will use the HTML part, and it will use `w3m` or `lynx` to convert the HTML to
plain text for display in the window.  I can tell it that images should be
opened by Preview or gqview -- based, of course, on what `which-config` has to
say.  If I was really twisted, I could have images converted to ASCII by aalib
and then displayed inline.  I am not, yet, that twisted.

At work, we have a number of special attachment types for automated requests
that get personally approved.  With the proper global configuration,
non-technical staff members can easily tell Mutt to approve the request.

### message pattern language

Like many MUA's, Mutt lets you select a bunch of messages and then perform some
operation on them.  You can do this by tagging each message (which is sort of
like command- or control-clicking each one to add it to the selection) and then
giving a command like "for this batch, do X."  If you want to operate on all
messages with given qualities, though, you can use patterns.  Patterns can
check all sorts of things: whether a message is deleted, whether a message is
PGP signed, whether a message was sent in a given absolute or relative time
range, whether its body or header contains certain text, whether the message
was sent to you or by you (or to or by anyone else), and all sorts of other
things.  Naturally, they can be combined with simple logical operators.

These patterns show up all over the place:  in hook definitions, in batch
operations (do X to all messages matching Y), and in display limits (only show
messages matching Y).  Some GUI MUA's have tolerable search features, but they
often end up returning a second-class folder-like result set on which a only a
subset of normal operations are available.  (They usually operate across all
folders, though, which is not easy to do in Mutt.)  I have not yet seen a way
to tell a GUI MUA to select all messages matching given criteria, which is not
to say that it isn't possible.

What bothers me more about searching in GUI MUA's is that it's so
labor-intensive.  There's usually a special "search criteria" dialog box,
generally with some kind of expanding grid interface, and if boolean logic is
available at all, it's usually awkward and limited.

Apple Mail's ability to save searches as virtual mailboxes is a fantastic
feature, and one that I've wanted in my MUA for years.  Someday, I hope to see
it integrated into an IMAP server so I can stop pining for it.

### where mutt falls down

#### profile switching

While I praised the ease with which one can create multiple profiles, there's a
drawback to my method:  it occurs at `mutt`'s initialization, so it's difficult
to switch back and forth between profiles during one session, which would be
useful for using one `mutt` for reading work and home email.  If each
configuration somehow "reset" all existing configuration and then reloaded the
correct profile, a macro could be made to do this... and in fact, now that I
write this down, I believe it's possible.  The macro would do something like:

    reset all
    unhook all
    source muttrc

The difficult will be in fixing bindings (if any must be changed, which is
actually unlikely, for me) and in changing what `which-config` will return.

#### non-capturing regex

Another failing in Mutt (in my opinion) is that its regex are non-capturing.
(If one of the worst things I can say about my MUA is that "its regex are
non-capturing" than either I'm a lousy critic or it's a fantastic MUA.  Please
let me know if I am a lousy critic.)

With capturing regex, it would be easy to write something like this:

    folder-hook =list.(.+) my_hdr From: <rjbs-$1@ml.manxome.org>

Instead, I need to generate all the needed hooks one by one, since the action
taken on the right hand side of the hook is constant.

#### aliases and address book

Mutt has a very primitive format for storing address book entries (called
aliases).  They're alright for simple use, but it's hardly suitable as a way to
store a real address book.  To make it easier to use an external address book,
Mutt provides the `query_command` setting, which lets you specify an external
program for finding addresses.  It isn't very well documented, but it's simple.
The bigger problem is that it's one-way.  Mutt supports adding new aliases to a
file -- that is, if you hit a key, it will set up an alias for the sender of
the message you're reading.  It doesn't support a way to send alias information
to an external program.

I suppose the solution there is to wrap `mutt` in something that checks for the
output file on quit and imports things... but that seems pretty ugly.

### conclusion

I am sure there are annoying things about Mutt that I've missed.  (I was
surprised while writing this, though, to find that one or two of my pet peeves
have been addressed in the last year or two.  e.g., there is now a
`imap_check_subscribed` option.)  I'm also sure there are things you can do
with a GUI MUA that aren't possible with Mutt.

I am interested to hear about both of these things.  Everybody knows that I'm
pretty interested in email, and that includes MUA's.  Why should I use anything
other than Mutt?  (That said, I know why my parents should use something other
than Mutt.)

