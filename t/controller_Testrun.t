use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WebCoordinator';
use WebCoordinator::Controller::Testrun;

ok( request('/testrun')->is_success, 'Request should succeed' );
done_testing();
