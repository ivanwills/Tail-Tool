#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 4 + 1;
use Test::NoWarnings;
use Test::Output;

my $module = 'Tail::Tool';
use_ok( $module );

my $tail = $module->new;
ok $tail, "Create a new $module object";

stdout_is( sub {$tail->default_printer('test')}, 'test', 'Outputs what was put in');
stdout_is( sub { $tail->tail(0) }, '', '');
