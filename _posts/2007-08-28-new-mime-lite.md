---
layout: post
title : "new mime::lite"
date  : "2007-08-28T12:17:18Z"
tags  : ["perl", "programming"]
---
MIME::Lite is, in my opinion, the worst of the popular email object modules. It's buggy, has a lousy interface, and just does awful things.  I'd go so far as to say that the number one mistake I see in new email modules is a reliance on MIME::Lite instead of Mail::Message or Email::MIME.

That said, I've just released the first non-developer release of MIME::Lite in over four years!  I get a nightly report of bugs in all (or much) of the CPAN's email code, and nearly a third of those have long been bugs in MIME::Lite. I've closed a number of them already, and will try to close some more.  So far, I think that nothing much should break, but it's hard to say.  The tests for MIME::Lite::HTML now fail, but only because it relies on receiving exactly identical output, and the location of the MIME-Version header has changed. (That's another lousy module, by the way, which was for a long time the only game in town.  It's finally been superseded by Email::MIME::CreateHTML.)

Please report problems with this new release of MIME::Lite to its bug tracker at rt.cpan.org. 
