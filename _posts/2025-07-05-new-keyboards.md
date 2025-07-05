---
layout: post
title : "I bought some new keyboards"
date  : "2025-07-05T12:00:00Z"
tags  : ["hardware","keyboard"]
---

I go to Melbourne a couple times a year, for work.  It's where our HQ is, and
it's good to have time in person with my colleagues.  It used to be that most
of this time was spent at big tables or in front of whiteboards.  There's still
quite a lot of that, but the past two or three times I was in Australia, I
spent a much larger chunk of time at a desk, programming.  Surely not the
majority of my time, but enough time that I cared about the ergonomics.  So,
last time I was there, I dug through the spare hardware cupboard and put
together the best workstation I could.  It was… not great.  Fortunately for me
(in one sense, anyway), one of my colleagues was on leave.  I boldly
appropriated his desk, which was much better hardware than my scavenging had
gotten me.  The thing that I ended up grumbling about, though, was the mouse
and keyboard.

Let's be clear: This was all on me!  I don't need the Australian office to
stock all my favorite hardware for the 7% of the year I spend there.  On the
other hand, I did feel like I wanted to plan ahead for next time.  I keep a bag
of stuff in the Melbourne office to make the trip easier.  This is mostly
cables, adapters, and toiletries.  It's much nicer to have my favorite Merkur
safety razor waiting for me than to spend two weeks using disposables.  My
plan was to put a keyboard and mouse in that bag.  Maybe a little USB hub.
Simple, right?  Well…

I'm fussy about my keyboards.  I'm not a keyboard wonk, I think.  I know just a
little bit about mechanical keyboards, and I know what I like.  Mostly, what I
like is full size (with numeric keypad) keyboards, in the traditional layout,
with clicky switches.  When I started thinking about taking a keyboard to
Australia, I owned three mechanical keyboards.  All Ducky brand, all with
Cherry MX blue switches.  Surely, I could just go order one of these, right?
Well, it didn't seem like it.  They were backordered everywhere I looked.  The
most likely-seeming one was the Ducky One 3, which looked about right.  I
almost just ordered it, but then I remembered:  a lot of keyboards are now
configurable via software.  That sounded interesting, so I did some more
digging.

The short version is that there's an open-source firmware for keyboards called
[QMK](https://github.com/qmk/qmk_firmware), and lots of keyboards use it.  It
lets you remap keys, program macros, and do that sort of thing.  A coworker
asked, "Why is that better than just updating your settings in macOS?"  The
answer is, basically:  If you tell your keyboard that its caps lock key should
act like a control key, it will do that on every computer you attach it to,
with no configuration required.  The longer form answer is that you can do all
sorts of weird stuff that macOS would never allow.

Ducky doesn't support QMK (or other reprogramming) on most of their keyboards.
The one I *did* find with QMK is the "Ducky One X 'Inductive Keyboard'".  They
bill it as "the world's first inductive keyboard".  I don't really understand
what an inductive switch is.  I looked into it a little.  I do know that it's
not a clicky blue switch, though, and I know that it costs a lot more than my
usual keyboards.  Pass.

Now I was sort of in open territory where I didn't want to be: picking a new
kind of keyboard.  This was agony.  I was trying to remember what other models
I'd used.  I looked into one in the US office (where most of the keyboards are
mechanical, with brown switches), and was reminded how much I dislike
clamped-in stabilizer bars.  (More on that later, maybe.)  Figuring out just
what I wanted seemed like it was going to be a pain.  *Also*, the news kept
telling me about massive impending tariffs, which were surely going to punish
me for delaying on ordering hardware from abroad.

## Keyboard 1

Eventually, I found myself looking at Keychron.  I knew of them only because a
few years ago I bought a four-pack of Keychron C1 mechanical keyboards for the
office for $50.  In my mind, they were some sort of Johnny-come-lately cheap-o
brand.  On the other hand, their site had an enormous variety of keyboards, and
I couldn't find anything online that backed my view.  I decided to order a K10
Max QMK, which ticked a couple key boxes: it's programmable with QMK and it's
wired (but *also* works over Bluetooth *or* with its own transceiver)

The problem was that it didn't have a blue switch option.  Red, Brown, or (I'm
not kidding) Super Banana.  Reds and browns, I knew, were no good for me.
Super banana, I was not sure, but I didn't want to commit to something I might
not like.  The good news is that the K10 is hot-swappable.  That means that
after you pull the keycap off of the switch, you can pull the switch out, too,
and replace it.  I gather that some gamers put different switches in for
different keys.  I don't really know why, but it's something like "I want a
really low activation force for my movement keys but a really quick reset for
my trigger keys".  I didn't care enough to look into it.  My goal was to put in
one hundred blue switches and dump all the originals into a box.

