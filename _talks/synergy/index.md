---
title: "Synergy: a chat bot framework"
description: "an extensible chatbot framework, and a reflection on the async/await abstraction"
date: 2024-02-04
tags: [ perl, programming ]
urls:
  - label: Video
    url: https://www.youtube.com/watch?v=3YlJHX1QO0Y
---

## Abstract

Years ago, we had to rewrite our old IRC bot in a hurry, converting it to the
Slack messaging API. When we did that, we also converted it to IO::Async and
began trying to keep it both async and easy to work on.

This talk will give a brief overview of the bot architecture and how we've kept
working on the bot simple, most especially by adopting Future::AsyncAwait.
We'll also look at how you can run your own instance of the bot.

## Notes

I was very happy with this talk.  I thought it looked good, I thought it did a
good job describing the bot enough to be useful, and I thought it hooked the
audience enough to let me pitch them on why async/await was a powerful
abstraction worth learning.

Also, I just like talking about Synergy.
