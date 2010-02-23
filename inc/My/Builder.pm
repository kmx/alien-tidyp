package My::Builder;

use strict;
use warnings;
use base 'Module::Build';

use lib "inc";
use File::Spec::Functions qw(catfile);
use ExtUtils::Command;

sub ACTION_code {
  my $self = shift;

  unless (-e 'build_done') {
    # we are deriving the subdir name from VERSION as we want to prevent
    # troubles when user reinstalls the newer version of Alien::Libtidyp
    my $build_out = catfile('sharedir', $self->{properties}->{dist_version});    
    $self->add_to_cleanup($build_out);
    $self->add_to_cleanup('build_done');
    # go for build
    $self->build_binaries($build_out);
    # store info about build into future Alien::Libtidyp::ConfigData
    $self->config_data('share_subdir', $self->{properties}->{dist_version});
    $self->config_data('config', { PREFIX => '@PrEfIx@',
                                   LIBS   => '-L@PrEfIx@/lib -ltidyp',
                                   INC    => '-I@PrEfIx@/include/tidyp',
                                 });
    # mark sucessfully finished build
    local @ARGV = ('build_done');
    ExtUtils::Command::touch();
  }
  $self->SUPER::ACTION_code;
}

sub build_binaries {
  die "###ERROR### My::Builder cannot build libidyp from sources, use rather My::Builder::<platform>";
}

1;
