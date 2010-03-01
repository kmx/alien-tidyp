#!perl -T

use strict;
use warnings;
use Test::More;

use Test::More tests => 6;
use Alien::Tidyp;

like( Alien::Tidyp->config('PREFIX'), qr/.+/, "Testing non empty config('PREFIX')" );
like( Alien::Tidyp->config('INC'), qr/.+/, "Testing non empty config('INC')" );
like( Alien::Tidyp->config('LIBS'), qr/.+/, "Testing non empty config('LIBS')" );

diag ("PREFIX=" . Alien::Tidyp->config('PREFIX'));
is( (-d Alien::Tidyp->config('PREFIX')), 1, "Testing existance of 'PREFIX' directory" );
is( (-d Alien::Tidyp->config('PREFIX') . '/include'), 1, "Testing existance of 'PREFIX/include' directory" );
is( (-d Alien::Tidyp->config('PREFIX') . '/lib'), 1, "Testing existance of 'PREFIX/lib' directory" );
