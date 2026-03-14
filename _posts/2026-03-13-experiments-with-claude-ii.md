---
layout: post
title : "experiments with claude, part ⅱ: my personal site"
date  : "2026-03-13T12:00:00"
tags  : ["programming","agents"]
---

I've been trying more things with Clade Code, and I want to keep some notes on
how it went.  This is the second post in a probably-short series about early
adventures with the tool.

## Project Two: rjbs.cloud/talks

I felt good about how the Cassandane subroutine signature replacement went, and
I wanted to do some more experimentation.  This time, I wanted to use Claude to
generate code that I *wouldn't* just go delete. I wanted something low stakes,
where I wouldn't have any reason to feel annoyed by Claude's choices in
implementation.  I also wanted to be able to say "yeah good enough" when *I*
thought it was good enough, without asking anybody else to accept that the work
was good enough for the repo.  That is:  I wanted an isolated test case where
only I was taking on any risk.  Easy: my personal web page!

Sure, in theory this was using company resources (my Claude subscription) for
personal use, but I already got Fastmail's $20 worth out of Claude in
Cassandane.  And it was professional development.  Yup, felt like a great idea!

Did I mention I was in Belgium at the time?  I was.  I was at FOSDEM, I'd just
given [a talk on JMAP](https://www.youtube.com/watch?v=aCbr8xIR2vU), and I was
going to put it on my "talks I've given page", but that page of my site was
still on my old website, where it was manually-written HTML.  My current site
is Jekyll, built by GitHub Pages, the definition of "good enough".  By hand, I
got the talks page into Jekyll, as a horrible hybrid of Markdown and the old
HTML.  You can read the state I got it into in [the last
commit](https://github.com/rjbs/rjbs.github.io/commit/a59e08cc4fa5a410dc0b227ab5bb7b901bebcf6a)
before I invited Claude to the party.

I prompted Claude with this:

> The file `talks/index.md` contains two lists of conference presentations. One
> is a Markdown bullet list of links, generally to YouTube. The other is HTML
> with thumbnail images linked to SpeakerDeck. Convert this to a data-driven
> grid rendered by Jekyll, presumably using a collection. Each entry should be
> able to contian a text description, title, and image asset.

If you want, you can read [the entire, highly-detailed transcript of this
session with
Claude](https://static.rjbs.cloud/claudelog/talks-page-import.html).  The short
version is that I spend about 20 minutes engaged with Claude.  (There are some
hours-long waits in there while I did things like "go to dinner".)  Claude very
quickly updated my repo to do just what I asked.  It looked pretty good, too,
and produced [a pretty straightforward
commit](https://github.com/rjbs/rjbs.github.io/commit/f049dc1d3644f9972984527ea16462a521144e83).
The commit message is crap: I wrote it, with an audience of "myself".

The commit adds a bunch of CSS (SCSS), which very plausibly contains pointless
crap or is doing in a goofy way.  I don't know because (a) I'm not a CSS expert
and (b) I could not care less.  This kind of "could not care less" echos my
feelings about the construction of the throwaway subroutine-signature-adder.
This code (the CSS) would stick around, but I wasn't going to have to think
about it.  The real content was the YAML file, and if the CSS got too
complicated later, I could throw it all away, start over, or whatever.  It was
not for human consumption, and posed roughly no risk.  (I did *read* it,
because no LLM-generated code is obviously safe and correct.)

With that done, things got more interesting, in that there was more faffing
about.  For a talk with slides and an image, I was going to have to do this:

```
/_data/talks.yaml   # <- add an entry
/asset/talk-name/preview.jpg
/asset/talk-name/slides.pdf
```

Ugh, there was too much chance of anomaly there.  I asked for a fix, Claude
said "What if we use a collection?" and I said, "*That's what I suggested to
start with!*"  Still, Claude went ahead and converted the talks.yaml file into
a bunch of individual Markdown files for me, so all was forgiven.  Then there
was a big back and forth about how to make preview image discoverable, where
Clade was definitely confused about how things worked.

{% chat %}
rjbs: How sure are you that files from a collection are part of `static_files`?
claude: *(thinking to itself)* The user is asking me to be honest about my
    certainty level again.  And they're right to push - I've been making
    assumptions. I'm not actually certain that static files within a collection
    directory appear in `site.static_files`. They might be in a different
    collection-specific variable, or might need to be accessed differently.
{% endchat %}

This was really frustrating, but only about 70% because of Claude.  The Jekyll
docs are beautiful but lousy.  They sort of vaguely describe how things work in
many cases, but they're hardly comprehensive.  We got there in the end, but it
was tedious:  I took over, made changes by hand, pushed, and checked what
happened.

### Project Two ½: rjbs.cloud/talks refactoring

After the previous day's mix of success and annoyance, I went back for round
two.  I did a few things.  I cleaned up some old posts, I reworked how the talk
source files were laid out… but the main thing was I got a local build running.
This was never going to be *hard*, because I'd done it before, but I didn't
want to futz around.  I asked Claude how I could get a local build going and it
said "like this" and dumped out a little shell script.  I didn't like it and
asked for a few improvements.  Within minutes, I had a local build-and-serve
script committed.

You can read [the whole
transcript](https://static.rjbs.cloud/claudelog/talks-page-refactor.html),
boring bits and all.  Also, of course the commits are all in my repo.

Was this safe to run on my laptop?  Well, I think so.

Claude's general tool-running security is pretty lousy.  It says it won't touch
stuff outside the project directory, and tries to ask for permission, but it's
pretty unintelligent.  When in doubt, throw it all in a container.  Anthropic
[offers some](https://code.claude.com/docs/en/devcontainer).  But there's also
**sandbox mode**.  In sandbox mode, Claude uses bubblewrap or seatbelts, which
are effectively process namespacing tools.  In sandbox mode, you can tell
Claude to go ahead and try whatever it wants.  If the kernel prevents it, then
it will ask permission.  This isn't a foolproof system, but it's suitable for
"hackin' on my personal website".

### Project Two ¾: rjbs.cloud hacking on the web

Last bit about using Claude for my personal site!

My friend David is much more of a power user of Claude than I am.  The other
day, he said he was kicking off some bugfixes from a taxi.  I said, "How does
that work?"  It's like this:  Just like you can chat with Claude in your
browser and ask it to explain how an octocoupler works, you can code with
Claude and ask it to make changes to your software.  It's like an IDE, but
there's no human-operable editor.  (Kind of like emacs, heyooooooo!)

You give Claude permission to access your GitHub repos, and it runs its edits
and other tool use inside Anthropic's compute cloud.  When it's done, it can
create PRs for you.

I am not enthusiastic about this setup, although "fire off a worker to get
started on a problem" is not a bad idea.  It's mostly that Claude Code on the
Web is pretty limited and I don't think it will be suitable for my primary work
any time soon.  Also, I'm less clear on the entire security model of delegated
GitHub access through Claude.  I need to really read the docs, here.

On the *other hand*, I fixed a bit of styling on my blog from a chat on my
tablet.  This all fell under "pretty neat, worked great, not interested".

![Claude Code on the Web](/assets/2026/claude-code-on-the-web.webp)
