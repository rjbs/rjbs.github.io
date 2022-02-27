---
layout: post
title : "my love/hate relationship with javascript"
date  : "2004-08-30T19:43:00Z"
tags  : ["code", "javascript"]
---
Last week, I got TT2, CGI::Application, Class::DBI, and Number::Tolerant all engaging in wonderful harmony.  It turned out, by the way, that I didn't need any kind of magic trigger to catch strings and convert them before they hit the database.  It's more like this:  my class has some fields that are inflated into tolerance objects.  I can assign tolerances to them, and their stringification is stored to the database.  When Class::DBI finds that stringification, it knows how to turn it back into an object.  The beauty is that I can just assign a stringification directly.  When I access it, I get the "inflated" version back.  I had thought I needed to inflate it before assigning, but I was wrong.  All I needed to to, to preserve my sanity, was to put a constraint on the column that only tolerances, valid strings, and undef were allowed to be set.

That's not today's accomplishment, though, it's last week's.

Today, I was just polishing off the main input form for this application.  I'm hoping to have the delivery meeting tomorrow.  Basically all of the fields are either free text, numbers, or tolerances.  A number of the text fields should be multiple choice, but in all cases those multiple choices are just guidelines, and users may need to enter one-off values.  This is a stupidly common scenario, and is the reason that combo boxes exist.

Of course, they don't exist in HTML forms.  I suppose that since I've gotten through ten years of HTML authoring without really hitting this wall, it's not as big a need as I thought, but it's still pretty obnoxious.  All the JavaScript combo boxes I found out on the web stank.  Most of them were text fields with dropdowns next to them.  Picking from the dropdown sets the text field.  Ugly!  I know I could've done some kind of crazy box-drawing to simulate a full combo box, but I can't stand the look of box-drawn widgets. They remind me that things are a hack.  So, I wrote my own little combo box.

It's nothing fancy.  There's a dropdown box with an "(other)" selection.  When that's selected, the box replaces itself with a text-entry field.  If that field is left blank, the dropdown comes back.  It works on MSIE, it works in Gecko, it works with WebKit, and it plugs nicely into my goofy "make a select element" code at work.

So, that's great!

I hesitate to admit that this took hours, mostly because MSIE is completely messed up.  Everything worked everywhere but Win32 MSIE, and I had to rewrite quite a lot of code to make it work, adding something like 400 bytes to the script.  (That's about 30% growth.)  Mostly, I had problems because setAttribute didn't seem to want to set the "name" attribute on form inputs. I'm told it works, but it didn't work for me.  Assigning to the "name" attribute directly, though, works just fine.

So, that done and plugged into the application, I'm finished with work for the day.  Have a free combo box:
<pre><code>	http://rjbs.manxome.org/hacks/js/combo.html
</code></pre>

