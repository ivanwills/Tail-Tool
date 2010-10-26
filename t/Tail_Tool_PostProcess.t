#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 10 + 1;
use Test::NoWarnings;

my $module = 'Tail::Tool::PostProcess';
use_ok( $module );


