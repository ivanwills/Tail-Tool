package Tail::Tool::Plugin::Spacing;

# Created on: 2010-10-06 14:17:00
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

extends 'Tail::Tool::PreProcess';

our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();
#our @EXPORT      = qw//;

has time => (
    is      => 'rw',
    isa     => 'Integer',
);
has short_time => (
    is      => 'rw',
    isa     => 'Integer',
    default => 0,
);
has short_lines => (
    is      => 'rw',
    isa     => 'Integer',
    default => 0,
);
has long_time => (
    is      => 'rw',
    isa     => 'Integer',
    default => 0,
);
has long_lines => (
    is      => 'rw',
    isa     => 'Integer',
    default => 0,
);

sub process {
    my ( $self, $line ) = @_;

    my $last = $self->time or return ($line);

    my $diff = time - $last;

    if ( $diff > $self->short_time ) {
        print "\n" x $self->short_lines;
    }
    elsif ( $diff > $self->long_time ) {
        print "\n" x $self->long_lines;
    }

    return ($line);
}

1;

__END__

=head1 NAME

Tail::Tool::Plugin::Spacing - Prints spaces when there has been a pause in
running.

=head1 VERSION

This documentation refers to Tail::Tool::Plugin::Spacing version 0.1.

=head1 SYNOPSIS

   use Tail::Tool::Plugin::Spacing;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

   my $sp = Tail::Tool::Plugin::Spacing(
       short_time  => 2, # 2 seconds
       short_lines => 2, # the number of lines to print when a short time has elapsed
       long_time   => 5, # 5 seconds
       long_lines  => 5, # the number of lines to print when a long time has elapsed
   );

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<new (%params)>

Param: C<short_time > - int - The minimum time (in seconds) for a pause to be
considered to have occured.

Param: C<short_lines> - int - The number of lines to print when a short time
has elapsed but between calls but a long time has not been reached.
Param: C<long_time  > - int - The minimum time (in seconds) for a long pause to
be considered to have occured.

Param: C<long_lines > - int - The number of lines to print when a long time has
elapsed between calls.

Description: create a new object

=head2 C<process ()>

Description: Prints spaces basied on time between last call and this one and
the settings.

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

Please report problems to Ivan Wills (ivan.wills@gamil.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gamil.com)
<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW, Australia, 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
