---
layout: post
title : "a new zsh prompt"
date  : "2006-03-28T05:03:43Z"
tags  : ["zsh"]
---
I was looking into some `zsh` functionality today and decided it was time to
update my prompt.  Here's what I've come up with so far, with the help of jcap:

    export PS1="%~$(print '%{\e[1m%}%(!.%{\e[31m%}#.%{\e[32m%}$)%{\e[0m%}') "
    export RPS1="%m@%D{{ "{%" }}H%M%S}:%h"

This replaces my old prompt of:

    export PS1='%m!%n:%~%(!.#.$) '

I liked the UUCP-style identifier, but the super-reduced left hand side is
pretty slick, as is the one dot of color.  (I tried using the built-in `colors`
function, but it gave me grief.)  I'd like to tidy up the RPS1, but I'm not
sure how, yet.

