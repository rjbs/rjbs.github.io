---
layout: post
title : mssql and other horrors
date  : 2004-10-28T13:25:00Z

---
I've put up another MSSQL-related module, Time::Piece::MSSQL.  I've found myself writing very small modules that don't do much except make my life easier.  That's good stuff.  Like, I wrote an OO wrapper around Time::Duration that lets me deal with duration-in-seconds columns in my databases very easily. Schwern and Tony get beers when I see them next, for CDBI.

Anyway, MSSQL is a real pain.  It works so well most of the time, and then something stupid comes up and stabs me in the eye.  For example, most SQL dialects let you tack "LIMIT 10 OFFSET 10" to the end of a query to get the second ten rows that the query would produce.  MSSQL has only TOP, which gives you LIMIT without OFFSET.  Also, it gets stuck between SELECT and the column list, not at the end.  This means that I can't put it in Class::DBI's add_constructor or retrieve_from_sql methods.  Come on, guys!  What benefit was there to ignore the standard?  (I know it's Sybase's fault, but MS could have fixed it.)

Also: experts-exchange is a scummy site.  They get high Google ranks for questions I ask, but you have to register to get answers.

In the UK office, there's a guy who has the same title that I do (I think), and he's been here this week.  We've been working on rewriting an old system with TT2, Class::DBI, and CGI::Application.  It was going well, although slower than I wanted.  Today, though, he's gone back to the hotel, and isn't feeling well.

This may be due to lack of sleep.  Last night, we went out to dinner, and then to the Eastern State Penitentiary, where they do a haunted house sort of thing. It was OK, although it's not exactly my sort of thing.  I was reminded of The Suffering, though, which was amusing.  Better than the pen was dinner.  We went to the Apollo Grill, which is just about always great, and Trevor was treating, which made it even better.  To top that all off, they've gotten rid of the chocolate-chocolate cake abomination and restored to power the Mexican chocolate peanut butter mousse cake.

It was good.

Due to me being a slacker, we haven't had as many horror movies on hand as we should've, but that's OK.  Tonight we'll watch Return of the Living Dead 3, which I've seen and probably overhyped to Gloria.  Still, it should be fun.  We might have received some more movies by then, too, and may just vegetate in front of the tube.

Now, the biggest horror of all: back to work.

