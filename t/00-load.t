#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 11 + 1;
use Test::NoWarnings;

BEGIN {
    use_ok( 'Tail::Tool'                    );
    use_ok( 'Tail::Tool::File'              );
    use_ok( 'Tail::Tool::Plugin::Highlight' );
    use_ok( 'Tail::Tool::Plugin::Ignore'    );
    use_ok( 'Tail::Tool::Plugin::Match'     );
    use_ok( 'Tail::Tool::Plugin::Replace'   );
    use_ok( 'Tail::Tool::Plugin::Spacing'   );
    use_ok( 'Tail::Tool::PostProcess'       );
    use_ok( 'Tail::Tool::PreProcess'        );
    use_ok( 'Tail::Tool::Regex'             );
    use_ok( 'Tail::Tool::RegexList'         );
}

diag( "Testing Tail::Tool $Tail::Tool::VERSION, Perl $], $^X" );
