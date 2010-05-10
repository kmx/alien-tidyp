package My::Builder;

use strict;
use warnings;
use base 'Module::Build';

use lib "inc";
use File::Spec::Functions qw(catfile);
use ExtUtils::Command;
use File::Fetch;
use Digest::SHA qw(sha1_hex);
use Archive::Extract;

sub ACTION_code {
  my $self = shift;

  unless (-e 'build_done') {
    # important directories
    my $download = 'download';
    my $patches = 'patches';
    my $build_src = 'build_src';
    # we are deriving the subdir name from VERSION as we want to prevent
    # troubles when user reinstalls the newer version of Alien::Tidyp
    my $build_out = catfile('sharedir', $self->{properties}->{dist_version});
    $self->add_to_cleanup($build_out);
    $self->add_to_cleanup($build_src);
    $self->add_to_cleanup('build_done');
    # get sources
    my ($url, $dir, $sha1) = ('http://github.com/downloads/petdance/tidyp/tidyp-1.02.tar.gz', 'tidyp-1.02', 'f3a6c9a2ed18c14fbf7330760ed727a70558e466');
    $self->fetch_file($url, $sha1, $download);
    $self->notes('tidyp_src', "$build_src/$dir");
    my $archive = catfile($download, File::Fetch->new(uri => $url)->file);
    my $ae = Archive::Extract->new( archive => $archive );
    die "###ERROR###: cannot extract tarball ", $ae->error unless $ae->extract(to => $build_src);
    # go for build
    $self->build_binaries($build_out, $self->notes('tidyp_src'));
    # store info about build into future Alien::Tidyp::ConfigData
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

sub ACTION_clean {
  my $self = shift;
  $self->make_clean($self->notes('tidyp_src'));
  $self->SUPER::ACTION_clean;
}

sub fetch_file {
  my ($self, $url, $sha1sum, $download) = @_;
  die "###ERROR### _fetch_file undefined url\n" unless $url;
  die "###ERROR### _fetch_file undefined sha1sum\n" unless $sha1sum;
  my $ff = File::Fetch->new(uri => $url);
  my $fn = catfile($download, $ff->file);
  if (-e $fn) {
    print "Checking checksum for already existing '$fn'...\n";
    return 1 if $self->check_sha1sum($fn, $sha1sum);
    unlink $fn; #exists but wrong checksum
  }
  print "Fetching '$url'...\n";
  my $fullpath = $ff->fetch(to => $download);
  die "###ERROR### Unable to fetch '$url'" unless $fullpath;
  if (-e $fn) {
    print "Checking checksum for '$fn'...\n";
    return 1 if $self->check_sha1sum($fn, $sha1sum);
    die "###ERROR### Checksum failed '$fn'";
  }
  die "###ERROR### _fetch_file failed '$fn'";
}

sub check_sha1sum {
  my( $self, $file, $sha1sum ) = @_;
  my $sha1 = Digest::SHA->new;
  my $fh;
  open($fh, $file) or die "###ERROR## Cannot check checksum for '$file'\n";
  binmode($fh);
  $sha1->addfile($fh);
  close($fh);
  return ($sha1->hexdigest eq $sha1sum) ? 1 : 0
}

sub build_binaries {
  die "###ERROR### My::Builder cannot build libidyp from sources, use rather My::Builder::<platform>";
}

1;
