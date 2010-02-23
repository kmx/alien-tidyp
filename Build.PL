use strict;
use warnings;

use lib "inc";

my %platforms =(
  MSWin32 => 'Windows',
  linux   => 'Unix',
  cygwin  => 'Unix',
  freebsd => 'Unix',
);
my $package = 'My::Builder::' . ($platforms{$^O} || 'Unix');
print "Gonna use '$package' class ...\n";
eval "require $package" or die "Require '$package' failed: $@\n";

my $builder = $package->new(
  module_name        => 'Alien::Libtidyp',
  all_from           => 'lib/Alien/SDL.pm',
  requires => {
    'File::ShareDir'    => 0,
    'File::Spec'        => 0,
  },
  build_requires => {
    'Test::More'        => 0,
    'File::Spec'        => 0,
    'ExtUtils::Command' => 0,
  },
  share_dir          => 'sharedir',
  create_makefile_pl => 'traditional',
);

$builder->create_build_script();