I ordered the K10 along with a tube of 110 Cherry MX blue switches.  When it
arrived, I played around for a bit, but quickly got to work pulling off all the
keycaps and pulling out all the switches.  This was easy, although the
switch-pulling tool that came with the keyboard was a bit rough on my fingers.
With all the (red) switches pulled, it was time to put in the blues.  Inserting
is not as simple as pulling, sadly.  At the bottom of each switch are two stiff
wires that slide into receivers in the keyboard.  The upper part of the switch
has two little arms that snap into place when the switch is seated.  If the
wires aren't perfectly lined up, or aren't straight, they will buckle or bend,
and then the switch won't form a circuit with the PCB.

This means that for each switch you insert, you first need to look carefuly at
the leads to make sure that they're straight and whole.  It's a little
slow-down, but not so bad.

<a href="https://www.flickr.com/photos/rjbs/54629694208/in/dateposted-ff/" title="red and blue switches"><img src="https://live.staticflickr.com/65535/54629694208_0f6202b977_c.jpg" width="600" height="800" alt="red and blue switches"/></a>

I put on some music and got to work.  Pretty soon, I'd replaced all the
switches and put the keycaps back on.  I opened the [Keychron
Launcher](https://launcher.keychron.com/#/keymap) to begin phase two.  The
Keychron Launcher is a web interface for managing the keyboard's settings.  It
amazes me, because it uses a web API called WebHID, which gives your browser
access to your HID devices *per se*.  I had to use Chrome, but when I did, let
let me flash my keyboard's firmware and update its keymap.  It also had a key
tester that let me test every single key.  When one or two didn't work, I
pulled the switches and replaced them with spares.  Pretty soon, the whole
keyboard worked and had a mapping I liked.  I was delighted.  Sure, it was
expensive, but it has a great weight, it has the switches I like, and I could
keep tweaking the keyboard layout until I was perfectly happy.

## Keyboard 2

It was good enough that I went right ahead and ordered *another one*, that one
for my office.  In the week since my first order, the price had gone up $20 —
almost certainly tariff-related.  This was just the first problem.

I ordered that second keyboard on April 6th, and I had it in my hands on the
10th.  I stuck around a little late after work to swap out the switches.
Pretty soon I had a keyboard that worked great… except for eleven keys, as seen
here.

<a href="https://www.flickr.com/photos/rjbs/54629774880/in/dateposted-ff/" title="a keyboard with switches not working"><img src="https://live.staticflickr.com/65535/54629774880_378a253562_c.jpg" width="800" height="284" alt="a keyboard with switches not working"/></a>

Many of the keys worked if I replaced my aftermarket blue switches with the
original reds that were included, so my first theory was that I had quite a lot
of busted blue switches.  I know the failure rate on switches is high, so I
went with that theory and ordered more.  Unfortunately, when they arrived, it
didn't help.  The reds still worked and the blues didn't.  Except, sometimes
the reds didn't.  Mostly it was centered around one part of the board, and if I
pressed hard, they would start or stop working.  I called on my friend Jesse,
established member of the [keyboard-industrial
complex](https://shop.keyboard.io/pages/about).  He worked with me for a while,
prompting me to do stuff I never would've done, like close circuits with a wire
lead.  Eventually, he was having me send close-up photos of the printed circuit
board that all the keys slot into.  He said, "Oh, look at those sockets!
They're at a bit too much of an angle, you're not going to get good connections
with those at all, they need re-soldering correctly."

Here's a photo from around that time.  Is it a bad socket?  I'm not sure, I had
a hard time seeing it, but Jesse seemed convinced, and I believe him.  But this
might be an unrelated photo.  My point is, this is what I was stuck thinking
about!

<a href="https://www.flickr.com/photos/rjbs/54629480041/in/dateposted-ff/" title="one wonky socket"><img src="https://live.staticflickr.com/65535/54629480041_292e945618_c.jpg" width="800" height="600" alt="one wonky socket"/></a>

Friends, I did not spent $190 on a pre-assembled keyboard just to be stripping
things down to the PCB and re-soldering them!  I'm not *that kind* of computer
nerd!  Frustrated, I wrote in to Keychron, who said they'd send me another PCB.
Not as good as another keyboard, but I could do this.  Eventually, the package
came.  I carefully disassembled my keyboard:  I removed the keycaps, then the
switches, then the top case, then the plate, then then PCB.  I attached the new
PCB, put on the top case, and put in the switches.  I was not bold enough to
put on all the keycaps, though.  I fired up the Keychron Launcher and entered
key test mode.  *Almost* perfect.  Everything worked except for one key that
I'd hardly need: `t`.

Probably I could key in a whole paragraph, using only such glyphs as remained
available.  I mean, I had a double dozen symbols under my fingers, plus one!
Only one member of our language's ABCs was missing.  Sadly, my keyboard was
here for work, and my job is hardly one focused on producing source code
lipogram.  If I was gonna use my new device, I would need all 101 keys working.

I took the keyboard apart again to see how things looked.  They didn't look
good.

<a href="https://www.flickr.com/photos/rjbs/54629694168/in/dateposted-ff/" title="broken socket"><img src="https://live.staticflickr.com/65535/54629694168_0c2e961b7e_c.jpg" width="800" height="600" alt="broken socket"/></a>

Look at this a little while and you'll see one of those black shapes isn't in
line with the others.  It's not just bent, it's totally disconnected.  It had
fallen off the PCB and was sitting under it inside the keyboard.  That's the
socket, and it's how the keyswitch connects to the circuit so that, when
pressed, the switch closes the circuit.  If the socket falls off, the key
absolutely will not work.

"What do I do now?" I asked Jesse.

"You solder it," he said.  "Good luck."

Fortunately, I had a soldering iron, never used.  I got in the [2023 Bag of
Crap](https://shop.keyboard.io/blogs/news/box-of-crap-november-2023-dubious-treasures-from-the-markets-of-shenzhen)
from Jesse's company.  He reported its original price as $2.60.  After trying
to use it, I'm sorry to say that it was closer to $0 in value.  Mine did not
heat up at all when plugged in.  It probably could've been used as an awl, but
what I needed was a *very hot* metal point, and I didn't want to heat it up on
coals.  I moaned and wailed in the office, and my coworker Kurt said he'd bring
in a proper soldering iron for me to use.  I was still pretty frustrated at
being in this position, but if it was going to get my keyboard working, fine.

He brought in a soldering iron and magnifiers, and I got to work.  Five or six
times, on three or four distinct days, I tried to solder that socket back on.
I couldn't get it done.  On one hand, it'd been decades since I last soldered
anything.  On the other hand, I felt sort of incompetent.

I emailed Keychron again:  Look, I said, the new PCB is at least as bad off as
the old one.  I tried hard to not ask you for more, because I'm sure the
tariffs are a problem, but at this point I think I've done enough.  Can you
just ship me a new complete keyboard so I am not forced to perform work on
yet another replacement part?

"No problem," they said.  "We'll send you a new printed circuit board."

Steam came from my ears, and Kurt pitied me.  "Let's fix that," he said.

<a href="https://www.flickr.com/photos/rjbs/54629677584/in/dateposted-ff/" title="kurt at work"><img src="https://live.staticflickr.com/65535/54629677584_22ecb84a36_c.jpg" width="600" height="800" alt="kurt at work"/></a>

Kurt sat down and methodically performed about a dozen steps, including the
three that I'd performed, plus another nine that probably made any part of the
job actually *work*.  With the piece soldered on, I reassembled they keyboard
and 99% of the switches worked.  I took a deep breath, pressed down on the
remainder, and then they *all* worked.  I screwed everything together and put
on the keycaps.  Everything was going great…

…until the very, very last keycap.  Remember at the very beginning, I said I
like to get a keyboard with a ten-key numeric keypad?  I really do, and I use
it!  The last key I was putting on was the keypad's "Enter" key, at the far
bottom right.  They keycap went on, but it didn't bounce up when pressed.  It
stayed down.  They Keychron keyboard had the screwed-in stabilizers like I
like, but the stabilizers on this key were now partly stuck in place.  They'd
move if pushed or pulled, but it took more force than the spring in the
keyswitch.  Here's a demonstration:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/rjbs/54629774990/in/dateposted-ff/" title="stuck stabs"><img src="https://live.staticflickr.com/31337/54629774990_405daa8fab_c.jpg" width="450" height="800" alt="stuck stabs"/></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

I asked Jesse, but he didn't have any advice that avoided disassembling the
dang thing again.  I really, *really* wanted to avoid that.  I'd had this thing
for two months, and I just wanted to have it in place and working.  I searched
the internet, I wiggled at the crossbar of the stabilizer, but nothing helped.

Here's the thing about stabilizers:  the wider or longer the key, the more
important the stabilizer is, and the closer to the edge you his the key, the
more important the stabilizer is.  The keypad's enter key is pretty short, at
2u, and I'd mostly hit it toward the middle, anyway.  I didn't need a
stabilizer!  Taking the stabilizer out would be a keyboard-disassembling task.
On the other hand, I could mangle the keycap so that it wouldn't snap onto the
stabilizer, and would only connect to the switch.  I got a spare keypad enter
key, I got a pair of pliers, and I fixed that keyboard.

<a href="https://www.flickr.com/photos/rjbs/54629476981/in/dateposted-ff/" title="brute force solution"><img src="https://live.staticflickr.com/65535/54629476981_7b01185114_c.jpg" width="600" height="800" alt="brute force solution"/></a>

Now I have working, clicky, programmable, lovely keyboards on my desks at work
and at home.  I'm pleased with them.  On the other hand, this was a stupid
amount of work, given the cost of the things.  I think I'd be happy to buy
another Keychron, and certainly I'd like my next keyboard (if I ever have to
buy another) to be programmable with something like QMX.  On the other hand, I
only wanted hot-swappable keys for the sake of getting blues.  I think my next
keyboard will have to come preassembled with blue switches, preferably soldered
right on by somebody else.

After this was all over, I took Kurt out for some beers as thanks, which came
with the bonus of getting me the pleasure of his company for a couple hours.
Next time, I'll also do *that* without all the soldering.
