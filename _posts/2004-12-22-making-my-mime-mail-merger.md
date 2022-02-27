---
layout: post
title : "making my mime mail merger"
date  : "2004-12-22T18:38:00Z"
---
We wanted to send out a "Seasons Greetings" mail to our customers.  I asked why we couldn't just use Office's mail merge feature, and it turned out that we wanted a custom "from" for each recipient, so that every customer would get the email from his sales rep.  This requirement was later dropped, at which point I realized that Outlook doesn't mail merge for email.  You can only mail merge if you're going to print, fold, and post your snail mail.  Ugh!

Of course we wanted to send HTML mail with colors and pictures, and of course I was offended and wanted to secretly make it multipart/alternative.  This gave me a reason to learn how to use some new PEP modules, mostly Email::MIME and Email::MIME::Creator.  I managed to write a simple mail merger for multipart mail in just a few lines of Perl.  It's not fantastic, but it's reusable for ... well, next Christmas, if nothing else.

I make a directory with just a few files:
<ul>
<li>addrs      - a tab-delimited list of salutations and email addresses</li>
<li>part.plain - TT2 template of the plaintext part</li>
<li>part.html  - TT2 template of the html part</li>
</ul>

The directory should really store the sender and subject in a file; it'd be a simple use of IO::All to do so; I'll get around to it next year.
<pre><code>	http://rjbs.manxome.org/hacks/perl/mailmerge
</code></pre>

