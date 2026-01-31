use Test::More 'no_plan';

use_ok( 'RJBS::Pants' );

@sets = (
  [  5, 10,  5 ],
  [  2,  6,  2 ],
  [ 11,  7,  1 ],
  [ 80, 64, 16 ],
);

is(
  gcd($_->[0],$_->[1]),
  $_->[2],
  "gcd($_->[0],$_->[1]) is $_->[2]"
) for @sets;
