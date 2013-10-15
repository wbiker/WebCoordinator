package WebCoordinator::Controller::Testcase;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WebCoordinator::Controller::Testcase - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->forward('/testcase/list');
}

sub list :Path :Args(0) {
    my ($self, $c) = @_;

    my $testcases = $c->model('TestRunData')->get_all_testcases($c);
    $c->stash(testcases => $testcases);
}


=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
