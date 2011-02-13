#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 2 + 1;
use Test::NoWarnings;

my $module = 'Tail::Tool';
use_ok( $module );

my $tail = $module->new;
ok $tail, "Create a new $module object";
