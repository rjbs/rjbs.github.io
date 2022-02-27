---
layout: post
title : sqlite: totally indestructable
date  : 2007-04-19T01:00:08Z
tags  : ["perl", "programming"]
---
Today, I saw some SQLite failures occur when a process had consumed all its
open filehandles with session databases.  My first thought was that there was a
circular reference preventing destruction.  After an almost comical amount of
struggle to get Devel::Cycle to work, and then an actually comical amount of
struggle to get Devel::FindRef to not choke on DBI connections, the problem
turned up.  I'm pretty sure that I wrote the offending line.  I feel fairly
silly about it now, since it is a pretty clear one-line red flag.  This is a
close approximation:

    $m->{_timer} = HTML::Mason::Timer->new(m => $m);

Ha!

Unfortunately, while this was clearly a good bug to fix, it didn't solve the
problem.  The error log kept showing "closing dbh with active statement
handles" even though everything relevant seemed to be calling `$sth->finish`.
Finally, this helped:

    sub DESTROY {
      my ($self) = @_;
      $_->finish for $self->{dbh}->ChildHandles; # This had to be added.
      $self->{dbh}->disconnect;
    }

Yow!  I wonder whether there are a huge pile of people being affected by this.
Maybe not, since using SQLite for sessions required a bit of a hack.

