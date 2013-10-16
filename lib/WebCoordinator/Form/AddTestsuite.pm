#
#===============================================================================
#
#         FILE: AddTestsuite.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: wba (wolf), wbiker@gmx.at
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 16/10/13 20:14:18
#     REVISION: ---
#===============================================================================
package WebCoordinator::Form::AddTestsuite;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use namespace::autoclean;


has '+item_class' => (default => 'WebCoordinator');
has_field 'name' => (label => 'Name', required => 1);
has_field 'description' =>(label => 'Description');
has_field 'submit' => (type => 'Submit', value => 'Create Testsuite');

1;
