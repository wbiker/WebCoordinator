package WebCoordinator::Controller::Testsuite;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use WebCoordinator::Form::AddTestsuite;

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
    my $testcases = $c->model('TestRunData')->get_test_cases($c, $testsuite->{tcids});
    $c->stash(testsuite => $testsuite);
    $c->stash(testcases => $testcases);
    $c->stash(debug => Dumper $testcases);
}

sub list :Path('/testsuite/list') :Args(0) {
    my ($self, $c) = @_;

    my $testsuites = $c->model('TestRunData')->get_all_testsuites($c);
    $c->stash(testsuites => $testsuites);
    $c->stash(debug => Dumper $testsuites);
}

sub add :Path('add') :Args(0) {
    my ($self, $c) = @_;
    
    my $form = WebCoordinator::Form::AddTestsuite->new;
    $c->stash(form => $form);
    $form->process(params => $c->req->parameters);

    return unless $form->validated;

    $c->model('TestRunData')->add_new_testsuite($c);
    $c->flash(message => 'New test suite created');
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

sub delete :Path('delete') :Args(1) {
    my ($self, $c, $testsuite_id) = @_;

    $c->model('TestRunData')->delete_testsuite($c, $testsuite_id);
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
    $c->flash(message => 'Test suite deleted');
}

sub addtestcases :Path('addtestcases') :Args(1) {
    my ($self, $c, $ts_id) = @_;

    if($ts_id && $ts_id eq "addtestcases") {
        my $testcases = $c->req->parameters;
        $c->log->debug("testcases got: ".Dumper $testcases);
        $c->model('TestRunData')->add_testcases_to_ts($c, $c->stash->{ts_id}, $testcases);
        $c->res->redirect($c->uri_for($c->stash->{ts_id}));
        $c->detach;
    }
    else {
        $c->stash(testsuite => $c->model('TestRunData')->get_test_suite($c, $ts_id));
        $c->stash(testcases => $c->model('TestRunData')->get_all_testcases($c));
        $c->flash(ts_id => $ts_id);
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
