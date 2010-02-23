#!perl -T

use strict;
use warnings;
use Test::More;

use Test::More tests => 6;
use Alien::Libtidyp;

like( Alien::Libtidyp->config('PREFIX'), qr/.+/, "Testing non empty config('PREFIX')" );
like( Alien::Libtidyp->config('INC'), qr/.+/, "Testing non empty config('INC')" );
like( Alien::Libtidyp->config('LIBS'), qr/.+/, "Testing non empty config('LIBS')" );

diag ("PREFIX=" . Alien::Libtidyp->config('PREFIX'));
is( (-d Alien::Libtidyp->config('PREFIX')), 1, "Testing existance of 'PREFIX' directory" );
is( (-d Alien::Libtidyp->config('PREFIX') . '/include'), 1, "Testing existance of 'PREFIX/include' directory" );
is( (-d Alien::Libtidyp->config('PREFIX') . '/lib'), 1, "Testing existance of 'PREFIX/lib' directory" );
