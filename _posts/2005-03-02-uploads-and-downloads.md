---
layout: post
title : uploads and downloads
date  : 2005-03-02T13:05:00Z

---
At work, I'm finally actually making progress on "attaching stuff to stuff." The initial manifestation of this is "attaching special instructions (like Word documents) to shipping specs."  I had wanted to use CGI::Uploader, but it's too screwed up for me at the moment.  Its tests are welded to ImageMagick or GD or something, and they're writting in a way that isn't immediately clear to me, so I can't easily pry them apart.  It reminds me of the way CGI::Application has HTML::Template welded to it.  The big annoyance for me is that there is no PPM for it, so it's a pain to install at work.

So, rather than use that possibly-round wheel, I am fashioning my own.  It's a simple Class::DBI class with a create_from_cgi_field method.  That method uses CGI::Upload to get some vitals about the file, copy it to disk, and store the vitals and file location in the database.  It's about thirty lines of Perl, and just a little tweaking I should be able to attach it to CGI::Form::Table input to get a file attachment from each row of a table.

Unfortunately, even now that I feel like getting things done, I can't just do them.  Supporting the ERP system is a big pain in the butt, mostly because even though every case is fairly simple, I need to spend hours figuring out how the simple bits work.  I don't know the jargon, the business rules, or the implementation.

Last night while Gloria was practicing yoga, I did some tinkering.  I finally put WWW::Mechanize to good use.  I've long thought it was a very useful module, just not for me.  I had started to use it for making a Netflix client and for one or two other abortive tasks, but now I have a script I know I will use frequently.

I really like the software from OmniGroup.  They make OmniOutliner, OmniGraffle, and OmniWeb, all of which I have bought and use regularly. OmniOutliner and OmniGraffle also come in Pro editions with a few features that are useful to me only once in a great while.  Fortunately, OmniGroup offers free one-day licenses.  They're usually sufficient to get me through my times of need, although fetching and installing the license is a pain.

So, I tied WWW::Mechanize to some AppleScript and now it's simple.  I'm not going to publish the script, becuse I think it's sort of naughty.  It was just a fun little way to spend an hour.  Not only did I get some practical experience with mech, but I got to lean how to script the Mac OS GUI.  Pretty cool.

