---
layout: post
title : "our text editors, our secret masters"
date  : "2008-10-08T12:33:37Z"
tags  : ["editor", "programming"]
---
Ever wonder how much of our programming style is dictated by our desire to see the right pretty colors?  In Perl, I think it's a good bit.

For example, I know that the person who wrote this line wasn't using Vim's default Perl syntax:

    Account->q(accountid => $self->{accountid});

...because it would interpret `q(...)` as a non-interpolative string. Meanwhile, the guy who wrote this was:

    $logger->("setting account information to \%info");

...because syntax highlighting told him that `%info` was a variable, even though Perl doesn't interpolate hashes.

I always put spaces around my range operators, because otherwise in `1..2` the dots are different colors.

Other examples welcome. 
