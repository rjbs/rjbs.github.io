---
layout: post
title : "i've got facets on my tags"
date  : "2005-06-07T02:40:55Z"
tags  : ["perl", "programming", "rubric"]
---
Well, I made a bunch of little steps here and there toward 0.12, most of which relate to implementing facets.  It's been a real pain, mostly because I didn't realize how many places I rely on tags being plain old arrays.  I think that once I finish the horrible hack/spike of getting everything working again, I will re-refactor tags to use some kind of TagSet that is polymorphous, appearing as both an array and a hash.  For now, I've got facets basically working in 0.11_01, but there are enough bits that I had to leave unwired that it isn't worth releasing yet.  I need to finish some talking with Mark Stosberg about the way that D::FV isn't yet perfect in my eyes; I'll certainly be using it by 0.12, though, even if I just subclass it to get my changes in.

Shawn Sorichetti says he's got some HTTP::Server::Simple and Test::WWW::Mechanize tests working, too, which is awesome.  It will give me a little guide to writing more of my own.  Getting facets in place (and some other recent work) has made me keenly aware of how much I need automated testing of the WebApp portions.

I need to get those tests written, soon, so I can figure out when I've finished getting facets working! 
