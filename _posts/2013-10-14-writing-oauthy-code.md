---
layout: post
title : "writing OAuthy code"
date  : "2013-10-14T14:56:19Z"
tags  : ["oauth", "perl", "programming"]
---
I've written a bunch of code that deals with APIs behind OAuth before.  I wrote
code for the Twitter API and for GitHub and for others.  I knew roughly what
happened when using OAuth, but in general everything was taken care of behind
the scenes.  Now as I work on furthering the control of my programmatic day
planner, I need to deal with web services that don't have pre-built Perl
libraries, and that means dealing with OAuth.  So far, it's been a big pain,
but I think it's been a pain that's helped me understand what I'm doing, so I
won't have to flail around as much next time.

I wanted to tackle Instapaper first.  I knew just what my goal automation would
look like, and I'd spent enough time bugging their support to get my API keys.
It seemed like the right place to start.  Unfortunately, I think it wasn't the
best service to start with.  It felt a bit like this:

> Hi!  Welcome to the Instapaper API!  For authentication and authorization,
> we use OAuth.  OAuth can be daunting, but don't worry!  There are a lot of
> libraries to help, because OAuth is a popular standard!
>
> By the way, we've made our own changes to OAuth so that it isn't quite
> standard anymore!

For one thing, they require xAuth.  Why?  I don't know, but they do.  I futzed
around trying to figure out how to use
[Net::OAuth](https://metacpan.org/module/Net%3A%3AOAuth).  It didn't work.
Part of seemed to be that no matter what I did, the xAuth parameters ended up
in the HTTP headers instead of the post body, and it wasn't easy to change the
request body because of the various layers in play.  I searched and searched
and found what seemed like it would be a bit help:
[LWP::Authen::OAuth](https://metacpan.org/module/LWP%3A%3AAuthen%3A%3AOAuth).

It looked like just what I wanted.  It would let me work with normal web
requests using an API that I knew, but it would sign things transparently.  I
bodged together this program:

    use JSON;
    use LWP::Authen::OAuth;

    my $c_key     = 'my-consumer-key';
    my $c_secret  = 'my-consumer-secret';

    my $ua = LWP::Authen::OAuth->new(oauth_consumer_secret => $c_secret);

    my $r = $ua->post(
      'https://www.instapaper.com/api/1/oauth/access_token', [
        x_auth_username => 'my-instapaper-username',
        x_auth_password => 'my-instapaper-password',
        x_auth_mode     => 'client_auth',

        oauth_consumer_key    => $c_key,
        oauth_consumer_secret => $c_secret,
      ],
    );

    print $r->as_string;

This program spits out a query string with my token and token secret!  Great,
from there I can get to work writing requests that actually talk to the API!
For example, I can list my bookmarks:

    use JSON;
    use LWP::Authen::OAuth;

    my $c_key     = 'my-consumer-key';
    my $c_secret  = 'my-consumer-secret';

    my $ua = LWP::Authen::OAuth->new(
     oauth_consumer_secret => $c_secret,
     oauth_token           => 'my-token',
     oauth_token_secret    => 'my-token-secret',
    );

    my $r = $ua->post(
      'https://www.instapaper.com/api/1/bookmarks/list',
      [
        limit => 200,
        oauth_consumer_key    => $c_key,
      ],
    );

    my $JSON = JSON->new;
    my @bookmarks = sort {; $a->{time} <=> $b->{time} }
                    grep {; $_->{type} eq 'bookmark' }
                    @{ $JSON->decode($r->decoded_content) };

    for my $bookmark (@bookmarks) {
      say "$bookmark->{time} - $bookmark->{title}";
      say "  " . $JSON->encode($bookmark);
    }

Great!  With this done, I can get my list of bookmarks and give myself points
for reading stuff that I wanted to read, and that's a big success right there.
I mentioned my happiness about this in `#net-twitter`, where the OAuth experts
I know hang out.  Marc Mims said, basically, "That looks fine, except that it's
got a big glaring bug in how it handles requests."  URIs and OAuth encode
things differently, so once you're outside of ASCII (and maybe before then),
things break down.  I also think there might be other issues you run into,
based on later experience.  I'm not sure LWP::Authen::OAuth can be entirely
salvaged for general use, but I haven't tried much, and I'd be the wrong person
to figure it out, anyway.

Still, I was feeling pretty good!  It was time, I decided, to go for my next
target.  Unfortunately, my next target was Feedly, and they've been sitting on
my API key request for quite a while.  They seem to be doing this for just
about everybody.  Why do they need to scrutinize my API key anyway?  I'm a
paid lifetime account.  Just give me the darn keys!

Well, fine.  I couldn't write my Feedly automation, so I moved on to my third
and, currently, final target: [Withings](http://withings.com/en/scales).  I
wanted code to get my last few weight measurements from my Withings scale.  I
pulled up their API and got to work.

The first roadblock I hit was that I needed to know my numeric user id, which
they really don't put anyplace you can find it.  I had to dig for about half an
hour before I found it embedded in a URL on one of their legacy UI pages.
Yeesh!

After that, though, things went from tedious to confusing.  I was getting
directed to a URL that returned a bodyless 500 response.  I'd get complaints
about bogus signatures.  I couldn't figure out how to get token data out of
LWP::Authen::OAuth.  I decided to bite the bullet and figure out what to do
with Net::OAuth::Client.

As a side note:  Net::OAuth says "you should probably use Net::OAuth::Client,"
and is documented in terms of it.  Net::OAuth::Client says, "Net::OAuth::Client
is alpha code. The rest of Net::OAuth is quite stable but this particular
module is new, and is under-documented and under-tested."  The other module I
ended up needing to use directly, Net::OAuth::AccessToken, has the same
warning.  It was a little worrying.

This is how OAuth works: first, I'd need to make a client and use it to get a
request token; second, I'd need to get the token approved by the user (me) and
turned into an access token; finally, I'd use that token to make my actual
requests.  While at first, writing for Instapaper, I found Net::OAuth to feel
overwhelming and weird, I ended up liking it much better when working on the
Withings stuff.  First, code to get the token:

    use Data::Dumper;
    use JSON 2;
    use Net::OAuth::Client;

    my $userid  = 'my-hard-to-find-user-id';
    my $api_key = 'my-consumer-key';
    my $secret  = 'my-consumer-secret';

    my $session = sub {
      state %session;
      my $key = shift;
      return $session{$key} unless @_;
      $session{$key} = shift;
    };

    my $client = Net::OAuth::Client->new(
      $api_key,
      $secret,
      site               => 'https://oauth.withings.com/',
      request_token_path => '/account/request_token',
      authorize_path     => '/account/authorize',
      access_token_path  => '/account/access_token',
      callback           => 'oob',
      session            => $session,
    );

    say $client->authorize_url; # <-- will have to go visit in browser

    my $token = <STDIN>;
    chomp $token;

    my $verifier = <STDIN>;
    chomp $verifier;

    my $access_token = $client->get_access_token($token, $verifier);

    say "token : " . $access_token->token;
    say "secret: " . $access_token->token_secret;

The thing that had me confused the longest was that coderef in `$session`.  Why
do I need it?  Under the hood, it looks optional, and it can be, but it's
easier to just provide it.  I'll come back to that.  Here's how you use the
program:

When you run the program, `authorize_url` generates a new URL that can be
visited to authorize a token to be used for future requests.  The URL is
printed to the screen, and the user can open the URL in a browser.  From there,
the user should be prompted to authorize access for the requesting application
(as authenticated by the consumer id and secret).  The website then redirects
the user to the callback URL.  I gave "oob" which is obviously junk.  That's
okay because the URL will sit in my browser's address bar and I can copy out
two of its query parameters: the token and the verifier.  I paste these into
the silently waiting Perl program.  (I could've printed a prompt, but I
didn't.)

Now that the token is approved for access, we can get an "access token."  What?
Well, the `get_access_token` method returns a Net::OAuth::AccessToken, which
we'll use something like an LWP::UserAgent to perform requests against the API.
I'll come back to how to *use* that a little later.  For now, let's get back to
the `$session` callback!

To use a token, you need to have both the token itself *and* the token secret.
They're both generated during the call to `authorize_url`, but only the token's
value is exposed.  The secret is never shared.  It is available, though, if
you've set up a session callback to save and retrieve values.  (The session
callback is expected to behave sort of like CGI's venerable `param` routine.)
This is one of those places where the API seems tortured to me, but I'm putting
my doubts aside because (a) I don't want to rewrite this library and (b) I
don't know enough about the problem space to know whether my feeling is
warranted.

Anyway, at the end of this program we spit out the token and token secret and
we exit.  We *could* instead start making requests, but I always wanted to have
two programs for this.  It helps me ensure that I've saved the right data for
future use, rather than lucking out by getting the program into the right
state.  After all, I'm only going to get a fresh auth token the first time.
Every other time, I'll be running from my saved credentials.

My program to actually fetch my Withings measurements looks like this:

    use Data::Dumper;
    use JSON 2;
    use Net::OAuth::Client;

    my $userid  = 'my-hard-to-find-user-id';
    my $api_key = 'my-consumer-key';
    my $secret  = 'my-consumer-secret';

    my $session = sub {
      state %session;
      my $key = shift;
      return $session{$key} unless @_;
      $session{$key} = shift;
    };

    my $client = Net::OAuth::Client->new(
      $api_key,
      $secret,
      site               => 'https://oauth.withings.com/',
      request_token_path => '/account/request_token',
      authorize_path     => '/account/authorize',
      access_token_path  => '/account/access_token',
      callback           => 'oob',
      session            => $session,
    );

    my $token   = 'token-from-previous-program';
    my $tsecret = 'token-secret-from-previous-program';

    my $access_token = Net::OAuth::AccessToken->new(
      client => $client,
      token  => $token,
      token_secret => $tsecret,
    );

    my $month_ago = $^T - 30 * 86_400;
    my $res = $access_token->get(
      "http://wbsapi.withings.net/measure"
      . "?action=getmeas&startdate=$month_ago&userid=$userid"
    );

    my $payload = JSON->new->decode($res->decoded_content);
    my @groups =
      sort { $a->{date} <=> $b->{date} } @{ $payload->{body}{measuregrps} };

    for my $group (@groups) {
      my $when   = localtime $group->{date};
      my ($meas) = grep { $_->{type} == 1 } @{ $group->{measures} };

      unless ($meas) { warn "no weight on $when!\n"; next }
      my $kg = $meas->{value} * (10 ** $meas->{unit});
      my $lb = $kg * 2.2046226;
      printf "%s : %5.2f lbs\n", $when, $lb;
    }

This starts to look good, to me.  I make an OAuth client (the code here is
identical to that in the previous program) and then make an AccessToken.
Remember, that's the thing that I use like a LWP::UserAgent.  Here, once I've
got the AccessToken, I `get` a resource and from there it's just decoding JSON
and mucking about with the result.  (The data provided from the Withings
measurements API is a bit weird, but not bad.  It's certainly not as weird as
many other data I've been given by other APIs!)

I may even go back to update my Instapaper code to use Net::OAuth, if I get a
burst of energy.  After all, the thing that gave me trouble was dealing with
xAuth using Net::OAuth.  Now that I have my token, it should just work… right?
We'll see.

