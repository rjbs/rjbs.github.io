---
title: "Crafting Custom Interfaces with Sub::Exporter"
description: "exporting subroutines, building closures, and currying methods with Sub::Exporter"
date: 2007-06-27
urls:
  - label: Slides
    url: https://speakerdeck.com/rjbs/crafting-custom-interfaces-with-sub-exporter
---

## Abstract

Everybody knows about Exporter.pm: you use it, and if someone uses your module,
they don't have to type quite as much. We'll look at how the Exporter works,
and how it fails to take advantage of the powerful concepts on which it's
built. We'll see how you can provide flexible import routines that allow your
module's user to type even less and get code that behaves much more like part
of his own program. You can avoid repeating unnecessary parameters to every
overly-generic routine and can avoid collision-prone global configuration. All
of this is made possible -- and easy -- by Sub::Exporter.

Generators -- routines that build routines -- can produce customized code,
built to each importer's specifications. Sub::Exporter lets you build and
provide customized routines easily. You'll learn how to write generators, and
how to use them with Sub::Exporter . In its simplest form, it's as easy to use
as Exporter.pm. With just a bit more configuration, it can build, group,
rename, and julienne routines easily. With this tool, you'll be able to provide
interfaces that are both simpler and more powerful than those provided by the
stock Exporter.
