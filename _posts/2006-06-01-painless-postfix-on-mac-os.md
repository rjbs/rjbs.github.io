---
layout: post
title : "painless postfix on mac os"
date  : "2006-06-01T08:57:00Z"
tags  : ["howto", "macosx", "postfix"]
---
Sometime during the past year I got a few things working on my Mac that really
made my life simpler: offlineimap, mutt, and postfix. offlineimap is a Python
program for syncing an IMAP store to a set of Maildirs. It works
bidirectionally and its installer is simple and just works. (Configuration was
a little weird, but even that is very simple.) mutt is my MUA of choice, and
its installation is even simpler.

The thing that gave me some grief was Postfix. I wanted to have it running so
that mutt could deliver mail to it, and it would deliver the mail through my
Pobox SASL account. I didn't know how to do that, and beyond that, Mac OS X
doesn't just leave the Postfix daemons running. I got it working on my last
laptop and I just set it back up on my new one. For future reference:

First, set up your hostname in `/etc/postfix/main.cf`; this means finding and
setting the following options:

* myhostname
* mydomain
* myorigin

Next, set up a relay host. This lets Postfix know that it sends mail through
another MX, not directly to receiving MXes. My relayhost section looks like
this:

    relayhost = [sasl.smtp.pobox.com]
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/saslpass
    smtp_sasl_security_options = noanonymous

The relay host is in brackets to indicate that it's actually a host, not a name
for which to find MXes. This enables SASL auth in the SMTP client, using your
map of credentials, and tell Postfix never to send mail without authenticating.

That map file looks like this:

    sasl.smtp.pobox.com
    myaccount@mydomain.com:NOTreallyMYpassword

Now when Postfix wants to deliver remote mail, it will do so by connecting to
Pobox's SASL server to do it. You don't need to worry about what ISP I'm on,
which is one of the big benefits of using Pobox in the first place.

Finally, your need to tell launchd to keep Postfix running all the time.
launchd is Mac OS X's answer to inetd, daemontools, cron, and sliced bread. You
can do this by editing a file undef `/System/Library`, which is probably
uncool, but makes life simple. You could (and probably should) instead install
a new launch daemon in `/Library`, but I don't know how to entirely disable the
one in the system directory. Once I find out, maybe I'll revise these
instructions.

The file is `/System/Library/LaunchDaemons/org.postfix.master.plist`;
obviously, it's a Property List file. You could edit it with the PList Editor,
but it won't want to let you modify the file, and I'd rather use Vim anyway.
You'll have to remove two entries in the ProgramArguments array: -e and 60.
Just delete the lines containing them. They tell Postfix's master daemon that
it should stop running after an hour. It's probably good that this is the
default configuration, as it's one more way in which the default OS X
installation is not providing network services for malware to exploit.

The daemon configuration only needs that -e 60 because it's run on demand.
(What makes demands of it? I don't know; possibly nothing.) You don't want it
run on demand, if you're using it to send mail all the time, though. You want
it to be run when the daemon definition is loaded. That's easy to: add a new
entry in the dict by adding these two lines just above the closing </dict>:

    <key>RunAtLoad</key>
    <true/>

Then you can reload the definition easily in the shell:

    sudo launchctl stop org.postfix.master
    sudo launchctl unload /System/Library/LaunchDaemons/org.postfix.master.plist
    sudo launchctl load /System/Library/LaunchDaemons/org.postfix.master.plist

You don't need to start, at the end, because you have it starting when it's
loaded!

That's it. Now mail sent through your Mac's sendmail command will go through
your SASL provider. You can now use localhost as your outbound SMTP server,
without relying on your MUA's potentially lousy "outbox" feature when you're
offline... just remember to sudo postfix flush when you're back on the network.

