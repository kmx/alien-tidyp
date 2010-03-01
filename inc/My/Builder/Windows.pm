package My::Builder::Windows;

use strict;
use warnings;
use base 'My::Builder';

use File::Spec::Functions qw(catdir catfile rel2abs);
use File::Spec qw(devnull);
use Config;

sub build_binaries {
  my ($self, $build_out) = @_;
  my $prefixdir = rel2abs($build_out);

  chdir "src";
  print "Gonna make -f build/win32/Makefile.mingw install ...\n";
  my $cmd = $self->get_make . " -f build/win32/Makefile.mingw PERL=$^X PREFIX=$prefixdir CC=$Config{cc} install";
  print "[cmd: $cmd]\n";
  $self->do_system($cmd) or die "###ERROR### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub make_clean {
  my ($self) = @_;

  chdir "src";
  print "Gonna make -f build/win32/Makefile.mingw clean\n";
  my $cmd = $self->get_make . " -f build/win32/Makefile.mingw PERL=$^X clean";
  print "[cmd: $cmd]\n";
  $self->do_system($cmd) or warn "###WARN### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub get_make {
  my ($self) = @_;
  my $devnull = File::Spec->devnull();
  my @try = ( $Config{gmake}, 'mingw32-make', 'gmake', 'make');
  foreach my $name ( @try ) {
    next unless $name;
    return $name if `$name --help 2> $devnull`;
  }
  return 'make';
}

1;
