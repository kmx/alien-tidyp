use strict;
use warnings;

use lib 'inc';

my %platforms =(
  # Unix = default, thus not listing all UNIX like systems
  MSWin32 => 'Windows',
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
    'File::Fetch'       => 0,
    'Digest::SHA'       => 0,
    'Archive::Extract'  => 0,
  },
  build_requires => {
    'Test::More'        => 0,
    'File::ShareDir'    => 0,
    'File::Spec'        => 0,
    'ExtUtils::Command' => 0,
    'File::Fetch'       => 0,
    'Digest::SHA'       => 0,
    'Archive::Extract'  => 0,
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

# set what tidyp tarball we are gonna use
$builder->notes('tidyp_url', 'http://github.com/downloads/petdance/tidyp/tidyp-1.02.tar.gz');
$builder->notes('tidyp_dir', 'tidyp-1.02'); # dirname inside the tarball
$builder->notes('tidyp_sha1', 'f3a6c9a2ed18c14fbf7330760ed727a70558e466'); # SHA1 checksum of the tarball
