---
title: "JMAP: the absolute minimum[.pdf]"
description: "a very quick tour through what JMAP is and why it's so great"
date: 2025-02-03
urls:
  - label: Video
    url: https://www.youtube.com/watch?v=8Y5U7OHtr24
---

## Abstract

JMAP (RFC 8620, 8261, &c.) is a new protocol meant to replace IMAP, CalDAV,
CardDAV, and to handle more kinds of data in the future. It keeps the most
important technical properties of those protocols, but ditches many things that
hold back improvements and hamper developers. It's built on commonly understood
and implemented standards, which makes it easy to get up and running and easy
to benefit from modern systems like push notifications. It's built as a syncing
protocol, providing easy sync features in a data agnostic way.

JMAP is still young, but there are multiple implementations of both client and
server. The most notable install of JMAP is at Fastmail, where it's the primary
interface to all customer data.

This talk will cover what JMAP looks like, the principles under which it
operates, and how to get started working with it. We will discuss the likely
next steps in JMAP's rollout and how Fastmail uses JMAP internally for its own
datatypes.

## Notes

I was happy with this for what it was: a quick intro to JMAP, explaining why it
will be so much easier for the casual hacker to make use of it compared to
legacy protocols.  I'd originally thought I was getting a 45-50 minute slot,
so I'd worked on a much more comprehensive talk.  I hope, someday, to produce
an online-only version of that.  I suspect that FOSDEM won't ever be the venue
for it, as the Modern Email dev room runs fast and tight.  But on its own, or
in a less frantic conference setting, it could be really good.
