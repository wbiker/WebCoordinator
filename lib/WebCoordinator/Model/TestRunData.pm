package WebCoordinator::Model::TestRunData;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;

extends 'Catalyst::Model';

=head1 NAME

WebCoordinator::Model::TestRunData - Catalyst Model

=head1 DESCRIPTION

This Catalyst Model capsulate the test run data. It loads the data from a file and store them back at each changing.

=cut

has 'testrun_data' => (is => 'ro', isa => 'HashRef');
has 'testrun_file' => (is => 'ro', isa => 'Str', default => './root/files/testruns.dat');
has 'testsuite_file' => (is => 'ro', isa => 'Str', default => './root/files/testruns.dat');
has 'error' => (is => 'rw', isa => 'Str');

sub BUILD {
    my $self = shift;

    # This method is called by Moose after object creation.
    # I use this to load the data from the file(s)
    if(-e $self->{testrun_file}) {
        my $tr = do { $self->{testrun_file}; };
        $self->{error} .= "couldn't parse testrun_file: $@" if $@;
        $self->{error} .= "Could not do testrun_file: $!" unless defined $tr;
        $self->{error} .= "Could not run testruns_file" unless $tr;
    }
    else {
        $self->{error} = 'Could not found testrun_file';
    }
}

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
