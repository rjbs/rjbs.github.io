---
layout: post
title : "code i've been poking at"
date  : "2005-11-28T02:11:03Z"
tags  : ["perl", "programming", "rubric"]
---
I haven't done any programming at all, this holiday, which is just fine with me.  I have had a really nice, relaxing time.  I've watched some lousy movies, read a decent book, played a lot of Disgaea, and eaten at least three slices of pumpkin pie.

Just before Thanksgiving, though, I did a fair bit of coding, most of which I'm actually pretty happy with.

I updated Rubric a bit.  It was nothing exciting, but at least one good thing came out of it.  I converted the distribution to Module::Install, which everyone says is what all the cool kids are doing.  It wasn't particularly exciting, but maybe it will save me time in the future.  I was a little disappointed to find that it doesn't have a boolean "recursive tests" option, and that the tests() setup that it does provide wants a string, not a list. That should be easy enough to patch.

Anyway, that's not the good thing.  The good thing is that I found a long-standing bug.  I use to intermittently get a weird test failure, saying something about "0 > 0" -- other people would report it, and I'd call it the "0 > 0" bug and say, "It's a bug in the tests, not the software.  Just ignore it." It really, really irritated me, though!  I couldn't figure out what the problem was, but I also wasn't trying very hard.  "The software still works," I'd say to myself.

I thought this bug was gone in my previous release, but after updating to Module::Install, I found it happening consistently.  I fired up the ever-useful DBI::Shell and looked into the problem.  It turned out to be related to one of SQLite's weird little quirks.  In SQLite, you can have untyped columns.  Even typed columns are more like type-hinted columns.  I had a number of columns without hints, and two related columns were being created differently during testing, but during production they'd always be created the same way. (Because, I think, the low-level create methods for entry tags were only called during testing.)  One column stored identifiers as numbers, the other as strings.  In SQLite, 5 is not equal to '5', so things went a little funny.

I updated the schema, wrote an annoying little update script, and the test failures are gone.  Rubric's Rubric::DBI::Setup has a set of subs it in that let it determine what version of the schema you're using and then update you automatically.  These generally are a list of commands like this (but longer): create new_table; insert into new_table select from table; drop table; create table; insert into table select from new_table; drop new_table;

That's because SQLite has only a limited ALTER TABLE command and can't remove or alter existing columns.  I should really write a little abstraction to make it easier to write ALTER TABLE instructions, but so far it's just been easier to suffer a little every time, rather than take all the suffering at once to write that abstraction.

I'm hoping to start doing some more work on Rubric soon, though.  At the very least, I'd like to make the search bar more useful.  hide is really eager to put a "search Google" link on the results page, and although I don't care for the idea, I'll try to make it easier to add that sort of feature.  I'd like to have a more generic search syntax, but it might be possible to implement in terms of the existing /entries handler.  Anyway, having a version with passing tests is really good.

I'd also like to make Rubric use two of my other recent projects: HTML::Widget::Factory and the Templatorium.

The first is already on the CPAN.  It's simple, but I've found it pretty nice to work with, and I'm looking forward to writing more interesting plugins for it.  Basically, it creates an object that produces HTML widgets on demand.  I pass that object to TT2 so that our designer can build widgets that do the right thing without having to worry about escaping, element names (which HTML form widgets are kinds of INPUTs and which aren't?), and some other issues. It's pluggable and pretty easy to use, so I'm hoping that as time goes by I can easily write a "calendar" plugin or a "dropdown menu" plugin.  This happened large as a reaction to my inability to find a very simple way to enhance widgets on the JSAN.  I was hoping to find some generic framework that would let me use one interface to say, "this input is actually decorated with a calendar selector," but I was let down.

The Templatorium is really, really sketchy right now, but it's in production for some things, and I like it.  It's a mixin that provides any class tree with a template store.  Templates are stored in a file hierarchy that mirrors the class hierarchy.  Templates can be gotten at as simple, renderable objects. They can be gotten and rendered with one method, or a method to render them can be installed onto their class easily.  I have some plans for special templates that do things like use multiple template files to construct Email::MIME objects, or that return objects with methods that render the BLOCKs in the template.  It will be cooler when it's more developed, and that's when I'll release it.

I was going to use Sub::Installer for installing the template-rendering methods, but then I realized how it worked.  I knew that by default it stuck its methods into UNIVERSAL, but I blindly assumed that I could override that easily with "use Sub::Installer ()" or something.  Ha!  No such luck.

The idea of messing with UNIVERSAL is, I think, nearly always a bad one. Sometimes it's sort of forgivable: UNIVERSAL::require tries to fix a Perl design problem and UNIVERSAL::isa does the same.  Using it for something as luxurious as Sub::Installer just bugged me, though, and I kept muttering about how I should write a replacement.

So I did.

I had basically written one inside of Templatorium.pm, but last week I factored it out into its own module, made it significantly cooler, and uploaded it. Because its primary interface is imperative and not object-oriented, I called it Sub::Install.

It is, in a number of ways, more pleasant for me to use than Sub::Installer. It uses named arguments and can infer all but one of them.  It will find named subs via inheritance, determine the name of code references by inspecting the SV, and can be used to copy subs or methods from one package to another just as easily as to install new subs.  Before calling it "done," I threw in a little compatibility layer with the newly-obsoleted Sub::Installer.  It does everything that did, save the really creepy "install the result of building a sub from this string of Perl code" feature.  Eew!

I know it's silly, but what I found particularly amusing was that Sub::Install uses itself to implement its own import routine.

Tomorrow I go back to work, and I think that I'm going to be ready to do get back to it.  It's been a really relaxing vacation.  Maybe I'll be able to get some more work done on some of these projects, soon, too -- but maybe not.  I have two RPGs to run next week! 
