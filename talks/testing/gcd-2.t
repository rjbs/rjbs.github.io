@sets = (
  [  5, 10,  5 ],
  [  2,  6,  2 ],
  [ 11,  7,  1 ],
  [ 80, 64, 16 ],
);
open TEST, ">/tmp/testgcd";
print TEST "$_->[0] $_->[1]\n" for @sets;
close TEST;
@results = `perl gcd < /tmp/testgcd`;
for (1 .. $#results) {
  ($gcd) = $results[$_] =~ /\D(\d+)$/;
  die "bad gcd($sets[$_][0],$sets[$_][1])"
    unless $gcd == $sets[$_][2];
}
