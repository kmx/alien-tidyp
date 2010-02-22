use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Alien::Libtidyp',
    license             => 'perl',
    dist_author         => q{KMX <kmx@cpan.org>},
    dist_version_from   => 'lib/Alien/Libtidyp.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Alien-Libtidyp-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
