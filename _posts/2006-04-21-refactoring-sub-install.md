---
layout: post
title : "refactoring sub::install"
date  : "2006-04-21T16:15:35Z"
tags  : ["perl", "programming"]
---
I've been doing some reworking in the guts of Sub::Install, trying to steal
good ideas from Sub::Define and to implement some of the ideas that came out of
discussions with its author, Johan Lodin.  Several of these deal with warning
handling, which has led me to produce this little routine.  I'm finding that I
really like it:

    my $eow_re;
    BEGIN { $eow_re = qr/ at .+? line \d+\.\Z/ };

    sub _do_with_warn {
      my ($patterns) = @_;
      sub {
        my ($code) = @_;

        my $old_warn_sig = $SIG{__WARN__};
        local $SIG{__WARN__} = sub {
          my ($error) = @_;
          for (@{ $patterns->{suppress} }) {
              return if $error =~ $_;
          }
          for (@{ $patterns->{croak} }) {
            if (my ($base_error) = $error =~ /\A($_) $eow_re/x) {
              Carp::croak $base_error;
            }
          }
          for (@{ $patterns->{carp} }) {
            if (my ($base_error) = $error =~ /\A($_) $eow_re/x) {
              $error = Carp::shortmess $base_error;
              last;
            }
          }
          $old_warn_sig ? $old_warn_sig->($error) : (warn $error)
        };
        $code->();
      };
    }

I'm probably going to add something like this, later:

    for my $re (keys %{ $patterns->{custom} }) {
      return $patterns->{custom}{$re}->($error) if $error =~ $re;
    }

I also spent a little time trying to deal with CarpLevel, but I found that when
I set it, it caused carp to act more like cluck, and when I skipped it, the
right thing happened.  I don't know why, and I haven't yet felt like
investigating.  I'll just carp about it here.

I knew, when releasing Sub::Install, that it omitted one feature of
Sub::Installer.  Sub::Installer can, given a destination and a string, evaluate
the string as a sub definition for the destination.  In other words:

    Target->install_sub(foo => "return scalar localtime");

    # is equivalent to:
    
    eval q{
      package Target;
      sub foo { return scalar localtime }
    };

The advantage over supplying a coderef is that some things are, much to my
chagrin, determined based on code compilation location rather than code
installation location.  That means that if you build a subref in Foo and
install it in Bar, things it calls will have a caller of Foo.  There are other
similar effects.  I had something of a "this far and no further!" feeling about
this.  Sub::Install exists to hide a little bit of ugliness, because I felt it
should not be ugly to install coderefs in packages.  Once you're in the land of
string eval, though, I think you need to see the ugliness, to remind yourself
of what you're doing.

(It would be nice if a few things that require string eval didn't, though.
I'd rather not have to see the ugliness of naturalizing code into a package or
requiring a module whose name is stored in a variable, for example.)

I stupidly missed one other feature Sub::Installer provided.  Because it was
invoked as a method, it could be subclassed.  I understood this, and knew it
was for creating new kinds of installation routines.  I provided a (secret)
means for a caller to say, in Sub::Install, "install this routine, but do it
this way."  I hadn't realized that, due to the semantics of Sub::Installer,
subclassing it would allow the *target* to change how it would *receive* subs,
rather than allow the caller to change how it would install subs!

Johan Lodin was not so blind, and built a mechanism for this into Sub::Define.
I didn't really care for it, though, and in the end it didn't work exactly the
way he'd wanted.  I'm probably going to build something like it into
Sub::Install, but it won't be as seamless as Sub::Installer's... but then
again, Sub::Installer's seamlessness comes from violating the nether regions of
my runtime environment, shoving code into UNIVERSAL whether I want it or not.

As for my next goals, they're in that murky, dangerous realm: provide an
open-ended customization system.  I'm happy with sticking to callbacks, but I
want to provide a nice generator for installers, so that a finicky user can
say something like:

      # Install by passing to self-redefining methods?
      *install_sub = Sub::Instal::generate_installer({
        inst => sub {
          my ($pkg, $name, $code) = @_;
          $pkg->$name($code);
        },
        inst_wrapper => Sub::Install::warning_handler({
          carp    => [ $redef_warning ],
          default => 'croak',
        }),
        return => 'inst_return',
      });

The above sucks in the specifics, but hopefully the actually implemented and
published version will be tolerable and extensible.  Maybe I'll get to work on
that, instead of just mumbling about it here...

