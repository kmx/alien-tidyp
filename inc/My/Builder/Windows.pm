package My::Builder::Windows;

use strict;
use warnings;
use base 'My::Builder';

use File::Spec::Functions qw(catdir catfile rel2abs);
use File::Spec qw(devnull);
use Config;

sub build_binaries {
  my ($self, $build_out, $srcdir) = @_;
  my $prefixdir = rel2abs($build_out);
  my $perl = $^X;
  # for GNU make on MS Windows it is safer to convert \ to /
  $perl =~ s|\\|/|g;
  $prefixdir =~ s|\\|/|g;

  my $makefile = rel2abs('patches\Makefile.mingw'); # ugly hack

  chdir $srcdir;
  print "Gonna make -f Makefile.mingw install ...\n";
  my @cmd = ( $self->get_make, '-f', $makefile, "PERL=$perl", "PREFIX=$prefixdir", "CC=$Config{cc}", "install" );
  print "[cmd: ".join(' ',@cmd)."]\n";
  $self->do_system(@cmd) or die "###ERROR### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub make_clean {
  my ($self, $srcdir) = @_;
  my $perl = $^X;
  # for GNU make on MS Windows it is safer to convert \ to /
  $perl =~ s|\\|/|g;

  my $makefile = rel2abs('patches\Makefile.mingw'); # ugly hack

  chdir $srcdir;
  print "Gonna make -f Makefile.mingw clean\n";
  my @cmd = ($self->get_make, '-f', $makefile, "PERL=$perl", 'clean');
  print "[cmd: ".join(' ',@cmd)."]\n";
  $self->do_system(@cmd) or warn "###WARN### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub get_make {
  my ($self) = @_;
  my $devnull = File::Spec->devnull();
  my @try = ( $Config{gmake}, 'mingw32-make', 'gmake', 'make');
  foreach my $name ( @try ) {
    next unless $name;
    return $name if `$name -v 2> $devnull`;
  }
  warn "###WARN### no GNU make utility detected, falling back to 'dmake'\n";
  return 'dmake';
}

sub quote_literal {
    my ($self, $txt) = @_;
    $txt =~ s|"|\\"|g;
    return qq("$txt");
}

1;
