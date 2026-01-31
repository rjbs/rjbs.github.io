use Test::More 'no_plan';
use_ok( 'RJBS::Pants');

$pants = RJBS::Pants->new(size => 34);
isa_ok($pants, 'RJBS::Pants');
is($pants->size, 34, 'pants fit');

$pants->size(38);
is($pants->size, 38, 'pants too loose');
