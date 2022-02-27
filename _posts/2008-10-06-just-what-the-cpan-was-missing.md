---
layout: post
title : just what the cpan was missing
date  : 2008-10-06T04:00:56Z
tags  : ["perl", "programming"]
---
I work for Pobox.  We provide identity management.  For the most part, it's
about email.  You register an email address with us and we handle the mail for
you.  We send it to an IMAP store, or your current ISP, or some flash in the
pan webmail provider like Google.  We do other things, though, like web and URL
redirection.  It's about managing services that relate to your identity.

Now, in internet years, we're ancient.  We've been operating since 1995, which
basically means that we've been providing internet services to real world end
users for just about as long as there have been end users in the real world.
(Inhabitants of `.edu` and `.mil` don't count; I said real world!)

That means that we used to offer some identity services that aren't really
relevant anymore.  For example, sometimes when sifting through data in the
customer configuration datastores, I come across the `plan` configuration.  Who
here rememberes the `.plan` file?  It's the precursor to twitter.  You put what
you were doing in your plan file and then when you got fingered, that file was
served up.

Yeah, don't ask me about the unfortunate name "finger."  I didn't name it.

Anyway, the long-gone support for finger at Pobox came up recently at a
planning meeting.  I said that I'd be focusing my time on re-enabling it during
some planned service updates.  The sysadmins groaned, and it encourated me.  I
wrote "finger server?" in my meeting notes.

This weekend, I made another crack about it, and got more worried noises from a
sysadmin.  I pulled up the RFC, realized how incredibly simple it would be to
implement, realized that the CPAN didn't have a finger daemon, and did wrote
one.  Net::Finger::Server is available for installation.

Just to show that it isn't entirely useless, I threw together a little finger
daemon:

    ~$ finger @git.codesimply.com | head
    [zodiac.codesimply.com]
    Repository                          Description                             
    Acme-Canadian                       Canooks in your code, eh?               
    Acme-Lingua-EN-Inflect-Modern       modernize Lingua::EN::Inflect rule's    
    Acme-ProgressBar                    a simple progress bar for the patient   
    Acme-Studly                         convertBetween various_well_known Ide...
    Amce-CNA                            a moer tolernat verison of mehtod loc...

...and then...

    ~$ finger Amce-CNA@git.codesimply.com | head
    [zodiac.codesimply.com]
    Project  : Amce-CNA
    Desc.    : a moer tolernat verison of mehtod location
    Clone URL: git://git.codesimply.com/Amce-CNA.git

I don't really think that we'll be bringing back finger support at Pobox.
That's fine, we have better things to do.  Finally, though, the CPAN has a
server for the only protocol whose RFCs have sections on integrating with
vending machines.

