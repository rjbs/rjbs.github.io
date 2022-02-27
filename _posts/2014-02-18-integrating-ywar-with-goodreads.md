---
layout: post
title : integrating Ywar with Goodreads
date  : 2014-02-18T01:37:51Z
tags  : ["perl", "productivity", "programming", "reading", "ywar"]
---
[Ywar](https://github.com/rjbs/Ywar) is a little piece of productivity software
that I wrote.  I've [written about Ywar
before](http://rjbs.manxome.org/rubric/entries/tags/productivity), so I won't
rehash it much.  The idea is that I use [The Daily Practice](https://tdp.me/)
to track whether I'm doing things that I've decided to do.  I track a lot of
these things already, and Ywar connects up my existing tracking with The Daily
Practice so that I don't have to do more work on top of the work I'm already
doing.  In other words, it's an attempt to make my data work for me, rather
than just sit there.

For quite a while now, only a few of my TDP goals needed manual entry, and most
of them could clearly be automated.  It wasn't clear, though, how to automate
my "keep reading books" tasks.  I knew Goodreads existed, but it seemed like
using Goodreads would be just as much work as using TDP.  Either way, I have to
go to a site and click something for each book.  I kept thinking about how to
make my reading goals more motivating and more interesting, but nothing
occurred to me until this weekend.

I was thinking about how it's hard for me to tell how long it will take me to
finish a book.  Lately, I'm taking an age to read *anything*.  Catch-22 is
about 500 pages and I've been working on it since January 2.  Should I be able
to do more?  I'm not sure.  My current reading goals have been very vague.  I
thought of them as, "spend 'enough time' reading a book from each shelf once
every five days."  This makes it easy to decide sloppily whether I've read
enough, but it's always an all-at-once decision.

In Goodreads, I can keep track of my progress over several days.  That means I
can change my goal to "get at least 50 pages read a week."  There's no fuzzy
logic there, just simple page count.  It might not be right for every book, but
I can adjust it as needed.  If it's too low or high, I can fix that too.  It
seemed like a marked improvement, and it also gave me a reason to consider
looking at Goodreads a bit more, where I've seen some interesting
recommendations.

With my mind made up, all I had to do was write the code.  Almost every time
that I've wanted to write code to talk to the developer API of a service that's
primarily addressed *not* via the API, it's been sort of a mess that's usable,
but weird and a little annoying.  So it was with Goodreads.  The [code for my
Goodreads/Ywar
integration](https://github.com/rjbs/Ywar/blob/master/lib/Ywar/Observer/Goodreads.pm)
is on GitHub.  Below is just some of the weirdness I got to encounter.

This request gets the books on my "currently reading" shelf as XML.

    sprintf 'https://www.goodreads.com/review/list?format=xml&v=2&id=%s&key=%s&shelf=currently-reading',
      $user_id,
      $api_key;

The resource is `review/list` because it's a list of reviews.  Go figure!  That
doesn't mean that there are actually any reivews, though.  In Goodreads, a
review represents the intersection of a user and a book.  If it's on your
shelf, it has a review.  If there's no review in the usual sense of the word,
it just means that the review's body is empty.

The XML document that you get in reply has a little bit of uninteresting data,
followed by a `<reviews>` element that contains all the reviews for the page of
results.  Here's a review:

    <review>
      <id>774476430</id>
      <book>
        <id type="integer">168668</id>
        <isbn>0684833395</isbn>
        <isbn13>9780684833392</isbn13>
        <text_reviews_count type="integer">7875</text_reviews_count>
        <title>Catch-22 (Catch-22, #1)</title>
        <image_url>https://d202m5krfqbpi5.cloudfront.net/books/1359882576m/168668.jpg</image_url>
        <small_image_url>https://d202m5krfqbpi5.cloudfront.net/books/1359882576s/168668.jpg</small_image_url>
        <link>https://www.goodreads.com/book/show/168668.Catch_22</link>
        <num_pages>463</num_pages>
        <format></format>
        <edition_information/>
        <publisher>Simon &amp; Schuster </publisher>
        <publication_day>4</publication_day>
        <publication_year>2004</publication_year>
        <publication_month>9</publication_month>
        <average_rating>3.96</average_rating>
        <ratings_count>355544</ratings_count>
        <description>...omitted by rjbs...</description>
        <authors>
          <author>
            <id>3167</id>
            <name>Joseph Heller</name>
            <image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/authors/1197308614p5/3167.jpg]]></image_url>
            <small_image_url><![CDATA[https://d202m5krfqbpi5.cloudfront.net/authors/1197308614p2/3167.jpg]]></small_image_url>
            <link><![CDATA[https://www.goodreads.com/author/show/3167.Joseph_Heller]]></link>
            <average_rating>3.94</average_rating>
            <ratings_count>368314</ratings_count>
            <text_reviews_count>9588</text_reviews_count>
          </author>
        </authors>
        <published>2004</published>
      </book>

      <rating>5</rating>
      <votes>0</votes>
      <spoiler_flag>false</spoiler_flag>
      <spoilers_state>none</spoilers_state>
      <shelves>
        <shelf name="currently-reading" />
        <shelf name="literature" />
      </shelves>
      <recommended_for></recommended_for>
      <recommended_by></recommended_by>
      <started_at>Thu Jan 02 17:04:20 -0800 2014</started_at>
      <read_at></read_at>
      <date_added>Tue Nov 26 08:37:09 -0800 2013</date_added>
      <date_updated>Thu Jan 02 17:04:20 -0800 2014</date_updated>
      <read_count></read_count>
      <body>

      </body>
      <comments_count>review_comments_count</comments_count>
      <url><![CDATA[https://www.goodreads.com/review/show/774476430]]></url>
      <link><![CDATA[https://www.goodreads.com/review/show/774476430]]></link>
      <owned>0</owned>
    </review>

It's XML.  It's not really that bad, either.  One problem, though, was that it
didn't include my current position.  My current position in the book is not a
function of my review, but of my status updates.  I'll need to get those, too.

I was intrigued, though by the `format=xml` in the URL.  Maybe I could get it
as JSON!  I tried, and I got this:

      [...,
      {"id":774476430,"isbn":"0684833395","isbn13":"9780684833392",
      "shelf":"currently-reading","updated_at":"2014-01-02T17:04:20-08:00"}
      ...]

Well!  That's certainly briefer.  It's also, obviously, missing a *ton* of
data.  It doesn't include book titles, total page count, or any shelves other
than the one that I requested.  That is: note that in the XML you can see that
the book is on both `currently-reading` and `literature`.  In the JSON, only
`currently-reading` is listed.  Still, it turns out that this is all I need, so
it's all I fetch.  I get the JSON contents of my books in progress, and then
once I have them, I can get each review in full from this resource:

      sprintf 'https://www.goodreads.com/review/show.xml?key=%s&id=%s',
        $api_key,
        $review_id;

Why does that help?  I mean, what I got in the first request was a review, too,
right?  Well, yes, but when you get the review via `review/show.xml`, you get a
very slightly different set of data.  In fact, almost the only difference is
the inclusion of `comment` and `user_status` items.  It's a bit frustrating,
because in both cases you're getting a `review` element, and their ids are the
same, but their contents are not.  It makes it a bit less straightforward to
write an XML-to-object mapper.

When I get review 774476430, which is my copy of Catch-22, this is the first
user status in the review:

      <user_status>
        <chapter type="integer" nil="true"/>
        <comments_count type="integer">0</comments_count>
        <created_at type="datetime">2014-02-16T12:47:14+00:00</created_at>
        <id type="integer">39382590</id>
        <last_comment_at type="datetime" nil="true"/>
        <note_updated_at type="datetime" nil="true"/>
        <note_uri nil="true"/>
        <page type="integer" nil="true"/>
        <percent type="integer">68</percent>
        <ratings_count type="integer">0</ratings_count>
        <updated_at type="datetime">2014-02-16T12:47:14+00:00</updated_at>
        <work_id type="integer">814330</work_id>
        <body/>
      </user_status>

By the way, the XML you get back isn't nicely indented as above.  It's not
entirely unindented, either.  It's sometimes properly indented and sometimes
just weird.  I think I'd be less weirded out if it just stuck to being a long
string of XML with indentation at all, but mostly libxml2 reads the XML, not
me, so I should shut up.

The important things above are the `page` and `percent` items.  They tell me
how far through the book I am as of that status update.  If I gave a page
number when updating, the `page` element won't have "true" as its `nil`
attribute, and the text content of the element will be a number.  If I gave a
percentage when updatng, as I did above, you get what you see above.  I can
convert a percentage to a page count by using the `num_pages` found on the book
record.  The whole book record is present in the review, as it was the first
time, so I just get all the data I need this time via XML.

Actually, though, there's a reason to get the XML the first time.  Each time
that I do this check, it's for in-progress books on a certain shelf.  If I
start by getting the XML, I can then proceed only with books that are also on
the right shelf, like, above, "literature."  Although you can specify multiple
shelves to the `review/list` endpoint, only one of them is respected.  If there
are four books on my "currently reading" shelf, but only one is "literature,"
then by getting XML first, I'll do two queries instead of five.

So I guess I should go back and start with the XML.

By the way, did you notice that `review/list` takes a query parameter called
format, which can be either XML or JSON, and maybe other things... but that
`review/show.xml` includes the type in the path?  You can't change the `xml` to
`json` and get JSON.  You just get a 404 instead.

In the end, making Ywar get data from Goodreads wasn't so bad.  It had some
annoying moments, as is often the case when using a mostly-browser-based web
service's API.  It made me finally use XML::LibXML for some real work, and
hopefully it will lead to me using Goodreads more and getting some value out of
that.

