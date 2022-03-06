---
layout: post
title : "rcn.com's selfcare center needs help"
date  : "2009-01-30T15:45:29Z"
tags  : ["javascript", "stupid"]
---
Some time ago I wrote [an entry about RCN's dumb password
questions]({% post_url 2007-12-01-password-security-questions %}).  Today, I got to deal
with this crap again.  I tried to reset my password and saw:

    Q: What is the account holder\'s favorite food?

(Yes, that backslash was in their text.)

I filled it out with the answer I had on file -- because I knew I'd never keep
one answer for that for long -- and it sent me back to the login screen *with
no error message*.  I went to the next question, and it did the same.  Also
amusing?  The answers were case-sensitive, even though they'd been given over
the phone.  Also, they'd been entered incorrectly.

I found this out by phoning in.  I was assigned a number of random passwords
that didn't work until I said, "just make it foobar123" and logged in.

Then I spent an hour trying to change it.  In Firefox and Safari, it just
failed.  See, the submit button on the form is JavaScript.  No JS, no updates.
If there's a pre-submit validation error, the error is displayed... as long
as you're using MSIE.  I had to change my validation questions (for no clear
reason, possibly corrupt data at their end).  Then I couldn't pick a new
password, it kept saying it was invalid.

Well, let's review.  Their site says:

> Please enter a 6 - 10 character password including at least one number
> and one letter. Use of a special character is recommended but not required.
> The following are valid special characters: `!@;#$^&*`.

The validation code, on the other hand, says:

    var r_password_re = /^[a-zA-Z0-9\!\@\#\$\%\^\&\*]{6,10}$/;
    var r_password_ok = r_password_re.exec(cpniPassword1.value);
    
    var r_password2_re = /(\d){1}/;
    var r_password2_ok = r_password2_re.exec(cpniPassword1.value);

    var r_password3_re = /[a-zA-Z]{1}/i;
    var r_password3_ok = r_password3_re.exec(cpniPassword1.value);

    var r_password_confirm_re = /[a-zA-Z0-9\!\@\#\$\%\^\&\*]{6,10}/;
    var r_password_confirm_ok = r_password_confirm_re.exec(cpniPassword2.value);

Aaauuuuuugh!

**BONUS FAIL**: After I saved this, I saw I had new mail.  RCN helpfully sent me my new password in plaintext email.
