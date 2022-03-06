---
layout: post
title: the black box
date: 2002-03-14T11:29:00Z
---

One of the best ideas in modular programming (and in much of design, really) is
'the black box.'  A *black box* is a mysterious device that accepts a given
type of input and operates on it in such a way as to produce a desired result
reliably.  Its workings are hidden from view, but because the relationship
between its input and its output is known, its workings don't matter.

A fast food drive-through is a good example of a black box system:  a customer
provides input (an order, money) and receives predictable output (his order and
a receipt).  We can make the dangerous assumption, for the moment, that the
order always goes through correctly.  The customer doesn't know how the
employees track the order internally or in what order they assemble his order.
He only knows that by giving specific input, he receives specific output.
Because the inner workings are hidden, the restaurant's manager is free to
reorganize them to provide the same result *more efficiently*.  The
order-tracking system may be revised, the ketchup dispensers may be upgraded,
or the entire staff may be replaced with robots.

It's equally important that, because the drive-through restaurant interface is
an open specification, others can implement their own drive-through
restaurants, from which the customer can expect identical (although possibly
faster or slower) service.  This means that if McDonald's is consistantly slow,
the customer can go to Burger King instead.

In terms of system programming, the black box allows us to specify purely
abstract interfaces and leave implementation as an exercise to the reader.  If
more than one implementation is forthcoming, programmers can pick the one they
feel best meets their needs -- the fastest, the smallest, or otherwise.
