---
layout: post
title : "json, yaml, cpan, meta"
date  : "2009-03-11T04:11:19Z"
tags  : ["cpan", "json", "perl", "programming", "yaml"]
---
For quite some time now, most distributions uploaded to the CPAN include the
file META.yml.  This file was introduced by Module::Build, and describes the
contents of the distribution.  It helps the PAUSE indexer and other tools
figure out what the distribution is and contains without a lot of analysis.

Unfortunately, YAML has problems.  The biggest problem is that its Perl
implementations are pretty lacking.  Ingy has been at work on some new
implementations, but they're not done yet.  Some of the lack is in feature
support -- this isn't a big deal for META.yml, because it needs only the
simplest features: store basic data in an easy to read format.  Some of the
lack, though, is in important things like representing Unicode properly.

David Golden busted out an [excellent illustration of YAML interop
problems](http://echo.dagolden.com/~xdg/meta-yaml-testing/).  It shows which
parsers fail to parse what input, or where they succeed but disagree.  Quite a
lot of the failures revolve around Unicode.  Other failures are related to
hand-written META.yml files.  Still others are just failures of some
non-standard parsers to parse the output of other non-standard producers.

YAML is very complex, so none of this should be surprising.  Without at least
one very compliant tool from the beginning, this kind of failure was destined
to happen.

Since very, very few features are needed, I think this is another place where
JSON is a much better tool than YAML.  It's got an [incredibly simple
grammar](http://json.org/) and, as far as I've ever seen, it has no serious
gotchas.  If all META.yml files were produced by compliant JSON emitters in the
future, there would be no issue with reading them.  We already have a fantastic
JSON emitter and parser in JSON.pm and JSON::XS.

None of this even requires a radical change in how we define META.yml.  [The
META.yml
spec](http://module-build.sourceforge.net/META-spec-current.html#format) says
that META.yml files are written in YAML.  Since YAML 1.2, YAML has been very,
very nearly a strict superset of JSON.  The current edge cases are very edgy
and I believe they are all going to be fixed.  (I remember one such case right
now, and I believe it is the most severe: you cannot have a hash key longer
than 1024 characters in YAML, but you may in JSON.)

In other words, if all META.yml files were produced by compliant JSON emitters
in the future, there would be no issue with reading them *even with a compliant
YAML parser*.

Adam Kennedy seems to think that this is not true.  In [a CPAN Rating](http://cpanratings.perl.org/dist/JSON-CPAN-Meta), he wrote:

> This module is based on the assumption that META.yml is YAML as described
> by the YAML specification.
> 
> This, unfortunately, is not the case. META.yml was created at a time
> when YAML was immature, and as a result it presents some problems in
> this regards.
> 
> The use of JSON in META.yml is likely to cause problems, and should
> be avoided wherever possible. 

META.yml *is* YAML as described by the YAML specification.  The META.yml says
so and links to the spec.

He doesn't enumerate what "some problems" are, so it's impossible to address
whatever problems he thinks it would cause.  I think this is FUD.

However, there are some things to clear up before it's clear sailing.  First,
we'd need a way to tell dist building tools to use JSON, not block-form YAML in
META.yml.  [I have already taken care of
this.](http://search.cpan.org/dist/JSON-CPAN-Meta/)

The CPAN's author upload server (PAUSE) will also need to use a better YAML
parser.  Right now, it's using the old YAML and YAML::Syck code, both of which
are horribly non-compliant and fail on plenty of valid YAML constructs,
including JSON-like YAML.  Upgrading that should be simple, and I'm hoping I
can help get it done during the upcoming QA Hackathon in Birmingham.

After that, it all comes down to this: things that read META.yml should be able
to read YAML.  Reading some lousy subset of YAML that is not well-defined by
the META.yml spec is no substitute.  If that is too tall an order, we need a
clear specification for a subset to use.  If we're going to do that... why not
just use JSON instead of a newly-minted subset spec of YAML?  If the future is
still META.yml, and not META.json, then it should be YAML, and not an imaginary
format with no other applications.

