#
#===============================================================================
#
#         FILE: AddTestrun.pm
#
#  DESCRIPTION: For adding a new test run
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: wba (wolf), wbiker@gmx.at
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 16/10/13 19:55:50
#     REVISION: ---
#===============================================================================
package WebCoordinator::Form::AddTestrun;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use namespace::autoclean;

has '+item_class' => (default => 'WebCoordinator');
has_field 'name' => ( label => 'Name', required => 1);
has_field 'submit' => ( type => 'Submit', value => 'Create Testrun' );

1;
