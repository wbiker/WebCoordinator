package WebCoordinator::Controller::Testcase;
use Moose;
use namespace::autoclean;
use WebCoordinator::Form::AddTestcase;

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

sub list :Path('list') :Args(0) {
    my ($self, $c) = @_;

    my $testcases = $c->model('TestRunData')->get_all_testcases($c);
    $c->stash(testcases => $testcases);
}

sub add :Path('add') :Args(0) {
    my ($self, $c) = @_;
    
    if(! $c->user_exists) {
        $c->flash(message => "You must be logged in for change actions");
        $c->res->redirect($c->uri_for('/login'));
        $c->detach;
    }

    my $form = WebCoordinator::Form::AddTestcase->new;
    $c->stash(form => $form);
    $form->process(params => $c->req->parameters);
    return unless $form->validated;

    $c->model('TestRunData')->add_new_testcase($c);
    $c->flash(message => 'New test case created');
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

sub delete :Path('delete') :Args(1) {
    my ($self, $c, $testcase_id) = @_;

    if(! $c->user_exists) {
        $c->flash(message => "You must be logged in for change actions");
        $c->res->redirect($c->uri_for('/login'));
        $c->detach;
    }

    $c->model('TestRunData')->delete_testcase($c, $testcase_id);
    $c->flash(message => 'Test case deleted');
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
