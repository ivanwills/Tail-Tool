package Tail::Tool::Plugin::Replace;

# Created on: 2010-11-10 09:10:52
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moose;
use warnings;
use version;
use Carp;
use English qw/ -no_match_vars /;

extends 'Tail::Tool::PreProcess';
with 'Tail::Tool::RegexList';

our $VERSION = version->new('0.4.1');

sub process {
    my ($self, $line) = @_;
    my $matches;

    for my $match ( @{ $self->regex } ) {
        $matches += $match->enabled;
        if ( $match->enabled ) {
            my $reg = $match->regex;
            my $rep = $match->replace;
            eval { $line =~ s/$reg/eval qq{"$rep"}/e };
        }
    }

    # return empty array if there were enabled matches else return the line
    return ($line);
}

sub _set_regex {
    my ( $self, $regexs, $old_regexs ) = @_;

    for my $regex ( @{ $regexs } ) {
       $regex->replace('') if !$regex->has_replace;
    }

    return;
}

1;

__END__

=head1 NAME

Tail::Tool::Plugin::Replace - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to Tail::Tool::Plugin::Replace version 0.4.1.


=head1 SYNOPSIS

   use Tail::Tool::Plugin::Replace;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

=head2 C<process ($line)>

Param: C<$line> -The line to process

Performs any changes to the line that have been specified.

=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

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
