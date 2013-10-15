package WebCoordinator::Model::TestRunData;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;
use JSON;
use Git::Wrapper;

extends 'Catalyst::Model';

=head1 NAME

WebCoordinator::Model::TestRunData - Catalyst Model

=head1 DESCRIPTION

This Catalyst Model capsulate the test run data. It loads the data from a file and store them back at each changing.

=cut

has 'testrun_data' => (is => 'ro', isa => 'HashRef');
has 'testrun_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testrun.db');
has 'testsuite_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testsuites_new.db');
has 'error' => (is => 'rw', isa => 'Str');
has 'testruns' => (is => 'ro', isa => 'HashRef');

sub BUILD {
    my $self = shift;

    # This method is called by Moose after object creation.
    # I use this to load the data from the file(s)
    if(-e $self->{testrun_file}) {
        $self->{error} .= "testrun file found";
        my $file = $self->{testrun_file};
        my $tr = do $file;
        $self->{error} .= "couldn't parse testrun_file: $@" if $@;
        $self->{error} .= "Could not do testrun_file: $!" unless defined $tr;
        $self->{error} .= "Could not run testruns_file" unless $tr;
        $self->{testruns} = $tr;
    }
    else {
        $self->{error} = 'Could not found testrun_file';
    }


    if(-e $self->{testsuite_file}) {
        $self->{error} .= "testsuite file found";
        my $file = $self->{testsuite_file};
        my $tr = do $file;
        $self->{error} .= "couldn't parse testsuite_file: $@" if $@;
        $self->{error} .= "Could not do testsuite_file: $!" unless defined $tr;
        $self->{error} .= "Could not run testsuite_file" unless $tr;
        $self->{testsuites} = $tr;
    }
    else {
        $self->{error} = 'Could not found testsuite_file';
    }
}

sub get_all_testruns {
    my $self = shift;
    my $c = shift;

    # count all keys of the testruns hash. SO, I know whether I have test runs or not.
    $c->log->info($self->{error});
#    my %testruns = %{$self->{testruns}};
#    my @tr_keys = keys%testruns;
#    $c->log("Does not found any test runs") if 0 == @tr_keys;

    return $self->{testruns};

    my %trs = %{$self->{testruns}};
    my $trsa = [];
    for my $key (keys %trs) {
        push($trsa, $trs{$key});
    }
    return $trsa;
}

sub get_test_run {
    my $self = shift;
    my $c = shift;
    my $testrun_id = shift;

    $c->log->debug("search test run $testrun_id");
    return $self->{testruns}->{$testrun_id};
}

sub get_test_suites {
    my $self = shift;
    my $c = shift;
    my $testsuite_ids = shift;

    my $ts = [];

    for my $ts_id (@{$testsuite_ids}) {
        push($ts, $self->{testsuites}->{$ts_id});
    }

    return $ts;
}

sub modify_testrun {
    my $self = shift;
    my $c = shift;
    my $tr_id = shift;

    my $tr_ref = $self->{testruns};

    my $tr = $tr_ref->{$tr_id};

    my $git = Git::Wrapper->new('./root/files');
    $c->log->debug($git->branch("$tr_id"));
}
=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
