use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WebCoordinator';
use WebCoordinator::Controller::Testcase;

ok( request('/testcase')->is_success, 'Request should succeed' );
done_testing();
