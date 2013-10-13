package WebCoordinator::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    INCLUDE_PATH => [
    WebCoordinator->path_to('root', 'src'),
    ],
    TEMPLATE_EXTENSION => '.tt2',
    WRAPPER => 'main',
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
