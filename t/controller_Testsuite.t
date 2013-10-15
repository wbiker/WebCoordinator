use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WebCoordinator';
use WebCoordinator::Controller::Testsuite;

ok( request('/testsuite')->is_success, 'Request should succeed' );
done_testing();
