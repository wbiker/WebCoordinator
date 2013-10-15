package WebCoordinator::Controller::Testrun;
use Moose;
use namespace::autoclean;
use Data::Dumper;

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


=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
