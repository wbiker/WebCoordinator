package WebCoordinator::Controller::Testsuite;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WebCoordinator::Controller::Testsuite - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub testsuite :Path('/testsuite') :Args(1) {
    my ( $self, $c, $testsuite_id ) = @_;

    my $testsuite = $c->model('TestRunData')->get_test_suite($c, $testsuite_id);

    $c->stash(testsuite => $testsuite);
}

sub list :Path('/testsuite/list') :Arg(0) {
    my ($self, $c) = @_;

    my $testsuites = $c->model('TestRunData')->get_all_testsuites($c);
    $c->stash(testsuites => $testsuites);
    $c->stash(debug => Dumper $testsuites);
}


=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
