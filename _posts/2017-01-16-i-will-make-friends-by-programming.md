---
layout: post
title : "I will make friends by programming."
date  : "2017-01-16T03:25:19Z"
tags  : ["friendship", "programming"]
---
Every once in a while I randomly think of some friend I haven't talked to in a
while and I drop them an email.  Half the time (probably more), I never hear
back, but sometimes I do, and that's pretty great.  This week, I read an
article about Eagle Scouts and it made me realize I hadn't talked to my high
school friend Bill Campbell for a while, so I dropped him an email and he wrote
right back, and I was happy to have sent the email.

Today, I decided it was foolish to wait for random thoughts to suggest I should
write to people, so I went into my macOS Contacts application and made a
"Correspondents" group with all the people whom it might be fun to email out of
the blue once in a while.

Next, I wrote a program to pick somebody for me to email.  Right now, it's an
incredibly stupid program, but it does the job.  Later, I can make it smarter.
I figure I'll run it once every few days and see how that goes.

I wrote the program in JavaScript.  It's the sort of thing you used to have to
write in AppleScript (or Objective-C), but JavaScript now works well for
scripting OS X applications, which is pretty great.  This was my first time
writing any JavaScript for OSA scripting, and I'm definitely looking forward to
writing more.  Probably my next step will be to rewrite some of the things I
once wrote in Perl, using Mac::Glue, which stopped working years ago when
Carbon was retired.

Here's the JavaScript program in its entirety:

```javascript
#!/usr/bin/osascript
Contacts = Application("Contacts");

var people = Contacts.groups.byName("Correspondents").people;
var target = people[ Math.floor( Math.random() * people.length ) ];

var first = target.firstName.get();
var last  = target.lastName.get();

first + " " + last;
```
