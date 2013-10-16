package WebCoordinator::Controller::Testrun;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use WebCoordinator::Form::AddTestrun;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WebCoordinator::Controller::Testrun - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub testrun :Path('/testrun') :Args(1) {
    my ( $self, $c, $testrun_id ) = @_;
    
    $c->log->info("testrun controller invoked");

    my $testrun = $c->model('TestRunData')->get_test_run($c, $testrun_id);
    my $test_suites = $c->model('TestRunData')->get_test_suites($c, $testrun->{tsids});

    $c->stash(testrun => $testrun);
    $c->stash(testsuites => $test_suites);
    $c->stash(debug => Dumper $test_suites);
}

sub list :Path('/testrun/list') :Args(0) {
    my ($self, $c) = @_;
    $c->log->debug("testrun path called");
    # Hello World
    my $tr_data = $c->model('TestRunData');

    my $tt = $tr_data->get_all_testruns($c);
#    my $tref = eval { $tt };
 #   if($@) { $c->log->error($@); }
    $c->stash(testruns => $tt);
    $c->stash(debug => Dumper $c->session);
}

sub add :Path('add') :Args(0) {
    my ($self, $c) = @_;

    my $form = WebCoordinator::Form::AddTestrun->new;
    $c->stash(form => $form);
    $form->process(params => $c->req->parameters);

    return unless $form->validated;

    $c->model('TestRunData')->add_new_testrun($c);
    $c->flash(message => 'New test run created');
    $c->res->redirect($c->uri_for('list'));
    $c->detach;
}

sub delete :Path('delete') :Args(1) {
    my ($self, $c, $testrun_id) = @_;

    $c->log->debug("Delete test run with id $testrun_id");
    $c->model('TestRunData')->delete_testrun($c, $testrun_id);
    $c->flash(message => 'Test run removed');
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
