---
layout: post
title : PTS 2019: Testing PAUSE by Hand (5/5)
date  : 2019-04-30T00:47:27Z
tags  : ["perl", "programming"]
---
Writing tests is great, but sometimes you're not sure what you're looking for.
Maybe you don't know what will happen *at all* if you try something new.  Maybe
you know it fails, but not how or where.  This is the kind of thing where
normally I'd fire up the perl debugger.  The debugger is too often ignored by
programmers who could solve problems a lot faster by using it.  I love adding
print statements as much as the next person -- maybe more -- but the debugger
is a specialized tool that is worth bringing out now and then.

That said, I am not here to advocate that you attach the debugger to the PAUSE
indexer.  It's just that tools for investigating are sometimes more appropriate
than tools for asserting.  So, I built one.

Actually, [I built it in
2015](https://github.com/andk/pause/commit/2f316987dcc1a3eb43c96a749e789f49fdff4e85),
but I've only used it sparingly until this week.  With the improvements I made
to my module faking code, it became much, much easier to use this tool to
investigate hypothetical scenarios.

It used to work like this:

      $ ./one-off-utils/build-fresh-cpan \
        Some-Tarball-1.23.tar.gz \
        Other-Thing-2.5.tar.gz

You'd provide it a bunch of pre-built tarballs and it would make a new
TestPAUSE, index the tarballs, and drop you into a shell.  Ugh!  I mean, it was
useful, but we're back to a world where we have to write a program to generate
fake data.  Instead, I updated the program to take a list of instructions of
what to do.  For example:

      $ ./one-off-utils/build-fresh-cpan \
        fake:RJBS:Some-Cool-Dist-1.234.tar.gz \
        fake:ANDK:CPAN-Client-3.000.tar.gz \
        file:RJBS:~/tmp/perl-5.32.0.tar.gz \
        index \
        perl:ANDK:'{name=>"Cool::Thing",version=>1,packages=>["Cool::Stuff"]}'

This does what you might expect:  it fakes up two tarballs and uploads those.
Then it runs the indexer.  Then it makes another fake with the given snippet of
Perl.  Finally, it drops you into a shell.  The shell might look like this:

    /private/var/folders/tp/xbk5yqfj7vv86jjcgk_cp4wh0000gq/T/wZwYj2Cgp0$ ls -l
    total 4
    drwxr-xr-x 5 rjbs staff  160 Apr 29 12:25 Maildir/
    drwxr-xr-x 4 rjbs staff  128 Apr 29 12:25 cpan/
    drwxr-xr-x 4 rjbs staff  128 Apr 29 12:25 db/
    drwxr-xr-x 5 rjbs staff  160 Apr 29 12:25 git/
    -rw-r--r-- 1 rjbs staff 3086 Apr 29 12:25 pause.log
    drwxr-xr-x 3 rjbs staff   96 Apr 29 12:25 run/

`Maildir` contains all the mail that PAUSE would've sent out.

`cpan` is the CPAN that would be published, so you can find the tarballs and
the index files there.

`db` has SQLite databases storing all the PAUSE data.

`git` is a git index storing every state that the index files have ever had.

`run` is not interesting, and stores the lockfile for the indexer.

Then there's `pause.log`.  As you might guess, it's the PAUSE log file. We'll
come back to that below.

Anyway, you can probably imagine that this is a pretty useful collection of
data for investigation!  You can very quickly answer questions like "if the
system is in state X and events A, B, C happen, what's the new state and why?"
In fact, we had quite a few questions that we'd put off answering in the past
because they were just too tedious to sort out.  Now they've become a matter of
writing a few lines at the command prompt.

Of course, the command prompt can be a tedious place to write what is,
effectively, a program, so `build-fresh-cpan` can also get instructions from a
file.  For example, I can write instructions to the file `test.pause` and then
run `./one-off-tools/build-fresh-cpan cmdprog:test.pause`.  Here's what a
program might look:

      # First, we import some boring stuff.
      fake:RJBS:Some-Cool-Dist-1.234.tar.gz
      fake:ANDK:CPAN-Client-3.000.tar.gz

      index

      # Then some more boring stuff, though slightly less boring.
      fake:ANDK:CPAN-Client-3.001.tar.gz
      perl:RJBS:
        {
          name      => 'Some-Cool-Dist',
          version   => 1.302,
          packages  => [
            qw( Some::Cool::Dist Some::Cool::Package ),
            'Some::Cool::Util' => { in_file => "lib/Some/Cool/Package.pm" },
          ]
        }

      index

      # And now RJBS tries to steal ownership of one of ANDK's packages!
      perl:RJBS:
        {
          name      => 'Some-Cool-Dist',
          version   => '4.000',
          packages  => [
            qw( Some::Cool::Dist Some::Cool::Package ),
            'Some::Cool::Util' => { in_file => "lib/Some/Cool/Package.pm" },
            'CPAN::Client',
          ]
        }

      index

      # Note that we didn't index CPAN::Client from RJBS.
      cmd:zgrep Client cpan/modules/02packages.details.txt.gz

      # Then ANDK takes pity on RJBS and grants him permission.  RJBS just re-indexes
      # the old dist.
      perm:RJBS:CPAN::Client:c

      # We pick the new file for individual indexing...
      index:R/RJ/RJBS/Some-Cool-Dist-4.000.tar.gz

      # ...but that doesn't rebuild the indexes, it only updates the database.
      cmd:zgrep Client cpan/modules/02packages.details.txt.gz

      # Let's poke around.
      shell

      # Everything looks fine in the logs, but it doesn't look like there has
      # been an update to the files on disk.  Maybe only full reindexes update
      # the files!

      # ...so we do a full reindex.
      index

      # ...and now it's there.
      cmd:zgrep Client cpan/modules/02packages.details.txt.gz

Turning a program like this into an automated test is trivial.  You copy in and
tweak a few lines, then add the assertions you want to make based on what
you've learned.  I expect to do a lot of investigation in this format.

I also might break this program as I work on it, but I don't expect it needs much long-term stability, beyond the basics.  Its documentation is in the command line usage:

		build-fresh-cpan [-IPpv] [long options...] TYPE:WHAT...
						--dir STR              target directory; by default uses a tempdir
						-v --verbose           print logs to STDERR as it goes
						-p STR --packages STR  02packages file to prefill packages table
						-P STR --perms STR     06perms file to prefill mods/primeur/perms
						--default-user STR     default PAUSEID for uploads; default: LOCAL
						-I --stdin             read instructions from STDIN to run before ARGV
						--each                 index at start and after each upload
						--[no-]shell           add an implicit "shell" as last instruction;
																	 on by default

		Other than the --switches, arguments are instructions in one of the forms
		below.  For those that list PAUSEID, it may be omitted, and the default
		user is used instead.

		Valid instructions are:

			form                  | meaning
			----------------------+-----------------------------------------------
			index                 | index now
			index:FILE            | index just one file
														|
			perm:PAUSEID:PKG:PERM | set perm (f or c or 0) for PAUSEID on PKG
														|
			file:PAUSEID:FILE     | upload the named file as the named PAUSE user
			fake:PAUSEID:FILE     | generate a dist based on the given filename
			json:PAUSEID:JSON     | interpret the given JSON string as a faker struct
			perl:PAUSEID:PERL     | interpret the given Perl string as a faker struct
														|
			adir:DIRECTORY        | author dir: dir with A/AB/ABC/Dist-1.0.tar.gz files
			fdir:DIRECTORY        | flat dir: upload all the files as default user
														|
			prog:file             | read a file containing a list of instructions
			progcmd:"program"     | run program, which should print out instructions
			cmd:"program"         | run a command in the working directory
			shell                 | run a shell in the working directory

		prog and progcmd output can split instructions across multiple lines.  Lines
		that begin with whitespace will be appended to the line preceding them.

Oh, and see that big table?  That's why I needed to [fix Getopt::Long::Descriptive](https://rjbs.manxome.org/rubric/entry/2114)!

## ...but what about logging?

The PAUSE indexer log file has often stymied me.  It has a lot of useful
information, and some not useful information, but it can be hard to tell just
what's going on.  For example, here's the log output from indexing just one
dist:

      >>>> Just uploaded fake from RJBS/Fake-Dist-1.23.tar.gz
      PAUSE::mldistwatch object created
      Running manifind
      Collecting distmtimes from DB
      Registering new users
      Info: new_active_users[RJBS]
      Starting BIGLOOP over 1 files
      . R/RJ/RJBS/Fake-Dist-1.23.tar.gz ..
      Assigned mtime '1556373013' to dist 'R/RJ/RJBS/Fake-Dist-1.23.tar.gz'
      Examining R/RJ/RJBS/Fake-Dist-1.23.tar.gz ...
      Going to untar. Running '/usr/bin/tar' 'xzf' '/var/folders/tp/xbk5yqfj7vv86jjcgk_cp4wh0000gq/T/jzPcAZf3Xg/cpan/authors/id/R/RJ/RJBS/Fake-Dist-1.23.tar.gz'
      Untarred '/var/folders/tp/xbk5yqfj7vv86jjcgk_cp4wh0000gq/T/jzPcAZf3Xg/cpan/authors/id/R/RJ/RJBS/Fake-Dist-1.23.tar.gz'
      Found 6 files in dist R/RJ/RJBS/Fake-Dist-1.23.tar.gz, first Fake-Dist-1.23/MANIFEST
      No readme in R/RJ/RJBS/Fake-Dist-1.23.tar.gz
      Finished with pmfile[Fake-Dist-1.23/lib/Fake/Dist.pm]
      Result of normalize_version: sdv[1.23]
      Result of simile(): file[Dist] package[Fake::Dist] ret[1]
      No keyword 'no_index' or 'private' in META_CONTENT
      Result of filter_ppps: res[Fake::Dist]
      Will check keys_ppp[Fake::Dist]
      (uploader) Inserted into perms package[Fake::Dist]userid[RJBS]ret[1]err[]
      02maybe: Fake::Dist                      1.23 Fake-Dist-1.23/lib/Fake/Dist.pm (1556373013) R/RJ/RJBS/Fake-Dist-1.23.tar.gz
      Inserting package: [INSERT INTO packages (package, version, dist, file, filemtime, pause_reg, distname) VALUES (?,?,?,?,?,?,?) ] Fake::Dist,1.23,R/RJ/RJBS/Fake-Dist-1.23.tar.gz,Fake-Dist-1.23/lib/Fake/Dist.pm,1556373013,1556373013
      Inserted into perms package[Fake::Dist]userid[RJBS]ret[]err[]
      Inserted into primeur package[Fake::Dist]userid[RJBS]ret[1]err[]
      Sent "indexer report" mail about RJBS/Fake-Dist-1.23.tar.gz
      Entering rewrite02
      Number of indexed packages: 0
      Entering rewrite01
      No 01modules exist; won't try to read it
      cared about 0 symlinks
      Entering rewrite03
      No 03modlists exist; won't try to read it
      Entering rewrite06
      Directory '/home/ftp/run/mirroryaml' not found
      Finished rewrite03 and everything at Sat Apr 27 14:50:14 2019

To make the log file easier to read, and logging easier to manage, I converted
PAUSE to use Log::Dispatchouli::Global.  Then I went through every log line and
rewrote many of them to have a more self-similar format, and used
Log::Dispatchouli's data printing facilities.  Here's the same operation in the
new log format:

      2019-03-29 13:27:28.0774 [23234] FRESH: just uploaded fake: cpan/authors/id/R/RJ/RJBS/Fake-Dist-1.23.tar.gz
      2019-03-29 13:27:28.0861 [23234] PAUSE::mldistwatch object created
      2019-03-29 13:27:28.0901 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: assigned mtime 1556558848
      2019-03-29 13:27:28.0902 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: beginning examination
      2019-03-29 13:27:28.0913 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: going to untar with: {{["/usr/bin/tar", "xzf", "/var/folders/tp/xbk5yqfj7vv86jjcgk_cp4wh0000gq/T/uRlTDQD954/cpan/authors/id/R/RJ/RJBS/Fake-Dist-1.23.tar.gz"]}}
      2019-03-29 13:27:28.0920 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: untarred /var/folders/tp/xbk5yqfj7vv86jjcgk_cp4wh0000gq/T/uRlTDQD954/cpan/authors/id/R/RJ/RJBS/Fake-Dist-1.23.tar.gz
      2019-03-29 13:27:28.0921 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: found 6 files in dist, first is [Fake-Dist-1.23/MANIFEST]
      2019-03-29 13:27:28.0922 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: no README found
      2019-03-29 13:27:28.0924 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: selected pmfiles to index: {{["Fake-Dist-1.23/lib/Fake/Dist.pm"]}}
      2019-03-29 13:27:29.0009 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: result of normalize_version: 1.23
      2019-03-29 13:27:29.0009 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: result of basename_matches_package: {{{"file": "Dist", "package": "Fake::Dist", "ret": 1}}}
      2019-03-29 13:27:29.0010 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: will examine packages: {{["Fake::Dist"]}}
      2019-03-29 13:27:29.0012 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: inserted into perms: {{{"err": "", "package": "Fake::Dist", "reason": "(uploader)", "ret": 1, "userid": "RJBS"}}}
      2019-03-29 13:27:29.0012 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: inserting package: {{{"dist": "R/RJ/RJBS/Fake-Dist-1.23.tar.gz", "disttime": 1556558848, "file": "Fake-Dist-1.23/lib/Fake/Dist.pm", "filetime": 1556558848, "package": "Fake::Dist", "version": "1.23"}}}
      2019-03-29 13:27:29.0013 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: inserted into perms: {{{"err": "", "package": "Fake::Dist", "reason": null, "ret": "", "userid": "RJBS"}}}
      2019-03-29 13:27:29.0013 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: Fake-Dist-1.23/lib/Fake/Dist.pm: inserted into primeur: {{{"err": "", "package": "Fake::Dist", "ret": 1, "userid": "RJBS"}}}
      2019-03-29 13:27:29.0015 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: ensuring canonicalized case of Fake::Dist
      2019-03-29 13:27:29.0035 [23234] R/RJ/RJBS/Fake-Dist-1.23.tar.gz: sent indexer report email
      2019-03-29 13:27:29.0040 [23234] rewriting 02packages
      2019-03-29 13:27:29.0069 [23234] no 01modules exist; won't try to read it
      2019-03-29 13:27:29.0069 [23234] symlinks updated: 0
      2019-03-29 13:27:29.0070 [23234] no 03modlists exist; won't try to read it
      2019-03-29 13:27:29.0171 [23234] FTP_RUN directory [/home/ftp/run/mirroryaml] does not exist
      2019-03-29 13:27:29.0213 [23234] finished rewriting indexes
      2019-03-29 13:27:29.0268 [23234] running a shell (/opt/local/bin/zsh)

It's not perfect, but I think it's much easier to read.

My hope is that the improved testing and investigation facilities will help us
make serious strides toward overhauling the indexer before PTS 2020.  We'll
see, but right now, I feel pretty good about it!

