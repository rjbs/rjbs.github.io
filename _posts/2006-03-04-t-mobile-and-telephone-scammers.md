---
layout: post
title : "t-mobile and telephone scammers"
date  : "2006-03-04T17:50:45Z"
tags  : ["phone", "stupid"]
---
We got a phone bill about a week ago, and it listed a $10 charge for Blinko.
What's Blinko?  Who knows!  Google suggested that it's some sort of scam, which
seemed likely.  Gloria said she'd received some sort of opt-out SMS from them,
and replied to opt out.  I checked their web site, and they look like one of
those wretched little "we send garbage crap to your phone for too much money!"
operations.

Later, she got another message from them, making us wonder if we could ever
stop them.

Today, I called T-Mobile to protest the billing.  I was told that they could
refund the charge, but that I'd need to call Blinko directly.  She said that
shd couldn't just block Blinko, and that there had been no charges since the
first.  I was given an 800 number, but when I called it, the woman who answered
patiently explained that they were Blinck, not Blinko, and that T-Mobile had
the bad habit of referring to them people who'd been harassed by Blinko.

So, fearing that this was going to become a huge ordeal, I called T-Mobile back
and explained my situation to a new CSR.  This woman was much more helpful.
She said, "Oh, I see there has been a subsequent charge frmo them, too.  I'll
just blacklist them!"  So, the previous CSR has been wrong on three counts:
Blinko is not Blinck, people *can* be blacklisted, and there *were* subsequent
charges.

Since this woman seemed so helpful, I told her about my previous problem: I
keep getting some phone-spammer calling my cell phone and trying to sell me (or
Crystal, whoever that is) medication.   I have gone through the litany: there
is no Crystal here;  I do not want you to call me;  it is illegal for you to
call me;  stop calling me!  My cell phone is listed on the "do not call"
registry -- which is redundant, since all cell phones are supposed to be on
that already.  Anyway, I've re-registered on both the US and Pennsylvania
lists.  Probably 75% (or more) of these calls are just machines that hang up,
presumably when no one is there to harass me.  When someone is there, they've
got an Indian or Pakistani accent.

For a long time, these numbers came from some 800 number for a Canadian
company.  That company denied any knowledge of what was going on.  After that,
the numbers started showing up as "Private Call" or "Unknown," which telephone
companies, both wired and wireless, refuse to let you block.  Now they're
showing up as various numbers from all around the country.  Among them:

    206-202-1399
    408-239-4343
    561-228-5685
    646-217-3202
    847-709-0211

Googling finds nothing helpful, just a few other people also being annoyed from
these numbers.  I'm assuming they're someone's VOIP gateways.

Last time I called, I was given two options:  I could change my number, which
is pretty unfair to me and to my friends, or I could use custom ring tones.
Unfortunately, what I'd have to do is set up a custom ring for each and every
entry in my address book, and then set the default ring to "no ring," because
otherwise I have to keep maintaining a list of all the bad numbers -- including
"private call."  Well, no phone can assign a ring tone to "private call" so
that's out, anyway.  I have at least one hundred entries in my address book, so
updating each one is out of the question.

The CSR was apparently intrigued by my suggestion that they might have a phone
that could ignore calls from callers not in the address book, but they didn't.
She told me I should tell them that they can't call me any more, or that I
should take legal action.  I've told them so -- I suppose I can ask for contact
information for their offices, but if they're already lying about taking me off
their list, why would they not lie about their corporate contact information?

I think that the phone companies simply must be in bed with the telemarketers.
There are so many simple things that could be done to solve a large number of
these problems!  My phone can play chess, but it can't do basic whitelisting.
Does that seem right to you? 

What I really want is a phone that runs Perl, or Python, or even Java, and lets
me write something simple that can sit between incoming calls and the ringer.
I want `procmail` for my phone.  Who *wouldn't* buy a phone that could do this:

    def IncomingCall(event):
      unless (event.calling_number and event.calling_number in phone.book):
        return REDIRECT_VOICEMAIL
      return None # allow call to go through

Seriously!  I'm not even going to get into the idea of ring tone based on
roaming status, time of day, current calendar events, or whether or not you are
currently checked by your phone's chess AI.
