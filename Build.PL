use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Tail::Tool',
    license           => 'perl',
    dist_author       => 'Ivan Wills <ivan.wills@gamil.com>',
    dist_version_from => 'lib/Tail/Tool.pm',
    requires          => {
        'perl'                         => 5.006,
        'AnyEvent'                     => 0,
        'Data::Dump::Streamer'         => 0,
        'EV'                           => 0,
        'Getopt::Alt'                  => 0,
        'IO::Prompt'                   => 0,
        'List::Util'                   => 0,
        'List::MoreUtils'              => 0,
        'Moose'                        => 0,
        'Moose::Role'                  => 0,
        'Moose::Util::TypeConstraints' => 0,
        'Path::Class'                  => 0,
        'Pod::Usage'                   => 0,
        'Readonly'                     => 0,
        'Scalar::Util'                 => 0,
        'Term::ANSIColor'              => 0,
        'TryCatch'                     => 0,
        'Term::Spinner'                => 0,
        'version'                      => 0,
        'warnings'                     => 0,
        'YAML'                         => 0,
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
