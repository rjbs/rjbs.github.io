---
layout: post
title : rest, post, and content negotiation
date  : 2008-04-10T18:47:58Z
tags  : ["http", "programming", "rest"]
---
This is a pretty reasonable HTTP request (please forgive any stupid mistakes
and focus on the point):

    GET /some/resource/123 HTTP/1.1
    Accept: text/x-json
    Accept: text/xml

It says: I want this resource, either in JSON or XML.

Here's another reasonable request:

    OPTIONS /some/resource/123 HTTP/1.1

To which the response might be:

    Allow: PUT, GET

It says: you can either try to retrieve or replace that resource.

Unfortunately, the server cannot respond:

    Allow: PUT, GET
    Accept: text/x-json
    Accept: text/xml

...which would here mean, "You can replace it by sending either JSON or XML."
Instead, the client has to guess and hope that its PUT is of an acceptable
type.  Error code 406 (not acceptable) is a good "I can't accept what you PUT"
reply, but it has no defined semantics for explaining what it *could* accept.
Ugh!

This seems like a pretty obvious design flaw.

I know "Accept" might be too broad for an OPTIONS reply, because PUT and POST
might accept different things, but... it's not an insoluble problem.  I'd
settle for Put-Accept or something.

I hate the idea of communicating this in a bespoke fashion through the OPTIONS
response content.

