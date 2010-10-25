package Tail::Tool::PreProcess;

# Created on: 2010-10-22 14:45:34
# Create by:  dev
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

has post => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);


1;

__END__

=head1 NAME

Tail::Tool::PreProcess - Parent module for Plugins that perform pre-porcessing
tasks on tailed lines. eg filtering

=head1 VERSION

This documentation refers to Tail::Tool::PreProcess version 0.1.


=head1 SYNOPSIS

   use Tail::Tool::PreProcess;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to dev (dev@localhost).

Patches are welcome.

=head1 AUTHOR

dev - (dev@localhost)
<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 dev (123 Timbuc Too).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
