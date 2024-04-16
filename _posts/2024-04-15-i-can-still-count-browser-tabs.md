---
layout: post
title : "I can still count browser tabs"
date  : "2024-04-15T20:24:36Z"
tags  : ["programming"]
---
A couple years ago, I posted about [making a Prometheus exporter for my Chrome
tab count](https://rjbs.cloud/blog/2021/08/i-closed-a-lot-of-browser-tabs/).  I
had fun doing it, but unfortunately it made it onto Hacker News, which as
always got a fair bit of missing-the-point.  So it goes.

Yesterday, for a mixture of principled reasons and procrastinatory ones, I
switched from Chrome to Firefox.  Mostly this was easy.  I upgraded Firefox,
installed some extensions, ported over my open tabs, and that was about it.
But I still wanted my tab graph, which surprisingly I have kept using.  Firefox
*is* AppleScriptable, but its tiny set of classes doesn't include anything
useful for tab counting.  I resorted to parsing the session state file.

This is a trick others have done, but now I have done it too.

```perl
use v5.36.0;

use Compress::LZ4;
use JSON::MaybeXS;
use Path::Tiny;

# I should not really hardcode the profile path.  But I don't want to look at
# them all, because it seems sometimes ancient ones linger.  I'll sort it out
# if this ever breaks. -- rjbs, 2024-04-14
my $profiles_root = path('/Users/rjbs/Library/Application Support/Firefox/Profiles');
my $backups_dir   = $profiles_root->child('xyzzy.default/sessionstore-backups');
my $backup_file   = $backups_dir->child('recovery.jsonlz4');

# This is some nonsense container data.  I learned this trick from this blog
# post's code: https://alexandre.deverteuil.net/post/firefox-tabs-analysis/
my $bytes = $backup_file->slurp;
substr $bytes, 0, 8, '';

my $json  = decompress($bytes);
my $data  = decode_json($json);

my $tab_count = 0;
my $window_count = 0;

for my $window ($data->{windows}->@*) {
  $window_count++;
  for my $tab ($window->{tabs}->@*) {
    # I don't use this, but just in case, now I have it.  Each tab's
    # "entries" is history entries for the tab, and the last one is the
    # currently active tab data.
    my $live = $tab->{entries}[-1]; # $live->{url} # <-- real url
    $tab_count++;
  }
}

say "firefox_open_windows $window_count";
say "firefox_open_tabs $tab_count";
```

This program just spits out two lines of Prometheus-formatted data.  Right now,
it's this:

```
firefox_open_windows 10
firefox_open_tabs 47
```

I could put this in a little web server running on my laptop, but I've mostly
avoided setting up any always-running daemons on my Mac.  I don't know why, it
just feels like one more hassle.  So, instead, I weirdly embedded this in my
[Hammerspoon](https://www.hammerspoon.org/) init:

```lua
ffMetrics = ""

function ffMakeMetricsTask ()
  return hs.task.new(
    "/Users/rjbs/code/hub/rjbs-misc/firefox-prometheus-metrics",
    function (exitCode, stdOut, stdErr)
      ffMetrics = stdOut
    end
  )
end

ffMetricsTimer = hs.timer.doEvery(60, function ()
  if not (ffMetricsTask and ffMetricsTask:isRunning()) then
    ffMetricsTask = ffMakeMetricsTask():start()
  end
end)
```

Then, in my existing metrics HTTP server run in Hammerspoon, I concatenate
`ffMetrics` into the result.

I am pleased with this solution.  It is stupid and works, which I often find a
very satisfying combination.
