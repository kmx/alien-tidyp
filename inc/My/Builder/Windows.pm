package My::Builder::Windows;

use strict;
use warnings;
use base 'My::Builder';

sub build_binaries {
  my( $self, $build_out) = @_;
  warn "Building from sources not supported on MS Windows platform";
}

1;
