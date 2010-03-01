package Alien::Tidyp;

use warnings;
use strict;

use Alien::Tidyp::ConfigData;
use File::ShareDir qw(dist_dir);
use File::Spec::Functions qw(catdir catfile rel2abs);

=head1 NAME

Alien::Tidyp - building and using tidyp library - L<http://www.tidyp.com>

=cut

our $VERSION = '0.99.3';

=head1 VERSION

Version 0.99.3 of Alien::Tidyp uses I<tidyp> sources v0.99 + some patches.

Specifically this commit: L<http://github.com/petdance/tidyp/commit/3b52d11248b69464ad399ed7faa51c23af61ac38>

=head1 SYNOPSIS

Alien::Tidyp during its installation does the following:

=over

=item * Builds I<tidyp> binaries from source codes

=item * Installs binaries and dev files (*.h, *.a) into I<share> directory of Alien::Tidyp distribution

=item * I<share> directory is usually something like this: /usr/lib/perl5/site_perl/5.10/auto/share/dist/Alien-Tidyp

=back

Later you can use Alien::Tidyp in your module that needs to link with I<tidyp>
like this:

    # Sample Makefile.pl
    use ExtUtils::MakeMaker;
    use Alien::Tidyp;

    WriteMakefile(
      NAME         => 'Any::Tidyp::Module',
      VERSION_FROM => 'lib/Any/Tidyp/Module.pm',
      LIBS         => Alien::Tidyp->config('LIBS'),
      INC          => Alien::Tidyp->config('INC'),
      # + additional params
    );

=head1 METHODS

=head2 config()

This function is the main public interface to this module.

    Alien::Tidyp->config('LIBS');

Returns a string like: '-L/path/to/libtidy/dir/lib -ltidyp'

    Alien::Tidyp->config('INC');

Returns a string like: '-I/path/to/libtidy/dir/include/tidyp'

    Alien::Tidyp->config('PREFIX');

Returns a string like: '/path/to/libtidy/dir'

=head1 AUTHOR

KMX, E<lt>kmx at cpan.orgE<gt>

=head1 BUGS

Please report any bugs or feature requests to E<lt>bug-Alien-Tidyp at rt.cpan.orgE<gt>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Alien-Tidyp>.

=head1 LICENSE AND COPYRIGHT

Copyright 2010 KMX.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

sub config
{
  my ($package, $param) = @_;
  my $share_dir = dist_dir('Alien-Tidyp');
  my $subdir = Alien::Tidyp::ConfigData->config('share_subdir');
  return unless $subdir;
  my $real_prefix = catdir($share_dir, $subdir);
  return unless ($param =~ /[a-z0-9_]*/i);
  my $val = Alien::Tidyp::ConfigData->config('config')->{$param};
  return unless $val;
  $val =~ s/\@PrEfIx\@/$real_prefix/g; # handle @PrEfIx@ replacement
  return $val;
}

1;
