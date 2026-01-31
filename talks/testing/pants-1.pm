package RJBS::Pants;

sub new {
  my $class = shift;
  my %attr  = @_;
  bless { %attr } => $class;
}

1;
