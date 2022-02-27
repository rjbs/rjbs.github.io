---
layout: post
title : "t-mobile, new phone, stupid problems"
date  : "2006-07-28T00:45:28Z"
tags  : ["phone", "stupid"]
---
So, I lost my phone.  Honestly, I think it was stolen.  Whatever!  I'm mostly
over it.

True to my word, I did not go for another Nokia.  I preferred the interface on
my old Motorola v180.  You know, the speed dial alone was far, far better.  On
the Motorola, I can assign digit strings to people, then press the digits and
pound to bring up that number.  This lets me make my dad, say, 9, and his cell
phone 99.  Both are then easy to dial.  On the Nokia, I only got nine slots,
they were more annoying to use, and they were harder to configure.

Nokia's buttons might have been as configurable, if only it had a newer version
of the firmware... but I digress.  Now I have a V3 RAZR, and so does Gloria.
Hers is pink.  Mine is not.

It took me a little while to get dial-up networking through my phone, but in
the end I got it working.  The on-line configurator gave me advice to do things
that were not possible ("click on this menu item, which does not exist") and
the customer service rep I got was equally unhelpful.  Finally, while she
read the useless web instructions to me over the phone, I jiggered with and
poked at the setup until it worked.

Unfortunately, getting it to work involved -- if I used T-Mobile's suggestion
-- bringing up a terminal window and typing in ATDT and such.  There were some
scripts for the RAZR on the web, but none of them worked quite right.  I found
myself editing them, working in the strange language of dial-up scripting.

    @LABEL 3
    ! Configure the phone
    matchclr
    matchstr 1 5   "OK\13\10"
    matchstr 2 101 "ERROR\13\10"
    write "AT&F0&D2&C1E0V1W1S95=47\13"
    matchread 30

With that working, my address book synced, and my account reactived, I was
almost done.  All that remained was to get Google SMS working.

Quite some time ago, I had [some stupid
problems](http://rjbs.manxome.org/rubric/entry/1238) with scammerly charges on
my phone.  Recently, it happened again.  I called in to have it taken care of,
and was told that numbers couldn't be blacklisted -- just like I was told last
time, until I was told otherwise.

I said that I would just go to a company that *could* fix this problem, and was
of course elevated to Tier 2... and Tier 2 told me that of course they could
blacklist the new charges.  These charges were from Jamster.  The CSR said, "I
see there are also some messages from Google.  I'll go ahead and block those,
too..."

"No, no!" I cried.  "I use those all the time.  They're free, and they're
imporant to me."  She said that she would *not* block Google, and that I was
right, it was free.  Promptly thereafter, my phone went AWOL.

Of course, once I got a new phone, I found out that I couldn't use Google SMS
anymore.  No sooner would I send out a message to 46645 than I'd get a reply,
"Access denied."

Tonight, I called in, worked my way up to tier two, and was told, "Oh, 46645 is
also Jamster."

What?  46645 is for Google SMS.  Except, she said, sometimes it's Jamster.  How
does that work?  She couldn't say.  My theory is pretty simple: she was full of
shit.

Anyway, I asked her to remove the block, and she did.  Now, when I send a
message to GOOGL, I get no reply at all.  I'll try again in the morning.

More annoying was the end of my conversation with Tier 1.  Before he
transferred me, he said, "You know, I see that you've been using text
messaging, but you have no SMS plan.  That will cost you ten cents per."

"Oh, no," I said, "I have [T-Mobile Total
Internet](http://www.t-mobile.com/shop/plans/detail.aspx?tp=tb1&id=311e4582-a0d6-4dc9-956e-8bce2691c67c).
That includes 300 SMS per month."

I was informed that I was misinformed, and I agreed to pay $5 per month to
avoid overage charges.  While on hold, though, I found the above link and got
angry: why had this guy lied to me?  Well, it turns out that there are two
things called T-Mobile Total Internet.  One is a plan, one is an add-on.  The
plan includes SMS.  The add-on does not.

I suggested that having one name for two things was confusing.  I got a
heartfelt, "Uh huh."  Well, I'll live.  I have a working phone, I can use it
for GPRS, and I might be able to SMS to Google tomorrow.

