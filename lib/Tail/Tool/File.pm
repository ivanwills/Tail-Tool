package Tail::Tool::File;

# Created on: 2010-10-25 11:11:38
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moose;
use version;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Path::Class;
use AnyEvent;

our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();
#our @EXPORT      = qw//;

has name => (
    is   => 'rw',
    isa  => 'Str',
);

has cmd => (
    is   => 'rw',
    isa  => 'Str',
);
has pid => (
    is   => 'rw',
    isa  => 'Str',
);
has handle => (
    is   => 'rw',
    isa  => 'FileHandle',
);
has size => (
    is       => 'rw',
    isa      => 'Int',
    init_arg => undef,
);
has pause => (
    is  => 'rw',
    isa => 'Bool',
);
has no_inotify => (
    is  => 'ro',
    isa => 'Bool',
);
has watcher => (
    is => 'rw',
);
has runner => (
    is  => 'rw',
    isa => 'CodeRef',
);
has started => (
    is       => 'rw',
    isa      => 'Bool',
    default  => 0,
    init_arg => undef,
);

my $inotify;
my $watcher;
sub watch {
    my ($self, $lines) = @_;

    return 0 if $self->pause || !-e $self->name;
    return $self->watcher if $self->watcher;

    if ( !defined $inotify ) {
        eval { require Linux::Inotify2 };
        if ($EVAL_ERROR) {
            $inotify = 0;
        }
        else {
            $inotify = Linux::Inotify2->new;
        }
    }

    my $w;
    if ( $inotify && !$self->no_inotify ) {
        $w = $inotify->watch( $self->name, Linux::Inotify2::IN_ALL_EVENTS(), sub { $self->run } );
        if ( !$watcher ) {
            $watcher = AE::io $inotify->fileno, 0, sub { $inotify->poll };
        }
    }
    else {
        $w = AE::timer 0, 2, sub { $self->run };
    }

    $self->watcher($w);

    my $fh = $self->handle;
    if ( !$fh ) {
        open $fh, '<', $self->name or die "Could not open '".$self->name."': $!\n";
        $self->handle($fh);
        $self->size(-s $self->name);
    }

    return $self->watcher;
}

sub run {
    my ($self, $first) = @_;

    $self->runner->($self, $first);
}

sub get_line {
    my ($self) = @_;
    my $fh = $self->handle;

    return if $self->pause;

    my $size = -s $self->name;
    if ( $size < $self->size ) {
        warn $self->name . " was truncated!\n";
        seek $fh, 0, 0;
    }
    else {
        seek $fh, 0, 1;
    }
    $self->size($size);

    return <$fh>;
}

1;

__END__

=head1 NAME

Tail::Tool::File - Looks after individual files

=head1 VERSION

This documentation refers to Tail::Tool::File version 0.1.

=head1 SYNOPSIS

   use Tail::Tool::File;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

=head2 C<watch ()>

Return: AnyEvent watcher or Linux::Inotify2 watcher

Description: Creates the watcher for the file if the file exists and is not
paused.

=head2 C<run ($first)>

Param: C<$first> - bool - Specifies that this is the first time run has been
called.

Description: Runs the the file event.

=head2 C<get_line ()>

Description: Gets any unread lines from the file.

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
