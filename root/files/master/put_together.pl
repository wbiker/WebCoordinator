#!/usr/bin/perl -l

use strict;
use warnings;
use Data::Dump::Streamer;

my $all_file = 'alltestcasesfromrun.db';
my $testrun_file = 'testrun.db';
my $testsuite_file = 'testsuite.db';
my $testcase_file = 'testcase.db';

die "Could not find $all_file" unless -e $all_file;
die "Could not find $testrun_file" unless -e $testrun_file;
die "Could not find $testsuite_file" unless -e $testsuite_file;
die "Could not find $testcase_file" unless -e $testcase_file;

my $all_ref = do $all_file;

my $testrun_ref = do $testrun_file;

my $testcase_ref = do $testcase_file;

my $testsuite_ref = do $testsuite_file;

for my $key (keys %{$all_ref}) {
  my $testtype = $key;
  my $tcid = $all_ref->{$key}->{tcid}; 
  my $tsid = $all_ref->{$key}->{tsid}; 
  my $runorder = $all_ref->{$key}->{runorder};

  my $testrun_by_testtype = $testrun_ref->{$testtype};
  for my $testsuite (@{$testrun_by_testtype->{tsids}}) {
        if($testsuite eq $tsid) {
            my $testsuite_add_testcaseid = $testsuite_ref->{$testsuite};
            push(@{$testsuite_add_testcaseid->{tcids}}, $tcid);
        }
  }
}

my $d = Data::Dump::Streamer->new;
$d->Names('testsuites');
$d->Data($testsuite_ref);
open(my $fh, ">", 'testsuites_new.db');
$d->To($fh)->Out();
close($fh);
