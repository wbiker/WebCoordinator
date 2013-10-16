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

has 'testrun_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testrun.db');
has 'testsuite_file' => (is => 'ro', isa => 'Str', default => './root/files/master/testrun.db');
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

sub modify_testrun {
    my $self = shift;
    my $c = shift;
    my $tr_id = shift;

    my $tr_ref = $self->{testruns};

    my $tr = $tr_ref->{$tr_id};

    my $git = Git::Wrapper->new('./root/files');
    $c->log->debug($git->branch("$tr_id"));
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

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
