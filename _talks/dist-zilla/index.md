---
title: "Dist::Zilla: RAAAAAAAAAR!"
description: "automating CPAN distribution building with Dist::Zilla"
date: 2010-06-21
urls:
  - label: Slides
    url: https://speakerdeck.com/rjbs/dist-zilla-raaaaaaaaar
---

## Abstract

Sharing your awesome code with the world is fun and rewarding, and the CPAN is
a great distribution mechanism. Unfortunately, there's a lot of boring
maintenance involved in the process, above and beyond just writing awesome
code. Dist::Zilla is a framework for automating every part of your packaging
and release cycle. It builds an installer, writes out boilerplate files,
determines your prerequisite libraries, rewrites your documentation, updates
the changelog, interacts with your version control system, and uploads your
release to the CPAN.

Because it only runs on the author's machine, it's free to have outlandish
requirements and execution costs, but the released code has no special
prerequistes and looks like any boring distribution from the installer's
perspective. Because it's primarily a framework for plugins, the behavior of
Dist::Zilla can be customized from minimal release automation to maximum
overkill. Hundreds of CPAN distributions have already switched to Dist::Zilla
to harness its power.

This presentation will cover writing new distributions using Dist::Zilla as
well as converting existing distributions. The existing plugins will be
explained, along with common configurations. It will cover writing new plugins
and plugin bundles.
