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
  module_name        => 'Alien::Tidyp',
  dist_version_from  => 'lib/Alien/Tidyp.pm',
  dist_author        => 'KMX, kmx@cpan.org',
  license            => 'perl',
  requires => {
    'File::ShareDir'    => 0,
    'File::Spec'        => 0,
  },
  configure_requires => {
    'File::Spec'        => 0,
    'ExtUtils::Command' => 0,
  },
  build_requires => {
    'Test::More'        => 0,
    'File::Spec'        => 0,
    'ExtUtils::Command' => 0,
  },
  share_dir          => 'sharedir',
  create_readme      => 1,
  meta_merge => {
    resources  => {
      bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Alien-Tidyp',
      repository => 'http://github.com/kmx/alien-tidyp',
    }
  }
);

$builder->create_build_script();
