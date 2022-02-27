---
layout: post
title : Dist::Zilla v5 will break and/or fix your code
date  : 2013-10-20T14:51:11Z
tags  : ["perl", "programming"]
---
## Preface

When I wrote Dist::Zilla, there were a few times that I knew I was introducing
encoding bugs, mostly around Pod handling and configuration reading.  (There
were other bugs, too, that I didn't recognize at the time.)  My feeling at the
time was, "These bugs won't affect me, and if they do I can work around them."
My feeling was right, and everything was okay for a long time.

In fact, the first bug report I *remember* getting was from Olivier Mengué in
2011.  He complained that [`dzil setup` was not doing the right thing with
encoding](https://rt.cpan.org/Ticket/Display.html?id=67551), which basically
meant that he would be known by his
[mojibake](http://en.wikipedia.org/Mojibake) name, Olivier MenguÃ©.  Oops.

I put off fixing this for a long time, because I knew how deeply the bugs ran
into the foundation.  I'd laid them there myself!  There were a number of RT
tickets or GitHub pull requests about this, but they all tended to address the
surface issues.  This is really not the way to deal with encoding problems.
The right thing to do is to write all internal code expecting text where
possible, and then to enforce encode/decode at the I/O borders.  If you've
spent a bunch of time writing fixes to specific problems inside the code, then
when you fix the border security you need to go find and undo all your internal
fixes.

My stubborn refusal to fix symptoms instead of the root cause left a lot of
tickets mouldering, which was probably very frustrating for anybody affected.
I sincerely apologize for the delay, but I'm pretty sure that we'll be much
better off having the right fix in place.

The work ended up getting done because David Golden and I had been planning for
months to get together for a weekend of hacking.  We decided that we'd try to
do the work to fix the Dist::Zilla encoding problems, and hashed out a plan.
This weekend, we carried it out.

## The Plan

As things were, Dist::Zilla got its input from a bunch of different sources,
and didn't make any real demand of what got read in.  Files were read raw, but
strings in memory were … well, it wasn't clear what they were.  Then we'd jam
in-memory strings and file content together, and then either encode or not
encode it at the end.  Ugh.

What we needed was strict I/O discipline, which we added by fixing libraries
like Mixin::Linewise and Data::Section.  These now assume that you want text
and that bytes read from handles should be UTF-8 decoded.  (Their documentation
goes into greater detail.)  Now we'd know that we had a bunch of text coming in
from those sources, great!  What about files in your working directory?

Dist::Zilla's GatherDir plugin creates `OnDisk` file objects, which get their
content by reading the file in.  It had been read in raw, and would then be
mucked about with in memory and then written back out raw.  This meant that
things tended to work, except when they didn't.  What we wanted was for the
files' content to be decoded when it was going to be treated as a string, but
encoded when written to disk.  We agreed on the solution right away:

#### Files now have both `content` and `encoded_content` and have an `encoding`.

When a file is read from disk, we only set the encoded content.  If you try
reading its content (which is always text) then it is decoded according to its
encoding.  The default encoding is UTF-8.

When a file is written out to disk, we write out the encoded content.

There's a good hunk of code making sure that, in general, you can update either
the encoded or decoded content and they will both be kept up to date as needed.
If you gather a file and never read its decoded content before writing it to
disk, it is never decoded.  In fact, its `encoding` attribute is never
initialized… but you might be surprised by how often your files' decoded
content is read.  For example, do you have a script that selects files by
checking the shebang line?  You just decoded the content.

This led to some pretty good bugs in late tests, hitting a file like
`t/lib/Latin1.pm`.  This was a file intentionally written in Latin-1.  When a
test tried to read it, it threw an exception: it couldn't decode the file!
Fortunately, we'd already planned a solution for this, and it was just fifteen
minutes work to implement.

#### There is a way to declare the encoding of files.

We've added a new plugin role, `EncodingProvider`, and a new plugin,
`Encoding`, to deal with this.  EncodingProvider plugins have their
`set_file_encodings` method called between file gathering and file munging, and
they can set the encoding attribute of a file before its contents are likely
to be read.  For example, to fix my Latin-1 test file, I added this to my
`dist.ini`:

    [Encoding]
    filename = t/lib/Latin1.pm
    encoding = Latin-1

The Encoding plugin takes the same file-specifying arguments as PruneFiles.  It
would be easy for someone to write a plugin that will check magic numbers,
or file extensions, or whatever else.  I think the above example is all that
the core will be providing for now.

You can set a file's encoding to `bytes` to say that it can't be decoded and
nothing should try.  If something *does* try to get the decoded content, an
exception is raised.  That's useful for, say, shipped tarballs or images.

#### Pod::Weaver now tries to force an `=encoding` on you by @Default

The `@Default` pluginbundle for Pod::Weaver now includes a new Pod::Weaver
plugin, `SingleEncoding`.  If your input has any `=encoding` directives,
they're consolidated into a single directive at the top of the document… unless
they disagree, in which case an exception is raised.  If no directives are
found, a declaration of UTF-8 is added.

For sanity's sake, `UTF-8` and `utf8` are treated as equivalent… but you'll end
up with UTF-8 in the output.

You can *probably* stop using Keedi Kim's `Encoding` Pod::Weaver plugin now.
If you don't, the worst case is that you might end up with two mismatched
encoding directives.

#### Your dist (or plugin) might be fixed!

If you had been experiencing double-encoded or wrongly-encoded content, things
*might just be fixed*.  We (almost entirely David) did a survey of dists on the
CPAN and we think that most things will be *fixed*, rather than broken by this
change.  **You should test with the trial release!**

#### Your dist (or plugin) might be broken!

...then again, maybe your code was relying, in some way, on weird text/byte
interactions or raw file slurping to set content.  Now that we think we've
fixed these in the general case, we may have broken your code specifically.
**You should test with the trial release!**

The important things to consider when trying to fix any problems are:

* files read from disk are assumed to be encoded UTF-8
* the value given as `content` in InMemory file constructors is expected to be
    text
* FromCode files are, by default, expected to have code that returns text;
    you can set `(code_return_type => 'bytes')` to change that
* your `dist.ini` and `config.ini` files **must** be UTF-8 encoded
* __DATA__ content used by InlineFiles **must** be UTF-8 encoded
* if you want to munge a file's content like a string, you need to use
    `content`
* if you want to munge a file's content as bytes, you need to use
    `encoded_content`

If you stick to those rules, you should have no problems… I think!  You should
also report your experiences to me or, better yet, to the [Dist::Zilla mailing
list](http://www.listbox.com/subscribe/?list_id=139292).

Most importantly, though, **you should test with the trial release!**

## The Trial Release

You'll need to install these:

* [Mixin::Linewise 0.100](https://metacpan.org/release/RJBS/Mixin-Linewise-0.100-TRIAL)
* [Data::Section 0.200002](https://metacpan.org/release/RJBS/Data-Section-0.200002-TRIAL)
* [Dist::Zilla 5.000](https://metacpan.org/release/RJBS/Dist-Zilla-5.000-TRIAL)

…and if you use Pod::Weaver:

* [Pod::Weaver 4.001](https://metacpan.org/release/RJBS/Pod-Weaver-4.001-TRIAL)
* [Dist::Zilla::Plugin::PodWeaver 4.000](https://metacpan.org/release/RJBS/Dist-Zilla-Plugin-PodWeaver-4.000-TRIAL)

## Thanks!

I'd like to thank everyone who kept using Dist::Zilla without constantly
telling me how awful the encoding situation was.  It was awful, and I never got
more than a few little nudges.  Everyone was patient well beyond reason.
Thanks!

Also, thanks to David Golden for helping me block out the time to get the work
done, and for doing so much work on this.  When he arrived on Friday, I was
caught up in a hardware failure at the office and was mostly limited to
offering suggestions and criticisms while he actually wrote code.  Thanks,
David!

