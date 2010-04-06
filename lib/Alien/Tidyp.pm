package Alien::Tidyp;

use warnings;
use strict;

use Alien::Tidyp::ConfigData;
use File::ShareDir qw(dist_dir);
use File::Spec::Functions qw(catdir catfile rel2abs);

=head1 NAME

Alien::Tidyp - building and using tidyp library - L<http://www.tidyp.com>

=cut

our $VERSION = '0.99.6';

=head1 VERSION

Version 0.99.6 of Alien::Tidyp uses I<tidyp> sources v0.99 + some patches.

Specifically this commit: L<http://github.com/petdance/tidyp/commit/749825bc9>

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

Please notice that the source code of tidyp library embedded in Alien::Tidyp
(in 'src' subdirectory) has a different license than module itself.

=head2 Alien::Tidyp perl module

Copyright (c) 2010 KMX.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head2 Source code of tidyp library

Copyright (c) 1998-2003 World Wide Web Consortium
(Massachusetts Institute of Technology, European Research
Consortium for Informatics and Mathematics, Keio University).
All Rights Reserved.

This software and documentation is provided "as is," and
the copyright holders and contributing author(s) make no
representations or warranties, express or implied, including
but not limited to, warranties of merchantability or fitness
for any particular purpose or that the use of the software or
documentation will not infringe any third party patents,
copyrights, trademarks or other rights.

The copyright holders and contributing author(s) will not be held
liable for any direct, indirect, special or consequential damages
arising out of any use of the software or documentation, even if
advised of the possibility of such damage.

Permission is hereby granted to use, copy, modify, and distribute
this source code, or portions hereof, documentation and executables,
for any purpose, without fee, subject to the following restrictions:

1. The origin of this source code must not be misrepresented.

2. Altered versions must be plainly marked as such and must not be misrepresented as being the original source.

3. This Copyright notice may not be removed or altered from any  source or altered source distribution.

The copyright holders and contributing author(s) specifically
permit, without fee, and encourage the use of this source code
as a component for supporting the Hypertext Markup Language in
commercial products. If you use this source code in a product,
acknowledgment is not required but would be appreciated.

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
