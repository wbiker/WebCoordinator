package WebCoordinator::Model::TestRunData;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;
use JSON;
use Git::Wrapper;
use File::Spec;
use Data::Dump::Streamer;
use Digest::MD5 qw(md5_hex);

extends 'Catalyst::Model';

=head1 NAME

WebCoordinator::Model::TestRunData - Catalyst Model

=head1 DESCRIPTION

This Catalyst Model capsulate the test run data. It loads the data from a file and store them back at each changing.

=cut

has 'branch_dir' => (is => 'ro', isa => 'Str', default => '../WebCoordinatorDataFiles');
has 'testrun_file' => (is => 'ro', isa => 'Str', default => 'testrun.db');
has 'testsuite_file' => (is => 'ro', isa => 'Str', default => 'testsuite.db');
has 'testcase_file' => (is => 'ro', isa => 'Str', default => 'testcase.db');
# due to several branches I use one hashref to store the data
has 'data' => (is => 'ro', isa => 'HashRef');

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

    my $branch = _get_branch($c);
    return $self->{$branch}->{testruns};
}

sub get_test_run {
    my $self = shift;
    my $c = shift;
    my $testrun_id = shift;

    my $branch = _get_branch($c);
    $c->log->debug("search test run $testrun_id");
    return $self->{$branch}->{testruns}->{$testrun_id};
}

sub get_test_suites {
    my $self = shift;
    my $c = shift;
    my $testsuite_ids = shift;

    my $ts = [];

    my $branch = _get_branch($c);
    for my $ts_id (@{$testsuite_ids}) {
        push($ts, $self->{$branch}->{testsuites}->{$ts_id});
    }

	my $tsref = $self->{$branch}->{testsuites};
	$c->log->debug(\$tsref);
    return $ts;
}

sub get_all_testsuites {
    my ($self, $c) = @_;

    my $branch = _get_branch($c);
    return $self->{$branch}->{testsuites};
}

sub get_all_testcases {
    my ($self, $c) = @_;

    my $branch = _get_branch($c);
    return $self->{$branch}->{testcases};
}

sub remove_ts_from_tr {
    my ($self, $c, $tr_id, $ts_id) = @_;

    my $branch = _get_branch($c);
    my $tsids = $self->{$branch}->{testruns}->{$tr_id}->{tsids};

    my @newarray = grep { $_ ne $ts_id } @{$tsids};
    $self->{$branch}->{testruns}->{$tr_id}->{tsids} = [@newarray];
}

sub _load_data_files {
	my $self = shift;
	
    my $git = Git::Wrapper->new($self->{branch_dir});
    my @branches = $git->branch;

    for my $branch (@branches) {
        $branch =~ s/\A\*//;
        $branch =~ s/\A\s+//;

	    for my $file (qw(testrun testsuite testcase)) {
		    my $file_name = $file."_file";
		    my $file_path = File::Spec->catfile($self->{branch_dir}, $self->{$file_name});
	        if(-e $file_path) {
	            my $tr = do $file_path;
        	    die "couldn't parse $file_path: $@" if $@;
    	        die "Could not do $file_path: $!" unless defined $tr;
	            die "Could not run $file_name" unless $tr;
			    my $variable = $file."s";
        	    $self->{$branch}->{$variable} = $tr;
    	    }
	        else {
        	    die "Could not found $file_path";
    	    }
	    }
    }
}

sub _save_data_files {
	my $self = shift;
    my $c = shift;
    my $commit_reasons = shift // "Commit without reasons";

    my $branch = _get_branch($c);
    $c->log->debug("Save files for user with branch '$branch'");
    
    my $git = Git::Wrapper->new($self->{branch_dir});
    $c->log->info("Checkout branch '$branch'");
    $git->checkout($branch);

	for my $file (qw(testrun testsuite testcase)) {
		my $file_path = File::Spec->catfile($self->{branch_dir}, $self->{$file."_file"});

		open(my $fh, ">", $file_path);
		my $data = $file."s";

        $c->log->debug("save '$data' in '$file_path'");
		my $d = Data::Dump::Streamer->new;
        $d->Names($data);
        $d->Data($self->{$branch}->{$data});
		$d->To($fh)->Out();
		close($fh);
	}

    $c->log->debug("Commit branch '$branch' with reason '$commit_reasons'");
    $git->commit({ message => $commit_reasons, all => 1 });
}

sub get_test_suite {
    my ($self, $c, $testsuite_id) = @_;

    my $branch = _get_branch($c);
    return $self->{$branch}->{testsuites}->{$testsuite_id};
}

sub add_new_testrun {
    my ($self, $c) = @_;

    # data of new test run are stored in $c->request->parameters
    # first create id
    my $id = md5_hex(time);
        
    my $branch = _get_branch($c);
    my $name = $c->req->parameters->{name};
    $self->{$branch}->{testruns}->{$id}->{name} = $name;
    $self->{$branch}->{testruns}->{$id}->{id} = $id;
	$self->_save_data_files($c, "Add new TR '$name' with id '$id'");
}

sub add_new_testsuite {
    my ($self, $c) = @_;

    my $id = md5_hex(time);

    my $branch = _get_branch($c);
    my $name = $c->req->parameters->{name};
    $self->{$branch}->{testsuites}->{$id}->{name} = $name;
    $self->{$branch}->{testsuites}->{$id}->{description} = $c->req->parameters->{description};
    $self->{$branch}->{testsuites}->{$id}->{id} = $id;
	$self->_save_data_files($c, "Add new TS '$name' with id '$id'");
}

sub add_new_testcase {
    my ($self, $c) = @_;

    my $id = md5_hex(time);

    my $branch = _get_branch($c);
    my $name = $c->req->parameters->{name};
    $self->{$branch}->{testcases}->{$id}->{name} = $name;
    $self->{$branch}->{testcases}->{$id}->{description} = $c->req->parameters->{description};
    $self->{$branch}->{testcases}->{$id}->{id} = $id;
	$self->_save_data_files($c, "Add new TC '$name' with id '$id'");
}

sub delete_testrun {
    my ($self, $c, $testrun_id) = @_;

    my $branch = _get_branch($c);
    delete $self->{$branch}->{testruns}->{$testrun_id};
	$self->_save_data_files($c, "Delete TR with id '$testrun_id'");
}

sub delete_testsuite {
    my ($self, $c, $testsuite_id) = @_;

    my $branch = _get_branch($c);
    delete $self->{$branch}->{testsuites}->{$testsuite_id};
	$self->_save_data_files($c, "Delete TS with id '$testsuite_id'");;
}

sub delete_testcase {
    my ($self, $c, $testcase_id) = @_;

    my $branch = _get_branch($c);
    delete $self->{$branch}->{testcases}->{$testcase_id};
	$self->_save_data_files($c, "Delete TC with id '$testcase_id'");;
}

sub save_testsuites_in_tr {
    my ($self, $c, $tr_id, $testsuites) = @_;
    
    my $branch = _get_branch($c);
    my $tr = $self->{$branch}->{testruns}->{$tr_id};

    if(!exists $tr->{tsids}) {
        $tr->{tsids} = [];
    }

    for my $ts (@{$testsuites}) {
        $c->log->debug("add $ts to tr");
        push($tr->{tsids}, $ts);
    }
    
    $self->{$branch}->{testruns}->{$tr_id} = $tr;
}

sub _get_branch {
    my $c = shift;

    if($c->session && exists $c->session->{branch}) {
        return $c->session->{branch};
    }

    return 'master';
}

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
