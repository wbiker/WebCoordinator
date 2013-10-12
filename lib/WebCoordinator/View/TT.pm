package WebCoordinator::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
);

=head1 NAME

WebCoordinator::View::TT - TT View for WebCoordinator

=head1 DESCRIPTION

TT View for WebCoordinator.

=head1 SEE ALSO

L<WebCoordinator>

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
