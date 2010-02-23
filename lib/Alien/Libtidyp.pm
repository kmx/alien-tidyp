package Alien::Libtidyp;

use warnings;
use strict;

use Alien::Libtidyp::ConfigData;
use File::ShareDir qw(dist_dir);
use File::Spec::Functions qw(catdir catfile rel2abs);

=head1 NAME

Alien::Libtidyp - building and using libtidyp binaries

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Alien::Libtidyp during its installation:

=over

=item * Build 'libtidyp' Libtidyp binaries from source codes (if possible on your system).

=item * Installs binaries into so called 'share' directory of Alien::Libtidyp distribution

=back

Later you can use Alien::Libtidyp in your module that needs to link agains Libtidyp
and/or related libraries like this:

    # Sample Makefile.pl
    use ExtUtils::MakeMaker;
    use Alien::Libtidyp;

    WriteMakefile(
      NAME         => 'Any::Libtidyp::Module',
      VERSION_FROM => 'lib/Any/Libtidyp/Module.pm',
      LIBS         => Alien::Libtidyp->config('LIBS'),
      INC          => Alien::Libtidyp->config('INC'),
      # + additional params
    );

=head1 METHODS

=head2 config()

This function is the main public interface to this module.

    Alien::Libtidyp->config('LIBS');

Returns a string like: '-L/path/to/libtidy/dir/lib -llibtidyp'

    Alien::Libtidyp->config('INC');

Returns a string like: '-I/path/to/libtidy/dir/include'

=head1 AUTHOR

KMX, C<< <kmx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-alien-libtidyp at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Alien-Libtidyp>. 

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
  my $share_dir = dist_dir('Alien-Libtidyp');
  my $subdir = Alien::Libtidyp::ConfigData->config('share_subdir');
  return unless $subdir;
  my $real_prefix = catdir($share_dir, $subdir);
  return unless ($param =~ /[a-z0-9_]*/i);
  my $val = Alien::Libtidyp::ConfigData->config('config')->{$param};
  return unless $val;  
  $val =~ s/\@PrEfIx\@/$real_prefix/g; # handle @PrEfIx@ replacement
  return $val;
}

1;

