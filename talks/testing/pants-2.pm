package RJBS::Pants;

use Class::Accessor;
__PACKAGE__->mk_accessors(qw(size));

sub new {
  my $class = shift;
  my %attr  = @_;
  bless { %attr } => $class;
}

1;
