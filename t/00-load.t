#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Alien::Libtidyp' ) || print "Bail out!
";
}

diag( "Testing Alien::Libtidyp $Alien::Libtidyp::VERSION, Perl $], $^X" );
