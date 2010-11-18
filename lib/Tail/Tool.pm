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
use Tail::Tool::File;
use Devel::Leak;
use Devel::Size qw/total_size/;

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
    isa     => 'Int',
    default => 10,
);
has pre_process => (
    is   => 'rw',
    isa  => 'ArrayRef',
    default => sub {[]},
);
has post_process => (
    is   => 'rw',
    isa  => 'ArrayRef',
    default => sub {[]},
);
has printer => (
    is      => 'rw',
    isa     => 'CodeRef',
    default => sub {
        sub { print @_ };
    },
);
has last => (
    is  => 'rw',
    isa => 'Tail::Tool::File',
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
        next if $key eq 'post_process' || $key eq 'pre_process';

        if ( $key eq 'files' ) {
            my @extra = ( no_inotify => $param{no_inotify} );
            for my $file ( @{ $param{$key} } ) {
                $file = Tail::Tool::File->new(
                    ref $file ? $file : ( name => $file, @extra )
                );
            }
        }
        elsif ( $key eq 'lines' || $key eq 'printer' || $key eq 'no_inotify' ) {
        }
        else {
            my $plugin
                = $key =~ /^\+/
                ? substr $key, 1, 999
                : "Tail::Tool::Plugin::$key";
            my $plugin_file = $plugin;
            $plugin_file =~ s{::}{/}gxms;
            $plugin_file .= '.pm';
            {
                # don't load twice
                no strict qw/refs/; ## no critic
                if ( !${"Tail::Tool::Plugin::${key}::"}{VERSION} ) {
                    eval { require $plugin_file };
                    if ( $EVAL_ERROR ) {
                        confess "Could not load the plugin $key (via $plugin_file)\n";
                    }
                }
            }

            my $plg = $plugin->new($param{$key});
            delete $param{$key};

            push @{ $param{ ( $plg->post ? 'post' : 'pre' ) . '_process' } }, $plg;
        }
    }

    return $class->$orig(%param);
};

my $handle;
my $count;
my $size;
sub tail {
    my ($self) = @_;

    $count = Devel::Leak::NoteSV($handle);
    $size  = total_size($self);
    for my $file (@{ $self->files }) {
        $file->runner( sub { $self->run(@_) } );
        $file->watch();
        $file->run(1);
    }
}

sub run {
    my ( $self, $file, $first ) = @_;

    my @lines = $file->get_line;

    if ( $first && @lines > $self->lines ) {
        @lines = @lines[ -$self->lines .. -1 ];
    }
    warn scalar @lines if @lines;

    for my $pre ( @{ $self->pre_process } ) {
        my @new;
        for my $line (@lines) {
            push @new, $pre->process($line);
        }
        @lines = @new;
    }
    for my $post ( @{ $self->post_process } ) {
        my @new;
        for my $line (@lines) {
            push @new, $post->process($line);
        }
        @lines = @new;
    }
    warn scalar @lines if @lines;

    if ( @lines ) {
        if ( @{ $self->files } > 1 && ( !$self->last || $file ne $self->last ) ) {
            unshift @lines, "\n==> " . $file->name . " <==\n";
        }
        $self->last($file);
    }

    my $my_size = total_size($self);
    if ($my_size != $size) {
        $size = $my_size;
        warn "Total Size = $size\n";
    }
    my $my_count = Devel::Leak::NoteSV($handle);
    if ($my_count != $count) {
        $count = $my_count;
        warn "Things now $count\n";
    }

    return $self->printer->(@lines);
}

1;

__END__

=head1 NAME

Tail::Tool - Tool for sophisticated tailing of files

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

=head2 C<tail ()>

Description: Start tailing?

=head2 C<run ($file, $first)>

Param: C<$file> - Tail::Tool::File - The file to run

Param: C<$first> - bool - Specifies that this is the first time run has been
called.

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
