package Tail::Tool;

# Created on: 2010-10-06 14:15:40
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moose;
use version;
use Carp;
use Scalar::Util;
use List::Util;
#use List::MoreUtils;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;


our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();
#our @EXPORT      = qw//;

has files => (
    is      => 'rw',
    isa     => 'ArrayRef[Tail::Tool::File]',
    default => sub {[]},
);
has lines => (
    is      => 'rw',
    isa     => 'Integer',
    default => 10,
);
has pre_process => (
    is   => 'rw',
    isa  => 'ArrayRef[Tail::Tool::PreProcess]',
);
has post_process => (
    is   => 'rw',
    isa  => 'ArrayRef[Tail::Tool::PostProcess]',
);

around BUILDARGS => sub {
    my ($orig, $class, @params) = @_;
    my %param;

    if ( ref $params[0] eq 'HASH' ) {
        %param = %{ shift @params };
    }
    else {
        %param = @params;
    }

    $param{pre_process}  ||= [];
    $param{post_process} ||= [];

    for my $key ( keys %param ) {
        if ( $key eq 'files' ) {
            for my $file ( @{ $param{$key} } ) {
                $file = Tail::Tool::File->new( name => $file );
            }
        }
        elsif ( $key eq 'lines' ) {
        }
        else {
            my $plugin = '+' eq substr $key, 0 ,1, 1 ? substr $key, 1, 999 : "Tail::Tool::Plugin::$key";
            my $plugin_file = $plugin;
            $plugin_file =~ s{::}{/}gxms;
            $plugin_file .= '.pm';
            eval { require $plugin_file };
            if ( $EVAL_ERROR ) {
                confess "Could not load the plugin $key (via $plugin_file)\n";
            }

            my $plg = $plugin->new($param{$key});
            delete $param{$key};

            $param{ ( $plg->post ? 'pre' : 'post' ) . '_process' } = $plg;
        }
    }

    return $class->$orig(%param);
};

sub tail {
    my ($self) = @_;
}

1;

__END__

=head1 NAME

Tail::Tool - Tool for sofisticated tailing of files

=head1 VERSION

This documentation refers to Tail::Tool version 0.1.


=head1 SYNOPSIS

   use Tail::Tool;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

   my $tt = Tail::Tool->new(
       files => [
           '/tmpl/test.log',
       ],
       Spacing => {
           short_time  => 2,
           short_lines => 2,
           long_time   => 5,
           long_lines  => 10,
       },
       ...
   );

   $tt->tail();

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS


=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW, Australia).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
