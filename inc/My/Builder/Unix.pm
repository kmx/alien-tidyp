package My::Builder::Unix;

use strict;
use warnings;
use base 'My::Builder';

use File::Spec::Functions qw(catdir catfile rel2abs);
use File::Spec qw(devnull);
use Config;

sub build_binaries {
  my ($self, $build_out, $srcdir) = @_;
  $srcdir ||= 'src';
  my $prefixdir = rel2abs($build_out);
  $self->config_data('build_prefix', $prefixdir); # save it for future ConfigData

  chdir $srcdir;

  # do './configure ...'
  my $run_configure = 'y';
  $run_configure = $self->prompt("Run ./configure again?", "n") if (-f "config.status");
  if (lc($run_configure) eq 'y') {
    my @cmd = ( './configure', '--enable-shared=no', '--disable-dependency-tracking', "--prefix=$prefixdir");
    print "Configuring ...\n";
    print "(cmd: ".join(' ',@cmd).")\n";
    $self->do_system(@cmd) or die "###ERROR### [$?] during ./configure ... ";
  }

  # do 'make install'
  my @cmd = ($self->get_make, 'install');
  print "Running make install ...\n";
  print "(cmd: ".join(' ',@cmd).")\n";
  $self->do_system(@cmd) or die "###ERROR### [$?] during make ... ";

  chdir $self->base_dir();
  return 1;
}

sub make_clean {
  my ($self, $srcdir) = @_;
  $srcdir ||= 'src';

  chdir $srcdir;
  my @cmd = ($self->get_make, 'clean');
  print "Running make clean ...\n";
  print "(cmd: ".join(' ',@cmd).")\n";
  $self->do_system(@cmd) or warn "###WARN### [$?] during make ... ";
  chdir $self->base_dir();

  return 1;
}

sub get_make {
  my ($self) = @_;
  my $devnull = File::Spec->devnull();
  my @try = ($Config{gmake}, 'gmake', 'make', $Config{make});
  my %tested;
  print "Gonna detect GNU make:\n";
  foreach my $name ( @try ) {
    next unless $name;
    next if $tested{$name};
    $tested{$name} = 1;
    print "- testing: '$name'\n";
    my $ver = `$name --version 2> $devnull`;
    if ($ver =~ /GNU Make/i) {
      print "- found: '$name'\n";
      return $name
    }
  }
  print "- fallback to: 'make'\n";
  return 'make';
}

sub quote_literal {
    my ($self, $txt) = @_;
    $txt =~ s|'|'\\''|g;
    return "'$txt'";
}

1;
