---
layout: post
title : "astronomical perl (just a tiny bit of it)"
date  : "2006-10-13T11:09:13Z"
tags  : ["astronomy", "perl", "programming", "rpg"]
---
The new house is three stories, and gets lots of natural light.  Sadly, none of
its third story windows is well-placed for stargazing.  If one was, I'd have
more time to look through my telescope and more inspiration to write silly
astronomy code.  Maybe when we overhaul the third floor, we'll put in a window
on the slant of the roof.  Probably not.

Since I don't do much stargazing, my last need for astronomical Perl code came
while working on the RPG that I run.  It's space-based, and I wanted to get an
idea of distance between various star systems.  There were a number of Astro
modules on the CPAN, but most of them either lacked the few features I needed
or required third party libraries that didn't just work out of the box.

Since I didn't need much at all, I just broke out my copy of Practical
Astronomy For Your Personal Computer (a fantastic book that I've never
regretted buying), and wrote this silly little program.  It would be a lot more
fun if there was a giant and easy to access database of stars.  I think I'll
need to dig more for that.

```perl
package Astro;
use Math::Trig ();

use strict;
use warnings;

# Stars are located by their RA (right ascension), declination, and distance
# from earth.

# RA  is usually expressed in hms: hours,   minutes,    seconds
# dec is usually expressed in dms: degrees, arcminutes, arcseconds
# distance is usually expressed in light years

# Spherical coordinates are usually expressed as [ rho, phi, theta ]
#   rho   - distance from center
#   phi   - one angle, in degrees
#   theta - one angle, in degrees

# A star's position can be expressed as [ dist, dec, ra ]

sub hms_to_dms {
  my ($hours, $minutes, $seconds) = @_;

  return map { $_ * 15 } @_;
}

sub dms_to_d {
  my ($deg, $arcmin, $arcsec) = @_;
  return $deg + $arcmin/60 + $arcsec/3600;
}

# given RA in hms, dec in dms, distance in ly
sub star_to_xyz {
  my ($dist, $dec, $ra) = @_;

  my $dec_deg = dms_to_d(@$dec);
  my $ra_deg  = dms_to_d(hms_to_dms(@$ra));

  for my $deg ($dec_deg, $ra_deg) {
    $deg = 360 - $deg if $deg < 0;
  }

  my $dec_rad = Math::Trig::deg2rad($dec_deg);
  my $ra_rad  = Math::Trig::deg2rad($dec_deg);

  return my ($x, $y, $z)
    = Math::Trig::spherical_to_cartesian($dist, $dec_rad, $ra_rad);
}

sub dist {
  my ($p1, $p2) = @_;

  my $mhd
    = ($p2->[0] - $p1->[0]) ** 2
    + ($p2->[1] - $p1->[1]) ** 2
    + ($p2->[2] - $p1->[2]) ** 2;

  return $mhd ** 0.5;
}

sub star_dist {
  my ($star1, $star2) = @_;

  my @s1_xyz = star_to_xyz(@$star1);
  my @s2_xyz = star_to_xyz(@$star2);

  print "star1: @s1_xyz\n";
  print "star2: @s2_xyz\n";

  dist(\@s1_xyz, \@s2_xyz);
}

my @aca  = star_to_xyz( 4.36, [ -60, 50,  2 ], [  14, 39, 37 ]);
my @acb  = star_to_xyz( 4.36, [ -60, 50, 14 ], [  14, 39, 35 ]);
my @wolf = star_to_xyz( 7.78, [   7, 00, 42 ], [  10, 56, 37 ]);

my %star = (   #  dist,   dec,               ra
  capella   => [ 42.20, [  45,  59,  53 ], [  5, 16, 41 ] ], # Alpha Aurigae
  castor    => [ 49.77, [  31,  53,  18 ], [  7, 34, 36 ] ], # Castor
  centauri  => [  4.36, [ -60, -50,  -2 ], [ 14, 39, 37 ] ], # a; Rigil Kent
                                                             # toliman, bungula
  draconis  => [ 18.78, [  69,  39,  40 ], [ 19, 32, 21 ] ], # Sigma Draconis
  eridani   => [ 10.52, [ - 9, -27, -30 ], [  3, 32, 56 ] ], # Epsilon Eridani
  errai     => [ 45.00, [  77,  37,  56 ], [ 23, 39, 21 ] ], # Gamma Cephei
  geminorum => [ 33.72, [  28,   1,  35 ], [  7, 45, 19 ] ], # Pollux
  gliese    => [ 51.81, [  29,  53,  48 ], [ 20,  3, 37 ] ], # Gliese 777; bin
  luyten    => [  8.72, [  17,  57,   0 ], [  1, 39,  1 ] ], # 726-8
  mensae    => [ 33.10, [ -74, -45, -11 ], [  6, 10, 14 ] ], # Alpha Mensae
  pavonis   => [ 30.10, [ - 5, -21, -58 ], [ 21, 26, 26 ] ], # gamma
  pegasi    => [ 53.00, [  12,  11,  00 ], [ 22, 46, 42 ] ], # Xi Pegasi
  persei    => [ 34.40, [  49,  36,  48 ], [  3,  9,  4 ] ], # Iota Persei
  reticuli  => [ 39.51, [ -62, -34, -31 ], [  3, 17, 42 ] ], # Zeta (binary)
  scorpii   => [ 45.70, [ - 8, -22, - 6 ], [ 16, 15, 37 ] ], # 18 Scorpii
  sol       => [  0.00, [   0,   0,   0 ], [  0,  0,  0 ] ], # YOU ARE HERE
  tau_ceti  => [ 11.89, [ -15, -56, -14 ], [  1, 44,  4 ] ], # Tau Ceti
  tucanae   => [ 28.00, [ -64, -52, -29 ], [  0, 20,  4 ] ], # Zeta
  wolf      => [  7.78, [   7,  00,  42 ], [ 10, 56, 37 ] ], # Wolf 359
  zavijava  => [ 35.60, [   1,  45,  53 ], [ 11, 50, 42 ] ], # Beta Virginis
);

if (@ARGV == 2) {
  print star_dist($star{$ARGV[0]}, $star{$ARGV[1]}), "\n";
} else {
  my @max = (0, undef, undef);
  for my $star1 (keys %star) {
    next unless $star{$star1};
    for my $star2 (grep { $_ ne $star1 } keys %star) {
      next unless $star{$star2};
      my $dist = star_dist($star{$star1}, $star{$star2});
      @max = ($dist, $star1, $star2) if $dist > $max[0];
    }
  }

  print "@max\n";
}

1;
```

