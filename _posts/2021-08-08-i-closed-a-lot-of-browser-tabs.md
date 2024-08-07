---
layout: post
title : "I closed a lot of browser tabs"
date  : "2021-08-08T15:39:36Z"
tags  : ["programming"]
image : "/assets/2021/08/tab-count-graph.png"
---
I am widely admired at work for my ability to have many, many browser tabs
open.  (That, at least, is what I take from the frequent shouts of "holy cow,
man, look at your browser!")  Nonetheless, I have long thought that it would be
worth getting my total tab count down.  I have tabs open for a bunch of
reasons.

* document I meant to read eventually
* document I meant to read in time for some meeting
* web application I always keep open
* thing I am in the middle of working on but should finish at some point
* thing I was reading or editing but am basically done with
* duplicate tab of any of the above

One problem here is that once the count of tabs is large enough, "clean up
tabs" starts with a whole step of "figure out which tab is what kind of tab".
Can I just close it because I'm done?  Is it a thing I should read?  Soon?
Someday?  I need to improve my real time habits: closing things when done,
grouping things by purpose, and so on.  Until then, though, I need to see when
I've let things get out of control.

For years, I've thought, "I should visualize my tab count over time."  Once or
twice I even wrote programs to help, but about a week ago I finally made the
whole thing go.  When I Tweeted about it, I got a couple "how'd you do thats?",
so I thought I'd write it up.  It's simple, except sort of not.

Here's the output:

![a graph of my browser tabs](/assets/2021/08/tab-count-graph.png)

If you can't tell, this graph is generated by
[Grafana](https://en.wikipedia.org/wiki/Grafana), a data visualizer that can
produce graphs and many other visualizations of data from all kinds of systems.
So, I needed to set up Grafana.  That was easy, I used their free cloud
hosting, but setting up Grafana on a Linode is also dead simple.  Basically,
you install and tell it where to get the data.  There are a lot of Grafana
tutorials.

I have my Grafana pointed at Prometheus.  Prometheus is a [time series
database](https://en.wikipedia.org/wiki/Time_series_database) that gathers data
by hitting HTTP endpoints.  To grossly simplify, if you want your application
to expose metrics to be gathered and later analyzed, you give it HTTP listener
that replies with data in a specific format.  There are a lot of Prometheus
tutorials.

What I needed to do was to provide an HTTP service that would provide tab
counts.  I picked the simplest possible way to provide that count, meaning a
response like this:

    Content-Type: text/plain

    chrome_open_tabs 234

**First problem**: how to count tabs?

When I originally looked at doing this, years ago, I was using Firefox.  I tend
to switch back and forth between Chrome and Firefox every few years.  In
Firefox, it was pretty easy to get tab counts.  In the profile directory,
there's a file called something like `sessionstore-backups/recovery.jsonlz4`.
The exact place this lives has changed over time, but generally there has been
a JSON file in your profile that you could read to see tabs.

Chrome stores its sessions in a seemingly obnoxious binary format called SSNS.
I looked at decoding it and groaned.  I knew I could write a browser extension
to get at the tab counts, but I had a vague sense of unease about two things.
First, I wasn't sure I'd have any means to embed a web server in Chrome to
serve this data.  That meant I'd want to write the data to a file to be server
by something else.  That gets to my second concern:  I doubted I'd be able to
reliably write the tab count to a file from an extension.

I had a flash of inspiration, though.  If, by some great mercy, Chrome was
automatable by AppleScript, I could make a go of it.  I opened up the macOS
Script Editor, hit Cmd-Shift-O to "Open Dictionary", and looked for Google
Chrome.  It was there!  Its automation suite is tiny, but it exposes windows
and tabs.  I was able to write this AppleScript:

```applescript
set tabcount to 0
if application "Google Chrome" is running then
  tell application "Google Chrome"
    repeat with w in windows
      set tabcount to tabcount + (count of tabs of w)
    end repeat
  end tell
end if
```

AppleScript is weird, but I have had decent success in using it for lots of
little tasks in the past.  These days, what I tend to do is prove something
will work in AppleScript, then port it to JavaScript, using JXA.  JXA is
"JavaScript for Automation", which is just "what if you could write JavaScript
instead of AppleScript to do the same stuff?"  This is pretty appealing!
JavaScript is a much less weird language, and you can combine your macOS
automation with other code you've written in JavaScript.

It's not perfect, though.  The objects you get to represent AppleScriptable
entities are pretty clumsy.  They don't let you get a list of their properties,
and if you make a guess, it won't help much.  `object.foo` will always evaluate
to a function, but that function may throw a "no such function" exception when
called.  Array-like objects aren't iterable, so you'll do a lot of looping over
indexes instead of iterating over value.  Still, this isn't so bad:

```javascript
let tabcount = 0;
const Chrome = new Application("Google Chrome");

if (Chrome.running()) {
  for (i in Chrome.windows) {
    tabcount += Chrome.windows[i].tabs.length;
  }
}
```

That "check if Chrome is running" step is important.  On one hand, it would be
nice to act like quitting Chrome didn't really eliminate the mental weight of
its tabs.  On the other, using AppleScript to talk to an application that isn't
running will launch that application, and I sure don't want that.

**Second problem**: how to spin up the HTTP service?

Now I had a means to count tabs.  The code I actually wrote was a little
different, because I gathered an array of per-window tab counts, in case I
wanted to graph that, too, but it was a lot like code above.  Now I needed to
get it running regularly.  The most obvious option for this was to have it run
under [launchd](https://en.wikipedia.org/wiki/Launchd), the macOS service
manager.  This would be very sensible, but would require I think about launchd
configuration, which I don't like doing.  I thought about setting up
[daemontools](https://en.wikipedia.org/wiki/Daemontools) to run things out of
my home directory.  I'd have to run it from launchd, but having set that up
once, I wouldn't have to think about it again.  I didn't even want to think
about it once, thought!

I had another weird realization.  I use a program called
[Hammerspoon](https://www.hammerspoon.org/), which is sort of an all-purpose
tool for doing macOS automation.  I use it to inject some menu bar icons that
reorganize my desktop or run timers, and to set up keyboard shortcuts for a few
things.  Among its many other functions, it has facilities for embedded HTTP
service.  It can *also* run JavaScript using JXA.  I wrote this:

```lua
tabulator = hs.httpserver.new()
tabulator:setPort(9876)
tabulator:setCallback(function (method, path, headers, body)
  if (method == "GET") and (path == "/metrics") then
    bool, tabcounts, descriptor = hs.osascript.javascript([[
      const Chrome  = new Application(
        "/Applications/Google Chrome.app"
      );

      let tabCounts = [];

      if (Chrome.running()) {
        for (i in Chrome.windows) {
          tabCounts.push(Chrome.windows[i].tabs.length);
        }

        tabCounts.sort((a,b) => b - a);
      }

      tabCounts;
    ]])

    if not bool then
      return "Error\n", 500, {}
    end

    local sum = 0
    for i, tabs in ipairs(tabcounts) do
      sum = sum + tabs
    end

    return "chrome_open_tabs " .. sum .. "\n", 200, {}
  else
    return "No good.\n", 404, {}
  end
end)

tabulator:start()
```

This creates a new HTTP listener on port 9876.  If it receives a GET request
for `/metrics`, it runs my JXA to ask Chrome (if running) about its tab count.
The `hs.osascript.javascript` function returns a tuple, and the second item in
it is the final statement of the JavaScript code, where we've ended with
`tabCounts`.  If the code ran without an error, I return my metrics in a 200
response.

To collect this locally and not let just anybody on the internet trigger this
JavaScript running, I have a locally running Prometheus instance on my MacBook.
It hits this endpoint and then relays the results to my Prometheus instance in
the cloud.  Grafana looks at that and shows me my tab count.  When it's in the
red, I sigh, look through my tabs, and close what I can.

You can see my tab count crashing a few times.  First, I closed obvious
duplicates or dead documents.  Later, I finished easy tasks represented by open
tabs.  On the weekend, I read a lot of backlogged articles and closed them.
Now I'm around 30 tabs, which seems like it's probably about the right number
for me.

I meant to build this to help me get better at doing things in Prometheus and
Grafana, but I think mostly it was just sort of fun weird general purpose
programming, and I enjoyed it.  It was a nice reminder that lots of tedious
problems have silly solutions.

