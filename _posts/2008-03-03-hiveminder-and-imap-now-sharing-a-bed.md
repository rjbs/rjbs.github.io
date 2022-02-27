---
layout: post
title : "hiveminder and imap, now sharing a bed"
date  : "2008-03-03T23:51:33Z"
tags  : ["email", "hiveminder", "productivity"]
---
Today, Best Practical announced [IMAP access to
Hiveminder](http://bestpractical.typepad.com/worst_impractical/2008/03/post.html).
It's way cool, and I'm sure I'll end up making a lot of improvement to my mutt
configuration tools to make the most of it.  You can check out their blog post
or documentation for more information, but basically you point your IMAP client
at Hiveminder and you can see your todo list.  You can drop new tasks (in the
form of email from elsewhere) into inbound folders and you can move existing
tasks into other folders to cause them to become hidden or complete.  There's a
bit more to it, but that's the gist.

My IMAP client of choice is
[OfflineIMAP](http://software.complete.org/offlineimap), as I've said many
times before.  It's the easiest way for me to use mutt with IMAP, whether
online or off.  Unfortunately, it has a really stupid bug.  Every message in an
IMAP account has a unique id (the UID), which is useful for doing
synchronization.  It lets you figure out that you've moved a message from one
place to another in your offline store.  OfflineIMAP doesn't seem to keep the
same UID on messages that have moved from one folder to another, which made it
impossible to use the IMAP interface to mark a message done or hidden.

As usual, the guys at Hiveminder were quick to sort this out, making their
correct software cope with my twitchy software.

Now, the folders in which Hiveminder presents your tasks are (I am told) great
for users of GUI MUAs, where they form a nice hierarchy of folders that you can
drill down through.  Here's a summary of the folder layout:

    Actions
      Completed
      Hide for
        Days..
          01 day
          (..more..)
        Months..
          01 month
          (..more..)
      Take
    Braindump mailboxes
      []
    Groups
      pep
        All tasks
        Everyone else's tasks
        Up for grabs
    Help
    News

Here's what they look like as directories:

    Actions/Completed
    Actions/Hide for/Days../01 day
    Actions/Hide for/Months../01 month
    Actions/Take
    Braindump mailboxes/[]
    Groups/pep
    Groups/pep/All tasks
    Groups/pep/Everyone else's tasks
    Groups/pep/Up for grabs
    Help
    News

The amount of typing needed to move things around between these folders is a
drag.  Fortunately, OfflineIMAP makes it really simple to map Hiveminder's IMAP
folders into a nice, shallow, easy to type hierarchy.  With my OfflineIMAP
configuration, it looks like this:

    ./braindump
    ./braindump.[]
    ./done
    ./groups
    ./groups.pep
    ./groups.pep.all
    ./groups.pep.avail
    ./groups.pep.others
    ./help
    ./hide.1d
    ./hide.1m
    ./inbox
    ./take

I need to do a bit of work to make
[WhichConfig](http://rjbs.manxome.org/rubric/entry/1592) check `$0` (or
something) to notice that I want to use Hiveminder, rather than the "normal"
mail available to it.  Even without having done that, the IMAP interface is
pretty fantastic.  I see a lot of weird Maildir tricks in my future.  Until I
have some to publish, here's my OfflineIMAP configuration for use with
Hiveminder:

*`.offlineimap`*:

    [general]
    pythonfile = ~/.offlineimap/helper.py

    [Account hiveminder]
    localrepository = hiveminder_maildir
    remoterepository = hiveminder_imap

    [Repository hiveminder_imap]
    type = IMAP
    remotehost = hiveminder.com
    ssl = yes
    remoteuser = user@example.com
    remotepass = PASSWORD

    nametrans    = lambda foldername: hm_nametrans(foldername)
    folderfilter = lambda foldername: hm_folderfilter(foldername)

    [Repository hiveminder_maildir]
    type = Maildir
    localfolders = ~/Mailhive

This relies on a few Python functions stored in another file:

*`helper.py`*:

    import re

    hide_re = re.compile('^Actions/Hide')
    spec_re = re.compile('(?P<n>\d\d) (?P<units>days?|months?)$')

    def hm_folderfilter(folder):
      if folder in ('Actions', 'Groups'): return False

      if hide_re.search(folder) and not spec_re.search(folder): return False

      return True

    def hm_nametrans(folder):
      if folder == 'Actions/Completed': return 'done'
      if folder == 'Actions/Take': return 'take'
      if folder == 'Actions/Take': return 'take'

      folder = re.compile('Braindump mailboxes').sub('braindump', folder)

      if hide_re.search(folder):
        spec  = spec_re.search(folder)
        n     = int(spec.group('n'))
        units = spec.group('units')

        return 'hide/%s%s' % (n, units[0:1])

      if re.compile('^Groups').search(folder):
        folder = re.compile('All tasks').sub('all', folder)
        folder = re.compile('Up for grabs').sub('avail', folder)
        folder = re.compile("Everyone else's tasks").sub('others', folder)

      return folder.lower()

