package WebCoordinator::Controller::Testrun;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;
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
    
    $c->log->info("testrun controller invoked. tr id '$testrun_id'");

    my $testrun = $c->model('TestRunData')->get_test_run($c, $testrun_id);
    my $test_suites = $c->model('TestRunData')->get_test_suites($c, $testrun->{tsids});

    $c->stash(testrun => $testrun);
    $c->stash(testsuites => $test_suites);
    my $dump = Dump($test_suites)->Out();
    $c->stash(debug => $dump);
}

sub list :Path('/testrun/list') :Args(0) {
    my ($self, $c) = @_;
    $c->log->debug("/testrun/list path called");
    # Hello World
    my $tr_data = $c->model('TestRunData');

    my $tt = $tr_data->get_all_testruns($c);
#    my $tref = eval { $tt };
 #   if($@) { $c->log->error($@); }
    $c->stash(testruns => $tt);
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

sub removetestsuite :Path('removetestsuite') :Args(2) {
    my ($self, $c, $tr_id, $ts_id) = @_;

    $c->log->debug("Remove ts '$ts_id' from tr '$tr_id'");
    $c->model('TestRunData')->remove_ts_from_tr($c, $tr_id, $ts_id);
    $c->res->redirect($c->uri_for('/testrun', $tr_id));
    $c->detach;
}

sub addtestsuites :Path('addtestsuites') :Args(1) {
    my ($self, $c, $tr_id) = @_;

    if($tr_id eq "addtestsuites") {
        my $testsuites = $c->req->parameters->{testsuites};
        $c->model('TestRunData')->add_testsuites_to_tr($c, $c->stash->{tr_id}, $testsuites);
        $c->res->redirect($c->uri_for($c->stash->{tr_id}));
        $c->detach;
    }
    else {
        $c->log->debug("/testrun/addtestsuites invoked. tr ID '$tr_id'");

        my $ts_all = $c->model('TestRunData')->get_all_testsuites($c);
        $c->stash(testsuites => $ts_all);
        $c->flash(tr_id => $tr_id);
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
