#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1 + 1;
use Test::NoWarnings;

BEGIN {
	use_ok( 'Tail::Tool' );
}

diag( "Testing Tail::Tool $Tail::Tool::VERSION, Perl $], $^X" );
