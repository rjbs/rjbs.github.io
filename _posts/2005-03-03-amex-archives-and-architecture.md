---
layout: post
title : "amex, archives, and architecture"
date  : "2005-03-03T18:10:00Z"
---
I really like American Express.  I see people posting their "AMEX SUX" pages, but I don't get it.  They've never done anything but treat me right.  Sure, they make a mistake here or there, but they're just fine by me.

Around about a month ago, I found some bogus charges in my statement.  I called American Express and told them, and they put a hold on the charges and started an investigation.  I asked whether I should get my card replaced, and they said it was probably just a mistake.  A few weeks later, I saw more charges, which they cleared.  I think it was the guy's first day; when he tried to transfer me to someone so I could have a new card sent to me, I got disconnected.

Later, when more charges showed up, I called and had those charges cleared, and a new card sent to me.  The CSR tried to sell me on switching to a better rewards plan, and I declined.  "Well, Mister Signes," she said, "I see here that you spend x-thousand y-hundred and fifty two dollars on groceries last year.  You know, if you'd had this rewards plan, which costs twenty-five dollars, you would have received the equivalent of sixty dollars worth of rewards points -- and that's for just groceries."

I'm not a fan of giant corporations having all my data sitting there, indexed to my SSN, but this was good!  She gave me the kind of analysis that helped me make a decision that I felt good about, and that I would've made if I had the analysis tools myself.  (Hey, it'd be nice if they gave me access to those kinds of tools, so I could see which programs would help me the most.)

I also let them give me some other bells and whistles, similarly informed.  The benefits for membership are nice.  For one small annual fee, I basically have a corporation watching my back in case I'm lost, mugged, robbed, swindled, or just broke.  Membership has its privileges.

I didn't come here to sell you on AmEx, though.  I came here to sell you on not using WinZip, ever.  This is my personal "WINZIP SUX" page.  I have two reasons.

The first may be a Windows problem: when I try to save a tarball, I always find WinZip opening archive.tar.tar instead of archive.tar.gz, which obviously doesn't work.  I have to save and then open it, which isn't the worst thing ever, but... come on!

The second error has cost me an hour or two, and is therefore the more awful. I had some bugs to fix in my CGI::Upload usage, today.  First of all, ActiveState currently distribuets the REALLY broken CGI-Upload-1.04, which is just ... bad.  It calls File::Basename::parsefile_set_fstype with a coderef, causing it to Not Work.  I downloaded the tarball of the dist to try to install it by hand, and the tests failed.  It kept putting \r\n into received files, even though it should have only been \n.  Finally, I found the problem: the tests and the code were fine; WinZip had "fixed" line endings when extracting. See, it knows that "tar" files are from unix, so its default behavior is to "fix" CRLFs.  Unbelievable!

At least I did uncover one small (but important) bug in CGI::Upload.  I sent it to the RT, but it looks like the RT has some ancient bugs sitting in it.

I finished all that nonsense before lunch, and Jay and I headed to Tulum for tacos.  I got a toasted almond veggie taco, and it was pretty good.  The people at the next table were talking about urban planning and renewal, and I interrupted to suggest they have a look at Christopher Alexander's work. Explaining the basis of "A Pattern Language," I was reminded how much I enjoyed it.  I should think about picking up A Timeless Way of Building, or How Buildings Learn.

First, though, I need to finish Love and Responsibility.

