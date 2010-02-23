package My::Builder::Unix;

use strict;
use warnings;
use base 'My::Builder';

use File::Spec::Functions qw(catdir catfile rel2abs);
use Config;

sub build_binaries {
  my ($self, $build_out) = @_;
  my $prefixdir = rel2abs($build_out);

  chdir "src/build/gmake";
  print "Gonna cd build/gmake & make install ...\n";
  my $cmd = $self->get_make . " install runinst_prefix=$prefixdir devinst_prefix=$prefixdir CC=$Config{cc}";
  print "[cmd: $cmd]\n";
  $self->do_system($cmd) or die "###ERROR### [$?] during make ... ";
  chdir $self->base_dir();
  
  return 1;
}

sub get_make {
  my ($self) = @_;
  return 'make';
}
1;
