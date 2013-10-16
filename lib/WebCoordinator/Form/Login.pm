#
#===============================================================================
#
#         FILE: Login.pm
#
#  DESCRIPTION: For the login
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: wba (wolf), wbiker@gmx.at
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 16/10/13 17:41:32
#     REVISION: ---
#===============================================================================
package WebCoordinator::Form::Login;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use namespace::autoclean;

has '+item_class' => ( default => 'WebCoordinator' );
has_field 'user' => ( label => 'User', required => 1 );
has_field 'password' => ( label => 'Password', required => 1 );
has_field 'submit' => ( type => 'Submit', value => 'Login' );

1;
