---
layout: post
title : a review of the catalyst book
date  : 2008-02-17T02:28:55Z
tags  : ["book", "perl", "programming", "review"]
---
In the index for "Catalyst" book, you'll find no entry for model, controller, action, dispatch, or ActionClass.  These are some of the most fundamental concepts in Catalyst.

Many technical books suffer most because of those elements that are outside of the author's direct control: weird layouts, weird typographical conventions, and lousy indices.  Knowing that, I'd never base my criticism of a technical book on the failings of its index.  The failings of "Catalyst's" index, however, are telling about the failings of the book as a whole.

If it were only the index that lacked this information, it would be a minor problem.  Unfortunately, there really is no comprehensive explanation of any of these topics.  Though there is an entry for "View," it is explained in as little detail as the rest of these concepts.

Pages 6 and 7 provide about one paragraph each for the concepts of MVC, Model, View, and Controller.  From there on, the book focuses on implementing specific tasks without explaining much of the concepts that are used to do so.  Actions aren't so much explained as implied to be subroutines with attributes.  While nearly all of dispatch in a simple Catalyst application is determined by a few named and attribute-laden subroutines, these are not even presented in a bullet list, let alone explained in any detail.

Instead of starting with an explanation of how the fundamentals works, Rockway works through specific, practical examples of application implementation. These provide a demonstration of quite a few of the things that one can do with Catalyst, and occasionally some explanation of why it works.  The explanations are not systematic, however, and concepts are presented out of order rather than in a logical progression.  By the end of chapter two, the first chapter with any specific examples, the reader is installing and using Template Toolkit, SQLite, and DBIx::Class.  Views are defined as bits of code that produce output based on the content of the "stash" on page 20, but the stash itself is not given any explanation until five pages later.  This kind of confusing presentation prevails through most of the book, and is sometimes rendered more confusing by the inclusion of huge code samples, some of which dominate three consecutive pages.

Some concepts are well explained.  The section on chained dispatch was clear and concise, though basic actions and dispatch remained unexplained.  The section on the REST ActionClass was clear, and I found it to be the most interesting section of the book.

The book desperately needs reorganization, both by inclusion of an explanation of the fundamental concepts used in Catalyst design and by reordering the presentation of material to present concepts in a logical order with no long gaps between items that belong together.  Finally, a few segments could probably be dropped entirely, or at least moved further back into the book. Explanations of FormBuilder and BindLex, for example, might have been interesting and useful for the creation of serious web applications, but they are instead presented without much explanation in chapter three, where they just serve to further confuse the subject at hand.

The Catalyst::Manual documents seem to provide much of the same information, and at no cost.  They also include some of the concepts that are missing from the book.  Although I think a second edition of "Catalyst," or a second book on the topic, could be a very useful book to introduce new users to Catalyst, I don't think this book has much value beyond that of the existing free documentation. 
