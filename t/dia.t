#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 4;

my $module = 'Tail::Tool';
use_ok( $module );


my $obj = $module->new();

ok( defined $obj, "Check that the class method new returns something" );
ok( $obj->isa('Tail::Tool'), " and that it is a Tail::Tool" );

can_ok( $obj, 'method',  " check object can execute method()" );
ok( $obj->method(),      " check object method method()" );
is( $obj->method(), '?', " check object method method()" );

ok( $Tail::Tool::func(),      " check method func()" );
is( $Tail::Tool::func(), '?', " check method func()" );
