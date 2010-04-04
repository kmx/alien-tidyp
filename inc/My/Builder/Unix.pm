package My::Builder::Unix;

use strict;
use warnings;
use base 'My::Builder';

use File::Spec::Functions qw(catdir catfile rel2abs);
use File::Spec qw(devnull);
use Config;

sub build_binaries {
  my ($self, $build_out) = @_;
  my $prefixdir = rel2abs($build_out);

  chdir "src/build/gmake";
  print "Gonna cd build/gmake & make install ...\n";
  my @cmd = ($self->get_make, 'installhdrs', 'installib', 'installexes',
                              "runinst_prefix=$prefixdir", "devinst_prefix=$prefixdir", "CC=$Config{cc}");
  print "[cmd: ".join(' ',@cmd)."]\n";
  $self->do_system(@cmd) or die "###ERROR### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub make_clean {
  my ($self) = @_;

  chdir "src/build/gmake";
  print "Gonna cd build/gmake & make clean\n";
  my @cmd = ($self->get_make, 'clean');
  print "[cmd: ".join(' ',@cmd)."]\n";
  $self->do_system(@cmd) or warn "###WARN### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub get_make {
  my ($self) = @_;
  my $devnull = File::Spec->devnull();
  my @try = ( $Config{gmake}, 'gmake', 'make');
  foreach my $name ( @try ) {
    next unless $name;
    return $name if `$name --help 2> $devnull`;
  }
  return 'make';
}

sub quote_literal {
    my ($self, $txt) = @_;
    $txt =~ s|'|'\\''|g;
    return "'$txt'";
}

1;
