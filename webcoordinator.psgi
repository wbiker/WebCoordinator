use strict;
use warnings;

use WebCoordinator;

my $app = WebCoordinator->apply_default_middlewares(WebCoordinator->psgi_app);
$app;

