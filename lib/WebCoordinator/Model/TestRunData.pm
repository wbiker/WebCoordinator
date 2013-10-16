package WebCoordinator::Model::TestRunData;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;
use JSON;
use Git::Wrapper;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);

extends 'Catalyst::Model';

=head1 NAME

WebCoordinator::Model::TestRunData - Catalyst Model

=head1 DESCRIPTION

This Catalyst Model capsulate the test run data. It loads the data from a file and store them back at each changing.

=cut

has 'testrun_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testrun.db');
has 'testsuite_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testsuite.db');
has 'testcase_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testcase.db');
has 'testruns' => (is => 'ro', isa => 'HashRef');
has 'testsuites' => (is => 'ro', isa => 'HashRef');
has 'testcases' => (is => 'ro', isa => 'HashRef');

sub BUILD {
    my $self = shift;

    # This method is called by Moose after object creation.
    # I use this to load the data from the file(s)
    $self->_load_data_files();
}

sub get_all_testruns {
    my $self = shift;
    my $c = shift;

    # count all keys of the testruns hash. SO, I know whether I have test runs or not.
#    my %testruns = %{$self->{testruns}};
#    my @tr_keys = keys%testruns;
#    $c->log("Does not found any test runs") if 0 == @tr_keys;

    return $self->{testruns};
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

	my $tsref = $self->{testsuites};
	$c->log->debug(\$tsref);
    return $ts;
}

sub get_all_testsuites {
    my ($self, $c) = @_;

    return $self->{testsuites};
}

sub get_all_testcases {
    my ($self, $c) = @_;

    return $self->{testcases};
}

sub _load_data_files {
	my $self = shift;
	
	for my $file (qw(testrun testsuite testcase)) {
		my $file_name = $file."_file";
		my $file_path = $self->{$file_name};
	    if(-e $file_path) {
	        my $tr = do $file_path;
        	die "couldn't parse $file_path: $@" if $@;
    	    die "Could not do $file_path: $!" unless defined $tr;
	        die "Could not run $file_name" unless $tr;
			my $variable = $file."s";
        	$self->{$variable} = $tr;
    	}
	    else {
        	die "Could not found $file_path";
    	}
	}
}

sub get_test_suite {
    my ($self, $c, $testsuite_id) = @_;

    return $self->{testsuites}->{$testsuite_id};
}

sub add_new_testrun {
    my ($self, $c) = @_;

    # data of new test run are stored in $c->request->parameters
    # first create id
    my $id = md5_hex(time);

    $self->{testruns}->{$id}->{name} = $c->req->parameters->{name};
    $self->{testruns}->{$id}->{$id} = $id;
}

sub add_new_testsuite {
    my ($self, $c) = @_;

    my $id = md5_hex(time);

    $self->{testsuites}->{$id}->{name} = $c->req->parameters->{name};
    $self->{testsuites}->{$id}->{description} = $c->req->parameters->{description};
    $self->{testsuites}->{$id}->{id} = $id;
}

sub add_new_testcase {
    my ($self, $c) = @_;

    my $id = md5_hex(time);

    $self->{testcases}->{$id}->{name} = $c->req->parameters->{name};
    $self->{testcases}->{$id}->{description} = $c->req->parameters->{description};
    $self->{testcases}->{$id}->{id} = $id;
}

sub delete_testrun {
    my ($self, $c, $testrun_id) = @_;

    delete $self->{testruns}->{$testrun_id};
}

sub delete_testsuite {
    my ($self, $c, $testsuite_id) = @_;

    delete $self->{testsuites}->{$testsuite_id};
}

sub delete_testcase {
    my ($self, $c, $testcase_id) = @_;

    delete $self->{testcases}->{$testcase_id};
}

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
