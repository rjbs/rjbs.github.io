---
layout: post
title : Parental controls don't help
date  : 2014-12-12T03:26:41Z
tags  : ["macosx"]
---
My parents recently got new computers, and my mother's old (but still pretty
modern) Mac Mini has more or less become my daughter's.  It's what she's been
using to play Minecraft, as I mentioned recently.  OS X has a "Parental
Controls" system, and I figured it would be useful.  I'd tell it to use its
default anti-porn web blacklist, to have a list of (say) ten allowed
applications, and to limit her instant messaging to a few approved people.  It
was a big mess.

First off, I enabled "Simple Finder."  I remember this well, as we used it in
the college labs on OS 8 when I worked at (while attending) Boston University.
Then, it was pretty simple.  You defined a list of applications which would
show up in a simple launcher, and that was that.  It's not that simple anymore.
Minecraft wouldn't work because it would want to spawn Java, which wasn't
approved.  Other apps couldn't run, seemingly because they weren't properly
signed.  I turned it off and opted, instead, to lock the dock.  That was a
mess, too, and I couldn't even figure out what the point was, as far as
"parental" control went.  I gave up.

My daughter likes to search the web for stuff.  Who doesn't?

I don't want to impose draconian limits on her web usage ("you can only go to
cute-puppy-games.biz!"), and I don't want to have to limit her to only strictly
supervised time, because I know that she really just wants to go read about
[Daria](https://en.wikipedia.org/wiki/Daria_Morgendorffer) in every free
minute, including when I'm not available.  I just want to limit the chances
that she will accidentally end up on some horrible, horrible page.

So, I turned on the Parental Controls option to "try to limit adult websitse
automatically."  I figured there'd be some Apple-curated block list, and that
was probably some help.  Well, it turned out that this block list included
things like Akami and other content-delivery networks.  Apple *uses* Akami, so
the App Store stopped working properly, as did `apple.com`.  I turned that
right off, again.  I'll stick to enabling safe search on Google and YouTube.

Parental Controls let you limit with whom your kid can correspond in Mail and
Messages.  I really didn't want to set her up to use iMessage, because it
stinks.  I'd end up getting messages on my phone all the time.  Anyway, the few
people I figured she'd want to talk to are instead on GTalk or AIM.  I set up
an AIM account for her to use (although I had to put it in my name as there are
no children under 13 allowed).  This was actually just fine.  I had to put
contacts in her address book for the people with whom she should be allowed to
chat, and then mark them as approved contacts.  Great!

I haven't yet set up a GTalk user for her because, once again, you can't get an
account if you're under 13.  I'll probably make one myself for her to use,
although I'm really unclear on whether this is permitted.  Still, she wants to
be able to chat with her aunt and uncle.  So there you go.

So, there's one winning feature.  I really wish I could have let her use Adium
instead, as its UI is much, much better.  Unfortunately, there are two big
problems.  First, even though they were briefly considered a blocker for a major
release, parental controls never got implemented and are now marked as "would
be nice to have."  Parental controls in IM are probably the ones I wanted most.
I still get unknown and presumably malicious people sending me random instant
messages.  I can ignore them.  I think my daughter would just like chatting,
and I don't want to have to worry about it.  Secondly, Adium can't use TLS to
talk to AIM.  It used to use SSL, but AOL disabled SSL after the Poodle
vulnerability.  If you use Adium, you have to authenticate in the clear.

Finally, there's Mail.  To let her use some of my App Store purchases, I made
her an iCloud child account attached to our family.  That got her an iCloud
mailbox, which I figured would be fine to just get started.  The idea behind
how Mac Mail parental controls work is good:  you (the parent) limit
correspondence to known contacts.  If your kid tries to mail someone else, or
if someone else tries to mail your kid, the mail goes to you.  You can then
mark the sender approved, or not.  There are a few problems, though.

The biggest one is that it doesn't work.  I was sent one of those approval
messages, and it had a big "click here to approve" button displayed inside
Mail's own UI.  I clicked and clicked, but nothing happened.  Gloria reported
the same.  So, now the only way to deal with updating the permitted senders is
to edit the contacts on the machine.  It's doable, but a much bigger hassle.

The other problem, of course, is that email isn't authenticated.  If you know
a kid's parent's email address, you can send them mail "from" the parent.  This
means that your kid might be protected from getting random mail, but they're
still wide open to targeted nasty mail.

In the end, I'm not crazy worried about most of these things.  I would like my
daughter to enjoy her time using the computer, and I'd like her to be able to
use lots of the cool things on the Internet, and that's my priority.  I just
don't want the many, many gross things on and about the Internet to show up and
ruin her day.  I don't think that's too much to ask.

Oh… one more thing.

She's been asking repeatedly for "some kind of music player."  I really wanted
her to have one, because she likes music, but I didn't want something that
would be totally uncontrolled.  I like Spotify, but its UI is really confusing.
Our music library is available on the NAS on our home network, but I couldn't
find any DLNA music players for OS X.  I ended up installing the Synology
iTunes Media Server on the NAS and pointing her iTunes at that.  It's not a
great solution.  I also had to say, "You should ask about albums before
listening to them."  She's not thrilled about that, and I wouldn't be, either,
but I have way too much stuff on there that isn't for her ears (yet).

I may set up Spotify, just because I know that mostly she wants to listen to
Selena Gomez, and won't go looking for trouble.  Searching around in my music,
she'd be adrift, and there's plenty of trouble lurking.  This is another place
that I'd love a quick across-the-internet system that could say, "Your kid
wants to listen to Li'l Kim.  **Allow or deny?**"

