use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name       => 'Tail::Tool',
	license           => 'perl',
	dist_author       => 'dev <dev@localhost>',
	dist_version_from => 'lib/Tail/Tool.pm',
	requires          => {
		'perl'             => 5.008,
	},
	build_requires => {
		'Test::More'       => 0,
		'Test::NoWarnings' => 0,
	},
	add_to_cleanup     => [ 'Tail-Tool-*' ],
	create_makefile_pl => 'traditional',
	create_license     => 1,
	meta_merge => {
		resources => {
			repository => 'git://github.com/ivanwills/Tail-Tool.git',
			bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tail::Tool',
		},
	},
);

$builder->create_build_script();
