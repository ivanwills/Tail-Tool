package Tail::Tool::RegexRole;

# Created on: 2010-11-07 16:36:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use Moose::Role;
use Moose::Util::TypeConstraints;
use version;
use English qw/ -no_match_vars /;
use Data::Dumper qw/Dumper/;

our $VERSION     = version->new('0.0.1');

subtype 'ArrayRefHashRef'
    => as 'ArrayRef[HashRef]';

coerce 'ArrayRefHashRef'
    => from 'ArrayRef'
    => via {
        my $array = $_;
        for my $item (@$array) {
            my ( $regex, $change, $enabled ) = ('', '', 1);
            if ( $item =~ m{^/[^/]+?/,} ) {
                my $rest;
                ( $regex, $rest ) = split m{/,}, $item, 2;
                $regex =~ s{^/}{};

                if ( !defined $enabled ) {
                    $enabled = 1;
                }
            }
            else {
                $regex = $item;
            }
            $item = { regex => $regex, change => $change, enabled => $enabled };
        }
        return $array;
    };

coerce 'ArrayRefHashRef'
    => from 'RegexpRef'
    => via { [{ regex => $_, enabled => 1 }] };

coerce 'ArrayRefHashRef'
    => from 'Str'
    => via { [{ regex => qr/$_/, enabled => 1 }] };

coerce 'ArrayRefHashRef'
    => from 'HashRef'
    => via { [$_] };

has regex => (
    is      => 'rw',
    isa     => 'ArrayRefHashRef',
    coerce  => 1,
    trigger => \&_set_regex,
);

sub summarise {
    my ($self) = @_;

    my @out;
    for my $regex ( @{ $self->regex } ) {
        my $text = "qr/$regex->{regex}/";

        if ( defined $regex->{replace} ) {
            $text .= "$regex->{replace}/";
        }

        if ( keys %{$regex} > 2 ) {

            for my $key ( keys %{$regex} ) {
                next if $key eq 'regex' || $key eq 'enabled' || $key eq 'replace';
                next if !$regex->{$key};
                my $value
                    = ref $regex->{$key} eq 'ARRAY' ? '[' . ( join ', ', @{ $regex->{$key} } ) . ']'
                    :                                 $regex->{$key};
                $text .= " $key=$value";
            }
        }

        $text .= 'd' if !$regex->{enabled};

        push @out, $text;
    }
    return join ', ', @out;
}

sub _set_regex {
    my ( $self, $regexs, $old_regexs ) = @_;

    for my $regex ( @{ $regexs } ) {
        $regex->{enabled} ||= 0;
    }

    return;
}

1;

__END__

=head1 NAME

Tail::Tool::RegexRole - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to Tail::Tool::RegexRole version 0.1.


=head1 SYNOPSIS

   use Tail::Tool::RegexRole;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

=head2 C<summarise ()>

Returns a string that summarise the current settings of the plugin instance

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

Copyright (c) 2010 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
